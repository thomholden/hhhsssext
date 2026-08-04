#include <math.h>
#include <stdio.h>
#include <stdlib.h>
/*#include "file.h"*/
#include "nrutil.h"

#define NAME_LENGTH 1024

/* GLOBAL VARIABLES FOR THIS FILE */

int     ni;		          /* dimension of input vectors	             */
int     nh;		          /* number of hidden layer units            */
int     no;		          /* dimension of outputs            */

float   **x, **y;  /* Inputs, targets */
int nd;            /* number of data points */

float   **w_dummy; 
int     nw, nw_dummy;   /* number of weights */

float   **a, **a_dummy; /* hyperparameters */
int     na, na_dummy;   /* number of hyper parameters */

float **ypred;        /* predicted target value */
float **apred;        /* predicted activation value */
float ***da_mat;      /* derivative of network activation wrt each weight */
float **y_tmp;        /* temporary storage of network outputs */
float **a_tmp;        /* temporary storage of network activations */
float **z_tmp;       /* temporary storage of hidden node ouputs */
float **dz_mat;      /* derivatives of hidden node outputs */
float *dent;            /* derivative of xentropy */
float *dr;            /* derivative of regulariser */

float **xhess;       /* Exact hessian for pattern x */
char    nettype [NAME_LENGTH];     /* class or regress */


/*----------------------------------------------------------------------*/

void mlp (float *w, float ***ypred, float ***apred)

     /* Single hidden layer MLP with tanh hidden units */

{
  register float act_tmp, total;
  register float act_out_tmp;
  register int n,h,i,k,kd;
  register int weight;
  register int hidden_weights;
  register int h_weight;

  extern void print_matrix();
  extern void print_vector();

  /* Forward pass through the hidden units */

  for (n=1; n<=nd; n++)
    for (h=1; h<=nh; h++){
      /*printf("Node %d:\n", h);*/
      act_tmp=0;
      for (i=1; i<=ni; i++) {
	weight=(h-1)*(ni+1)+i;
	/*printf("Weight %d\n",weight);*/
	act_tmp+= x[n][i]*w[weight];
      }
      weight=(h-1)*(ni+1)+ni+1;
      /*printf("Weight %d\n",weight);*/
      act_tmp+=w[weight];
      z_tmp[n][h]=tanh((double)act_tmp);
      dz_mat[n][h]=1-z_tmp[n][h]*z_tmp[n][h];
    }

  /*printf("Hidden node outputs:\n");
    print_matrix(z_tmp,nd,nh);*/

  /* Forward pass through the output units */

  hidden_weights=(ni+1)*nh;
  /*printf("Node %d:\n", nh+1);*/
  for (n=1; n<=nd; n++){
    for (k=1; k<=no; k++){
      act_out_tmp=0;
      for (h=1; h<=nh; h++){
	weight=hidden_weights+h+(k-1)*(nh+1);
	/*printf("Weight %d\n",weight);*/
	act_out_tmp+=z_tmp[n][h]*w[weight];
      }
      weight=hidden_weights+k*(nh+1);
      /*printf("Weight %d\n",weight);*/
      act_out_tmp+=w[weight];
      a_tmp[n][k]=act_out_tmp;
    }
    if (strcmp(nettype,"class")==0)
      if (no==1)
	y_tmp[n][1]=1.0 / (1.0 + exp ((double)-1*a_tmp[n][1]));
      else {
	total=0;
	for (k=1; k<=no; k++){
	  total+=exp(a_tmp[n][k]);
	}
	for (k=1; k<=no; k++)
	  y_tmp[n][k]=exp(a_tmp[n][k])/total;
      }
    else 
      for (k=1; k<=no; k++)
	y_tmp[n][k]=a_tmp[n][k];
  }
   
  /* Backward pass through network: */
  /* Get derivative of network activation wrt each weight: da */

  /*For hidden weights */
  for (k=1; k<=no; k++)
    for (n=1; n<=nd; n++)
      for (h=1; h<=nh; h++){
	h_weight=hidden_weights+h+(k-1)*(nh+1);
	for (i=1; i<=ni; i++){
	  weight=(h-1)*(ni+1)+i;
	  /*printf("Weight %d\n",weight);*/
	  da_mat[n][weight][k]=x[n][i]*w[h_weight]*dz_mat[n][h];
	}
	weight=(h-1)*(ni+1)+ni+1;
	da_mat[n][weight][k]=w[h_weight]*dz_mat[n][h];
      }


  /*For output weights*/
  for (k=1; k<=no; k++)
    for (n=1; n<=nd; n++){
      for (h=1; h<=nh; h++){
	h_weight=hidden_weights+h+(k-1)*(nh+1);
	da_mat[n][h_weight][k]=z_tmp[n][h];
	for (kd=1; kd<=no; kd++)
	  if (kd!=k){
	    h_weight=hidden_weights+h+(kd-1)*(nh+1);
	    da_mat[n][h_weight][kd]=0;
	  }
      }
      weight=hidden_weights+k*(nh+1);
      da_mat[n][weight][k]=1;
    }
  /*printf("da:\n");
    print_matrix(da_mat,nd,nw);*/

  /*da=vector(1,nw);
    for (i=1; i<=nw; i++)
    for (n=1; n<=nd; n++)
    da[i]=da[i]+da_mat[n][i];*/

  /*printf("Output:\n");
    print_vector(y_tmp,nd);*/

  *ypred=y_tmp;
  *apred=a_tmp;
}

