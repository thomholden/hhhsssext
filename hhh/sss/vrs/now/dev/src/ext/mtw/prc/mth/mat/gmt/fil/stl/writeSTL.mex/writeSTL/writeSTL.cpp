#include "string.h"
#include "mex.h"
#include "iostream.h"
#include "fstream.h"
#include "string.h"
#include "time.h"
#include "stdio.h"
#include "math.h"

//using namespace std;

void writeSTL(int numberOfNodes, double *Nodes, int numberOfTriangles, double* Triangles,char* filename)
{
	//crete file
	FILE * pFile;
  pFile = fopen(filename,"w");
	char buffer[200];
    char a;
    int i;
    for(i=0; i<0; i++)//numberOfNodes
    {
        printf("Nodes %d x %f ",i,  Nodes[i]);
        printf("Nodes %d y %f ",i,  Nodes[i+numberOfNodes]);
        printf("Nodes %d z %f\n",i, Nodes[i+2*numberOfNodes]);
    }   
	//STL header
	fputs("solid ars_STL\n",pFile);
  int n;
	for(int iTriangle=0; iTriangle<numberOfTriangles; iTriangle++)
	{	
		int currentTriangle[3]  = {(int)Triangles[iTriangle],(int)Triangles[iTriangle+numberOfTriangles], (int)Triangles[iTriangle+2*numberOfTriangles]};
        currentTriangle[0] -=1;
        currentTriangle[1] -=1;
        currentTriangle[2] -=1;
        double pointA[3]         = { Nodes[currentTriangle[0]], Nodes[currentTriangle[0]+numberOfNodes], Nodes[currentTriangle[0]+2*numberOfNodes]};
        double pointB[3]         = { Nodes[currentTriangle[1]], Nodes[currentTriangle[1]+numberOfNodes], Nodes[currentTriangle[1]+2*numberOfNodes]};
        double pointC[3]         = { Nodes[currentTriangle[2]], Nodes[currentTriangle[2]+numberOfNodes], Nodes[currentTriangle[2]+2*numberOfNodes]};
		    double BminusA[3]        = { pointB[0]-pointA[0], pointB[1]-pointA[1], pointB[2]-pointA[2]};
    		double CminusA[3]        = { pointC[0]-pointA[0], pointC[1]-pointA[1], pointC[2]-pointA[2]};
        double normal[3]        = { BminusA[1]*CminusA[2]-BminusA[2]*CminusA[1], -(BminusA[0]*CminusA[2]-BminusA[2]*CminusA[0]), BminusA[0]*CminusA[1]-BminusA[1]*CminusA[0]};
        double intenistyOfNormal = sqrt( normal[0]*normal[0]+ normal[1]*normal[1] + normal[2]*normal[2]);
        if(intenistyOfNormal>0) //ako je dobra normal upisi, ako nije preskoci trouglic
		{
			normal[0] = normal[0]/intenistyOfNormal;
			normal[1] = normal[1]/intenistyOfNormal;
			normal[2] = normal[2]/intenistyOfNormal;
			sprintf (buffer, "facet normal %f %f %f \n", normal[0],normal[1],normal[2]);
      fputs (buffer,pFile);
			fputs ("outer loop\n",pFile);
					sprintf(buffer, "vertex %f %f %f\n", pointA[0],pointA[1],pointA[2]);
					fputs(buffer,pFile);
					sprintf(buffer, "vertex %f %f %f\n", pointB[0],pointB[1],pointB[2]);
					fputs(buffer,pFile);
					sprintf(buffer, "vertex %f %f %f\n", pointC[0],pointC[1],pointC[2]);
					fputs(buffer,pFile);
				fputs("endloop\n",pFile);		
			fputs("endfacet\n",pFile);
		}//end if(intenistyOfNormal==0)
	}//endfor
    fputs("endsolid ars_STL\n",pFile);
	fclose(pFile);
}
///////////// MEX ///////////////////////
//INPUTS(matlab)
		// nodes[numNudes x 3] = prhs[0]
		// faces[numFaces x 3] = prhs[1]
		// string							 = prhs[2]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{//void upisiSTL(int numberOfNodes, double Nodes[][3], int numberOfTriangles, int Triangles[][3])
    const   mwSize  *dims 															     ;
    const   mxArray *mxNodes     = prhs[0]                   ;
    double          *Nodes       = (double*)mxGetPr(mxNodes) ;
    const   mxArray *mxTriangles = prhs[1]                   ;
    double          *Triangles   = mxGetPr(mxTriangles)      ;
    int             numberOfNodes                            ;
    int             numberOfTriangles                        ;
    ////// Nodes 
    numberOfNodes     = (int)mxGetM(prhs[0]);
    numberOfTriangles = (int)mxGetM(prhs[1]);
    char *filename;
    filename = mxArrayToString(prhs[2]);
    writeSTL(numberOfNodes,Nodes,numberOfTriangles,Triangles, filename);
    ////////////////////////////////////////////////////////////  
    printf("-----------------------------------------------\n");
    printf("--------------------STL------------------------\n");
    printf("naziv fajla(filename)             : %s\n",filename);
    printf("br cvorova(number of nodes)       : %d\n",numberOfNodes);
    printf("br trouglova(number of triangles) : %d\n",numberOfTriangles);
    printf("-------------------END STL---------------------\n");
    printf("-----------------------------------------------\n");
}












