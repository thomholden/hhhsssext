% FELICITY Class for storing time-series, or indexed, simulation data and re-loading it.
%
%   obj         = FEL_SaveLoad(Data_Dir,File_Prefix);
%
%   Data_Dir    = string representing directory in which to store the simulation data.
%   File_Prefix = string representing file name prefix to use when storing indexed
%                 simulation data.
%
%   obj         = FEL_SaveLoad(Data_Dir,File_Prefix,Num_Pad_Zeros_File_Index);
%
%   Num_Pad_Zeros_File_Index = number of zeros to pad in the index of the filename when
%                              storing simulation data. (Default = 6)
classdef FEL_SaveLoad
    properties %(SetAccess='private',GetAccess='private')
        Data_Dir    % string for dir to store and read simulation data
        File_Prefix % file name prefix to use when storing simulation data
        Num_Pad_Zeros_File_Index
    end
    methods
        function obj = FEL_SaveLoad(varargin)
            
            if or(nargin < 2,nargin > 3)
                disp('Requires 2 or 3 arguments!');
                disp('First  is a directory for storing data.');
                disp('Second is a file prefix to use in naming the storage files.');
                disp('Third  is the number of zeros to pad in the storage filename index.');
                error('Check the arguments.');
            end
            
            obj.Data_Dir    = varargin{1};
            obj.File_Prefix = varargin{2};
            if (nargin==3)
                obj.Num_Pad_Zeros_File_Index = varargin{3};
            else
                obj.Num_Pad_Zeros_File_Index = 6;
            end
            if or(obj.Num_Pad_Zeros_File_Index < 0, obj.Num_Pad_Zeros_File_Index > 20)
                error('Invalid zero pad length!');
            end

            % check that it is a valid directory
            if ~(exist(obj.Data_Dir,'dir')==7)
                error('Data_Dir is not a valid directory!');
            end
            
            % check that prefix is a string
            if ~ischar(obj.File_Prefix)
                error('File_Prefix must be a string!');
            end
            % make sure first character is NOT a number
            m = regexp(obj.File_Prefix(1), '\d', 'match');
            if ~isempty(m)
                error('First character in the prefix cannot be a number!');
            end
        end
    end
end

% END %