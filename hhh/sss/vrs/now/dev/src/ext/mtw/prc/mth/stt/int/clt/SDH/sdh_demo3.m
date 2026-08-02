function sdh_demo3
% SDH_DEMO3 Music Collection consisting of 77 pieces
%    the full titles of the pieces can be found at
%    http://www.oefai.at/~elias/music/demo/songs77.html

% elias 04/07/2002

load music % consisting of 77 songs, variable: sData

disp('Calculating SOM ...')
% train a ghsom
sMap = som_randinit(sData,'msize',[7 7],'shape','sheet','lattice','rect');
sMap = som_batchtrain(sMap,sData,'radius',linspace(4,0.1,100),'tracking',0);
sMap = som_autolabel(sMap,sData);
disp('Done.')

f = figure;
set(f,'numbertitle','off');
set(f,'name','SDH Demo3a');

% basic SOM visualization
som_show(sMap,'empty','','footnote','','bar','none'); % visualize
som_show_add('label',sMap.labels,'textsize',7,'textcolor','k')

f = figure;
set(f,'numbertitle','off');
set(f,'name','SDH Demo3b');
s=subplot(1,1,1);

S = sdh_calculate(sData, sMap, 'interp.ntimes', 2, 'frame', 'on', 'spread',1);
sdh_visualize(S,'labels',sMap.labels,'subplot',s,'sofn',0,'fontcolor','r')
set(f,'renderer','painter') % this is necessary because Matlab messes up the renderer sometimes
