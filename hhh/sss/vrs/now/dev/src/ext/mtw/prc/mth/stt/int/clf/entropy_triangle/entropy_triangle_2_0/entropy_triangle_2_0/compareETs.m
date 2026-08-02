function [] = compareETs(C,names,expName)
% [] = compareETs(C)
% [] = compareETs(C,names)
% [] = compareETs(C,names,expName)
%
%
% A basic primitive to compare classifiers.
%
% Takes a cell array of confusion matrices [C], with a list [names] of 
% different confusion matrices over an experiment [expName], works out the 
% entropy triangles:
% - in the given order, then 
% - in accuracy order, then 
% - in descending normalized information transfer factor order. 
%
% It ends up giving all heatmaps of the confusion matrices, if possible.
%
% As an intermediate step it provides the perplexity information in the
% matrices, as well as the NIT, the EMA, CEN and MCC
% 
% By default if also provides a latex-able table of these evaluation
% measures.
%
% Authors: FVA; CPM, 2009-2014
error(nargchk(1, 3, nargin));

% Argument processing
if iscell(C)
    M=length(C);%%Number of confusions matrices in array.
else
    error('entropy:compareETs','parameter C must be a cell array of matrices');
end
% % Obtaining a list of tags for the different classes in the xperiment
% if nargin > 1
%     if iscell(tags)
%         nTags=length(tags);
%     else
%         error('entropy:compareETs','parameter [tags] must be a cell array of strings');        
%     end
% else% If not supplied, contrive some tags for each class
%     %TODO: Check that all CM have the same number of classes
%     nTags=length(C{M});%% CAVEAT! This presupposes that the last confusion matrix is the biggest.
%     tags=cell(nTags,1);%The tags for each class
%     for i=1:nTags
%         tags{i}=sprintf('tag %s',i);
%     end
% end
%Processing the list of names of the classifiers
if nargin > 1
    numNames = length(names);
    if not(iscellstr(names))
        error('entropy:compareETs','parameter [names] must be a cell array of strings');
    elseif (numNames == 0)%this is just to let an exp name be given
        exp
    elseif (length(names) ~= M)
        M = length(names);
        warning('entropy:compareETs','truncating experiments to the named sublist');
    end
    texnames = names;
else
    texnames=cell(M,1);
    names=cell(M,1);
    for i=1:M,
        names{i}=sprintf('C_%d',i);
        texnames{i}=sprintf('$C_{%d}$',i);
    end
end
%% PRocessing the name of the experiment
if nargin > 2
    if not(ischar(expName))
        error('entropy:compareETs','parameter [expName] must be a string'); 
    end
else
    expName = 'Classfrs.';
end

%% Work out the triangles and their information decomposition
SPLIT=false;%We do not use the split triangles in this script.
%SPLIT=true;
colormap(copper);

%%% Numbers related to perplexity
%nmuXY=zeros(M,1);%%normalized mutual information in natural units

%% Work out the entropies and the magnitudes to be represented
[nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy]=coordinates(C);
[muXY,nxy,myx,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy);
N = cellfun(@(c) sum(sum(c)),C);
theseDiag = cellfun(@(c) sum(diag(c)), C);
% Work out the accuracies
acc = theseDiag./N;
%CEN and MCC calculations
for m=1:M
    [cen(m),mcc(m)]=cen_mcc(C{m})
end

%% Print out the information in a table
PRINT_TABLE=true;
%PRINT_TABLE=false;
if (PRINT_TABLE)
    [kk,thisIndex] = sort(acc,'descend');%... in descending accuracy order
    if size(thisIndex,1)~=1
        thisIndex=thisIndex';
    end
    %\usepackage{PrintTable}% YOU NEED TO IMPORT THIS!
    expTag = expName;
    l = max(max(cellfun(@length,names)), length(expTag));
    form = '%s';%Solve issues with field lengths in formatted visualizations
    formExpTag = sprintf(form,expTag);
    % 
    t = PrintTable;%No caption supplied now: see end of printing mechanism
    t.HasRowHeader = true;
    t.HasHeader = true;
    %print: perplexities, mu factor, accuracy, EMA, NIT, 1_CEN and MCC
    t.addRow(formExpTag, '$k_X$','$k_{X|Y}$','$\mu_{XY}$','$a(P_{XY})$','$a''(P_{XY})$','$q_X(P_{XY})$', '$1-CEN$','$MCC$');
    for i=thisIndex%
        %Adding rows with custom format for each label
        t.addRow(...
            texnames{i},nx(i),nxy(i),muXY(i),acc(i),1/nxy(i), nmuXY(i), 1-cen(i), mcc(i),...
            {form,'%.3f','%1.3f','%1.3f','%1.3f','%1.3f','%1.3f','%1.3f','%1.3f'})
    end
    t.Caption = sprintf(['Perplexities, accuracy $a(P_{XY})$, modified accuracy $a''(P_{XY})$ ' ...
        'and normalised information transfer factor $q_X(P_{XY})$ for %s confusion matrices.'], expName);
    %Can we generate normal output?
    t.print;
    %Generate the tex output
    t.Format = 'tex';
    t.print;
end 

%% Define labels for the ternary plot
%labs for the split plot: OLD STUFF
clabs = '$${H''}_{P_{X|Y}}, {H''}_{P_{Y|X}}$$';
alabs = '$$\Delta \emph{{H''}}_{P_X}, \Delta \emph{{H''}}_{P_Y}$$';
blabs = '$$\emph{{MI''}}_{P_{XY}}$$';

