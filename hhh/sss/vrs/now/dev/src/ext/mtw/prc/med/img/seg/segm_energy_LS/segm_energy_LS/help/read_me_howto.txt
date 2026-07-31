+---------------+
| HOW TO USE IT |
+---------------+

  This toolbox implements a level-set energy-based segmentation algorithm 
which uses finite-differences for curve evolution.
  It allows you to run the level-set algorithm at any (rougher)
image scale -- this not only improves the speed but it also reduces 
the sensitivity to initialization.

  This way, given a segmentation problem, one can use this GUI in order 
to find the proper parameters which yield the desired partitioning for 
the class of images used. 
  The functions in the toolbox could be then re-used for a higher-level 
scripting algorithm, if desired. That is, one can progress from this 
"open-loop" toolbox to their own "closed-loop" algorithm.

NOTE: 
  This is NOT a full multigrid algorithm, the scale navigation is provided 
in "manual" mode, for "image learning". Once you get the hang of it, you 
can then code that bit in. On the same line, the error is calculated and 
shown, but NO decision is taken, the iteration control is also left manual.

+------+
| FLOW |
+------+

  Load data to be segmented (as an image or .mat file). The segmentation 
mask is initialized automatically (with "circles") unless you select 
options|IniMethod "draw", in which case you will be asked to draw an 
initial segmentation mask every time you load a new file or when you 
click Load "(Re)Init Membrane.

  Start iterating at the roughest scale. You can prolongate towards finer 
scales and restrict back towards rougher scales using the provided controls.
  In order for the processing time to stay reasonable use larger scale depths 
for large images (so that the roughest scale is around 100 pixels or less)

  For "straightforward" images of say 300 pixels try smoothness parameters 
of 0.01 - 0.1 and go from there. If the contours start oscillating then
tweak the time parameter dt and/or the curve redistancing function.

  At every step the current solution is shown, while under the 'View' menu 
there are more goodies -- error evolution, error function gradient etc.

  The level-set function and/or mask can be saved and reloaded at a later time 
for further comparisons or iterations.
(refer to the "Load" and "Save" sections in Help | Menus).

