function rgb = sdh_colormap(type, sea_level);

% SDH_COLORMAP
% 
% rgb = sdh_colormap(type,[sea_level]);
%
%  sdh_colormap('islands');
%  rgb = sdh_colormap('islands');
%  rgb = sdh_colormap('islands',1/5); % less water
%  rgb = sdh_colormap('blueish');
%  rgb = sdh_colormap('light-gray');
%
%  Input arguments: 
%    type      (string) Options: 'islands' (default), 'blueish', 'light-gray'
%    sea_level (scalar) default = 1/3: percentage of max hight to which water reaches.
%
%  Output arguments:
%    rgb       (matrix) RGB color values 64x3 values between 0 and 1.
%
%  Notice: colormap(rgb) is called within this function.    
%
%  Returns colormap values (RGB) for visualizations (in particular for islands metaphor).

% elias 25/04/2002

% defaults
if nargin < 1,
    type = 'islands';
elseif nargin < 2,
    sea_level = 1/3; % default sea level
end

switch type % shortcuts
case 'i', type='islands';
case 'b', type='blueish';
case 'lg', type='light-gray';
end

switch type
case 'light-gray', rgb = 1-(1-gray)/2;
case 'blueish',    rgb = repmat(linspace(0.5,1,64)',1,3).*repmat([0.8 0.9 1],64,1);
case 'islands',
    sea_level = round(sea_level*64);
    if sea_level > 42,
        error('Error: (sdh_colormap) sea level too low (max < 2/3).');
    elseif sea_level < 0,
        error('Error: (sdh_colormap) sea level too low (min = 0).');
    end
    sea_level = max(1,sea_level); % cannot deal with 0

    % defined in HSV values 
    h=[...
            linspace(1,1,sea_level)*2/3,...
            60/360,60/360,...            
            ones(1,42-sea_level)*1/3,...        
            ones(1,12)*1/3,... 
            ones(1,8)]';       
    s=[...
            linspace(1,1,sea_level),...     
            0.7,0.7,...           
            ones(1,42-sea_level),...     
            linspace(1,0.5,12),...     
            zeros(1,8)]';       
    v=[...
            linspace(0.5,1,sea_level),...       % water    (sea level)
            1,1,...                             % beach    (02)
            linspace(0.4,0.6,42-sea_level),...  % forest   (64 - 20 - sea level))
            linspace(0.6,0.7,12),...            % gras     (12)    
            linspace(0.7,1,8)]';                % mountain (10)    
    
    rgb = hsv2rgb([h,s,v]);
end

colormap(rgb);