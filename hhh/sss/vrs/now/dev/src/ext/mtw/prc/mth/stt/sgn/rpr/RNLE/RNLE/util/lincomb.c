
/* List of inclusions. */
#include "mex.h"
#include "math.h"

/* List of definitions. */
#define BufferSize 100

/* Gateway routine. */
void mexFunction(int NumberOfOutputs, mxArray *ListOfOutputs[], int NumberOfInputs, const mxArray *ListOfInputs[]) {
  
  /* Declare variables. */
  int ArgumentCounter, Dimension, Index, LargeStep, NumberOfCoefficients, NumberOfDimensions, NumberOfElements, SmallStep;
  int *ListOfDimensions, *DimensionMarker, *DimensionPointer;
  double AuxiliaryScalar;
  double *CoefficientPointer, *ElementMarker, *ElementPointer, *ListOfCoefficients, *ListOfCombinations, *ListOfElements, *SlicePointer;
  char ErrorMessage[BufferSize];
  
  /* Check number of inputs and outputs. */
  if (NumberOfInputs<2) {
    mexErrMsgTxt("Not enough inputs.");
  }
  if (NumberOfInputs>3) {
    mexErrMsgTxt("Too many inputs.");
  }
  if (NumberOfOutputs>1) {
    mexErrMsgTxt("Too many outputs.");
  }
  
  /* Initialize input counter. */
  ArgumentCounter=0;
  
  /* Check first input. */
  if (!(mxIsDouble(ListOfInputs[ArgumentCounter]))) {
    sprintf(ErrorMessage,"Input %d must be double-precision.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  if (mxIsComplex(ListOfInputs[ArgumentCounter])) {
    sprintf(ErrorMessage,"Input %d must be real.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  if (mxIsSparse(ListOfInputs[ArgumentCounter])) {
    sprintf(ErrorMessage,"Input %d must be full.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  
  /* Store input size and pointer to data. */
  NumberOfDimensions=mxGetNumberOfDimensions(ListOfInputs[ArgumentCounter]);
  NumberOfElements=mxGetNumberOfElements(ListOfInputs[ArgumentCounter]);
  ListOfDimensions=mxGetDimensions(ListOfInputs[ArgumentCounter]);
  ListOfElements=mxGetPr(ListOfInputs[ArgumentCounter]);
  
  /* Increment counter. */
  ArgumentCounter++;
  
  /* Check second input. */
  if (!(mxIsDouble(ListOfInputs[ArgumentCounter]))) {
    sprintf(ErrorMessage,"Input %d must be double-precision.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  if (mxIsComplex(ListOfInputs[ArgumentCounter])) {
    sprintf(ErrorMessage,"Input %d must be real.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  if (mxIsSparse(ListOfInputs[ArgumentCounter])) {
    sprintf(ErrorMessage,"Input %d must be full.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  if (mxGetNumberOfDimensions(ListOfInputs[ArgumentCounter])>2) {
    sprintf(ErrorMessage,"Input %d must be a vector.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  if ((mxGetM(ListOfInputs[ArgumentCounter])>1)&(mxGetN(ListOfInputs[ArgumentCounter])>1)) {
    sprintf(ErrorMessage,"Input %d must be a vector.",ArgumentCounter+1);
    mexErrMsgTxt(ErrorMessage);
  }
  
  /* Store input size and pointer to data. */
  NumberOfCoefficients=mxGetNumberOfElements(ListOfInputs[ArgumentCounter]);
  ListOfCoefficients=mxGetPr(ListOfInputs[ArgumentCounter]);
  
  /* Branch according to number of inputs. */
  if (NumberOfInputs>2) {
    
    /* Increment counter. */
    ArgumentCounter++;
    
    /* Check third input. */
    if (!(mxIsDouble(ListOfInputs[ArgumentCounter]))) {
      sprintf(ErrorMessage,"Input %d must be double-precision.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if (mxIsComplex(ListOfInputs[ArgumentCounter])) {
      sprintf(ErrorMessage,"Input %d must be real.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if (mxIsSparse(ListOfInputs[ArgumentCounter])) {
      sprintf(ErrorMessage,"Input %d must be full.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if (mxGetNumberOfDimensions(ListOfInputs[ArgumentCounter])>2) {
      sprintf(ErrorMessage,"Input %d must be a scalar.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if ((mxGetM(ListOfInputs[ArgumentCounter])>1)&(mxGetN(ListOfInputs[ArgumentCounter])>1)) {
      sprintf(ErrorMessage,"Input %d must be a scalar.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    
    /* Store and cast input value. */
    AuxiliaryScalar=mxGetScalar(ListOfInputs[ArgumentCounter]);
    Dimension=(int)(AuxiliaryScalar);
    
    /* Check value of third input. */
    if (mxIsNaN(AuxiliaryScalar)) {
      sprintf(ErrorMessage,"Input %d must be numeric.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if (mxIsInf(AuxiliaryScalar)) {
      sprintf(ErrorMessage,"Input %d must be finite.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if ((double)(Dimension)!=AuxiliaryScalar) {
      sprintf(ErrorMessage,"Input %d must be integer.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    if (Dimension<=0) {
      sprintf(ErrorMessage,"Input %d must be positive.",ArgumentCounter+1);
      mexErrMsgTxt(ErrorMessage);
    }
    
    /* Branch to deal with singleton dimension. */
    if (Dimension>NumberOfDimensions) {
      
      /* Check size consistency between first and second inputs. */
      if (NumberOfCoefficients!=1) {
        sprintf(ErrorMessage,"Input %d must have one element.",ArgumentCounter);
        mexErrMsgTxt(ErrorMessage);
      }
      
      /* Allocate space for output and store pointer to data. */
      *ListOfOutputs=mxCreateNumericArray(NumberOfDimensions,ListOfDimensions,mxDOUBLE_CLASS,mxREAL);
      ListOfCombinations=mxGetPr(*ListOfOutputs);
      
      /* Compute weighted array. */
      for (Index=0; Index<NumberOfElements; Index++) {
        *ListOfCombinations++=(*ListOfCoefficients)*(*ListOfElements++);
      }
      
    } else {
      
      /* Decrement to account for zero-based indexing. */
      Dimension--;
      
      /* Check size consistency between first and second inputs. */
      if (NumberOfCoefficients!=ListOfDimensions[Dimension]) {
        if (ListOfDimensions[Dimension]>1) {
          sprintf(ErrorMessage,"Input %d must have %d elements.",ArgumentCounter,ListOfDimensions[Dimension]);
        } else {
          sprintf(ErrorMessage,"Input %d must have one element.",ArgumentCounter);
        }
        mexErrMsgTxt(ErrorMessage);
      }
      
      /* Allocate space for output and store pointer to data. */
      if ((DimensionMarker=(int*)mxMalloc(NumberOfDimensions*sizeof(int)))==NULL) {
        mexErrMsgTxt("Out of memory.");
      }
      memcpy(DimensionMarker,ListOfDimensions,NumberOfDimensions*sizeof(int));
      DimensionMarker[Dimension]=1;
      *ListOfOutputs=mxCreateNumericArray(NumberOfDimensions,DimensionMarker,mxDOUBLE_CLASS,mxREAL);
      ListOfCombinations=mxGetPr(*ListOfOutputs);
      mxFree(DimensionMarker);
      
      /* Compute step sizes. */
      SmallStep=1;
      DimensionMarker=ListOfDimensions+Dimension;
      for (DimensionPointer=ListOfDimensions; DimensionPointer<DimensionMarker; SmallStep*=*DimensionPointer++);
      LargeStep=SmallStep*ListOfDimensions[Dimension];
      
      /* Compute linear combinations. */
      ElementMarker=ListOfElements+NumberOfElements;
      while (ListOfElements<ElementMarker) {
        for (SlicePointer=ListOfElements+SmallStep; ListOfElements<SlicePointer; ListOfElements++) {
          CoefficientPointer=ListOfCoefficients;
          for (ElementPointer=ListOfElements; ElementPointer<ListOfElements+LargeStep; ElementPointer+=SmallStep) {
            *ListOfCombinations+=(*CoefficientPointer++)*(*ElementPointer);
          }
          ListOfCombinations++;
        }
        ListOfElements+=LargeStep-SmallStep;
      }
      
    }
    
  } else {
    
    /* Check size consistency between inputs. */
    if (NumberOfCoefficients!=NumberOfElements) {
      if (NumberOfElements>1) {
        sprintf(ErrorMessage,"Input %d must have %d elements.",ArgumentCounter,NumberOfElements);
      } else {
        sprintf(ErrorMessage,"Input %d must have one element.",ArgumentCounter);
      }
      mexErrMsgTxt(ErrorMessage);
    }
    
    /* Allocate space for output and store pointer to data. */
    *ListOfOutputs=mxCreateNumericMatrix(1,1,mxDOUBLE_CLASS,mxREAL);
    ListOfCombinations=mxGetPr(*ListOfOutputs);
    
    /* Compute weighted sum. */
    for (Index=0; Index<NumberOfElements; Index++) {
      *ListOfCombinations+=(*ListOfCoefficients++)*(*ListOfElements++);
    }
    
  }
  
}

/* Clear definitions. */
#undef BufferSize 100
