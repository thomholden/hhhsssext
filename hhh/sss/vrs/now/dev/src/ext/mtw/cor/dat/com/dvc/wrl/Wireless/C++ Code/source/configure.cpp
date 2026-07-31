#include <configure.h>
#include "engine.h"

void sendandsync(Signal var_c, const char *varName){

	Engine *ep=engOpen(NULL);
			puteng(var_c,ep,varName);
			//engEvalString(ep,"currentCount_C=evalin('base','c()'); ");
			//engEvalString(ep,"pause(.5)");
			engEvalString(ep,"savetoM;");
			engEvalString(ep,"sync_c;");
			engEvalString(ep,"deletetoC;");
}

void sendandsyncbool(Bits var_c, const char *varName){

	Engine *ep=engOpen(NULL);
			putengbool(var_c,ep,varName);
			//engEvalString(ep,"currentCount_C=evalin('base','c()'); ");
			//engEvalString(ep,"pause(.5)");
			engEvalString(ep,"savetoM;");
			engEvalString(ep,"sync_c;");
			engEvalString(ep,"deletetoC;");
}

void sendandsyncsample(Sample var_c, const char *varName){

	Engine *ep=engOpen(NULL);
			putengsample(var_c,ep,varName);
			//engEvalString(ep,"currentCount_C=evalin('base','c()'); ");
			//engEvalString(ep,"pause(.5)");
			engEvalString(ep,"savetoM;");
			engEvalString(ep,"sync_c;");
			engEvalString(ep,"deletetoC;");
}

void puteng(Signal sigOut,Engine *ep,const char* varName){

			int i;
			mxArray *pmxarray = mxCreateDoubleMatrix(sigOut.size(),1, mxCOMPLEX);
			double *pmxreal = mxGetPr(pmxarray);
			double *pmximag = mxGetPi(pmxarray);
			for(i= 0; i < sigOut.size() ; i++) {
				pmxreal[i] = sigOut[i].real(); 
				pmximag[i] = sigOut[i].imag();
			}
			engPutVariable(ep, varName, pmxarray); // Send data to MATLAB
}

void putengsample(Sample sigOut,Engine *ep,const char* varName){

			int i;
			mxArray *pmxarray = mxCreateDoubleMatrix(1,1, mxCOMPLEX);
			double *pmxreal = mxGetPr(pmxarray);
			double *pmximag = mxGetPi(pmxarray);
			for(i= 0; i < 1 ; i++) {
				pmxreal[i] = sigOut.real(); 
				pmximag[i] = sigOut.imag();
			}
			engPutVariable(ep, varName, pmxarray); // Send data to MATLAB
}

void putengbool(Bits sigOut,Engine *ep,const char* varName){

			int i;
			mxArray *pmxarray = mxCreateDoubleMatrix(sigOut.size(),1, mxREAL);
			double *pmxreal = mxGetPr(pmxarray);
			for(i= 0; i < sigOut.size() ; i++) {
				pmxreal[i] = double(sigOut[i]); 
			}
			engPutVariable(ep, varName, pmxarray); // Send data to MATLAB
}