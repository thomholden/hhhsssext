#ifndef _MatlabImage_h_
#define _MatlabImage_h_

#include <vector>
#include <mex.h>


//! Simple image with minimal dependencies that can be used in Matlab mex files
template <typename T>
struct MatlabImage
{
    //! Default constructor
    MatlabImage( )
    {
        _dimensions.resize(4);
        std::fill( _dimensions.begin(), _dimensions.end(), 0 );
        _data.clear();
    }

    //! Copy constructor
	template <typename N>
    MatlabImage( const MatlabImage<N>& img )
	{
		this->resize( img.size(0), img.size(1), img.size(2), img.size(3) );
		std::copy( img._data.begin(), img._data.end(), this->_data.begin() );
	}

    //! Copy constructor for mxArray*
    MatlabImage( const mxArray* ma )
    { *this = ma; }
    
    //! Copy data from mxArray*
    MatlabImage<T>& operator = ( const mxArray* ma );

    //! Return mxArray
    operator mxArray*() const;
    
    /// x,y,z,v Operator()
    inline T& operator() (const int i, const int j, const int k, const int l )
    { return _data[ l * _dimensions[0] * _dimensions[1] * _dimensions[2] + k * _dimensions[0] * _dimensions[1] + j * _dimensions[0] + i ]; }
    inline const T& operator() (const int i, const int j, const int k, const int l )const
    { return _data[ l * _dimensions[0] * _dimensions[1] * _dimensions[2] + k * _dimensions[0] * _dimensions[1] + j * _dimensions[0] + i ]; }

    /// x,y,z Operator()
    inline T& operator() ( const int i, const int j, const int k )
    { return _data[ k * _dimensions[0] * _dimensions[1] + j * _dimensions[0] + i ]; }
    inline const T& operator() ( const int i, const int j, const int k ) const
    { return _data[ k * _dimensions[0] * _dimensions[1] + j * _dimensions[0] + i ]; }

    /// x,y Operator()
    inline T& operator() ( const int i, const int j )
    { return _data[ j * _dimensions[0] + i ]; }
    inline const T& operator() ( const int i, const int j ) const
    { return _data[ j * _dimensions[0] + i ]; }

    /// index Operator()
    inline const T& operator() ( const int i ) const
    { return _data[ i ]; }
    inline T& operator() ( const int i )
    { return _data[ i ]; }

    /// index operator []
    inline T& operator[]( const int i )
    { return _data[ i ]; }
    inline const T& operator[]( const int i ) const
    { return _data[ i ]; }
    
    // Resize
    void resize( int w, int h = 1, int d = 1, int v = 1 )
    {
        // Do not resize if dimensions already agree
        if( _dimensions.size() == 4 && w == _dimensions[0] && h == _dimensions[1] && d == _dimensions[2] && v == _dimensions[3] )
            return;
        _dimensions.resize(4);
        _dimensions[0] = w;
        _dimensions[1] = h;
        _dimensions[2] = d;
        _dimensions[3] = v;
        _data.resize( w * h * d * v );
        std::fill( _data.begin(), _data.end(), 0 );  
    }
    
    // Return size for dimension d
    int size( int d ) const
    { return _dimensions[d]; }
    
    // Dimensions and pixel data
    std::vector<int> _dimensions;
    std::vector<T> _data;
    
};




template <typename T>
MatlabImage<T>& MatlabImage<T>::operator=( const mxArray* ma )
{
    if( mxIsComplex( ma ) )
        mexErrMsgTxt( "MatlabImage<T>& MatlabImage<T>::operator=( const mxArray* ma ): can't handle complex data (mxIsComplex(ma))" );

    mwSize nDims = mxGetNumberOfDimensions( ma );
    const mwSize *dims = mxGetDimensions( ma );

    switch ( nDims )
    {
    case 1:
        this->resize( dims[0] );
        break;
    case 2:
        this->resize( dims[1], dims[0] );
        break;
    case 3:
        this->resize( dims[1], dims[0], dims[2] );
        break;
    default:
        mexErrMsgTxt( "MatlabImage<T>& MatlabImage<T>::operator=( const mxArray* ma ): not a supported dimension." );
    }

    int d = this->size(2);
    int h = this->size(1);
    int w = this->size(0);

    mxClassID classid = mxGetClassID( ma );

    if( classid == mxDOUBLE_CLASS )
    {
        double* pMa = (double*)mxGetData(ma);
        int i=0;     
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else if( classid == mxUINT8_CLASS )
    {
        unsigned char* pMa = (unsigned char*)mxGetData(ma);
        int i=0;       
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else if( classid == mxINT32_CLASS )
    {
        int* pMa = (int*)mxGetData(ma);
        int i=0;      
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else if( classid == mxUINT32_CLASS )
    {
        unsigned int* pMa = (unsigned int*)mxGetData(ma);
        int i=0;     
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else if( classid == mxSINGLE_CLASS )
    {
        float* pMa = (float*)mxGetData(ma);
        int i=0;     
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else if( classid == mxINT64_CLASS )
    {
        long long* pMa = (long long*)mxGetData(ma);
        int i=0;       
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else if( classid == mxUINT64_CLASS )
    {
        unsigned long long* pMa = (unsigned long long*)mxGetData(ma);
        int i=0;        
            for(int z=0; z<this->size(2); z++)
                for(int y=0; y<this->size(1); y++)
                    for(int x=0; x<this->size(0); x++,i++)
                        _data[i] = (T)pMa[ z*w*h + x*h + y ];
    }
    else
        mexErrMsgTxt( "MatlabImage<T>& MatlabImage<T>::operator=( const mxArray* ma ): classid is not a supported type." );

	return *this;

}


//! Converts Matrix to matlab array
template <typename T>
MatlabImage<T>::operator mxArray*() const
{
    int nDim = 2;
    if( (int)this->size(2) > 1 )
        nDim++;

    mwSize dims[3];
    dims[1] = (int)this->size(0);
    dims[0] = (int)this->size(1);

    if( this->size(2) > 1 )
        dims[2] = this->size(2);
   
    mxArray* ma = mxCreateNumericArray( nDim, dims, mxDOUBLE_CLASS, mxREAL );
    double* pMa = (double*)mxGetData( ma );

    int w = this->size(0);
    int h = this->size(1);
    int i = 0;
        for(int z=0; z<this->size(2); z++)
            for(int y=0; y<this->size(1); y++)
                for(int x=0; x<this->size(0); x++,i++)
                    pMa[z*w*h + x*h + y] = _data[i];
    return ma;
}

#endif // _Image_h_
