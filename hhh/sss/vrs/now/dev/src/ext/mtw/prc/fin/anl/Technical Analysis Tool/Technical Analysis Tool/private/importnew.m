function importnew(obj,tats)
% tatool helper function to complete the initialization of the main UI
% after loading in data for any time EXCEPT the first time.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin < 2
    str = [mfilename,' requires 2 inputs.'];
    error(str);
end
if ~ishandle(obj)
    str = ['The first input to ',mfilename,' must be a graphics handle.'];
    error(str);
end
if ~istats(tats)
    str = ['The seond input to ',mfilename,' must be a tats structure.'];
    error(str);
end

ad = guidata(obj);
if isfield(ad.handles,'welcomeinfo')
    error([mfilename,' shouldn''t be called if this is true.']);
    return
end

% Before substituting any new data for old make sure that all calculations
% can be performed successfully
try
    % Loop through the old data substituting new data into place.  If this is
    % successful then we'll poke this new data back into the axes
    newdata = getdatastruct(ad.handles.tatoolfig); 
    for idx = 1:length(ad.axestags)
        this_axis = newdata.(ad.axestags{idx});
        nlines = length(this_axis);
        for jdx = 1:nlines
            if (idx==1) && (jdx==1) %The prices data is slightly different to other which require
                % a function evaluation
                newdata.(ad.axestags{idx})(jdx).name = tats.name;
                newdata.(ad.axestags{idx})(jdx).dates = tats.dates;
                newdata.(ad.axestags{idx})(jdx).data = tats.data;
            else
                % loop through each line determining which indicator and which
                % period it represents
                pcolon = findstr(this_axis(jdx).name,':');
                % If this indicator has multiple parameters, then break out
                % all except the first one (which will be done next)
                if ~isempty(pcolon) 
                    ncolon = length(pcolon);
                    vals = cell(1,ncolon+1);
                    for kdx = 1:ncolon
                        % convert the string between 2 colons to a number
                        vals{kdx+1} = str2num(this_axis(jdx).name(pcolon(kdx)+1:min(end,pcolon(kdx)+1))); %#ok
                    end
                    lname = this_axis(jdx).name(1:pcolon(1)-1);
                else
                    vals = cell(1,1);
                    lname = this_axis(jdx).name;
                end
                for kdx = length(lname):-1:1
                    firstval = str2num(lname(kdx:end)); %#ok
                    if isempty(firstval)
                        vals{1} = str2num(lname(kdx+1:end)); %#ok
                        iname = lower(lname(1:kdx));
                        break
                    end
                end
                % calculate the indicator and create a temporary tats
                indicator = feval(iname,tats.data,vals{:});
                taseries.name = this_axis(jdx).name;
                taseries.dates = tats.dates;
                taseries.data = indicator;               
                % if indicator has more then one column then form a
                % temporary tats and modify it for plotting before
                % putting it back into the main structure
                if size(indicator,2) > 1
                    taseries = modifytatsforplotting(taseries);
                end
                % now poke back into main structure
                newdata.(ad.axestags{idx})(jdx) = taseries;
            end
        end
    end
catch
    % Something has gone wrong calculating an indicator for the new data so
    % can't complete the calculations.
    estr = {['Error loading ',tats.name],...
            '',...
            ['A problem occured trying to calculate ',this_axis(jdx).name,' for the new data.  ',...
                'Try removing ',this_axis(jdx).name,' from the current plots and reloading ',tats.name,'.']};
    errordlg(estr,'TATOOL LOAD ERROR','modal');
    return;
end

% Have calculated the required indices for the new data so plot it

% Loop over all the axes
for idx = 1:length(ad.axestags)
    % set axes to be changed
    ha = ad.handles.(ad.axestags{idx});
    axes(ha);
    % get the children on the axes (make the assumption that they are all of type 'line')
    hc = get(ad.handles.(ad.axestags{idx}),'Children');
    hc = flipud(hc);
    nc = length(hc);
    % loop through each child and substitute the new data.
    for jdx = 1:nc
        if (idx==1) && (jdx==1)
            %The price series is slightly different to other plots
            % as we need to worry about the name and the legend
            set(hc(jdx),...
                'XData',newdata.(ad.axestags{idx})(jdx).dates,...
                'YData',newdata.(ad.axestags{idx})(jdx).data,...
                'Tag',[(newdata.(ad.axestags{idx}).name),'line']);
            % need to modify the name due to the TEX interpreter
            thisname = newdata.(ad.axestags{idx})(jdx).name;
            switch thisname(1) % Modify name because of TEX interpreter
                case '^'
                    thisname = ['\',thisname]; %#ok
                case '_'
                    thisname = ['\',thisname]; %#ok
            end
            % create legend
            hl = legend(ha);
            if isempty(hl) % there's no legend (which shouldn't be the case) so create one
                legend(thisname);   
            else
                lstring = get(findobj(hl,'Type','Text'),'String');
                if isa(lstring,'cell')
                    legend(ha,strvcat(thisname,lstring{2:end})); %#ok
                else
                    legend(ha,strvcat(thisname,lstring(2:end,:))); %#ok
                end
            end
        else
            set(hc(jdx),...
                'XData',newdata.(ad.axestags{idx})(jdx).dates,...
                'YData',newdata.(ad.axestags{idx})(jdx).data);
        end
    end
    % bring the legend to the front
    legend(ha);
    % set the x axis
    setdaterange(ad.daterange.str,ad.daterange.num);
end

% Save new data to app data
ad.tats = tats;
guidata(obj,ad);
