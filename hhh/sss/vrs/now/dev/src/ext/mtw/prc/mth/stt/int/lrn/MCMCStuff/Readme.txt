MCMC Methods for MLP and GP and Stuff (for Matlab 6.*)

Maintainer: Aki Vehtari <Aki.Vehtari@hut.fi>

This software is distributed under the GNU General Public Licence
(version 2 or later); please refer to the file Licence.txt,
included with the software, for details.


Table of contents:

1. INTRODUCTION
2. DOCUMENTATION AND DEMOS
3. INSTALLING THE TOOLBOX




    ------------------------------------------
1. INTRODUCTION

Basic design of this toolbox is based on Netlab
<http://www.ncrg.aston.ac.uk/netlab/>. However, this 
toolbox is not compatible with Netlab, because the option handling
has been changed to use structures similar to current default in
Mathworks' toolboxes. Furthermore, the code in this toolbox has been
streamlined and optimized for faster computation, and it has been
extended to include some of the features present in FBM
<http://www.cs.toronto.edu/~radford/fbm.software.html> and some
other features. Some of the most computationally critical parts
have been coded in C. For easier introduction to MLP's and GP's,
Netlab is better suited, especially because of the accompanying text
book (Nabney I.T. (2001) Netlab: Algorithms for Pattern
recognition). Purpose of this toolbox was to port some of the features
in the FBM to Matlab environment for easier development for Matlab
users. 


Most of the code has been written by Aki Vehtari in the Laboratory
of Computational Engineering <http://www.lce.hut.fi> at Helsinki
University of Technology (HUT) <http://www.hut.fi>. Currently
there is also code written by (in alphabetical order) Toni Auranen,
Christopher M Bishop, James P. LeSage, Ian T Nabney, Radford Neal,
Carl Edward Rasmussen, and Simo Särkkä. During the summer of 2004 the
code was fully documented and pulled together as a toolbox by Jarno
Vanhatalo, an undergraduate student at HUT. Speciall thanks are
directed to Prof. Jouko Lampinen who helped in converting the C
sources into mex-files for Windows. 


2. DOCUMENTATION AND DEMOS:

In the toolbox there are two demonstration programs, that solve a two
dimensional regression problem with MLP network and Gaussian
process. These are demo_2input and demo_2ingp. The demos are discussed
in more detail in the home page of the toolbox
<http://www.lce.hut.fi/research/compinf/mcmcstuff/demos> and in
documentation of the software that is available from the home page
of the toolbox <http://www.lce.hut.fi/research/compinf/mcmcstuff/>.   

Features treated in the documentation are: 
 - Baysian learning for MLP in a regression problem
 - a Gaussian Hierarchical prior structure with Automatic Relevance
   Determination (ARD)
 - noise model with normal distribution
 - Markov Chain Monte Carlo method
 - hybrid Monte Carlo and Gibbs sampling
 - a Gaussian process in a regression problem
 - Bayesian learning for MLP in classification problems with two or
   many classes
 - a Gaussian process in classification problem with two classes
 - noise model with Students t-distribution
 - input variable selection for MLP and GP (various methods)
Features not treated in the documentation are: 
 - covariate dependent groupped noise model


3. INSTALLING THE TOOLBOX

-All files needed to run the toolbox in linux, Alfa and Windows (*.m,
 *.mexaxp, *.mexglx, *.dll)  are located in the same directory with
 this Readme.txt (mcmcstuff/). The toolbox should work in the above
 architechtures after the mcmcstuff/ is added to Matlab path.

-In the directory mcmcstuff/ there are also two subdirectories
 linuxCsource/ and winCsource/ containing the functions written in C
 for Linux, Alfa (linuxCsource/) and Windows (winCsource/). The reason
 for two different folders is that the 'math.h' of C library is
 different in Linux and Windows and that the function names in BLAS
 libraries are different in Windows than in Linux and Alfa. For
 example in Linux 'dpotrf_' is in Windows 'dpotrf'.

-The toolbox can be tested by running demonstration program
 demo_2ingp (NB! the demo takes quit a long time, approximately 30
 minutes on a 2400MHz Intel Pentium workstation, it is sufficient
 enough to run the demo for few minutes to be sure that it works). If
 there is no right mex-files for the architechture of your computer,
 you get an error message "error, No mex-file for this
 archtitecture. See Matlab help and convert.m in ./linuxCsource or 
 ./winCsource for help."
 
 -There are two different compiler m-files, compile.m in
  mcmcstuff/linuxCsource/ and compile_windows.m in
  mcmcstuff/winCsource/. The *.c files can be converted to mex-files
  by running these files in Matlab in the same directory where the
  it is located. If the compilers do not work directly the relations
  between C-functions can still be seen from them. 