/*----------------------------------------------------------------------*/

float reg (float *w)
{
  register int i;
  register float w_err=0;

  for (i=1; i<=nw; i++){
    /*printf("Weight %d\n", i);*/
    w_err += a[1][i]*w[i]*w[i];
  }
  w_err=w_err*0.5;
  /*printf("Weight error=%1.6f\n", w_err);
    return(w_err);*/
}

/*----------------------------------------------------------------------*/

float mse (float *w)
{
  register int i,k;
  register float g=0;

  extern void print_vector();
  extern void print_matrix();


  mlp (w, &ypred, &apred);

  for (i=1; i<=nd; i++)
    for (k=1; k<=no; k++)
      g += (y[i][k]-ypred[i][k])*(y[i][k]-ypred[i][k]);
  /*printf("Total squared error =%1.6f\n", g);*/
  return(g);
}

/*----------------------------------------------------------------------*/

float xent (float *w)
{
  float **act;
  register int i,k;
  register float e = 1.0e-10;
  register float g=0;

  extern void print_vector();
  extern void print_matrix();


  mlp (w, &ypred, &apred);

  for (i=1; i<=nd; i++){
    if (no==1)
      g += y[i][1]*log((double)ypred[i][1]+e) + (1-y[i][1])*log((double)1-ypred[i][1]+e);
    else
      for (k=1; k<=no; k++)
	g += y[i][k]*log((double)ypred[i][k]+e);
  }
  g=-g;
  /*printf("Cross entropy=%1.6f\n", g);*/
  return(g);
}

/*----------------------------------------------------------------------*/

float reg_xent (float *w)
{
  register float g =0;
  register float w_err=0;
  register float e=0;

  g=xent(w);
  w_err=reg(w);
  e=g+w_err;
  return(e);
}

/*----------------------------------------------------------------------*/

float reg_mse (float *w)
{
  register float g =0;
  register float w_err=0;
  register float e=0;

  g=mse(w);
  w_err=reg(w);
  e=g+w_err;
  return(e);
}

/*----------------------------------------------------------------------*/

void dreg (float *w, float **df)
{
  register int i;

  extern void print_vector();

  for (i=1; i<=nw; i++){
    /*printf("Weight %d\n", i);*/
    dr[i] = a[1][i]*w[i];
  }
  /*printf("dreg:\n");
    print_vector(d,nw);*/
  *df=dr;
}


/*----------------------------------------------------------------------*/

void dxent (float *w, float **df)
{
  register float delta;
  register int i,j,k;

  extern void print_vector();

  for (j=1; j<=nw; j++)
    dent[j]=0;

  for (k=1; k<=no; k++)
    for (i=1; i<=nd; i++){
      delta=ypred[i][k]-y[i][k];
      /*printf("Delta=%1.4f\n",delta);*/
      /*printf("Weight %d\n", i);*/
      for (j=1; j<=nw; j++)
	dent[j] += delta*da_mat[i][j][k];
    }
  /*printf("dxent:\n");
    print_vector(d,nw);*/
  *df=dent;
}

