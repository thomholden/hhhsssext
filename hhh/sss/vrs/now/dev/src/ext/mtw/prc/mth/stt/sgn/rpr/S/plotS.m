function plotS(S,varargin)
% plotS   2-D plot of S estimator.
%
%     plotS(S) plots S estimator (mean over the trials) over a surface of
%     129 points (electrodes). A color bar on the right side of the schema 
%     shows the range of S values, and the different color intensities 
%     corresponding to different S values. The topology of the Geodesic 
%     128 EEG/ERP setup is considered.
% 
%     plotS(S,area) plots S estimator computed over a given brain region area. 
%     Area can be a vector of electrodes numbers, or one of the string for
%     predefined brain areas:  
%        'OL' : occipital left 
%        (i.e. [74 75 70 71 72 65 66 69 76 82])
%        
%        'OR' : occipital right 
%        (i.e. [76 77 82 83 84 85 89 90 91 95])
%
%        'O'  : occipital (left+right)
%
%        'FL' : frontal left  
%        (i.e. [39 35 29 25 20 12 34 128 21 28 33 6 24 26 27 11 19 23 127 16 18 22 17])
%        
%        'FR' : frontal right 
%        (i.e. [1 2 3 4 5 6 8 9 10 11 14 15 16 17 117 118 121 122 123 124 125 126])
%
%        'F'  : frontal (left+right)
%
%        'TL' : temporal left  
%        (i.e. [40 41 44 45 46 47 49 50 51 56 57 58 59 63 64])
%        
%        'TR' : temporal right 
%        (i.e. [92 96 97 98 99 100 101 102 103 108 109 110 114 115 116 120])
%
%        'T'  : temporal (left+right)
%
%        'PL' : parietal left  
%        (i.e. [52 53 54 60 61 62 67 68 73])
%
%        'PR' : parietal right 
%        (i.e. [62 68  73 78 79 80 86 87 93])
%
%        'P'  : parietal (left+right)
%
%        'CL' : central left
%        (i.e. [7 13 30 31 32 36 37 38 42 43 48 55])
%        
%        'CR' : central right
%        (i.e. [55 81 88 94 99 104 105 106 107 111 112 113])
%
%        'C'  : central (left+right)
%
%     If area='' all the 129 electrodes are to considered. 
%     The topology of the Geodesic 128 EEG/ERP setup is considered as default.
%
%     plot(S,area,setup) where setup is the experimental setup used. As
%     default, setup='EEG_Geod'. No other setup is yet supported.
%
%     Example:
%     % random values for S, faking 129 electrodes and 10 trials
%     S=(randn(10,129)+1)/2;
%     % plotting S over all
%     plotS(S)
%     % select an area
%     area=[10:50];
%     % plot over area
%     plotS(S(:,area),area)
%
%     See also getRegionEEG, getClusters.

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.



% Check number of inputs
if nargin < 1
    error('Missing input');
elseif nargin > 3
    error('Too many input arguments');
end

% check input
if ischar(S)
    error('S should not be a string. Please check help tutorial');
end

if nargin == 3,
    setup = varargin{2};
else
    setup='EEG_Geod';
end


% If S computed on more than one trial, we consider mean(S)
MS=nanmean(S,1);
  
