function z = harmonicseries(Amp,e2,e3,e4,e5,e6,e7,e8)
%HARMONICSERIES   Sum of harmonic space-time series.
%   z = HARMONICSERIES(Amp,Per,Pha,t) Gives the 1D harmonic time series 
%   z(t) as the sum of sinusoidal series (vector same size as t):
%
%      z(t) = sum_i [ Amp_i * cos(W_i*t + Po_i) ]
%
%   where W=2*pi/Per are the angular frequencies, Per the periods and 
%   Po=Pha*pi/180 their initial phases (Pha in degrees).
%
%   z = HARMONICSERIES(Amp,Len,Per,Pha,t,x) Gives the 2D harmonic space-
%   time field z(t,x) as the sum of sinusoidal series (matrix: time x 
%   space):
%
%      z(t,x) = sum_i [ Amp_i * cos(W_i*t - K_i*x + Po_i) ]
%
%   where K=2*pi/Len are the wavenumbers and Len their wavelengths. 
%
%   z = HARMONICSERIES(Amp,Len,Dir,x,y) Gives the harmonic 2D space field 
%   z(x,y) as the sum of sinusoidal series (matrix same size as x,y):
%
%      z(x,y) = sum_i [ Amp_i * cos(Kx_i*x + Ky_i*y) ]
%
%   where (Kx,Ky) are the components of the wavenumber vectors with
%   magnitudes 2*pi/Len and Dir their Oceanography-like (1) directions 
%   (in degrees).
%
%   z = HARMONICSERIES(Amp,Len,Dir,Per,Pha,x,y,t) Gives the 3D harmonic 
%   space-time field z(x,y,t) as the sum of sinusoidal series (3D array: 
%   matrix-space x vector-time):
%
%      z(x,y,t) = sum_i [ Amp_i * cos(W_i*t - Kx_i*x - Ky_i*y + Po_i) ] 
%
%   Note (1): The directions Oceanography-like are
%            
%                             (y)
%                        North = 0º  _ _
%                              ^        \
%                              |        _\|
%                              |          .
%             West = 270º -----0----->  East = 90º (x)
%                              |
%                              |
%                        South = 180º
%
%   Note: if x,y are raw and column vectors respectively, internally are
%   converted in a 2D meshgrid, with y-component increasing upwards 
%   (contrary to the raw index): 
%      [x,y] = meshgrid(sort(x),fliplr(sort(y(:))'));
%
%   Example:
%      t = 0:99;
%      X = -100:100; Y = -50:50;
%      [x,y] = meshgrid(X,fliplr(Y)); % Y increase upwards
%      Amp = [10 11 9];
%      Per = [200 70 30];
%      Pha = [0 90 180];
%      Len = [10 20 50];
%      Dir = [0 45 150];
%      zt   = harmonicseries(Amp,Per,Pha,t);
%      ztx  = harmonicseries(Amp,Len,Per,Pha,t,X);
%      zxy  = harmonicseries(Amp,Len,Dir,X,Y');
%      zxyt = harmonicseries(Amp,Len,Dir,Per,Pha,x,y,t);
%      subplot(221), plot(t,zt), xlabel t, title('Time series')
%      subplot(222), surf(x,y,zxy), view(2), axis tight, shading interp 
%      xlabel x, ylabel y, title('Space series')
%      for k = 1:length(t) 
%       subplot(223), plot(X,ztx(k,:)), xlabel x, ylabel t
%       axis([0 100 -40 40])
%       title(['1D Wave at time: ' num2str(t(k))]), drawnow
%       subplot(224), surf(x,y,zxyt(:,:,k)), shading interp
%       axis([-100 100 -50 50 -40 40])
%       title(['2D Wave at time: ' num2str(t(k))]), drawnow
%      end
  
%   Written by  
%   Lic. on Physics Carlos Adrián Vargas Aguilera  
%   Physical Oceanography MS candidate  
%   UNIVERSIDAD DE GUADALAJARA   
%   Mexico, 2004  
%  
%   nubeobscura@hotmail.com  


switch nargin
 
 case 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Entries:
  Amp = Amp(:);
  Per = e2(:);
  Pha = e3(:);
  t   = e4;
  
  % Checks inputs:
  if (length(Amp)~=length(Per)) || (length(Amp)~=length(Pha))
   error('harmonicseries:IncorrectDataLength',...
         'Harmonic parameters must be of the same length.')
  end
  
  % Converts degrees to radians:
  Pha = Pha*pi/180;

  % Angular frequency (rad/s):
  W = 2*pi./Per;         

  % 1D harmonic time series:
  z = zeros(size(t));
  for nt = 1:length(t)
    z(nt) = sum( Amp .* cos( W*t(nt) + Pha ) );
  end
  
 case 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Entries:
  Amp = Amp(:);
  Len = e2(:);
  Per = e3(:);
  Pha = e4(:);
  t   = e5;
  x   = e6;
  
  % Checks inputs:
  if (length(Amp)~=length(Len)) || (length(Amp)~=length(Per)) || ...
                                   (length(Amp)~=length(Pha))
   error('harmonicseries:IncorrectDataLength',...
         'Harmonic parameters must be of the same length.')
  end
  
  % Converts degrees to radians:
  Pha = Pha*pi/180;

  % Angular frequency (rad/s):
  W = 2*pi./Per;         

  % Wavenumber (rad/m):
  K = 2*pi./Len;      
  
  % 2D Harmonic space-time series:
  z = zeros(size(x));
  for nt = 1:length(t)
   for nx = 1:length(x)
    z(nt,nx) = sum( Amp .* cos( W*t(nt) - K*x(nx) + Pha ) );
   end
  end
  
 case 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Entries:
  Amp = Amp(:);
  Len = e2(:);
  Dir = e3(:);
  x   = e4;
  y   = e5;
  
  % Meshgrid?
  if (size(x,1)==1) && (size(y,2)==1)
   [x,y] = meshgrid(sort(x),fliplr(sort(y(:))'));
  end
  
  % Checks inputs:
  if (length(Amp)~=length(Len)) || (length(Amp)~=length(Dir)) 
   error('harmonicseries:IncorrectDataLength',...
         'Harmonic parameters must be of the same length.')
  end
  if (size(x,1)~=size(y,1)) || (size(x,2)~=size(y,2))
   error('harmonicseries:IncorrectDataLength',...
         ['x,y must be matrixes of the same size or a raw,column vector'...
         ' repectively.'])
  end
  
  % Converts degrees to radians:
  Dir = Dir*pi/180;      

  % Wavenumber components (rad/m):
  K = 2*pi./Len;
  Kx = K.*sin(Dir);     
  Ky = K.*cos(Dir);     

  % 2D Harmonic space series:
  z = zeros(size(x));
  for ny = 1:size(y,1)
   for nx = 1:size(x,2)
    z(ny,nx) = sum( Amp .* cos( Kx*x(ny,nx) + Ky*y(ny,nx)) );
   end
  end
  
 case 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Entries:
  Amp = Amp(:);
  Len = e2(:);
  Dir = e3(:);
  Per = e4(:);
  Pha = e5(:);
  x   = e6;
  y   = e7;
  t   = e8;
  
  % Meshgrid?
  if (size(x,1)==1) && (size(y,2)==1)
   [x,y] = meshgrid(sort(x),fliplr(sort(y(:))'));
  end
  
  % Checks inputs:
  if (length(Amp)~=length(Len)) || (length(Amp)~=length(Dir)) || ...
     (length(Amp)~=length(Per)) || (length(Amp)~=length(Pha))  
   error('harmonicseries:IncorrectDataLength',...
         'Harmonic parameters must be of the same length.')
  end
  if (size(x,1)~=size(y,1)) || (size(x,2)~=size(y,2))
   error('harmonicseries:IncorrectDataLength',...
         ['x,y must be matrixes of the same size or a raw,column vector'...
         ' repectively.'])
  end
  
  % Converts degrees to radians:
  Dir = Dir*pi/180;  Pha = Pha*pi/180;
  
  % Angular frequency (rad/s):
  W = 2*pi./Per;        
  
  % Wavenumber components (rad/m):
  K = 2*pi./Len;
  Kx = K.*sin(Dir);     
  Ky = K.*cos(Dir);     

  % 3D Harmonic space-time series:
  z = zeros(size(y,1),size(x,2),length(t));
  for ny = 1:size(y,1)
   for nx = 1:size(x,2)
    for nt = 1:length(t)
     z(ny,nx,nt) = sum( Amp .* cos( W*t(nt) - Kx*x(ny,nx) - Ky*y(ny,nx) ...
                                    + Pha ) );
    end
   end
  end

 otherwise
 error('harmonicseries:NotEnoughInputArguments',...
  'Four, Five, Six or Eigth Input Arguments Required.')
 
end


% Carlos Adrián. nubeobscura@hotmail.com