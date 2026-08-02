function h = waitbar(x,name)
%WAITBAR Display wait bar.
%       H = WAITBAR(X,'title') creates and displays a wait bar of
%       fractional length X.  The handle to the waitbar figure is
%       returned in H.  X should be between 0 and 1.  Each
%       subsequent call to waitbar, WAITBAR(X), extends the length
%       of the bar to the new position X.
%
%       WAITBAR is typically used inside a FOR loop that performs a
%       lengthy computation.  A sample usage is shown below:
%
%           h = waitbar(0,'Please wait...');
%           for i=1:100,
%               % computation here %
%               waitbar(i/100)
%           end
%           close(h)

%       Clay M. Thompson 11-9-92
%       Copyright (c) 1992-93 by The MathWorks, Inc.
%       $Revision: 1.9 $  $Date: 1993/09/24 18:57:13 $

x = max(0,min(100*x,100));

if nargin==2,
  pos = get(0,'ScreenSize');
  f = figure('position',[pos(3)/2-180 pos(4)/2-37 360 75], ...
             'NextPlot','new','resize','off');
  colormap([])

  h = axes('Xlim',[0 100],'Ylim',[0 1]);
  title(name)
  set(h,'box','on')
  set(h,'position',[.05 .30 .9 .30])
  set(h,'YTickLabelMode','manual')
  set(h,'YTickLabels',[])

  xpatch = [0 x x 0];
  ypatch = [0 0 1 1];
  xline = [100 0 0 100 100];
  yline = [0 0 1 1 0];
  p = patch(xpatch,ypatch,'r','Edgecolor','r','EraseMode','none');
  l = line(xline,yline,'eraseMode','none');
  set(l,'Color',get(gca,'Xcolor'))

else
  f = gcf;
  h = gca;
  ch = get(gca,'children');
  p = []; l = [];
  for i=1:length(ch),
    t = get(ch(i),'type');
    if strcmp(lower(t),'patch'), p = ch(i); end
    if strcmp(lower(t),'line'), l = ch(i); end
  end
  if isempty(p) | isempty(l), error('Couldn''t find waitbar handles.'); end
  xpatch = get(p,'xdata');
  xpatch = [xpatch(2) x x xpatch(2)];
  set(p,'Xdata',xpatch)
  xline = get(l,'xdata');
  set(l,'xdata',xline)
end

drawnow

if nargout==1,
  fout = f;
end

