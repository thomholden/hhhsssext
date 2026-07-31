% programArgs Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "util.h"
#include "programargs.h"
% class ProgramArgs
%}

classdef programArgs
    % C++ Code
    %{
      private:
    	   int m_argc;
    	   char** m_argv;
    %}
    properties
        m_argc=0;  % Number of arguments
        m_argv=''; % Cell array of parameters
    end
    methods
        % C++ Code
        %{
        ProgramArgs::ProgramArgs(int argc,
                                 char* argv[])
        {
            _ASSERTE(argc > 0);
            _ASSERTE(argv != null);
            m_argc = argc;
            m_argv = argv;
        }
        %}

        function obj=programArgs(argc, argv)
            %assert(argc>0); % Skipped to allow no parameters
            %assert(~isempty(argv));
            obj.m_argc = argc;
            obj.m_argv = argv;
        end

        % C++ Code
        %{
        ProgramArgs::~ProgramArgs() {

        }
        % Destructor not necessary

        int ProgramArgs::count() {
            return m_argc;
        }
        %}
        function out=count(obj)
            out=obj.m_argc ;
        end

        function out=programName(obj) %#ok
            % C++ Code
            %{
            const char* ProgramArgs::programName() {
                return m_argv[0];
            }
            %}

            % Only equivalent in MATLAB if the application called from
            % command line

            stack=dbstack;
            out= stack(end).name; % Get name of first function called
        end

        function out=findOption(obj, option)
            % C++ Code
            %{
            bool ProgramArgs::findOption(const char* option) {
                for (int i=0; i<m_argc; ++i) {
                    if (strcmp(option, m_argv[i]) == 0) {
                        return true;
                    }
                } return false;
            }
            %}

            % Returns true if option found
            for ii= 1: obj.m_argc
                if strcmp(option, obj.m_argv{ii})
                    out=true;
                    return
                end
            end
            out=false;
        end

        % C++ Code
        %{
        // Return the parameter for a given option as a string
        const char*
        ProgramArgs::getParameter(const char* option,
                                  const char* sdef) {
            for (int i=0; i<m_argc; ++i) {
                if (strcmp(option, m_argv[i]) == 0) {
                    if (i < (m_argc-1)) {
                        return m_argv[i+1];
                    }
                }
            }
            return sdef;
        }
        %}
        function out=getParameter(obj,option, sdef)
            % Returns value of option or default
            for ii= 1: obj.m_argc
                if strcmp(option, obj.m_argv{ii})
                    if ii < obj.m_argc
                        out=obj.m_argv{ii+1};
                        return
                    end
                end
            end
            out=sdef;
        end


        function out=getIntParameter(obj,option, idef)
            % C++ Code
            %{
            // Return the parameter for a given option as an integer
            int
            ProgramArgs::getIntParameter(const char* option,
                                         int idef)
            {
                const char* param = getParameter(option, null);
                return ((param != null) ? atoi(param) : idef);
            }
            \\Returns value of option as integer (double) or default
            %}
            param=getParameter(obj,option,'');
            if strcmp(param,'');
                out=idef;
            else
                out=str2double(param); % No need to force integer
            end
        end

        function out=getDoubleParameter(obj,option,ddef)
            % C++ Code
            %{
            // Return the parameter for a given option as a double
            double
            ProgramArgs::getDoubleParameter(const char* option,
                                            double ddef) {
                const char* param = getParameter(option, null);
                return ((param != null) ? atof(param) : ddef);
            }
            %}
            param=getParameter(obj,option,'');
            if strcmp(param,'');
                out=ddef;
            else
                out=str2double(param); % No need to force integer
            end
        end
    end
end