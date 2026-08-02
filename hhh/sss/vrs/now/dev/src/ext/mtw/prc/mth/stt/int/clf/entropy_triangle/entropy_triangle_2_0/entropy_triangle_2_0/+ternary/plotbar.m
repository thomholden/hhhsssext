function handles = plotbar(A, B, C, d,varargin)
% TERNARY.PLOTBAR plot EXTENDED ternary phase diagram with COLOUR BAR on
% the side, when necessary
%
%   TERNARY.PLOT(A, B) plots ternary phase diagram for three components.  C is calculated
%      as 1 - A - B. No colour bar is plotted.
%
%   TERNARY.PLOT(A, B, C) plots ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the
%       total. No colour bar is plotted.
%
%   TERNARY.PLOT(A, B, C, D) plots extended ternary phase data for the
%       three components A, B, C. If the values are not fractions, the values 
%       are normalised by dividing by the total. The lengths of [A,B,C] are truncated
%       to that of D. A colour bar is plotted with the convention that:
%       - if [D] is a cell array of strings, the strings in [D] are used as labels on the
%       colour bar.
%       - if [D] is an array of integers, they are order-inverted and transformed intro
%       strings before being used as labels on the colour bar. 
%       - if [D] is an array of other numbers, their range is used to build
%       the color bar 
%
%   TERNARY.PLOT(A, B, C, D, LINETYPE) the same as the above, but with a user specified LINETYPE (see PLOT
%       for valid linetypes).
% 
%   h = TERNARY.PLOT(...) returns handles to the axes issued from the plot.
%
%   NOTES
%   - An attempt is made to keep the plot close to the default plot type.  The code has been based largely on the
%     code for POLAR and TERNPLOT, although inverting the increasing value
%     direction.
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNARY.LABEL
%
%   See also TERNARY.LABEL PLOT POLAR

%       b
%      / \
%     /   \
%    c --- a 

% Author: Carl Sandrock 20020827
% Modifications: Francisco Valverde 20091123
% May 2005: added constant data plot option
error(nargchk(2, 256, nargin));

%CPM, FVA: Flags for printing tick labels in the color bar.
intc=false;%integer tick labels
%stringc = false;%string tick labels
% CPM: Constant data, set marker: no color bar on the side.
%FVA: by default, do not plot the bar
withbar = false;%Flag for plotting the sidebar
maxM=20; %If the number of matrices is very big, do not write all the labels in the colorbar
%majors = 10;%FVA: We like our ternary plots to have 10 ticks on the major axes
% FVA: the above should NOT be here, but in the basic plot preparation.
% Make ternary axes and query their state
%[hold_state, cax, next] = ternary.axes(majors,'fraction');

% FVA: Complete coordinates and work them out once and for all
if nargin < 3
    C = 1 - (A+B);
end;
%[fA, fB, fC] = fractions(A, B, C);
Total = (A+B+C);
fA = A./Total;
fB = B./Total;
fC = 1-(fA+fB);
%FVA: the following coordinates is what gets plotted
[x, y] = ternary.coords(fA, fB, fC);
% Sort data points in x order
% FVA: Why? Commented away because it interferes with any possible prior
% ordering on the data
% [x, ind] = sort(x);
% y = y(ind);

%M should be defined in here. The parameter analysis here is crucial.
% - if d is a cell array of strings, plot bar on the strings.
% - if d is from other types of cell array, plot recursively
if nargin >  3
    switch class(d)
        case 'cell'
            M=length(d);
            if not(iscellstr(d))%
                for i = 1:M
                    plotbar(A{i}, B{i}, C{i}, d{i}, varargin)
                end
                return%all work has been dispatched to recursive calls
            end
        case {'double','int'}
            %FVA: all the values for cumulative printing should be between 0 and 1,
            %otherwise the bar on the side does not have much sense. 
            if (ishold() && any(arrayfun(@(dat) any(dat < 0.0) || any(dat > 1.0),d)))
                error('ternary:plotbar: cumulative plot with non [0,1] value')
            end
            %CPM: modifications for discrete values of d
            %M=length(d);%%Number of confusions matrices in the array
            %[~, ~, M] = size(d);
            M = max(size(d));
        otherwise
            error('ternary:plotbar: unpredicted range data parameter %s', class(d))            
    end
    withbar = (M > 1);
    maxM = min(maxM,M);%Number of ticks in the plotbar to be plotted
