/* $ Revision: 1.2 $ */
/*=================================================================
 * api_maxfig.c 
 * 
 * This is a MEX-file for MATLAB 7 (R14 SP2).
 * Copyright (c) 2005 Mihai Moldovan M.Moldovan@mfi.ku.dk
 *============================================================*/

/*=================================================================
 * TO COMPILE:
 * mex api_maxfig_R14SP2.c user32.lib
 *============================================================*/

/*=================================================================
 * INPUT(S):
 * (matlab scalar) matlab figure handle
 * (matlab char array) show type
 *============================================================*/
 
 /*=================================================================
 * OUTPUT(S):
 * (matlab array) Client Size
 *============================================================*/

 
 #include "windows.h"
 #include "mex.h"
 
 //------------------------------------------------
  
 char *mywindow;
 char *myclass;
 int myshowtype;
 long found=0;
 RECT rr;
 
 //------------------------------------------------
BOOL CALLBACK OneWindow( HWND hwnd, LPARAM lParam  )
 //------------------------------------------------
{
      /* the EnumWindows in maxwin calls this function repeatedly
      * passing the hwnd handles of all top-level windows 
      * and few top-level child windows owned by the system that have the WS_CHILD style */

      char windName[256];
      char clName[256];
           
      // get the name and class of the window
      GetWindowText(hwnd, windName, sizeof(windName));
      GetClassName(hwnd, clName, sizeof(clName));
      
          
      
      if (_strnicmp(windName,mywindow,strlen(mywindow))==0 && _strnicmp(clName,myclass,strlen(myclass))==0)
        {
          
          
            // We found a windows...
          
          if (myshowtype==1){
            ShowWindow(hwnd,SW_SHOWMAXIMIZED); 
            GetWindowRect(hwnd,&rr);}
          else if (myshowtype==2){
              GetWindowRect(GetDesktopWindow(),&rr);}
              
          SetWindowPos (hwnd, HWND_TOPMOST, rr.left, rr.top, rr.right, rr.bottom, SWP_SHOWWINDOW| SWP_FRAMECHANGED);
          
          // return client
          GetClientRect(hwnd,&rr);
          
          found=1;
	          
          // you should find only one match
          // quit searching
          return FALSE;  
         }
           
     // get a new window if any 
     return TRUE ;

}
 

 //------------------------------------------------
void cmain()
//------------------------------------------------
{
    // there may be other windows with searched title
    // match the class

    LPARAM lParam;   
    
    // cycle through windows
	EnumWindows(OneWindow,  lParam); 
    return;
}

//------------------------------------------------
//The api_showwindow starts here 
//------------------------------------------------