/*----------------------------------------------------------------------*/

void dreg_xent (float *w, float *df)
{
  register int i;
  float *d1;
  float *d2;

  extern void print_vector();
  dxent(w,&d1);
  dreg(w,&d2);

  for (i=1; i<=nw; i++)
    df[i]=d1[i]+d2[i];

  /*printf("dreg_xent OK:\n");
    print_vector(df,nw);*/

}

/*----------------------------------------------------------------------*/

void f_test(float *w, float (*func)(float []))

     /* Routine for testing link with numerical recipes optimizers */
{
  float fp;

  fp=(*func)(w);
  printf("fp=%1.4f\n",fp);
}

/*----------------------------------------------------------------------*/

void df_test(float *w, void (*dfunc)(float [], float[]))

     /* Routine for testing link with numerical recipes optimizers */
{
  float *xi;

  extern void print_vector();

  xi=vector(1,nw);
  (*dfunc)(w,xi);
  printf("xi:\n");
  print_vector(xi,nw);
}

/*----------------------------------------------------------------------*/


void optimise (float **w, char *algorithm, float ftol, int maxits, float ***new_weights)
{
  /* inside this routine we have weight vectors */
  /* outside we have weight matrices */

  float e;
  float *start_w;
  float *stop_w;
  float **tmp_w;
  int iter;
  float fret;
  float *df;
  int i;

  extern void get_row(float **v, int r, int cols, float **vec);
  extern void print_matrix();
  extern void print_vector();
  /*extern void frprmn();*/
  extern void frprmn(float p[], int n, float ftol, int itmax, int *iter, float *fret, float (*func)(float []), void (*dfunc)(float [], float []));

  extern void dfpmin(float p[], int n, float ftol, int itmax, int *iter, float *fret, float (*func)(float []), void (*dfunc)(float [], float []));

  get_row(w,1,nw,&start_w);
  /*printf("Initial weights\n");
print_vector(start_w,nw);*/

/* Test routines 
f_test(start_w, reg_xent);
df_test(start_w, dreg_xent);*/



/*puts(algorithm);
printf("Value=%d",strcmp(algorithm,"conjgrad"));
printf("Value=%d",strcmp(algorithm,"bfgs"));*/
  if (strcmp(algorithm,"conjgrad")==0)
    if (strcmp(nettype,"class")==0)
      frprmn(start_w, nw, ftol, maxits, &iter, &fret, reg_xent, dreg_xent);
    else
      frprmn(start_w, nw, ftol, maxits, &iter, &fret, reg_mse, dreg_xent);
  else if (strcmp(algorithm,"bfgs")==0)
    if (strcmp(nettype,"class")==0)
      dfpmin(start_w, nw, ftol, maxits, &iter, &fret, reg_xent, dreg_xent);
    else
      dfpmin(start_w, nw, ftol, maxits, &iter, &fret, reg_mse, dreg_xent);

  else {
    printf("Algorithm: %s unknown\n", algorithm);
    exit(0);
  }

  /*printf("Trained weights:\n");
print_vector(start_w,nw);*/

/*e=reg_xent(start_w);
dreg_xent(start_w,&df);*/

  tmp_w=matrix(1,1,1,nw);
  for (i=1; i<=nw; i++)
    tmp_w[1][i]=start_w[i];
  *new_weights=tmp_w;
}

/*----------------------------------------------------------------------*/

