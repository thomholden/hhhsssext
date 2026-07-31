function [C,T]=Tri_C(P_Mins,OPEN,L_MRKT)

%% Document Title

% Download current option prices from yahoo finance. This code goes to
% yahoo finance homepage and get quotes for a list of stocks. 
% It downloads the prices every given minutes when the market is open.
% The output is an Excel file with a list of dates, times, put and call option prices.
% I developed the code to keep record of some option prices as historical prices are
% not available for downloading.
%% Author
% Author : Haidar Haidar University of Sussex Email: h.haidar@sussex.ac.uk
% Date: April - 2010 , homepage: http://www.maths.sussex.ac.uk/~haidar
% Updated: January - 2014
%% Reference:  
% ATri is based on get_gf_quote.m by krish reddy of Mathworks, 
% Copyright by NEO672, Concept 7 Intelligencies.
% Date: May 2nd 2008.

%% Inputs
% Write the required companies symbols in the this format <SP.txt>
% Write the corresponding excercise prices in the this format <E.txt>

% function [C,T]=Tri_C(P_Mins,OPEN,L_MRKT)
    
% P_Mins is the frequency of downloading in minutes , e.g 1 to get a quote every minute

% OPEN is the time that the market trading starts so you can run the code and it will automatically enter the market at that time
% If market trading time starts is 1:00 pm OPEN is set at
% 14.25 hours which is 13*60=780
% Set OPEN=0 if you want to start downloading now.
% 
% L_MRKT is the period in minutes for which you want to download, e.g enter
% 6*60 for 6 hours.

% Basicly connect your computer to the internet and run the function on
% Monday and get your continuous option prices at the end of the week. you
% can stop at anytime Ctrl+C and you will find the updated output in an
% Excel file called Haidar

%% Example
%  [C,T]=Tri_C(1,855,8)

%% Output
% <Haidar.xlsx>
% If the code couldn't find the price, it basically shows -1.

%% Read the stocks, Exercise prices, Trading time, Download frequency.

name=Tri_Name
SN=length(name);

fid = fopen('E.txt','r+');
AE = fscanf(fid,'%c');
E=str2num(AE)

fclose(fid);

j=0;
tic;
T={};
at=clock;   
C=0;

while weekday(now)~=7
    at=clock;   
    at(4)*60+at(5)
  while (at(4)*60+at(5))>=OPEN
        T_B=0;
        tic;                
         while toc<(60*L_MRKT)
            T_E=toc;
            if T_E-T_B>(P_Mins*60)           
                T_B=toc;
                j=j+1
                T=[T {datestr(now)}];          
%                 for i=1:SN
                for i=1:SN
                    C(j,(i-1)*4+1:i*4) = ATri(name(i),E(i));
                end
            Update_R(name,C,T,SN);
            end
        end
        at=clock;   
    end
end

return

%% Get option prices
function Quote = ATri(stck,E)

% Yr=2013;
Yr=2015;
Mth=1;
Quote=-1*ones(2,2);

for jj=0:1

Yr=Yr+jj;

    urlStr = strcat('http://finance.yahoo.com/q/op?s=',stck,'&m=',num2str(Yr),'-0',num2str(Mth));

    java_url     = java.net.URL(urlStr)
    stream=openwebb(java_url);
    ireader     = java.io.InputStreamReader(stream );
    breader      = java.io.BufferedReader(ireader);
    
CLS=0;
switch Yr
    case 2015
        C_Yr=17;
    case 2016
        C_Yr=15;
end
    
Type='C';
for kk=1:2 
    HYR=true;
    if kk==2
        Type='P';
    end
    ref_strings.companyId = strcat(num2str(C_Yr),Type,'000')

if E>99
    ref_strings.companyId(6)=[];
else if E<10
        ref_strings.companyId(7)='0';
    end
end
    
    count = 0;
    while(HYR)
        count = count+1;
        if kk==1
            line_buff = char(readLine(breader));
        end
                
        if length(strfind(line_buff,ref_strings.companyId))>0                
                        if mod(E,1)
                            H_ID= strcat(ref_strings.companyId,num2str(E*10),'00');
                        else                            
                            H_ID= strcat(ref_strings.companyId,num2str(E),'000');
                        end
                        tem = strfind(line_buff,H_ID);
                        if (tem)
                            line_buff(tem:end)
                            bgn= strfind(line_buff(tem(1):end),'right"><b>');
                            bgn=bgn(1)+9+tem(1);
                            lst= strfind(line_buff(bgn:end),'</b>');
%                             line_buff(bgn:lst(1)+bgn-2)
                            Quote(jj+1,kk) = str2double(deblank(line_buff(bgn:lst(1)+bgn-2)));
                            HYR=0;
                        end
                break;
        end
        
    end
            
            if (isempty(line_buff) == 1)
                CLS=CLS+1;
                if CLS==4
                    CLS==0
                    break;
                end
            end        
       
    end
 

end

Quote = reshape(Quote,1,4);
return
%% Test the link is valid
 function stream=openwebb(link)
                try
                    WaitTime=toc;
                    stream       = openStream(link);
                catch 
                    while toc<(WaitTime+5)      % wait 5 seconds
                    end
                    stream       =openwebb(link)
                end                    
return    

%% Update the Excel file
function Update_R(nm,C,T,SN)

for k=1:SN
      CNN=num2cell(C(:,(k-1)*4+1:k*4));
      HeadL={'C 1/2015', 'C 1/2016', 'P 1/2015', 'P 1/2016', 'Date/Time'};
      Result=[HeadL; CNN T'];
      R_excel(nm(k),Result);
end

return


function R_excel(nm,RT)

S = char(nm);
xlswrite('Haidar.xlsx',RT,S, 'A1');

return

%% Import the list of Stocks from SP.txt file
function [name]=Tri_Name
fid = fopen('SP.txt','r+');
A = fscanf(fid,'%c');
H = strfind(A,sprintf('\n'));
y=H+1;
y=[1 y];
SH=length(H);
name={};
    for i=1:SH
    name(i)=cellstr(A(y(i):(H(i)-1)));
    end
fclose(fid);
return