//------------------------------------------------
void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
//------------------------------------------------
{
    char *input_buf;
    int   buflen;
    int   status;
    double *output;
  
    double         handle; 
    const mxArray *name_array_ptr;
    mxArray       *value;
    char matlabclass[256];
    
    char  buffer[256];
      
  //------------------------------------------------
  //Check for proper number of arguments. 
  //------------------------------------------------
    
  if(nrhs != 2) 
    mexErrMsgTxt("2 inputs required. \n resultcode=api_showwindow(hndl,showstate)\n\n Copyright (c) 2005 Mihai Moldovan M.Moldovan@mfi.ku.dk");
  else if(nlhs > 1) 
    mexErrMsgTxt("1 output supported. \n resultcode=api_showwindow(hndl,showstate)\n\n Copyright (c) 2005 Mihai Moldovan M.Moldovan@mfi.ku.dk");
  
   //------------------------------------------------
   // Check if there are any figures available
   // Use get(0,'CurrentFigure')
   // to avoid creating an empty figure
   //------------------------------------------------
    
    //Make sure the drawing is finished
    mexEvalString ("drawnow");
    
    handle=0;
    name_array_ptr = mexGet(handle, "CurrentFigure");
    
    if (name_array_ptr == NULL)
      mexErrMsgTxt("Invalid window handle");  
    
     // Make a safe copy of "CurrentFigure" propery
    value = mxDuplicateArray(name_array_ptr); 
  
    if (mxIsEmpty(value))
        mexErrMsgTxt("No figures available..."); 
      
        
   //------------------------------------------------
   // first input argument must be the figure handle
   // this is a double 
   //------------------------------------------------
        
   // Input must be a handle
    if(!mxIsDouble(prhs[0]))
	    mexErrMsgTxt("Must be called with a valid handle");
     
    //Check to make sure input argument is a scalar
    if (mxGetN(prhs[0]) != 1 || mxGetM(prhs[0]) !=1)
      mexErrMsgTxt("Input must be a scalar handle value.\n");
        
    //Get the handle 
    handle = mxGetScalar(prhs[0]);
    
   
   //------------------------------------------------
   //  If NumberTitle property is 'on'
   //  Figure No. N (where N is the figure handle)
   //  is prefixed to the figure window title.
   //  This is the only way to make sure that 
   //  the figure title is unique
   //------------------------------------------------
   
    name_array_ptr = mexGet(handle, "NumberTitle");
    
    if (name_array_ptr == NULL)
      mexErrMsgTxt("Invalid window handle");  
    
     // Make a safe copy of "NumberTitle" propery
    value = mxDuplicateArray(name_array_ptr); 
    
   if(mxIsChar(value) != 1)
    mexErrMsgTxt("Input must be a string.");
  
   if(mxGetM(value) != 1)
    mexErrMsgTxt("Input must be a row vector.");
    
    //Get the length of the input string. 
    buflen = (mxGetM(value) * mxGetN(value)) + 1;
    
    //Allocate memory for input string.
    input_buf = mxCalloc(buflen, sizeof(char));
    
    //Copy the string data into a C string 
    status = mxGetString(value, input_buf, buflen);
    
    if(status != 0)
        mexErrMsgTxt("no space for string");
        
     
   //------------------------------------------------
   // make titlestring
   //------------------------------------------------
     
    // force Numbertitle
    mexSet(handle, "NumberTitle", mxCreateString("on"));
    mexEvalString ("drawnow");
    
   
    // matlab seems to display noninteger handles with a precision of 9
    // regardless of the "command window : Text Display" preferences
   
    //sprintf(  buffer, "Figure No. %.9g", handle );
    
    sprintf(  buffer, "Figure %.9g", handle );
    
    //to make sure we could use
    //buffer = _ecvt( handle, 20, &decimal, &sign );
    //and then add the . and remove the tail 000
                 
   //saves in global
   mywindow=buffer;
  
   //mexErrMsgTxt(mywindow);
   
   //------------------------------------------------
   // second input argument 
   //------------------------------------------------
  
   /* Input must be a string. */
  if(mxIsChar(prhs[1]) != 1)
    mexErrMsgTxt("Input must be a string.");
  
    /* Input must be a row vector. */
  if(mxGetM(prhs[1]) != 1)
    mexErrMsgTxt("Input must be a row vector.");
    
  //Get the length of the input string. 
  buflen = (mxGetM(prhs[1]) * mxGetN(prhs[1])) + 1;
  
  //Allocate memory for input string.
  input_buf = mxCalloc(buflen, sizeof(char));
  
  ///Copy the string data into a C string 
  status = mxGetString(prhs[1], input_buf, buflen);
   
  if(status != 0)
    mexErrMsgTxt("no space for string");
    
    //saves in global
    
    if (_stricmp(input_buf,"DESKTOP")==0)
        myshowtype= 1;
    else if (_stricmp(input_buf,"SCREEN")==0)
        myshowtype= 2;   
    else
        mexErrMsgTxt("Invalid show state ! \n Expecting one of:\n SW_SHOWMAXIMIZED,SW_SHOWMINIMIZED,SW_FORCEMINIMIZE, \n SW_HIDE,SW_SHOWNORMAL,SW_SHOW, \n SW_MAXIMIZE,SW_MINIMIZE,SW_RESTORE, \n SW_SHOWDEFAULT,SW_SHOWMINNOACTIVE,SW_SHOWNA,SW_SHOWNOACTIVATE");
  
    //------------------------------------------------
   // hidden input argument 
   //------------------------------------------------     
   
   // The class of the matlab figure is something like
   // com.mathworks.hg.peer.FigurePeer$FigureFrame
   // We will use filter only the start
  
  //com.mathworks.hg.peer.FigureFrameProxy$FigureFram
  //strcpy (matlabclass, "com.mathworks.hg.peer.FigurePeer$FigureFrame");
  strcpy (matlabclass, "com.mathworks.hg.peer.FigureFrameProxy$FigureFrame");
  
  myclass=matlabclass;
   
   //------------------------------------------------
   // call the C code
   //------------------------------------------------ 
       
   cmain();
    
   
   //------------------------------------------------
   // restore NumberTitle
   //------------------------------------------------
    
   mexSet(handle, "NumberTitle",value);
   mexEvalString ("drawnow");
     
   
   //------------------------------------------------
   // first output argument 
   //------------------------------------------------
    
   // Create matrix for the return argument.
  plhs[0] = mxCreateDoubleMatrix(1,4, mxREAL);
  
   // Assign pointers to output. 
   output = mxGetPr(plhs[0]);
   
   // fill the output 
   if (found==0)
        mexWarnMsgTxt ("No matching windows...");
    else
        
        output[0]=rr.left;
        output[1]=rr.top;
        output[2]=rr.right;
        output[3]=rr.bottom;
        
        found=0;
   
   //------------------------------------------------
  
    
 }