void hessian_patt_mlp (float *ww, int patt, float *xpatt, double *delta)
{
  /* Calculation of Hessian using Bishop's exact method for a single input pattern. For a MLP with one layer of tanh units and linear/sigmoid/softmax outputs trained on mse
or cross entropy error. 

     ww	        Weights
     xpatt    	One input pattern
     delta           de/dy for mse, de/da for cross entropy */

  /* Note: this correct implementation from formulae in Jan 98 Lab book. These
work for softmax outputs whereas Bishops two-layer recipe (p157-158) does not */

/* Internal variables
w    	        output layer weights 
phi             hidden layer outputs            	     
delta           error scalar
y               output vector        	     	     */

  register int j, jd, i, id, k, kd, h;
  register int w_index, wd_index;
  int nhw;  /* number of hidden weights */
  int now;  /* number of output weights */
  float ypatt;  /* network output for this pattern */
  float *phi;
  float *w;
  double first_term;
  double second_term;
  double dzda;
  double dzdaj;
  double dzdajd;
  double d2zda;
  double xi,xid;
  double zj,zjd;
  double Hkk;

  extern void print_vector();

  nhw=nh*(ni+1);
  now=nw-nhw;
  w=vector(1,nw);
  for (i=1; i<=now; i++)
    w[i]=ww[nhw+i];

  phi=vector(1,now);
  for (h=1; h<=nh; h++)
    phi[h]=z_tmp[patt][h];
  phi[nh+1]=1;

  /* BOTH WEIGHTS IN FIRST LAYER */

  for (j=1; j<=nh; j++)
    for (jd=1; jd<=nh; jd++) {
      /* SUM wkj wkjd Hkk TERM */
      second_term=0;
      for (k=1; k<=no; k++)
	for (kd=1; kd<=no; kd++){
          if (strcmp(nettype,"class")==0)
	    if (kd==k)
	      Hkk=ypred[patt][k]*(1-ypred[patt][k]);
            else
	      Hkk=-ypred[patt][k]*ypred[patt][kd];
	  else
	    if (kd==k)
	      Hkk=1;
            else
	      Hkk=0;
          second_term += w[jd+(k-1)*(nh+1)]*w[j+(kd-1)*(nh+1)]*Hkk;
      }
    
      /* PRODUCT OF FIRST DERIV TERM 
       For tanh hidden units */
      dzdaj=1-phi[j]*phi[j];
      dzdajd=1-phi[jd]*phi[jd];
      second_term = dzdaj*dzdajd*second_term;

      if (j==jd){
	first_term=0;
	for (k=1; k<=no; k++)
	  first_term += w[jd+(k-1)*(nh+1)]*delta[k];
	/*For tanh hidden units */
	d2zda=2*phi[jd]*(phi[jd]*phi[jd]-1);
	first_term = first_term * d2zda;
      }
      else
	first_term = 0;

      for (i=1; i<=ni+1; i++)
	for (id=1; id<=ni+1; id++){
	  w_index=(j-1)*(ni+1) + i;
	  wd_index=(jd-1)*(ni+1) + id;
	  if (i==ni+1)  /* bias */
	    xi=1;
	  else
	    xi=xpatt[i];
	  if (id==ni+1) /* bias */
	    xid=1;
	  else 
	    xid=xpatt[id];
	  /* EQUATION 4.83 FROM BISHOP */
	  xhess[w_index][wd_index]=xi*xid*(first_term+second_term);
	}
    }

  /* BOTH WEIGHTS IN SECOND LAYER */

  for (j=1; j<=nh+1; j++)
    for (jd=1; jd<=nh+1; jd++) 
      for (k=1; k<=no; k++)
	for (kd=1; kd<=no; kd++){
	  w_index=nhw + j + (k-1) * (nh+1);
	  wd_index=nhw + jd + (kd-1) * (nh+1);
	  if (j==nh+1)  /* Bias */
	    zj=1;
	  else
	    zj=phi[j];
	  if (jd==nh+1) /* Bias */
	    zjd=1;
	  else
	    zjd=phi[jd];
          if (strcmp(nettype,"class")==0)
	    if (kd==k)
	      Hkk=ypred[patt][k]*(1-ypred[patt][k]);
            else
	      Hkk=-ypred[patt][k]*ypred[patt][kd];
	  else
	    if (kd==k)
	      Hkk=1;
            else
	      Hkk=0;
	  /* EQUATION 4.82 from BISHOP  */
          xhess[w_index][wd_index] = zj*zjd*Hkk;
	}


  /* ONE WEIGHT IN EACH LAYER */

  for (j=1; j<=nh; j++)
    for (jd=1; jd<=nh+1; jd++)
      for (k=1; k<=no; k++)
	for (i=1; i<=ni+1; i++) {
	  w_index=(j-1)*(ni+1)+i;
	  wd_index=nhw +jd + (k-1) * (nh+1);
	  /*printf("w_index = %d, wd_index = %d", w_index, wd_index);*/
	  if (jd==nh+1) /*Bias  */
	    zjd=1;
	  else
	    zjd=phi[jd];
	  if (i==ni+1) /* Bias */
	    xi=1;
	  else
	    xi=xpatt[i];

       	  dzdaj=1-phi[j]*phi[j];
	  dzdajd=1-phi[jd]*phi[jd];

	  /* Evaluate first term */
	  if (j==jd)
	    /* next line should be
	       first_term=delta[k]*dzdajd;*/
	    first_term=delta[k]*dzdaj;
	  else
	    first_term = 0;

	  /* Evaluate second term */
	  second_term=0;
	  for (kd=1; kd<=no; kd++){
	    if (strcmp(nettype,"class")==0)
	      if (kd==k)
		Hkk=ypred[patt][k]*(1-ypred[patt][k]);
	      else
		Hkk=-ypred[patt][k]*ypred[patt][kd];
	    else
	      if (kd==k)
		Hkk=1;
	      else
		Hkk=0;
	    second_term += w[j+(kd-1)*(nh+1)]*Hkk;
	  }
	  second_term = second_term * zjd * dzdaj;
	  /* EQUATION 4.84 BISHOP */
	  xhess[w_index][wd_index]=xi*(first_term+second_term);
	  /* set opposite term also */
	  xhess[wd_index][w_index]=xhess[w_index][wd_index];
	}

  free_vector(phi,1,now);
  free_vector(w,1,now);
}

