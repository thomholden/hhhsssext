function uimenuindicatorscb(obj,eventdata,axestype,iname,dvals) %#ok
% tatool helper function for processing the addition or removal of the
% indicator specified by the iname variable.
% AXESTYPE should be either 'mainaxes' or 'ownaxes' and specifies whether the
% indicator should be plotted on the main axes or an axes of it's own.
% INAME is a function handle for calulating the indicator.
% DVALS is a cell array containing prompt/default value pairs for querying
% the user for parameters to use in calculating the indicator

% NOTE: Indicators that have more than one parameter (e.g. bollinger bands)
% are displayed in text as bollingerP1:P2, but their tag uses an
% underscore, e.g. bollingerP1_P2.  Colons can't be used for both as they
% are invalid in variable (and field) names.  Underscores are difficult for
% both as the TEX interpretor causes other issues that would require
% potentially substantial and cumbersome workarounds.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);
tag = get(obj,'Tag');
switch tag(end-2:end)
    case 'new' % Need to calculate and add a new (potentially first) indicator
        % so create a UI asking the user to enter the parameters needed to
        % calculate the specified indicator
        paramcell  = indicatordlg(...
            'Name',[upper(iname),' parameter query'],...
            'PromptString',['Please enter parameters for the ',iname,' calculation...'],...
            'OKString','OK',...
            'InputStrings',dvals(1:2:end),...
            'InputDefaults',dvals(2:2:end));
        if isempty(paramcell)
            % Cancel was pressed so do nothing
            return
        end
        % try to perform the calculation.  return if it can't be done
        try
            taseries.name = [upper(iname),localcell2str(paramcell{:})];
            taseries.dates = ad.tats.dates;
            taseries.data = feval(iname,ad.tats.data,paramcell{:});
        catch
            if exist(iname)~=2 %#ok
                estr = {'Please put the "analysisfcns" directory onto the MATLAB path';...
                    'then try again.  Type "help addpath" at the MATLAB command prompt';...
                    'for more information if required.'};
            else
                estr = {['There has been a problem calculating the ',iname,' indicator for'];...
                    'the given parameters.  The error given was';...
                    lasterr};
            end
            errordlg(estr,'TATOOL Error','modal');
            return
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % if specified Indicator and Period already exists then do nothing
        % if no indicator exists then make a plot
        % if Indicator (but not this Period) exist then add this one to existing plot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(axestype,ad.axestags{1}) && (length(get(get(obj,'Parent'),'Children'))==1)
            % Indicator is on the main axis and no 'Delete' menu item
            % exists already so create one
            mtag = [tag(1:end-3),'delete'];  % use same tag but with 'delete' rather than 'new'
            ad.handles.(mtag) = uimenu(...
                'Parent',get(obj,'Parent'),...
                'Label','Delete',...
                'Separator','on',...
                'Tag',mtag);
        end
        % For positioning need to know how many axes already exist
        na = length(ad.axestags);
        bottommargin = ad.sliderwidth + ad.defaultaxesspacing/2 + ad.defaultxlabelspacing;
        if ~strcmp(axestype,ad.axestags{1}) && ~any(strcmp(ad.axestags,[lower(iname),'axes']))
            % Indicator isn't on the mainaxes nor does an axis exists for this indicator
            % so create axis for it below existing axes and move the other axes up
            atag = [lower(iname),'axes'];
            amainpos = get(ad.handles.(ad.axestags{1}),'Position'); % this is always the main (price) plot axes
            fpos = get(ad.handles.tatoolfig,'Position'); %#ok
            % create new axes
            newapos = [amainpos(1) bottommargin amainpos(3) amainpos(4)*ad.defaultrelativeheight];
            ad.handles.(atag) = ...
                axes('Parent',ad.handles.tatoolfig,...
                'Units','pixels',...
                'Box','on',...
                'Tag',atag,...
                'Position',newapos);
            title([upper(iname),' Indicator']);
            ad.axestags{end+1}=atag;
            % now loop through pre-existing axes and move them up
            offset = amainpos(4)*ad.defaultrelativeheight + ad.defaulttitlespacing +...
                ad.defaultaxesspacing + ad.defaultxlabelspacing;
            for idx = 1:na
                apos = get(ad.handles.(ad.axestags{idx}),'Position');
                apos(2) = bottommargin + (na-idx+1)*offset;
                set(ad.handles.(ad.axestags{idx}),'Position',apos);
            end
            % need to move the legends too
            legend('ResizeLegend');
            % also create a 'Delete' uimenu
            mtag = [tag(1:end-3),'delete'];  % use same tag but with 'delete' rather than 'new'
            ad.handles.(mtag) = uimenu(...
                'Parent',get(obj,'Parent'),...
                'Label','Delete',...
                'Separator','on',...
                'Tag',mtag);
        end
        % decide which axes to use
        if strcmp(axestype,ad.axestags{1})  % use mainaxes
            ha = ad.handles.(ad.axestags{1});
        else % use specific indicator axes
            ha = ad.handles.(ad.axestags{strcmp(ad.axestags,[lower(iname),'axes'])});
        end
        % If Indicator of this period doesn't exist then plot it
        if isempty(findobj(ha,...
                'Type','line',...
                'tag',[strrep(taseries.name,':','_'),'line']))
            % set the axes
            axes(ha);
            % before doing the plot need to to check whether this is a 2 or
            % more line plot (e.g. upper and lower bollinger bands) and
            % modify the data appropriately
            taseries = modifytatsforplotting(taseries);
            % do the plot
            % Workaround for bug in usage of LEGEND in R14SP1
            axislocations_store(gcbo);
            plottats(taseries);
            axislocations_set(gcbo);
            % set axis to the one given
            xlabel('Dates');
            grid on;
            % set the date range of the new data
            setdaterange(ad.daterange.str,ad.daterange.num);
            % add a UImenu item to enable it to be deleted
            mtagstr = ['uimenuindicatorsdelete',lower(strrep(taseries.name,':','_'))];
            ad.handles.(mtagstr) = uimenu(...
                'Parent',ad.handles.(['uimenuindicators',lower(iname),'delete']),...
                'Label',taseries.name,...
                'Callback',{@uimenuindicatorscb,axestype,iname,dvals},...
                'Tag',mtagstr);
        end
        
        % Bring this axis to the top of the view window
        if na == length(ad.axestags)
            % No axes were added, so repositioning hasn't occured yet - so do
            % it now
            apos = get(ha,'Position'); % we're going to put this axes in the lower left corner at 'bottommargin'
            offset = apos(2)-bottommargin;
            for idx = 1:na
                apos = get(ad.handles.(ad.axestags{idx}),'Position');
                set(ad.handles.(ad.axestags{idx}),'Position',apos-[0 offset 0 0]);
            end
        end
        % Need to worry about resizing if the figure is larger than the
        % initial size (as the main price plot may now be positioned too
        % low on the figure window.  But do this for all cases at the
        % bottow, outside the switching
        
    otherwise % Need to remove specified Indicator period from axes
        % (could also check that tag(end-5:end) is 'delete')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % if only one indicator exists then delete axes
        % if more than one exists then just delete it (and its legend)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ndeletes = length(get(get(obj,'Parent'),'Children'));
        if ~strcmp(axestype,ad.axestags{1}) && ndeletes == 1
            % Indicator is not on the mainaxes and only one indicator exists
            % so delete the whole axis.  But first we're going to reposition any
            % axes below this one.
            % Firstly get handles and position of all axes
            ahandles = nan*ones(size(ad.axestags));
            apositions = nan*ones(length(ahandles),4);
            for idx = 1:length(ahandles)
                ahandles(idx) = ad.handles.(ad.axestags{idx});
                apositions(idx,:) = get(ahandles(idx),'Position');
            end
            % find the position of the one that needs to be deleted
            ahdelete = ad.handles.([lower(iname),'axes']);
            idxdelete = find(ahandles==ahdelete);
            % Now delete the axes and if it's not the last one then move
            % the others up one position
            delete(ahandles(idxdelete));
            if idxdelete < length(ahandles)
                for jdx = idxdelete+1:length(ahandles)
                    set(ahandles(jdx),'Position',apositions(jdx-1,:));
                end
            end
            ahandles(idxdelete)=[];
            apositions(end,:)=[];
            % and remove the handles from app data
            ad.handles = rmfield(ad.handles,...
                {[lower(iname),'axes'],...   %axes handle
                    ['uimenuindicators',lower(iname),'delete'],... % delete menu handle
                    ['uimenuindicatorsdelete',lower(strrep(get(obj,'Label'),':','_'))]}); %deleteIndicator menu handle
            % and delete the 'Delete' menu
            delete(get(obj,'Parent'));
            % and remove the tag from ad.axestags
            ad.axestags(idxdelete) = [];
            
            % Finally need to do some position checking to ensure that the
            % remaining axes are positioned correctly on the figure
            maxlowerleft = ad.sliderwidth + ad.defaultaxesspacing/2 + ad.defaultxlabelspacing;
            actuallowerleft = apositions(end,2);
            if actuallowerleft > maxlowerleft
                % y positions of plot are too high and need to be brought down 
                offset = actuallowerleft - maxlowerleft;
                for idx = 1:length(ahandles)
                    apositions(idx,2) = apositions(idx,2)-offset;
                    set(ahandles(idx),'Position',apositions(idx,:));
                end
            end
            % Now shift down has occured need to worry about resizing if the figure
            % is larger than the initial size (as the main price plot may now be positioned
            % too low on the figure window.  But do this for all cases at the
            % bottow, outside the switching
            
        else
            % Indicator is on the main axes or more than one Indicator is plotted on this
            % axis, hence delete just this specific one
            istr = get(obj,'Label');
            istr2 = strrep(istr,':','_');
            if strcmp(axestype,ad.axestags{1}) % delete from main axes
                ha = ad.handles.(ad.axestags{1});
                % if this is the only indicator on the main axes then also delete
                % the DELETE uimenu
                if length(get(get(obj,'Parent'),'Children'))==1
                    delete(get(obj,'Parent'));
                    ad.handles = rmfield(ad.handles,['uimenuindicators',lower(iname),'delete']);
                else
                    delete(obj); %otherwise just delete the item
                end 
            else
                ha = ad.handles.([lower(iname),'axes']); % delete from own axes
                % and delete the item from the 'Delete' menu
                delete(obj);
            end
            delete(findall(ha,'Tag',[istr2,'line'])); % delete line
            % remove the handle from app data
            ad.handles = rmfield(ad.handles,['uimenuindicatorsdelete',lower(istr2)]);            
            % and update the legend
            hl = legend(ha);
            lstring = strvcat(get(findobj(hl,'Type','Text'),'String')); %#ok
            if isa(lstring,'char')
                lstring = cellstr(lstring);
            end
            lstring(strcmp(lstring,istr)) = [];
            legend(ha,lstring{end:-1:1});
        end
end

% save changed application data (can't use obj because we've deleted it)
guidata(ad.handles.tatoolfig,ad);

% Workaround for bug in usage of LEGEND in R14SP1
axislocations_store(ad.handles.tatoolfig);

% resize the figure (note that this must be done after saving the new app
% data
resizecb(ad.handles.tatoolfig,[]);

% When manipulating axes MATLAB automatically turns the zoom off, so need
% to check where tatool thinks it should be and put it back on in needed
resetzoom(ad.handles.tatoolfig);

function str=localcell2str(varargin)
% Helper function to take a cell array of numeric scalar integers and convert to a
% colon seperated string.  e.g. {1,2,3} becomes '1:2:3'
lin = length(varargin);
str = '';  % can't preallocate as we don't know in advance how long the numbers will be
for idx = 1:lin
    num = varargin{idx};
    if ~isscalarinteger(num)
        error('Inputs must be scalar integers.');
    else
        str = [str,num2str(num),':']; %#ok
    end
end
str(end)='';  % eliminate last colon
