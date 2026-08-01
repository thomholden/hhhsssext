function [Sxx, Syy, Szz, Txy, Tyz, Txz] = scalecombine(channels, scales)
%SCALECOMBINE Combines multiple field outputs (RPT files) from the
%ABAQUS/CAE visualisation module.
%   [Sxx, Syy, Szz, Txy, Tyz, Txz] = SCALECOMBINE(channels, scales) returns 
%   the components of the Cauchy stress tensor for each node in a finite 
%   element model.
%
%   The scale and combine is used in fatigue analysis where the finite element 
%   model is solved for one or more stress states (channels) and extruded
%   into a scaled time history of stresses by scaling each channel with a 
%   loading definition, and combining each scaled channel into a single tensor.
%
%   The loading definition is a series of numeric scale factors which
%   represent a fatigue cycle of the FE model. Since finite element
%   analysis is often time-intensive, loading scales allow for the model to
%   be solved for one state and extruded in a fatigue time history.
%
%   Sxx, Syy, Szz, Txy, Tyz and Txz are all NxM arrays, where N is the 
%   number of nodes in the model and M is the load history length.
%
%   CHANNELS is the filename of the RPT containing the field output as a 
%   string if one channel is being scaled.
%
%   CHANNELS is a cell array of strings, where each string is the filename 
%   of the RPTs containing the field output if multiple channels are being
%   scaled and then combined into a single nodal listing.
%
%   SCALES is the filename of the loading data as a string if it is being
%   used to scale one channel.
%
%   SCALES is a cell array of strings, where each string is the filename of
%   the loading data if they are being used to scale multiple channels into
%   a single nodal listing.
%
%   Notes:
%
%   The loading data defined by SCALES is defined in the form of an Nx1
%   vector. The value of N must be the same for all the loading files. If
%   the load lengths are different, zeros may be appended to the shorter
%   loadings and the stresses for these load steps will be ignored.
%
%   SCALECOMBINE recognises loading data from .txt and .dat file formats
%
%   For fatigue analysis, the loading definition usually represents
%   constant, or variable amplitude fatigue cycles. For non-fatigue
%   applications where only a single stress state is required, the loading
%   scale may be defined as the 1x1 array [1].
%
%   In order to generate a valid scale and combine, the loading must be
%   proportional so that the stresses from each channel can be superimposed
%   without incurring a phase difference. Hence SCALECOMBINE should only be
%   used in conjunction with elastic FEA where the stress-strain
%   relationship is linear.
%
%   SCALECOMBINE requires GETRPT.m in order to interpret the RPT file(s).
%
%   Make sure all channel and loading files are in your working directory.
%
%   Example: Create a nodal listing of each stress component for a shaft
%   in fully-reversed bending from an ABAQUS model with 5000 nodes.
%
%       channels = 'shaft_field_output.rpt';
%       scales = 'fully_reversed_loading.dat';
%
%   Examine the contents of fully_reversed_loading.dat:
%
%       dlmread('fully_reversed_loading.dat')
%
%       ans = 
%
%           1
%           -1
%
%       In this example, the stresses from shaft_field_output.rpt go
%       through one reversal.
%
%       [Sxx, Syy, Szz, Txy, Tyz, Txz] = scalecombine(channels, scales);
%
%   MATLAB returns the six tensor components each with size 5000x2 because
%   the model has 5000 nodes and the load history contains two steps.
%
%   Example: Create a nodal listing of the shear stresses for a shaft in
%   pure tension and fully-reversed mixed tension-torsion.
%
%       channels = {'shaft_field_output_tension.rpt',...
%           'shaft_field_output_tension_torsion.rpt'};
%       scales = {'pure_tension_loading.dat',...
%          'tension_torsion_loading.dat'};
%
%   Examine the contents of pure_tension_loading.dat:
%
%       dlmread('pure_tension_loading.dat')
%
%       ans = 
%
%           1
%           0.1
%           1.3
%           0.3
%
%   Examine the contents of tension_torsion_loading.dat:
%
%       dlmread('tension_torsion_loading.dat')
%
%       ans = 
%
%           2
%           -2
%           1
%           -1
%
%       In this example, the first loading represents the pure tension
%       case, while the second represents fully-reversed loading.
%
%       [~, ~, ~, Txy, Tyz, Txz] = scalecombine(channels, scales);
%
%   Replace the terms Sxx, Syy and Szz with ~ since only the shear stress
%   is required.
%
%   See also getRPT

%   Copyright Louis Vallance, Safe Technology Limited
%   Last modified 19-Jun-2014 18:42:16

%% Make sure there are the same number of channels as scales:

error = false;
if length(channels) ~= length(scales)
    Sxx = 0; Syy = 0; Szz = 0; Txy = 0; Tyz = 0; Txz = 0;
    return
end

try
    %% Load files from listbox:
    
    j1 = 1; first_time = 1;
    
    for i = 1:length(channels)
        [channel, ~] = getRPT(channels{i});
        if isempty(channel)
            Sxx = 0; Syy = 0; Szz = 0; Txy = 0; Tyz = 0; Txz = 0;
            return
        end
        
        scale = dlmread(scales{i});
        
        %% Make sure channel/loading files are correctly defined:
        
        [~,col] = size(channel);
        skip = col - 6;
        if col<6
            error = true;
        end
        
        [~,col] = size(scale);
        if col ~= 1
            error = true;
        end
        
        if error
            Sxx = 0; Syy = 0; Szz = 0; Txy = 0; Tyz = 0; Txz = 0;
            return
        end
        
        %% Scale channel:
        if first_time
            [Lc, ~] = size(channel);
            Ls = length(scale);
            scaled_channels = zeros(Ls,6,Lc*length(channels));
            first_time = 0;
        end
        
        for j = 1:Lc % Loop over each node
            for k = 1:6 % Loop over tensor components
                scaled_channels(:,k,j1) = channel(j,k+skip)*scale;
            end
            
            j1 = j1+1;
            
        end
    end
    
    %% Combine the scaled channels:
    
    a = 1;  b = Lc - 1;
    combined_channel = zeros(Ls,6,Lc);
    
    for i = 1:Lc
        
        for j = a:Lc:(length(channels)*Lc) - b
            combined_channel(:,:,i) = combined_channel(:,:,i)+...
                scaled_channels(:,:,j);
        end
        
        a = a + 1;
        b = b - 1;
        
    end
    
catch
    
    Sxx = 0; Syy = 0; Szz = 0; Txy = 0; Tyz = 0; Txz = 0;
    return
    
end

%% Assign the combined stresses to their individual components:

Sxx(:,:) = combined_channel(:,1,:);
Syy(:,:) = combined_channel(:,2,:);
Szz(:,:) = combined_channel(:,3,:);
Txy(:,:) = combined_channel(:,4,:);
Tyz(:,:) = combined_channel(:,5,:);
Txz(:,:) = combined_channel(:,6,:);

Sxx = Sxx';
Syy = Syy';
Szz = Szz';
Txy = Txy';
Tyz = Tyz';
Txz = Txz';
end