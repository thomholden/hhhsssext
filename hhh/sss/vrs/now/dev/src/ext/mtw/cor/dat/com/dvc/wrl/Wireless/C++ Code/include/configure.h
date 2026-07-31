#define MODE  0 // Set Mode

// Set MODE to 0:Default, no interfaction with MATLAB
// Set MODE to 1: Link with engine 


#include "engine.h"
#include "basetype.h"

 void sendandsync(Signal var_c, const char *varName);
 void sendandsyncbool(Bits var_c, const char *varName);
 void sendandsyncsample(Sample var_c, const char *varName);

 void puteng(Signal sigOut,Engine *ep, const char* varName); 
 void putengbool(Bits sigOut,Engine *ep,const char* varName);
 void putengsample(Sample sigOut,Engine *ep, const char* varName); 
