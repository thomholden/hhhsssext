
/* List of inclusions. */
#include "mex.h"
#include "math.h"

/* Gateway routine. */
void mexFunction(int n, mxArray *q[], int m, const mxArray *p[]) {
  
  /* Declare variables. */
  bool b;
  int i, j, k, kk, ik, jk, ij, r, s, *d;
  double t, *x, *y, *dx, *dy;
  
  /* Check number of inputs and outputs. */
  if (m<2) {
    mexErrMsgTxt("Not enough inputs.");
  }
  if (m>2) {
    mexErrMsgTxt("Too many inputs.");
  }
  if (n>1) {
    if (n>2) {
      mexErrMsgTxt("Too many outputs.");
    }
    b=true;
  } else {
    b=false;
  }
  
  /* Initialize counter. */
  i=0;
  
  /* Check first input. */
  if (!(mxIsDouble(p[i]))) {
    mexErrMsgTxt("First input must be double-precision.");
  }
  if (mxIsComplex(p[i])) {
    mexErrMsgTxt("First input must be real.");
  }
  if (mxGetNumberOfDimensions(p[i])>2) {
    mexErrMsgTxt("First input must be a matrix.");
  }
  if (mxIsSparse(p[i])) {
    mexErrMsgTxt("First input must be full.");
  }
  m=mxGetM(p[i]);
  if (mxGetN(p[i])!=m) {
    mexErrMsgTxt("First input must be square.");
  }
  
  /* Store pointer to first input. */
  x=mxGetPr(p[i]);
  
  /* Allocate space for first output. */
  q[i]=mxCreateNumericMatrix(m,m,mxDOUBLE_CLASS,mxREAL);
  
  /* Store pointer to first output. */
  y=mxGetPr(q[i]);
  
  /* Increment counter. */
  i++;
  
  /* Check second input. */
  if (!(mxIsDouble(p[i]))) {
    mexErrMsgTxt("Second input must be double-precision.");
  }
  if (mxIsComplex(p[i])) {
    mexErrMsgTxt("Second input must be real.");
  }
  n=mxGetNumberOfDimensions(p[i]);
  if (n>2) {
    if (n>3) {
      mexErrMsgTxt("Second input must have no more than three dimensions.");
    }
  } else {
    if (mxIsSparse(p[i])) {
      mexErrMsgTxt("Secound input must be full.");
    }
  }
  d=mxGetDimensions(p[i]);
  if (*d!=m) {
    mexErrMsgTxt("First and second inputs must have the number of rows.");
  }
  if (*(d+1)!=m) {
    mexErrMsgTxt("First and second inputs must have the number of columns.");
  }
  
  /* Store pointer to second input. */
  dx=mxGetPr(p[i]);
  
  /* Store numerical tolerance. */
  t=mxGetEps();
  
  /* Branch according to number of outputs. */
  if (b) {
    
    /* Allocate space for second output. */
    q[i]=mxCreateNumericArray(n,d,mxDOUBLE_CLASS,mxREAL);
    
    /* Store pointer to second output. */
    dy=mxGetPr(q[i]);
    
    /* Store number of elements. */
    s=m*m;
    if (n>2) {
      n=s*d[n-1];
    } else {
      n=s;
    }
    
    /* Copy matrices. */
    ij=0;
    for (j=0; j<m; j++) {
      for (i=0; i<j; i++) {
        y[ij]=0.0;
        for (r=0; r<n; r+=s) {
          dy[ij+r]=0.0;
        }
        ij++;
      }
      for (i=j; i<m; i++) {
        y[ij]=x[ij];
        for (r=0; r<n; r+=s) {
          dy[ij+r]=dx[ij+r];
        }
        ij++;
      }
    }
    
    /* Factorize matrices. */
    for (k=0; k<m; k++) {
      
      /* Check for early return. */
      kk=k+k*m;
      if (y[kk]<t) {
        mexErrMsgTxt("First input must be positive-definite.");
      }
      
      /* Define pivots. */
      y[kk]=sqrt(y[kk]);
      for (r=0; r<n; r+=s) {
        dy[kk+r]/=2.0*y[kk];
      }
      
      /* Adjust leading columns. */
      jk=kk+1;
      for (j=k+1; j<m; j++) {
        y[jk]/=y[kk];
        for (r=0; r<n; r+=s) {
          dy[jk+r]=(dy[jk+r]-y[jk]*dy[kk+r])/y[kk];
        }
        jk++;
      }
      
      /* Perform row operations. */
      ij=jk;
      jk=kk+1;
      for (j=k+1; j<m; j++) {
        ij+=j;
        ik=jk;
        for (i=j; i<m; i++) {
          y[ij]-=y[ik]*y[jk];
          for (r=0; r<n; r+=s) {
            dy[ij+r]-=dy[ik+r]*y[jk]+y[ik]*dy[jk+r];
          }
          ij++;
          ik++;
        }
        jk++;
      }
      
    }
    
  } else {
    
    /* Copy matrix. */
    ij=0;
    for (j=0; j<m; j++) {
      for (i=0; i<j; i++) {
        y[ij]=0.0;
        ij++;
      }
      for (i=j; i<m; i++) {
        y[ij]=x[ij];
        ij++;
      }
    }
    
    /* Factorize matrix. */
    for (k=0; k<m; k++) {
      
      /* Check for early return. */
      kk=k+k*m;
      if (y[kk]<t) {
        mexErrMsgTxt("First input must be positive-definite.");
      }
      
      /* Define pivot. */
      y[kk]=sqrt(y[kk]);
      
      /* Adjust leading column. */
      jk=kk+1;
      for (j=k+1; j<m; j++) {
        y[jk]/=y[kk];
        jk++;
      }
      
      /* Perform row operations. */
      ij=jk;
      jk=kk+1;
      for (j=k+1; j<m; j++) {
        ij+=j;
        ik=jk;
        for (i=j; i<m; i++) {
          y[ij]-=y[ik]*y[jk];
          ij++;
          ik++;
        }
        jk++;
      }
      
    }
    
  }
  
}