%labels for the un-split plot
clab = '$${VI''}_{P_{XY}}$$';
alab = '$$\Delta \emph{H''}_{P_X \cdot P_Y}$$';
blab = '$$2\times {MI''}_{P_{XY}}$$';


%% representation based in ordering due to precision (Accuracy?)

colormap(jet(M))
%colormap(hsv(M))
%colormap(copper(M))%too dark scale.
%colormap(bone(M))%Problem: highest c has white-on-white marker.
%colormap(autumn(M))

%CPM: Back to the primitives in +ternary 
%Takes default values for ticks and labels
ternary.axes(10,'fraction');
if SPLIT
    ternary.label(alabs,blabs,clabs);
else
    ternary.label(alab,blab,clab);
end

%prevent the entropy triangle to be over bloated with dots
if (M > 100) 
    mainMsize = 4;
    splitMsize = 1;
else
    mainMsize = 7;
    splitMsize = 4;
end
irank=fliplr(1:M);%present info from first to last
h=ternary.plotbar(nDHpxpy(irank),n2MI(irank),nVI(irank),names(irank),'markersize',mainMsize,'marker','d');

if SPLIT
    hold on
    h=ternary.plotbar(nDHpx(irank),n2MI(irank),nVIx(irank),names(irank),'markersize',splitMsize,'marker','x');
    hold on
    h=ternary.plotbar(nDHpy(irank),n2MI(irank),nVIy(irank),names(irank),'markersize',splitMsize,'marker','o');
    hold off
end


%% Same as in figure 1 but with the colourmap representing the accuracy
figure(2)
% JUST CHOOSE ANY >(
%colormap('default')
%colormap(autumn)
%colormap(winter)
%colormap(summer)
colormap(jet)
%colormap(cool)
%colormap(copper)
%colormap(hot)%%needs scaling so that 100% corresponds with white
ternary.axes(10,'fraction');
if SPLIT
    ternary.label(alabs,blabs,clabs);
else
    ternary.label(alab,blab,clab);
end
h=ternary.plotbar(nDHpxpy,n2MI,nVI,acc,'markersize',mainMsize,'marker','d');
if SPLIT
    hold on
    h=ternary.plotbar(nDHpx,n2MI,nVIx,acc,'markersize',splitMsize,'marker','x');
    hold on
    h=ternary.plotbar(nDHpy,n2MI,nVIy,acc,'markersize',splitMsize,'marker','o');
    hold off
end
title('Colour according to Acc');

%% Same as in figure 1 but with colourmap representing NIT, which is kind
% silly, since you can read the rank from Mutual Information in the ET.
figure(3)
%colormap(jet)
%colormap('default')
%colormap(copper)
colormap(jet)
% Set the ER view on plot
ternary.axes(10,'fraction');
if SPLIT
    ternary.label(alabs,blabs,clabs);
else
    ternary.label(alab,blab,clab);
end
h=ternary.plotbar(nDHpxpy,n2MI,nVI,nmuXY,'markersize',mainMsize,'marker','d');
if SPLIT
    hold on
    h=ternary.plotbar(nDHpx,n2MI,nVIx,nmuXY,'markersize',splitMsize,'marker','x');
    hold on
    h=ternary.plotbar(nDHpy,n2MI,nVIy,nmuXY,'markersize',splitMsize,'marker','o');
    hold off
end
title('Colour according to NIT');

%% Same as in figure 1 but with colourmap representing 1-cen (cen ranges [1,0])
figure(4)
%colormap(jet)
%colormap('default')
%colormap(copper)
%colormap(jet)
% Set the ER view on plot
ternary.axes(10,'fraction');
if SPLIT
    ternary.label(alabs,blabs,clabs);
else
    ternary.label(alab,blab,clab);
end
h=ternary.plotbar(nDHpxpy,n2MI,nVI,1-cen,'markersize',mainMsize,'marker','d');
if SPLIT
    hold on
    h=ternary.plotbar(nDHpx,n2MI,nVIx,1-cen,'markersize',splitMsize,'marker','x');
    hold on
    h=ternary.plotbar(nDHpy,n2MI,nVIy,1-cen,'markersize',splitMsize,'marker','o');
    hold off
end
title('Colour according to 1-CEN');

%% Same as in figure 1 but with colourmap representing (mcc+1)/2 (mcc ranges [-1,1])
figure(5)
%colormap(jet)
%colormap('default')
%colormap(copper)
colormap(jet)
% Set the ER view on plot
ternary.axes(10,'fraction');
if SPLIT
    ternary.label(alabs,blabs,clabs);
else
    ternary.label(alab,blab,clab);
end
h=ternary.plotbar(nDHpxpy,n2MI,nVI,(mcc+1)/2,'markersize',mainMsize,'marker','d');
if SPLIT
    hold on
    h=ternary.plotbar(nDHpx,n2MI,nVIx,(mcc+1)/2,'markersize',splitMsize,'marker','x');
    hold on
    h=ternary.plotbar(nDHpy,n2MI,nVIy,(mcc+1)/2,'markersize',splitMsize,'marker','o');
    hold off
end
title('Colour according to (MCC+1)/2');

%% Finally print the heatmaps, in case you are curious to check your intution
% about which system is the best by these means.
%pause
if (M <= 20)
    figure(6)
    colormap(jet)
    for i=1:M
        if M < 15
            rows=2;
        else
            rows=3;
        end
        subplot(rows,ceil(M/rows),i);
        imagesc(C{i})
    end
end