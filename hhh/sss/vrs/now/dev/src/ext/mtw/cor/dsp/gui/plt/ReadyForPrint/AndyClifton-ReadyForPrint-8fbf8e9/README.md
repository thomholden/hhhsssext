ReadyForPrint
=============

`readyForPrint()` is a MATLAB function to create publication-ready graphics. `readyforprint()` resizes and reformats images for inclusion in documents, presentations or web pages.

The function has several arguments that must be supplied in the correct order.

````matlab
readyforprint([W H],fontsize, fgc, bgc, LineWidth,FigureHandle) 
````
The arguments are:
+ `[W H]`; width and height of the image (inches). This is the size of the output you'll get using the `print()` command. Defaults [6 3] if left empty. 
+ `fontsize`;	Font size (pts). This will be the font size of the labels on the x and y-axis. Tick labels are set to 80% of this size (limited to 6 pts or above). Titles are set to 120% of this size, and bold. Defaults to 8 if left empty. 
+ `fgc`; foreground colour, either as 'r' or RGB [0.5 0.5 0.5] style. Defaults to 'k' if left empty. 
+ `bgc`; background colour, either as 'r' or RGB [0.5 0.5 0.5] style. Defaults to 'w' if left empty. 
+ `LineWidth`;	Width of lines in figures. use 0.5 for journal plots, 2 for overhead presentations, etc. Defaults to 0.5 if left empty. 
+ `FigureHandle`; Optional. Handle of the figure to prepare for printing. Defaults to the current figure.

The sizes, face, and edge colors of markers are not normally modified. However, data that have been plotted with `'MarkerEdgeColor'` set to `'k'` and `'MarkerFaceColor'` set to `'w'` will be plotted with the edges set to the new foreground color, and the marker filled with the new background color.

As an example, for a figure that takes up a single column in a two-column paper, use 

    readyforprint([3.5 3],8,'k','w',0.5)

For a figure that takes up the whole page width, use something like 

    readyforprint([6.5 3],8,'k','w',0.5)

For an image for a presentation, try larger fonts and thicker lines; 

    readyforprint([6 5],14,'k','w',1)

The code below demonstrates the code in use. A more detailed example using x-y data, `gscatter()` and the `peaks()` function is included in the `demo.m` file.

    figure 
    plot(rand(10),rand(10),'ko','MarkerFaceColor','r') 
    legend('test') 
    set(legend,'location','best') 
    saveas(gcf,'this_is_my_raw_figure','fig') 
    readyforprint([4 3],10,[0.7 1 0.6],[0 0.1 0.1],3)

To print, I recommend the use of .eps over .jpg, used together with the function, fixPSlinestyle.m

    print('-djpeg','this_is_my_printed_jpg') % for a jpg 
    print('-depsc2','-loose','this_is_my_printed_eps') % for an eps

Users may also wish to combine this code with the recommendations given in http://blogs.mathworks.com/loren/2007/12/11/making-pretty-graphs/ for producing quality graphics. Those recommendations are implemented in the attached functions `pretty_xyplot`, `pretty_boxplot` and `pretty_timeplot`.

Code is provided as is, with no guarantees.
