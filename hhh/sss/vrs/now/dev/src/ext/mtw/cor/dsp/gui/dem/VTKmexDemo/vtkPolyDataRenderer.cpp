
/****************************************************
(C) 2005 Dominik Szczerba <domi at vision ee ethz ch>
*****************************************************/

//#include <cstdlib>
//#include <cmath>

/* MEX HEADERS */
#include <mex.h>

/* VTK HEADERS */
#include <vtkPolyData.h>
#include <vtkPoints.h>
#include <vtkCellArray.h>
#include <vtkDoubleArray.h>
#include <vtkPolyData.h>

#include <vtkCell.h>
#include <vtkCellData.h>
#include <vtkDataSet.h>
#include <vtkDataSetAttributes.h>
#include <vtkProperty.h>

#include <vtkDataSetMapper.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkInteractorStyleTrackballCamera.h>

/* MAIN FUNCTION */
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){

  double *v;	// Vertices
  double *f;	// Faces
  
  unsigned int nV, nF, nC=0, i, j;

  if(nrhs<2)
	 mexErrMsgTxt("2+ input args required");

  double* dcolors = 0;
  vtkDoubleArray* dcolarr = 0;
  
  nV = mxGetM(prhs[0]);
  nF = mxGetM(prhs[1]);
  v = mxGetPr(prhs[0]);
  f = (double*)mxGetPr(prhs[1]);
  if(nrhs>=3){
	 //mexPrintf("found color information\n");
	 nC = mxGetM(prhs[2]);
	 if(nC!=nF)
		mexErrMsgTxt("dimension mismatch");
	 dcolors = mxGetPr(prhs[2]);
	 dcolarr = vtkDoubleArray::New();
	 dcolarr->SetName("aCellScalar");
	 dcolarr->SetArray(dcolors,nF,1);//save dcolors
  }
  mexPrintf("got %d nodes, %d faces and %d colors\n",nV,nF,nC);

  // Initialize vtk variables
  vtkPolyData *surf = vtkPolyData::New();
  vtkPoints *sverts = vtkPoints::New();
  vtkCellArray *sfaces = vtkCellArray::New();

  // Load the point, cell, and data attributes.
  //indexes in VTK are 0-based, in Matlab 1-based
  const int offset = -1;
  for(i=0; i<nV; i++) sverts->InsertPoint(i,v[i],v[nV+i],v[2*nV+i]);
  for(i=0; i<nF; i++){
	 sfaces->InsertNextCell(3);
	 for(j=0;j<3;j++){
		int idx = (unsigned int)f[j*nF+i]+offset;
		if(idx<0 || idx>=nV)
		//mexPrintf("Warning : wrong index\n");
		  mexErrMsgTxt("wrong index");
		sfaces->InsertCellPoint(vtkIdType(idx));
	 }
  }
  
  // assign the pieces to the vtkPolyData.
  surf->SetPoints(sverts);
  surf->SetPolys(sfaces);
  sverts->Delete();
  sfaces->Delete();

  if(nC>0){
	 surf->GetCellData()->SetScalars(dcolarr);
  }

  // now render
  vtkDataSetMapper::SetResolveCoincidentTopologyToPolygonOffset();
  vtkPolyDataMapper *surfMapper = vtkPolyDataMapper::New();
  vtkActor *surfActor = vtkActor::New();
  vtkRenderer *aRenderer = vtkRenderer::New();
  vtkRenderWindow *renWin = vtkRenderWindow::New();
  vtkRenderWindowInteractor *iren = vtkRenderWindowInteractor::New();
  
  surfMapper->SetInput(surf);
  //surfMapper->ScalarVisibilityOff();
  if(nC>0){
	 surfMapper->ScalarVisibilityOn();
	 surfMapper->SetScalarRange(0,1);  
  }

  surfActor->SetMapper(surfMapper);
  surfActor->GetProperty()->SetAmbient(0.1);
  surfActor->GetProperty()->SetDiffuse(0.3);
  surfActor->GetProperty()->SetSpecular(1.0);
  surfActor->GetProperty()->SetSpecularPower(30.0);
  
  aRenderer->AddActor(surfActor);
  aRenderer->SetBackground(0.2,0.2,0.2);
  
  iren->SetRenderWindow(renWin);
  
  renWin->AddRenderer(aRenderer);
  renWin->SetSize(500,500);
  renWin->Render();
  
  vtkInteractorStyleTrackballCamera *style = 
 	 vtkInteractorStyleTrackballCamera::New();
  iren->SetInteractorStyle(style);

  // Start interactive rendering
  iren->Start();

  // clean up
  surfMapper->Delete();
  surfActor->Delete();
  surf->Delete();
  aRenderer->Delete();
  renWin->Delete();
  iren->Delete();
  style->Delete();

}