/*----------------------------------------------------------------------*/

void exact_hessian_mlp(float *w, float ***h)

{
  register int i,k;
  double *delta;
  float **hess;

  extern void print_matrix();
  extern void print_vector();
  extern void add_matrix();

  xhess=matrix(1,nw,1,nw);
  hess=matrix(1,nw,1,nw);
  delta=dvector(1,no);

  mlp (w, &ypred, &apred);
  for (i=1; i<=nd; i++){
    /*printf("Data point %d\n", i);*/
    for (k=1; k<=no; k++)
      delta[k]=ypred[i][k]-y[i][k];
    /*if (i<20 && i>16){
      printf("Data point=%d Delta=%1.4f ",i,delta); 
      printf("apred=%1.4f  ",apred[i]); 
      printf("ypred=%1.4f  ",ypred[i]); 
      printf("y=%1.4f\n",y[i][1]); 
      print_vector(z_tmp[i],nh);
      print_vector(x[i],ni);
      }*/
    hessian_patt_mlp (w,i,x[i],delta);
    add_matrix(hess,xhess,nw,nw,hess);
    /*print_matrix(xhess,nw,nw);*/
  }

  /*print_vector(w,nw);*/
  free_matrix(xhess,1,nw,1,nw);
  free_dvector(delta,1,no);
  *h=hess;
}

/*----------------------------------------------------------------------*/
 
