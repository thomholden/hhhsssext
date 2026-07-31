function data = getOptionChainYQL(tickers)
%%
% PURPOSE: function getOptionChainYQL obtains option chain of stock with Yahoo! Query Languae from Yahoo.
%
% USAGE: data = getOptionChainYQL({'GOOG','MSFT'});
%            
% REFERENCE: http://www.yqlblog.net/blog/2009/06/02/getting-stock-information-with-yql-and-open-data-tables/
% http://stackoverflow.com/questions/6442737/get-financial-option-data-with-yql
% http://stackoverflow.com/questions/6477551/yql-options-expirationss
% $Revision: 1.0 $ $Date: 2012/08/19 06:00$ $Author: Pangyu Teng $
% $Revision: 2.0 $ $Date: 2014/07/09 18:00$ $now supports miniOption
%                                           $implemented by G, matlab central authors # 379241
%                  $Date: 2014/07/09 18:13$ $now supports index options
%                                           $implemented by Tom, matlab central authors # 483995

if nargin<1
    display('getStockInformation.m requires 1 input parameter!');
    return;
end

display(sprintf('Connecting to Yahoo.com, please wait.... (getOptionChainYQL.m)'));

data = [];
for i = 1:numel(tickers)
    
    %get data
    
    %%%##### support index option start
    %Replace ^ by hexadecimal ASCII value with % in front 
    %Note that %25 is % and %5E is ^ 
    tickers2=strrep(tickers, '^', '%255E'); 

    %Add ^ (in hexadecimal ASCII format) for VIX, DJX and S&P 500 
    ind=find(ismember(tickers,{'VIX','DJX','SPXPM'})==1); 
    if ~isempty(ind) 
    for j = 1:length(ind) 
    tickers2{ind(j)}=['%255E',tickers{ind(j)}]; 
    end 
    end
    %%%##### support index option end 

    optionChain = getOptionChainYQLCore(tickers2{i});
    %organize data in to struct.
    data(i).ticker = tickers{i};
    data(i).expirations = unique([optionChain(:).expiration]);
    data(i).expirationsStr = datestr(data(i).expirations);    
    data(i).calls = optionChain(strfind([optionChain(:).type],'C'));    
    data(i).puts = optionChain(strfind([optionChain(:).type],'P'));
    
    display(sprintf('pulling option chain of %d of %d tickers',i,numel(tickers)));
end
 

function data = getOptionChainYQLCore(ticker)

%import java classes
import java.io.*;
import java.net.*;
import java.lang.*;

%import XPath classes, for searching and parsing
import javax.xml.xpath.*;

%get portfolio info from google in xml format.
success=false;
MAXITER=3;
try
    % try to create new event
    safeguard=0;    
    while (~success && safeguard<MAXITER)
        %build URL
        geturlString = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.options%20where%20symbol=%22';
        
        %format end of getURLstring depending on number of tickers.
        geturlString = [geturlString, ticker, '%22'];
        geturlString = [geturlString, 'AND%20expiration%20in%20(select%20contract%20from%20yahoo.finance.option_contracts%20where%20symbol=%22'];
        geturlString = [geturlString, ticker, '%22)'];
        geturlString = [geturlString, '%0A%09%09&diagnostics=true&env=http%3A%2F%2Fdatatables.org%2Falltables.env'];
        
        %establish URL connection.
        url = URL( geturlString );
        con = url.openConnection();    
        con.setInstanceFollowRedirects(false);
        con.setRequestMethod( 'GET' );        
        con.setRequestProperty('content-type','application/atom+xml;charset=UTF-8');

        %continue if response is okay.
        if con.getResponseCode() == 200,
            success = true;            
            continue;
        else
            display(sprintf('failed! http code: %d',con.getResponseCode()));
            con.disconnect();
            success=false;
            data =[];
            return;
        end
        safeguard = safeguard + 1;
    end
catch ME
    display(ME.message);
    success=false;
    data =[];
    return;
end



%read retrieved xml data.
xmlData=xmlread(con.getInputStream());
 %%show xml data.
 %xmlstr = xmlwrite(xmlData)

