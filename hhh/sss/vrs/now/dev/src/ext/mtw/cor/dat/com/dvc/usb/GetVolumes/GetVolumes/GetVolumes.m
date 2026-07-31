% Usage:  ret = GetVolumes
%         Get an overview of all mounted volumes (USB, SD, ...).
%
%         ret = GetVolumes( VolumeLabel )
%         Get the (one) mounted volume with name <VolumeLabel>.
%
% Release:  V1.05 11-09-2014
%
% Author:   Jan G. de Wilde   email: jan.dewilde@nl.thalesgroup.com
%           Thales Nederland B.V.

% V1.00 19-02-2014  First release
% V1.01 20-02-2014  {'EN','NL'} languages supported
% V1.02 21-02-2014  NetDrives supported
% V1.03 22-02-2014  Support for Windows and Linux
% V1.04 27-05-2014  Support for Volumes with no-'VolumeLabel'
% V1.05 11-09-2014  Nicer layout when nargout==0       

function ret = GetVolumes( VolLabel )

if nargin == 0,     VolLabel = '';   end

ret = [];   ind = 0;
VolLabelFound = false;

if ispc,    % WINDOWS
    for vol = 'a' : 'z',
        [ err, sys ] = system(['dir /W ' vol ':\']);    % V1.04
        if ~err,
            EOL = find( sys == 10 );
            pos = strfind( sys, [' ' upper(vol) ' '] ) + 3;
            while sys(pos) ~= ' ', pos = pos + 1;   end

            ind = ind + 1;
            ret(ind).Volume = [ vol ':' ]; %#ok<*AGROW>
            ret(ind).Label  = sys( pos(1)+1 : EOL(1)-1 );

            if ~isempty( VolLabel )  &&  strcmpi( ret(ind).Label, VolLabel ),
                VolLabelFound = true;
            end

            % last line
            lijn= sys( EOL(end-1)+1 : EOL(end)-1 );
            pos = find( lijn == ')' );
            lijn= lijn( pos+1 : end );
            pos = find( lijn==','  |  lijn=='.' );      % V1.01
            str = lijn( pos(1)-3 : pos(end)+3 );
            str( str==' ' | str==',' | str=='.' ) = ''; % V1.01
            ret(ind).BytesFree = str2double( str );
        end

        if VolLabelFound,   break;   end
    end
else    % LINUX
    [ err, sys ] = system('/bin/df');
    if ~err,
        EOL = find( sys == 10 );
        for vol = 2 : length( EOL ),
            lijn = sys( EOL(vol-1)+1 : EOL(vol)-1 );
            
            pos = strfind( lijn, '% /' );
            if isempty( pos ),   continue;   end
            
            if strcmpi( lijn(1:4), 'none' ),   continue;   end

            ind = ind + 1;
            if lijn(end) == '/',
                ret(ind).Volume = '/';
                ret(ind).Label  = '/';
            else
                ret(ind).Volume = lijn( pos(end)+2 : end );
                [ ~, fn, ex ]   = fileparts( ret(ind).Volume );
                ret(ind).Label  = [ fn ex ];
            end
            
            if ~isempty( VolLabel )  &&  strcmpi( ret(ind).Label, VolLabel ),
                VolLabelFound = true;
            end
            
            pos2 = pos - 5; pos1 = pos2;
            while lijn(pos1) ~= ' ',   pos1 = pos1 - 1;   end
            ret(ind).BytesFree = str2double( lijn( pos1+1 : pos2 ) ) * 1024;
            
            if VolLabelFound,   break;   end
        end
    end
end

% COMMON
if ~isempty( VolLabel ),
    if VolLabelFound, 	ret = ret( end );
    else                ret = [];
    end
end

if nargout == 0,
    LenVolume   = 6;     % V1.05
    LenLabel    = 6;
    for ind = 1 : length( ret ),
        LenVolume = max( LenVolume, length( ret(ind).Volume ) );
        LenLabel  = max( LenLabel,  length( ret(ind).Label  ) );        
    end
    
    frmt = sprintf('%%-%ds   %%-%ds   %%s\\n', LenVolume, LenLabel );
    fprintf( frmt, 'Volume', 'Label', 'BytesFree (GB)' ); %#ok<CTPCT>
    for ind = 1 : length( ret ),
        fprintf( frmt, ret(ind).Volume, ret(ind).Label, sprintf('%9.1f',ret(ind).BytesFree/2^30) );
    end
    clear ret
end

return