printusage()
{

  printf("conjgrad: optimisation algorithm for training an MLP with a single
hidden layer of tanh units. The output units are linear, sigmoids or softmax units.\n");

  printf("\nCommand requires 12 parameters:");
  printf("\n1. Training data filename");
  printf("\n2. Weights filename");
  printf("\n3. Hyperparameters filename");
  printf("\n4. Number of inputs in the net"); 
  printf("\n5. Number of hidden units in the net"); 
  printf("\n6. Number of outputs in the net"); 
  printf("\n7. Network type ('class' or 'regress')");
  printf("\n8. Algorithm (bfgs or conjgrad)");
  printf("\n9. Tolerance");
  printf("\n10. Maximum number of iterations");
  printf("\n11. Output weights filename");
  printf("\n12. Output hessian filename\n\n");

  printf("\n\nFormat of data files:");
  printf("\nTraining data:\n each training example is a row. The last element is the target value (y). The elements before this are the inputs (x).\n");
  printf("\nWeights:\n A single row where the jth entry is the jth weight in the net\n");
  printf("\nHyperparameters:\n A single row where the jth entry is the hyperparamater corresponding to the jth weight in the net. Note: eg. all the values may be the same indicating the weights are governed by a single hyperparameter.\n");
  printf("\nOutput weights:\n A single row where the jth entry is the jth trained weight in the net\n\n");
  exit (0);
}
 
/*-----------------------------------------------------------------*/

main (argc, argv)
     int argc;
     char *argv[];
{
  char    x_file [NAME_LENGTH];     /* data file */
  char    w_file [NAME_LENGTH];     /* weights file */
  char    a_file [NAME_LENGTH];     /* hyperparameter file */
  char    ow_file [NAME_LENGTH];     /* output weights file */
  char    oh_file [NAME_LENGTH];     /* output hessian file */
  char    algorithm [NAME_LENGTH];     /* bfgs or conjgrad */

  float   **w;
  float   **new_weights;
  float   **hessian;
  int   maxits;
  float ftol;

  extern void get_data();
  extern void print_matrix();
  extern void print_vector();

  if (argc!=13)
    printusage();
 
  sscanf(argv[1],"%s",x_file);
  sscanf(argv[2],"%s",w_file);
  sscanf(argv[3],"%s",a_file);
  sscanf(argv[4],"%d",&ni);  
  sscanf(argv[5],"%d",&nh);   
  sscanf(argv[6],"%d",&no);   
  sscanf(argv[7],"%s",nettype);
  sscanf(argv[8],"%s",algorithm);
  sscanf(argv[9],"%f",&ftol);
  sscanf(argv[10],"%d",&maxits);
  sscanf(argv[11],"%s",ow_file);
  sscanf(argv[12],"%s",oh_file);

  /* LOAD TRAINING DATA */
  get_data(&x,&y,&nd,&ni,no,x_file);

  /*printf("Number of Input Variables=%d\n", ni);
    printf("Number of Examples=%d\n", nd);
    printf("Number of outputs=%d\n", no);*/

  /*print_matrix(x,nd,ni);
    print_matrix(y,nd,1);*/

  /* LOAD WEIGHTS */
  get_data(&w,&w_dummy,&nw_dummy,&nw,0,w_file);
  /*printf("Number of weights=%d\n", nw);
    print_matrix(w,1,nw);*/

  /* Check number of weights is compatible with network */

  if (nw != (ni+1)*nh+(nh+1)*no){
    printf("\nError in conjgrad: mismatch between data dimensions and network size\n");
    exit(-1);
  }

  /* LOAD HYPERPARAMETERS */
  get_data(&a,&a_dummy,&na_dummy,&na,0,a_file);
  /*printf("Number of hyperparameters=%d\n", na);
    print_matrix(a,1,na);*/

  /* Allocate working space for computations */
  y_tmp=matrix(1,nd,1,no);             /* for network outputs */
  a_tmp=matrix(1,nd,1,no);             /* for network acivation */
  da_mat=f3tensor(1,nd,1,nw,1,no);     /* for derivatives of node activations */
  dz_mat=matrix(1,nd,1,nh);            /* for derivatives of hidden node outputs */
  z_tmp=matrix(1,nd,1,nh);             /* for hidden node outputs */
  dr=vector(1,nw);                     /* for derivative of regularized cost term  */
  dent=vector(1,nw);                   /* for derivative of cross entropy cost */

  /* OPTIMISE */
  optimise(w,algorithm,ftol,maxits,&new_weights);
  /*printf("New weights:\n");
    print_matrix(new_weights,1,nw);
    printf("New weights:\n");
    print_vector(new_weights[1],nw);*/

  /*printf("Optimisation OK\n\n");*/

  /* OUTPUT WEIGHTS */
  fprint_matrix(new_weights,1,nw,ow_file);

  /* GET HESSIAN */
  exact_hessian_mlp(new_weights[1], &hessian);
  fprint_matrix(hessian,nw,nw,oh_file);

  /*printf("Evaluation of Hessian OK\n\n");*/

  /* Free up working space */
  free_matrix(y_tmp,1,nd,1,no);
  free_matrix(a_tmp,1,nd,1,no);
  free_f3tensor(da_mat,1,nd,1,nw,1,no);
  free_matrix(dz_mat,1,nd,1,nh);
  free_matrix(z_tmp,1,nd,1,nh);
  free_vector(dr,1,nw);
  free_vector(dent,1,nw);
}

