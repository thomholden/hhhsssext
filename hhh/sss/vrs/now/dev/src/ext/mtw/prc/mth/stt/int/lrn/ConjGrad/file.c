/*----------------------------------------------------------------------
  --- FILENAME: file.c
  --- DESCRIPTION: Definition of file handling routines 
  ----------------------------------------------------------------------*/

#include <stdio.h>
#include "nrutil.h"

# define LINELENGTH 65536

/*------------------------------------------------------------------------*/

void add_matrix(float **m1, float **m2, int rows, int columns, float **mout)
/* Add two matrices */
{
int i, j;
 
for (i=1;i<=rows;i++)
  for (j=1; j<=columns; j++)
                mout[i][j]=m1[i][j]+m2[i][j];
}

/*------------------------------------------------------------------------*/

void fprint_matrix(float **v, int x, int y, char *name)
/* PRINT UNIT OFFSET VECTORS IE THOSE THAT GO 1..N, NOT 0..N-1 */
{
int i=1;
int j=1;
FILE *fp;
 
fp=fopen(name,"w"); 
if (fp==NULL){
  printf("Error in fprint_matrix: could not open file\n");
  exit(0);
}
  
for (i=1; i<=x; i++){
        fprintf(fp,"\n");
        for (j=1; j<=y; j++)
                fprintf(fp,"%1.4f ", v[i][j]);
}
        
fprintf(fp,"\n");
}

/*------------------------------------------------------------------------*/

void print_matrix(float **v, int x, int y)
/* PRINT UNIT OFFSET VECTORS IE THOSE THAT GO 1..N, NOT 0..N-1 */
{
int i=1;
int j=1;
 
 
for (i=1; i<=x; i++){
        printf("\n");
        for (j=1; j<=y; j++)
                printf("%1.4f ", v[i][j]);
}
        
printf("\n");
}

/*------------------------------------------------------------------------*/

void print_vector(float *v, int n)
/* PRINT UNIT OFFSET VECTORS IE THOSE THAT GO 1..N, NOT 0..N-1 */
{
int i=1;
 
for (i=1; i<=n; i++){
       printf("%1.4f ", v[i]);
}
        
printf("\n");
}

/*------------------------------------------------------------------------*/

void get_row(float **v, int r, int cols, float **vec)
/* Pick out row from a matrix */
{
int i=1;
int j=1;
float *tmp_vec;

tmp_vec=vector(1,cols);
/*print_vector(tmp_vec,cols);*/
 
for (j=1; j<=cols; j++)
      tmp_vec[j]= v[r][j];
*vec=tmp_vec;
}


/*----------------------------------------------------------------------*/

void words_in_line (char *instr, int *w)

/* return the number of words in a string */
/* where a word is any sequence of characters that does not contain */
/* a blank, tab or newline */
{
 int f=0; /* number of words or fields */
 int infield=0;
 int i=0;
  
 f=0;
 infield=0;					
 for (i=0; i<strlen(instr); i++) {
	if ((instr[i]==' ') || (instr[i]=='\n') || (instr[i]=='\t'))
		 infield=0;
	else if (infield==0) {
		 infield=1;
		 f++;
	}
 }
 /*printf("%d\n",f);*/
 *w=f;
}

/*----------------------------------------------------------------------*/

void get_data (float ***idata, float ***odata, int *ndata, int *ma, int outputs, char *fname)
/* INPUTS */
/* OUTPUTS */
/* Number of data points */
/* Number of input variables */
/* Number of outputs */
/* Read from file with this name */
{
int examples=0;
int variables=0;
int var_number=1;
int example=1;
int num_words=0;
float value=0;
char instr[LINELENGTH];
FILE *fp;
int firstline=1;
float **tempin;
float **tempout;

/*printf("Reading Data File: %s\n", fname);*/
/* GET NUMBER OF VARIABLES AND NUMBER OF EXAMPLES */

fp=fopen(fname,"r");
if (fp==NULL) {
	printf("Cannot open input data file %s\n", fname);
	exit(0);
}

firstline=1;
while (fgets(instr,LINELENGTH,fp)!=NULL) {
        /*puts(instr);*/
        words_in_line(instr,&num_words);
	if (num_words==0)
		break;
	if (!firstline && num_words!=variables)
		nrerror("Inconsistent number of variables in examples file");
	variables=num_words;
	examples++;
	firstline=0;
}

variables-=outputs;
fclose(fp);

/*RESERVE SPACE FOR TRAINING DATA */

tempin=matrix(1,examples,1,variables);
tempout=matrix(1,examples,1,outputs);

/* GET TRAINING DATA */
/*printf(" GET TRAINING DATA\n");*/
fp=fopen(fname,"r");
if (fp==NULL) {
	printf("Cannot open input data file %s\n", fname);
	exit(0);
}

var_number=1;
example=1;
while (fscanf(fp,"%f",&value)!=EOF) {
        if (var_number<=variables)
		tempin[example][var_number]=value;
	else
		tempout[example][var_number-variables]=value;
	var_number++;
	if (var_number>variables+outputs){
		var_number=1;
		example++;
	}
}
fclose(fp);
*ndata=examples;
*ma=variables;
*idata=tempin;
*odata=tempout;
/*print_matrix(tempin,examples,variables);*/
/*printf("Number of Input Variables=%d\n", variables);
printf("Number of Examples=%d\n", examples);*/
}


