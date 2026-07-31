% this function reads the ASCII metastock file and returns a stock
% this function throws the dates
function [st] = readMetastockFile (fName);

% read metastock file
%array = load (fName);

startC = 3;  %start counting from 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get the number of lines the text contains (and the sHeader)
fid = fopen(fName, 'rt');
lines = 0;
while feof(fid) == 0
  tline = fgetl(fid);
  if (lines==0)
      sHeader = tline;
  end
  if (size(tline) > 0) 
    lines = lines + 1;
  end
end
fclose(fid); 

%%%%%%%%%%%%%%%%%%%%%
%construct the header
remainder = sHeader;
pos = 0;
while (any(remainder))
  [chopped,remainder] = strtok(remainder, '<>,');  
  chopped = lower(chopped);
  
  if (pos >= startC)
    if strcmp(chopped,'high') == 1 %idendical
        header.high = pos-startC+1;
    elseif strcmp(chopped,'low') == 1 %idendical
        header.low = pos-startC+1;
    elseif strcmp(chopped,'open') == 1 %idendical
        header.open = pos-startC+1;
    elseif strcmp(chopped,'close') == 1 %idendical
        header.close = pos-startC+1;
    elseif strcmp(chopped,'vol') == 1 %idendical
        header.volume = pos-startC+1;
    end
  end
  pos = pos+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%these nubers are zero based
startR = 1;
stopR = lines-1;
stopC = 8;

datesMet = csvread(fName,startR,2, [startR, 2, stopR, 2]);
% disp (datesMet);
[linesData colons] = size(datesMet);
dates = zeros (linesData,1);

for i=1:linesData
    
    n = datesMet(i, 1);
    if (n < 19000000)
      if n > 900000         %990312
        n = 19000000 + n; %19990312
      else
          n = 20000000 + n;
      end
    end
    
    y = floor(n / 10000);
    m = floor((n - y*10000)/100);
    d = ((n - y*10000 - m*100));
    dates(i,1) = datenum (y, m, d);
    
end


arrayData = dlmread (fName, ',', [startR, startC, stopR, stopC]);

%construct the stock
st = stock (dates, header, arrayData);