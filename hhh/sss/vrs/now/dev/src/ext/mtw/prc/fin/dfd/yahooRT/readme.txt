YAHOORT Extends the Datafeed Toolbox's YAHOO object, allowing real-time data to be fetched from Yahoo's Premium Finance service.

Requirements:
- Datafeed Toolbox license
- Yahoo account subscribed to Yahoo Premium Finance.

1. To install, simply unzip the contents of 'yahooRT.zip' to a location on the MATLAB path.

2. Try running 'yahooRTdemo.m' during active US trading hours (9:30am-4:00pm ET). You should observe a difference of ~15 minutes between the base YAHOO.FETCH and YAHOORT.FETCH.
*You will need to set the USERNAME and PASSWORD variables in this file before you run it*

3. For more information, type
>> help yahooRT


Please contact me at eric.johnson@mathworks.com if you have any questions.
Thanks for checking out my project!

*Updates*
9/9/08 - Fixed authentication issue on 64-bit MATLAB.
