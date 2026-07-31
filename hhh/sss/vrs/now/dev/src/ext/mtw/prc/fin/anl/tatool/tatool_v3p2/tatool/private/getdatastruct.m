function out = getdatastruct(hf)
% tatool helper function to get all of the data from all of the axes and
% return them in a data structure
% The returned structure has a field for each axis currently on tatool.
% The name of the fields are the axes tags.  The dimension of each field is
% the number of lines currently plotted on each axis.  Each of these
% substructures has a field called name (the tag of the line, without the
% 'line' as the final 4 characters), dates and data.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if (nargin ~= 1) || ~ishandle(hf) || ~strcmp(get(hf,'Tag'),'tatoolfig')
    str = ['The input to ',mfilename,' must be a handle to a tatool figure.'];
    error(str);
end

ad = guidata(hf);

% Loop though all axes getting the line data from them
for idx = 1:length(ad.axestags)
    atag = ad.axestags{idx};
    % Use a flipud here so that the first thing plotted is at the top of
    % the list
    hc = flipud(get(ad.handles.(atag),'Children'));
    nc = length(hc);
    for jdx = 1:nc
        ctag = get(hc(jdx),'Tag');
        out.(atag)(jdx).name = strrep(ctag(1:end-4),'_',':'); % remove the 'line' string at the end
        out.(atag)(jdx).dates = get(hc(jdx),'XData')';
        out.(atag)(jdx).data = get(hc(jdx),'YData')';
    end
end