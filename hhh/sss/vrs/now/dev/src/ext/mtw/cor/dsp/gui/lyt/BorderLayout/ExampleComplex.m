f = figure('Name', 'Complex Border Example');
p = uipanel;
set(p,'position',[.1 .1 .8 .8]);
set(p,'backgroundColor',[1 0 0]);
panels1 = BorderLayout(p,50,50,200,50);
set(panels1.North,'backgroundColor',[0 1 0]);
set(panels1.South,'backgroundColor',[0 0 1]);
set(panels1.East,'backgroundColor',[0 1 1]);
set(panels1.West,'backgroundColor',[1 0 1]);
set(panels1.Center,'backgroundColor',[1 1 0]);

panels2 = BorderLayout(panels1.Center,50,50,50,50);
set(panels2.North,'backgroundColor',[0 .7 0]);
set(panels2.South,'backgroundColor',[0 0 .7]);
set(panels2.East,'backgroundColor',[0 .7 .7]);
set(panels2.West,'backgroundColor',[.7 0 .7]);
set(panels2.Center,'backgroundColor',[.7 .7 0]);

panels3 = BorderLayout(panels1.East,50,50,50,50);
set(panels3.North,'backgroundColor',[0 .5 0]);
set(panels3.South,'backgroundColor',[0 0 .5]);
set(panels3.East,'backgroundColor',[0 .5 .5]);
set(panels3.West,'backgroundColor',[.5 0 .5]);
set(panels3.Center,'backgroundColor',[.5 .5 0]);

panels4 = BorderLayout(panels3.Center,15,15,15,15);
set(panels4.North,'backgroundColor',[0 .3 0]);
set(panels4.South,'backgroundColor',[0 0 .3]);
set(panels4.East,'backgroundColor',[0 .3 .3]);
set(panels4.West,'backgroundColor',[.3 0 .3]);
set(panels4.Center,'backgroundColor',[.3 .3 0]);