%disconnect connection.
con.disconnect();
%data=struct([]);

%find value of for every item under <quote>.
factory = XPathFactory.newInstance;
xpath = factory.newXPath;


%get the symbol
expression = xpath.compile('/query/results/*');
nodeList = expression.evaluate(xmlData,XPathConstants.NODESET);
symbol = char(nodeList.item(0).getAttribute('symbol'));

%%%##### support index option start
if numel(symbol) > 3
if strcmpi(symbol(1:3),'%5E') 
symbol=symbol(4:length(symbol)); 
end
end
%%%##### support index option end

%locate number of options
expression = xpath.compile('/query/results/optionsChain/*');
nodeList = expression.evaluate(xmlData,XPathConstants.NODESET);
optionNum = nodeList.getLength;

optionSymbol=cell(nodeList.getLength,1); 
optionType=cell(nodeList.getLength,1); 
%get option symbol and type of each option
for i = 1:optionNum
    optionSymbol{i}=char(nodeList.item(i-1).getAttribute('symbol'));
    optionType{i}=char(nodeList.item(i-1).getAttribute('type'));
end

%locate attribute names under first quote 
expression = xpath.compile('/query/results/optionsChain/option[1]/*');
nodeList = expression.evaluate(xmlData,XPathConstants.NODESET);
numFields = nodeList.getLength;
fieldNames=cell(nodeList.getLength,1); 
for i = 1:nodeList.getLength
    fieldNames{i}=char(nodeList.item(i-1).getNodeName);
end

%weird
numFields = 8;
fieldNames = fieldNames(1:numFields);

%locate all attributes under /option/
expression = xpath.compile('/query/results/optionsChain/option/*');
nodeList = expression.evaluate(xmlData,XPathConstants.NODESET);
numAllItems = nodeList.getLength;

%iterate through the nodes, get values that are returned.
infoCellArray = cell([numAllItems,1]);
for i = 1:numAllItems
    if ~isempty(nodeList.item(i-1).getFirstChild)
        infoCellArray{i} = char(nodeList.item(i-1).getTextContent);
    else
        infoCellArray{i} = 'NaN';    
    end
end

%reshape data.
infoCellArray = reshape(infoCellArray,[numFields,optionNum]);

%convert some cells to nums
infoCellArray  = setFieldsToNums(infoCellArray,fieldNames);

%%####  mini option support start
%get expiration from symbol 
miniOption = ~cellfun(@isempty, regexp(optionSymbol, ['^',symbol,'7'])); 
expiration = zeros(numel(miniOption),1); 
expiration(~miniOption) = datenum(cellfun(@(x) x(numel(symbol)+1:numel(symbol)+6),optionSymbol(~miniOption),'UniformOutput',false),'yymmdd'); 
if sum(miniOption) > 0 
expiration(miniOption) = datenum(cellfun(@(x) x(numel(symbol)+2:numel(symbol)+7),optionSymbol(miniOption),'UniformOutput',false),'yymmdd'); 
end 
expirationStr = datestr(expiration);
%%####  mini option support end

% %%get expiration from symbol
% expiration = datenum(cellfun(@(x) x(numel(symbol)+1:numel(symbol)+6),optionSymbol,'UniformOutput',false),'yymmdd');
% expirationStr = datestr(expiration);


%combine data
infoCellArray = [optionSymbol';optionType';num2cell(expiration)';cellstr(expirationStr)';infoCellArray];

%convert cell to struct.
data = cell2struct(infoCellArray,['symbol' ; 'type'; 'expiration'; 'expirationStr'; fieldNames],1);

%format content of cell from string to number.
function data = setFieldsToNums(data,fieldNames)

    %get the names of the fields that contain numbers.
    numFieldNames = getNumFields();
    
    for i = 1:numel(fieldNames)
        %convert strings to numbers
        if sum(strcmp(fieldNames{i},numFieldNames))
             data(i,:)= cellfun(@str2num,data(i,:),'UniformOutput',false);
        end
    end

function output = getNumFields()
output = {'strikePrice' 'lastPrice' 'change' 'bid' 'ask' 'vol' 'openInt'};