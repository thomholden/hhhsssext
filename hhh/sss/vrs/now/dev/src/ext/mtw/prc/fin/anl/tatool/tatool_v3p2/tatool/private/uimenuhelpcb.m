function uimenuhelpcb(obj,eventdata,varargin) %#ok
% tatool helper function for processing the callbacks for the main help
% menu
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj); %#ok

switch get(obj,'Tag')
    case 'uimenuhelphelp'
        helptext = textread('ReadMe.m','%s','delimiter','\n','whitespace','');
        str = strrep(helptext,'% ',''); % remove comment chars
        str = strrep(str,'%','');
        helpwin(str,'TATOOL');
    case 'uimenuhelpabout'
        str = {'TATOOL was written by Phil Goddard, the Principal of Goddard Consulting.';...
            'Feel free to send comments to phil@goddardconsulting.ca.';...
            ' ';...
            'Version 3.2';...
            'Q2 2011'};
        msgbox(str,'TATOOL','help','modal')
    otherwise
        str = [mfilename,' shouldn''t be called in this way,'];
        error(str);
end