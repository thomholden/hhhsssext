+------------------------------------+
|        IMAGE SEGMENTATION          |
| multiscale energy-based level sets |
+------------------------------------+

This toolbox has been downloaded from
http://www.mathworks.com/matlabcentral/fileexchange/31975-image-segmentation-multiscale-energy-based-level-sets
In case not, refer to this location for the latest version.

It implements an energy-based segmentation algorithm that uses 
finite-difference based level set evolution. (See [1], [2]).
Multiscale curve evolution is implemented ([3]), which reduces the 
sensitivity to initialization as well as improves the execution speed. 

Questions? tudima at zahoo dot ccomm, change z>y

References:
-----------
[1] R. J. LeVeque - "Finite Difference Methods
for Differential Equations" September, 2005
[2] T. Chan and L. Vese, "Active contours without edges"
IEEE Trans.Img.Proc., vol. 10, pp. 266-277, 2001.
[3] W. L. Briggs, V. Emden Henson, S. F. McCormick
"A Multigrid Tutorial", SIAM, Philadelphia, 2001.

Short revision list:
--------------------
1.0.0.1 - 16.08.2011
          can now change on the fly the scale depth kMax
          (before one had to reload the file)	
1.0.0.2 - 22.04.2012
          allow spaces in directory names
          add handy reset button (before in pull-down menu)
          better help, split by section
1.0.1 	- 18.02.2013
	  allow saving (and loading) of masks and/or level-set functions
	  improved help comments