end


% plot data and get the axes if any
if ~withbar
    %q = plot(x, y, varargin{:});
    q=plot(x,y,'db','markerfacecolor','b',varargin{:});
else%plot with bar
    hasColorbar =  numel(findobj(gcf,'tag','Colorbar')) ~= 0;
    %FVA: the recipe to get the colorbar handle is from doc colorbar
    if (hasColorbar) %only redraw labels and bar if non-existent
        lab = get(findobj(gcf,'tag','Colorbar'),'YTickLabel');
        miv = str2double(lab(1,:));
        mav = str2double(lab(length(lab),:));
    else %draw colorbar & labels
        if iscellstr(d)%the data are names
            intc=true;
            lab = char(d(round(linspace(1,M,maxM))));
            d=1:M;
            miv=min(d);
            mav=max(d);
        else%%data not names, but numeric
            miv=min(d);
            mav=max(d);
            if (miv==mav), mav=ceil(miv); end%try to widen range
            intc=(round(d)==d);%detects whether d is integer
            %CPM: if all the values in d are equal the colormap created must have
            %at least one element. Otherwise it returns NaN.
                % Create the yticklabels
            ytl=linspace(miv,mav,maxM);
            lab = cell(1,maxM);
            for i=1:maxM
                % Create the yticklabels
                if (intc)%The data are integer
                    lab{i}=sprintf('%-4.0f',ytl(i));
                else%data are not names, nor integers
                    lab{i}=sprintf('%-4.3f',ytl(i));
                end
            end
            lab=char(lab);%from cell str to array of chars
        end
%    end
            
    
    %hcb = colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],'YTickLabel',int2str([1:numcolors]'), 'YLim', [1 numcolors]);
    %set(hcb,'ylim',[1 length(map)]);
%    if not(ishold())%Draw the colorbar on the side!!
        numcolors = M;%Try to draw as many colours as points
        hcb=colorbar;
        if intc
            if numcolors>maxM, numcolors=maxM; end
            fprintf('*****numcolors is %d\n', numcolors);%FVA
            caxis([1 numcolors]);
            yal= (1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors);
            set(hcb,'YTick',yal);
            %print the actual labels lab
            set(hcb,'YTickLabel',lab,'fontsize',9,'ycolor','k','xcolor','k','YLim', [1 numcolors]);
            %colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],'YTickLabel',s, 'YLim', [1 numcolors]);
        else%When the results are non-integers, non-names
            nticks=10;
            caxis([0 1]);
            yal=linspace(0,1,nticks);
            set(hcb,'YTick',yal);
            % Create the yticklabels
            ytl=linspace(miv,mav,nticks);
            %s=char(nticks,4);
            lab=cell(1,4);
            for i=1:nticks
                if abs(min(log10(abs(ytl)))) <= 3
                    lab{i}=sprintf('%-4.3f',ytl(i));
                else
                    lab{i}=sprintf('%-4.2E',ytl(i));
                end
                %s(i,1:length(B))=B;
            end
            lab=char(lab);
            set(hcb,'YTickLabel',lab,'fontsize',9,'ycolor','k','xcolor','k','YLim', [0 1]);
            %colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],'YTickLabel',s, 'YLim', [1 numcolors]);
        end
        set(gca,'dataaspectratio',[1 1 1]), axis off; 
        %set(cax,'NextPlot',next);
    end
    
    % Get the current colormap, distribute the colours and finally plot.
    map=colormap;


    for i=1:M
        if intc
            in=1+round((d(i)-miv)*(length(map))/(mav-miv+1));
        else
            in=1+round((d(i)-miv)*(length(map))/(mav-miv));
        end
        if in==0, in=1; end
        if in > length(map), in=length(map);end
        %numcolors = length(in);
        q=plot(x(i),y(i),'s','Color',map(in,:),'markerfacecolor',map(in,:),varargin{:});
    end
    %q=plot(x,y,'s','Color',map(in,:),'markerfacecolor',map(in,:),varargin{:});

end

%now plot the real bar

% Guarantee output parameter if existent!
if nargout > 0
    handles = q;
end
return%handles
