MATLAB Function to Simulate the Heiderian Balance of Graph
***********************************************************

The program presented here is to analyze the adjacency matrix by using the Heiderian Balance Theory. For more information about the analysis of Heider Balance Theory in social analysis refer to http://www.bandungfe.net/wp2004/2004n.pdf.

Before simulation, you must prepare the adjacency matrix in your spreadshet. The NxN adjacency matrix exhibit the value of the edges (representing the sentiment among NxN individuals. After loading the adjacency matrix into the workspace (simply by double clicking the spreadsheet file in the current directory), thenafter you may run this function. 

Usage: >> heider(adjacency_matrix, number_of_iteration)

Input: 1. adjacency matrix NxN
       2. Number of iteration you want

Output: figure before and after the simulation
Example: in the workspace you have adjacancy matrix in variable 'adj'
ex.: adj = [0 0 -1; 1 0 1; 0 1 0];
if you want to iterate the graph upto 20 iterations,
type: >> heider(adj,20);

An m-file of example can be seen in example.m

For Further Information refer the related paper:
http://www.bandungfe.net/wp2004/2004n.pdf

Citation information of the paper:
Khanafiah, Deni & Situngkir, Hokky. (2004). Social Balance Theory: Revisiting Heider's Balance Theory for Many Agents. Working Paper WPN2004. Bandung Fe Institute. 
Any comments & questions: hs@compsoc.bandungfe.net or dk@students.bandungfe.net

All rights reserved, feel free to use the program by cite the correct citation information.

---------------------------------------------------------------

Bandung Fe Institute (c) 2004