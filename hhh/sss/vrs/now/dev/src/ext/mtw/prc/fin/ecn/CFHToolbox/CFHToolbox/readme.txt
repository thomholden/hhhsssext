CFH Toolbox
Matthias Held (matthias.held@whu.edu)

A collection of characteristic function transform methods in finance. It 
combines the seminal approach of Affine-Jump-Diffusion (AJD) option pricing 
of Duffie/Pan/Singleton (2000) with the Fast Fourier Transform methods of 
Carr/Madan (1999) and Chourdakis (2004). 

Run install.m to install the toolbox. For an overview and detailed 
instructions, type 

>> doc cfhtoolbox

at the Matlab prompt.

Version history:
1.5   - added a GUI, call it via >>cfh;
1.4.1 - added arbitray payoff function capability to cf2spread
1.4   - added American options for Lévy processes; spread option pricing
1.3   - added extended transform functions
1.2   - added Kou's model
1.1   - added FFT methods to the conditional expectation function.
1.0   - initial release.