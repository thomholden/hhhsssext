//
// This code is provided for example purposes only.
// 
// Copyright 2011-2013 MathWorks, Inc.
//


#ifndef verifyLanes_H
#define verifyLanes_H

////////////////////
// Verify Functions
////////////////////

extern void initializeVerifyLanes(int row, int col, int planes);

extern void verifyLanes(const unsigned char* frame, int laneVertices_data[200], int laneVertices_size[2]);

extern void terminateVerifyLanes();




#endif