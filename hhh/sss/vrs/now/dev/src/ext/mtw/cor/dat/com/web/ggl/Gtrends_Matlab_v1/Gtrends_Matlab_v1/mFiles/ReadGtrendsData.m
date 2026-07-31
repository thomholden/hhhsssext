% Function for parsing google trends data
%
% INPUT:    filename - Name of file with gtrends data (usually report.csv)
%
% OUTPUT:   startDate - Cell array with starting dates of each gtrends search index
%           endDate - Cell array with ending dates of each gtrends search
%           index volume
%           typeDate - type of dates in filename (weekly or monthly)
%           GtrendsOut - Gtrends volume data 
%
% AUTHOR: Marcelo Perlin (marcelo.perlin@ufrgs.br)

function [startDate,endDate,typeDate,GtrendsOut] = ReadGtrendsData(filename)

fid=fopen(filename);

if fid<0
    error(['File ' filename ' was not found']);    
end

for i=1:5   % skip header
    str=fgetl(fid);
end

if isnumeric(str)
    error('No search data found in Gtrends. This means a low search volume for myStr');
end

idx=1;
GtrendsOut=zeros(1,1);
startDate=cell(1,1);
endDate=cell(1,1);
while 1
    
    lineNow=fgetl(fid);
    
    if strcmp(lineNow,'')
        break;
    end
    
    
    otherIdx=strfind(lineNow,',');
    
    gTrendsNbr=str2num(lineNow(otherIdx+1:end));
    
    if isempty(gTrendsNbr)
        break
    else
        GtrendsOut(idx,1)=gTrendsNbr;
    end
    
    
    % check number of "-" in order to distinguish weekly and monthly data
    
    nDash=numel(strfind(lineNow,'-'));
    
    if nDash>1
        if idx==1
            typeDate='Weekly';
        end
        startDate{idx,1}=lineNow(1:10);
        endDate{idx,1}=lineNow(14:14+9);
    else
        typeDate='Monthly';
        startDate{idx,1}=[lineNow(1:7) '-01'];
        temp=addtodate(datenum(startDate{idx,1},'yyyy-mm-dd'),1,'month');
        temp=addtodate(temp,-1,'day');
        
        endDate{idx,1}=datestr(temp,'yyyy-mm-dd');
    end
    
    idx=idx+1;
end

fclose(fid);