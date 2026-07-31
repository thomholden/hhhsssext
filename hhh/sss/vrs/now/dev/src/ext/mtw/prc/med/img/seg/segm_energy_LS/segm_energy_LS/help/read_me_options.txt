+---------------------+
| BUTTON DESCRIPTIONS |
+---------------------+

PARAMETERS panel
----------------
set parameters that govern the curve evolution:
 - Mu : the weight of the separation curve length: the higher
   its value, the shorter (thus smoother) the length.
 - Lambda+ / Lambda- : the weights of the In/Out square error terms.
 - dt: the artificial time step; reduce it when you notice
   instabilities, can be increased for smooth segmentations with often resets.
 - Nu : area term, set mostly at zero by most people :-)

OPTIONS panel
-------------
INITALIZATION of the levelset, which can be
 - arbitrary (circles)
 - manually drawn
REDISTANCING of the levelset
 - bwdist (fastest)
 - if not available, use the built-in function (slower)
REGULARIZATION
 - 'atan', best :-)
 - 'sine', narrowband, for educational purposes only
PROLONGATION / RESTRICTION
 can be cell-based or vertex based

SCALE panel
-----------
SCALE DEPTH (default 3)
	-- after editing field the image scales are recalculated 
GO Down -- go to a rougher scale
GO Up   -- go to a finer scale
DO Iter -- execute the specified #iterations (in iterations|steps)

ITERATIONS panel
----------------
 - #steps to execute at one press of scale|Do Iter! button
 - it/step: #relaxation iterations at each step
 - relaxation method (only Jacobi for now)
