f = figure('Name', 'Simple Border Example');
panels = BorderLayout(f, 50, 50, 50, 50);
set(panels.North, 'backgroundcolor', [1 0 0]);
set(panels.South, 'backgroundcolor', [0 1 0]);
set(panels.East, 'backgroundcolor', [0 0 1]);
set(panels.West, 'backgroundcolor', [1 1 0]);
set(panels.Center, 'backgroundcolor', [1 0 1]);
