
// MexThread interface
#include "MexThread.h"

// Image processing
#include "MatlabImage.h"
#include "GaussianBlur.h"


//! Derived class. Reads input image and sigma and performs Gaussian
// blur filtering.
class MyWorkerThread : public MexThread
{
public:
        
    //! Simple thread function
    void run()
    {  
       GaussianBlur( input, sigma, output );
    }
    
    //! Get input image and sigma
    void parseInputParameters( const std::vector<const mxArray*>& rhs )
    {
        if( rhs.size() < 2 )
            mexErrMsgTxt( "rhs.size() < 2" );
        input = rhs[0];
        convert( rhs[1], sigma );
    }
    
    //! Return filtered image
    void returnResults( mxArray *plhs[] )
    {  
        plhs[0] = output;
    }
    
    // Algorithm input / output
    MatlabImage<double> input, output;
    double sigma;
    
};


// Mex gateway function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    static MyWorkerThread workerThread;
    workerThread.processMexCall( nlhs, plhs, nrhs, prhs ); 
}
