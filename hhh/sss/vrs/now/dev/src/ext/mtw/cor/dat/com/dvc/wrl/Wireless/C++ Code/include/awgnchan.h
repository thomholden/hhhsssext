// This software was developed at the National Institute of Standards 
// and Technology by employees of the Federal Government in the course 
// of their official duties. Pursuant to title 17 Section 105 of the 
// United States Code this software is not subject to copyright 
// protection and is in the public domain. 
// 
// We would appreciate acknowledgement if the software is used.



// File: awgnchan.h
// Last modified: 8 June 2001
// Author(s):
//   T. A. Hall
//   Amir Soltanian
//   Wireless Communications Technologies Group
//   National Institute of Standards and Technology
//   100 Bureau Drive, STOP 8920
//   Gaithersburg, MD 20899-8920
//   {timhall,amirs}@nist.gov
//
#ifndef __awgnchan_h__
#define __awgnchan_h__

#include "basetype.h"

// Forward declaration
class AWGN;

// Additive white Gaussian noise channel
class AWGNChannel : public Channel {
public:
    // Default and copy constructors
    AWGNChannel(double dB_noise=1.0);
    AWGNChannel(AWGNChannel& awgnchan);
    // Destructor
    virtual ~AWGNChannel();

    // Channel adds desired and interference signals plus additive white Gaussian noise
    virtual Signal process(const Signal& desired, const Signal& interference);

private:
    AWGN* m_awgn;   // Complex additive white Gaussian noise generator
};

#endif  //__awgnchan_h__

