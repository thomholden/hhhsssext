+---------------------+
|   PULL-DOWN MENUS   |
+---------------------+

  "Load" - gray level data can be loaded from image files, .mat 
files or from the workspace. 
In order to save time, results of long segmentation sequences can 
be saved and reloaded as the current state in order to be used as 
a starting point for the subsequent iterations. One can load a new 
segmentation mask and/or the level-set function Fn. A segmentation 
mask can also be loaded from the workspace, this comes handy in debug).
For very large images it is recommendable to simultaneously load the 
level-set function Fn as well, as its calculation might take time.

CAUTION - NO size check is performed at loading. Not even cropping/padding.
That is, make sure you load the data at the proper resolution level. 
(i.e., the same scale at which it was saved)
	
  "Save" 
  At any point during segmentation one can save the current state. 
The "mask" option takes the least disk space (data is binary), while 
"mask+Fn" is the fastest at reload.

  "Show" 
  Displays the evolution of the level set as inkblots and curves.

  "View" 
  - "Error" evolution, as well as area, curve length...
  - plot more goodies (gradient of the Heaviside function, etc.)
  - "Report" generates a few LaTex strings with relevant info and 
    places them on top of the data to segment, if you want to graphically 
    save a particular result
