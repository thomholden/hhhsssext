function FH = Make_Movie(obj, FileName, Cmd, SL, Plot_Func, Start_Index, End_Index, Step)
%Make_Movie
%
%   Make a movie.
%
%   FH = obj.Make_Movie(FileName, Cmd, SL, Plot_Func, Start_Index, End_Index, Step);
%
%   FileName  = local filename to use when saving the figure.
%   Cmd       = any valid command to MATLAB's VideoWriter object.
%               If empty, then default = 'MPEG-4'.
%   SL        = a FEL_SaveLoad object for loading the simulation data to plot.
%   Plot_Func = function handle to a plot routine for plotting the simulation at a
%               particular "time" index.
%   Start_Index, End_Index = make movie of simulation from Start_Index to End_Index.
%               If Start_Index empty, then default = 0.
%               If End_Index   empty, then default = last index of simulation.
%   Step      = increment of simulation index (i.e. the difference between two movie
%               frame simulation indices = Step).  If empty, then default = 1;
%
%   FH = handle to figure window.

% Copyright (c) 05-05-2014,  Shawn W. Walker

if isempty(Cmd)
    Cmd = 'MPEG-4';
end

if isempty(Start_Index)
    Start_Index = 0;
end
if isempty(End_Index)
    End_Index = SL.Get_Max_Index;
end
if isempty(Step)
    Step = 1;
end
Step = round(Step);

if (Start_Index < 0)
    error('Invalid Start_Index!');
end
if (End_Index > SL.Get_Max_Index)
    error('Invalid End_Index!');
end
if (Step < 1)
    error('Invalid Step size!');
end

% Create an animation
FH = figure('Renderer','zbuffer');

% load start iteration
SS = SL.Load(Start_Index);
Plot_Func(SS);

Frame_Indices = (Start_Index:Step:End_Index)';
Num_Frames = length(Frame_Indices);
Frames(Num_Frames) = getframe(gcf);

%set(gca,'nextplot','replacechildren');
for ii = 1:Num_Frames
    
    clf;
    % plot at the current simulation index
    sim_index = Frame_Indices(ii);
    SS = SL.Load(sim_index);
    Plot_Func(SS);
    
    % store each frame to the file
    Frames(ii) = getframe(gcf);
end

% create video object
Full_FN = fullfile(obj.Plot_Dir,FileName);
vidObj  = VideoWriter(Full_FN,Cmd);
open(vidObj);
writeVideo(vidObj,Frames);
close(vidObj);

end