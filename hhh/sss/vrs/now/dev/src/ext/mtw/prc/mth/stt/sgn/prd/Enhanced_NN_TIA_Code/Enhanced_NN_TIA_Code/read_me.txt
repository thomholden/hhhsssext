Code for A neural network based dynamic forecasting model for Trend Impact Analysis:
===================================================================================

This code is the implementation of the A neural network based dynamic forecasting model for Trend
Impact Analysis described in the paper:

"A neural network based dynamic forecasting model for Trend Impact Analysis"

It consists of 6 functions:

1. Main Function -- (Main)
2. Generate Degree of Severity -- (GenerateDegreeSeverity)
3. Compute Fractional Change Vector -- (ComputeFracChgVect)
4. Maximum Impact Update -- (MaxUpdate)
5. Steady-State Impact Update -- (SSUpdate)
6. Neural Network Function (NN_Function)

as explained in the paper .. Plus one auxiliary function for plotting the representative scenarios named: "DrawTIA"

-------------------------------------------------------------------------------------------------------------------

Input:
======

Nine Excel Sheets from which the main function reads the Historical Data, Surprise-Free Values and the inputs of experts for the event probabilities of occurrence for each degree of severity and impact parameters along the forecasting horizon.

Output:
=======

"Representative Scenarios" plot along with the surprise-free values as illustrated in figure 9.

-----------------------------------------------------------------------------------------------

Instructions for Running the Code:
==================================

1. Make sure to insert the code, i.e. m-files, and the input data files in the "Work" directory of Matlab.
2. Press the "Run" button from the "Main" function.

---------------------------------------------------

Note:
=====

The input available in the data files and the Number of Scenrios, Number of Events and Number of Years are typically those found in the "Numerical Example" in the paper.