% switch over different possible setups
switch setup
    
    % EEG setup supported 
    case 'EEG_Geod'

      % Load electrodes coordinates
      load CoordInterp;
  
      % plot on a subset of sites
      if nargin==2,
     
         area=varargin{1};
         
         % if is a string
         if ischar(area)
             
             % switch over the predefined areas
             switch area
                 % occipital left
                 case 'OL'
                 disp('Brain area of interest: Occipital left');
                 area=getRegionEEG(area);

                 % occipital right  
                 case 'OR'
                 disp('Brain area of interest: Occipital right');
                 area=getRegionEEG(area);
                
                 % occipital
                 case 'O'
                 disp('Brain area of interest: Occipital');
                 regionL=getRegionEEG('OL');
                 regionR=getRegionEEG('OR');
                 area=unique([regionL ; regionR]);
                 
                 % frontal left
                 case 'FL'
                 disp('Brain area of interest: Frontal left');
                 area=getRegionEEG(area);
                 
                 % frontal right
                 case 'FR'
                 disp('Brain area of interest: Frontal right');
                 area=getRegionEEG(area);

                 % frontal
                 case 'F'
                 disp('Brain area of interest: Frontal');
                 regionL=getRegionEEG('FL');
                 regionR=getRegionEEG('FR');
                 area=unique([regionL ; regionR]);
          
                 % temporal left
                 case 'TL'
                 disp('Brain area of interest: Temporal left');
                 area=getRegionEEG(area);

                 % temporal right
                 case 'TR'
                 disp('Brain area of interest: Temporal right');
                 area=getRegionEEG(area);

                 % temporal
                 case 'T'
                 disp('Brain area of interest: Temporal');
                 regionL=getRegionEEG('TL');
                 regionR=getRegionEEG('TR');
                 area=unique([regionL ; regionR]);
                 
                 % parietal left
                 case 'PL'
                 disp('Brain area of interest: Parietal left');
                 area=getRegionEEG(area);

                 % parietal right
                 case 'PR'
                 disp('Brain area of interest: Parietal right');
                 area=getRegionEEG(area);
                 
                 % parietal
                 case 'P'
                 disp('Brain area of interest: Parietal');
                 regionL=getRegionEEG('PL');
                 regionR=getRegionEEG('PR');
                 area=unique([regionL ; regionR]);
                 
                 % central left
                 case 'CL'
                 disp('Brain area of interest: Central left');
                 area=getRegionEEG(area);
                 
                 % central right
                 case 'CR'
                 disp('Brain area of interest: Central right');
                 area=getRegionEEG(area);
                 
                 % central
                 case 'C'
                 disp('Brain area of interest: Central');
                 regionL=getRegionEEG('CL');
                 regionR=getRegionEEG('CR');
                 area=unique([regionL ; regionR]);
                 
                 % all electrodes
                 case ''
                 area=1:129;

            otherwise
                error ('area should be one among OL, OR, O, FL, FR, F, TL, TR, T, PL, PR, P, CL, CR, C, '' ');
            end
            % end switch area
      
         end
         % if ischar
         
        % Input check
        if ~(size(S,2) == length(area))
            error('S does not match the second input in size');
        end
      
         % Ordering CO vector
        [a,idx]=unique(CO(:,3));
        CO=CO(idx,:);
        % Keeping only the selected ones
        CO=CO(area,:);
    
        % else of if nargin==2  
        else
  
        % Order CO components
        [a,idx]=unique(CO(:,3));
        % To perform input check
        CO=CO(idx,:);
      
      end
      % end if nargin==2
      
  
      % Input check
      if ~(size(S,2)==size(CO,1))
         error('Input S was not computed on all electrodes or does not correspond to second input.');
      end
  
      % compute coordinates and incidence matrix
        [tri,x,y,A]=IncidenceMatrix(CO);
      
      % prepare for mesh
      [X,Y]=meshgrid(linspace(min(x),max(x),length(x)),linspace(min(y),max(y),length(y)));
      % refinement
      collim=quant([
             min(MS) max(MS);
             ],0.005);

     
      % Open the Figure
      % Position of the frames
      hlow=0.4;
      hdiv=0.7;
      hhig=2.0;
      vlow=1.0;
      vdiv=1.5;
      vhig=1.0;

      % row and column
      nrow=1;
      ncol=1;

      % number of color
      nclr=128;
  
      % 2D Box size
      wd=(17.5-hlow-(ncol-1)*hdiv-hhig)/ncol;
      ht=wd;
  
      % Printout the final size
      [ncol*wd+hlow+(ncol-1)*hdiv+hhig nrow*ht+vlow+(nrow-1)*vdiv+vhig+1.5];

      % Fonts sizes
      fnt=8;
      fnl=9;
      fnlb=9;
  
      figure(...
            'units','centimeters',...
            'position',[hlow vlow ncol*wd+hlow+(ncol+2)*hdiv+hhig nrow*ht+vlow+(nrow-1)*vdiv+vhig+1.5], ...
            'PaperUnits','centimeters', ...
            'PaperOrientation','portrait', ...
            'PaperPosition',[hlow vlow ncol*wd+hlow+(ncol-1)*hdiv+hhig nrow*ht+vlow+(nrow-1)*vdiv+vhig+1.5], ...
            'PaperType','A4', ...
            'Color','w' ...
            );
  
  
      % Plot the N subboxes
      for r=1:nrow,
          for c=1:ncol,
            % Axes
            ax=[-1 1 -1 1];
        
            % Subplot
            ha=axes(...
                   'units','centimeters',...
                   'position',[hlow+(c-1)*(hdiv+wd)+0.5 vlow+(r-1)*(vdiv+ht) wd ht],...
                   'fontsize',fnt,...
                   'fontname','helvetica',...
                   'fontangle','normal',...
                   'Clim',collim(r,:), ...
                   'visible','off', ...
                   'box','on', ...
                   'Color','none' ...
                   );
            axis(ax);   
        
            % Compute the contour
            Zin=griddata(x,y,MS,X,Y,'linear');

            % vector for contour 
            v=linspace(min(MS)+0.05*(max(MS)-min(MS)),max(MS)-0.05*(max(MS)-min(MS)),7);
        
            % draw contour lines
            cc=contourc(X(1,:),Y(:,1),Zin,v);
        
            % Contour
            bl=1;
            while bl<size(cc,2),
                np=cc(2,bl);
                line(cc(1,(bl+1):(bl+np)),cc(2,(bl+1):(bl+np)),'color','w','linewidth',0.5);
                bl=bl+np+1;
            end
        
            % color surface
            colormap(fliplr(pink(nclr))); 
            patch('faces',tri,'vertices',[x(:) y(:) zeros(size(x(:)))],'facevertexcdata',MS(:),'facecolor','interp','edgecolor','none');
        
            % electrodes position
            line(x,y,'linestyle','none','marker','.','markersize',8,'markerfacecolor',0.5*[1 1 1],'markeredgecolor',0.5*[1 1 1]);
        
            % the head
            ph=linspace(0,2*pi,100)+pi/2;
            line(cos(ph),sin(ph),'linewidth',0.5,'color',0.5*[1 1 1],'clipping','off');
            n=3; line([cos(ph(n)) 1.15*cos(ph(1)) cos(ph(end-n+1))],[sin(ph(n)) 1.15*sin(ph(1)) sin(ph(end-n+1))],'linewidth',0.5,'color',0.5*[1 1 1],'clipping','off');
            ph=linspace(pi-0.27*pi,pi+0.27*pi,20);
            er=0.3;
            ed=0.225;
            line(-(1-ed)+er*cos(ph),er*sin(ph),'linewidth',0.5,'color',0.5*[1 1 1],'clipping','off');
            line(+(1-ed)+er*cos(ph+pi),er*sin(ph+pi),'linewidth',0.5,'color',0.5*[1 1 1],'clipping','off');
        
            % colorbar and its positioning
            if c==ncol,
               % Axes
               hcb=axes(...
                       'units','centimeters',...
                       'position',[hlow+0.3+(c-1)*(hdiv+wd)+wd+hlow+1 vlow+(r-1)*(vdiv+ht) wd/25 ht],...
                       'fontsize',fnt,...
                       'fontname','helvetica',...
                       'fontangle','normal',...
                       'YAxisLocation', 'right', ...
                       'visible','on', ...
                       'box','on', ...
                       'Color','none' ...
                       );
               ax=[0 1 0 1];
               axis(ax);
            
               % plot of the bar
               t=collim(r,:);
               d=(t(2) - t(1))/nclr;
               t=[t(1)+d/2  t(2)-d/2];
               image([0 1],t,(1:nclr)');
            
               set(hcb, ...
                  'Ydir','normal', ...
                  'YAxisLocation', 'right', ...
                  'visible','on', ...
                  'xtick',[], ...
                  'box','on', ...
                  'Color','none' ...
                  );
           end;
        
       end;
   end;
   
   % other recording setups not yet supported   
    otherwise
        error('Invalid setup');
        
end
% end switch over setup

return;
% end plot
