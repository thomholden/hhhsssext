function ThreeRedCandles(sys)
% THREEREDCANDLES - Three Red Candles Trading System
%
% Buys at the open price of the next bar when three red candles occur
% in a row. A red candle is defined by the closing price of a bar being
% equal to or smaller than the opening price. The position is closed
% when three white candles occur in a row. A white candle is defined
% by the closing price of a bar being greater than the opening price.
%
% Author: TA Developer Pty. Ltd. (http://www.tadeveloper.com)

% current bar
Open = sys.Open;
Close = sys.Close;
% previous bar
OpenShiftOne = Shift(Open,1);
CloseShiftOne = Shift(Close,1);
% bar minus two
OpenShiftTwo = Shift(Open,2);
CloseShiftTwo = Shift(Close,2);

% combine signals with the & operator
ThreeRedCandles = (Open>=Close) & (OpenShiftOne>=CloseShiftOne) & (OpenShiftTwo>=CloseShiftTwo);
ThreeWhiteCandles = (Open<Close) & (OpenShiftOne<CloseShiftOne) & (OpenShiftTwo<CloseShiftTwo);

% Enter long position when three red candles occur and
% exit position when three white candles occur
AddLongSignal(sys, ThreeRedCandles, ThreeWhiteCandles);

end
