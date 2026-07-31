%construct the stock using 2 dimentional array
% the header has the positions header.high, header.low, header.open header.close, header.volume
%
% each day keeps one colon
% h l o c v
% h l o c v
% h l o c v
%
% Use the header to see the order of the data
function [st] = stock (dates, header, arrayData);

h = arrayData(:,header.high);
l = arrayData(:,header.low);
o = arrayData(:,header.open);
c = arrayData(:,header.close);
v = arrayData(:,header.volume);

% st = [dates, [h l o c v]];%, ['high' 'low' 'open' 'close' 'volume']);
st.dates=dates;
st.high = h;
st.low = l;
st.open = o;
st.close = c; 
st.volume = v;

