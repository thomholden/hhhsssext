% random Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
%class Random {
%}
classdef random
    methods
        function obj=random(varargin)
            % C++ Code
            %{
            Random(int iseed=-1);
            // Construct Random object
            Random::Random(int iseed) {
                if (iseed >= 0) {
                    seed((unsigned int)iseed);
                }
            }
            %}
            iseed=getArg(1,varargin,-1);
            if iseed >= 0
                random.seed(iseed);
            end
        end
    end
    methods (Static)
        function seed(uiseed)
            % C++ Code
            %{
            // Set the seed for random number generation
            //static
            void
            Random::seed(unsigned int uiseed) {
                srand(uiseed);
            }
            %}
            rand('seed',uiseed); % Initialize seed
        end
        function out=drand(varargin)
            % C++ Code
            %{
            static double drand(double scale=1.0);
            // Use rand to return a double in [0.0, scale]
            //static
            double
            Random::drand(double scale) {
                return scale * rand0_1();
            }
            %}
            scale=getArg(1,varargin,1);
            out=scale * rand0_1;
        end
        function out=irand(varargin)
            % C++ Code
            %{
             static int irand(int scale=1);
            // Use rand() to return an integer in [0, scale]
            //static
            int
            Random::irand(int scale) {
                double dval = drand((double)scale);
             if (dval >= 0.0) { return int(floor(dval + 0.5)); }
            else             { return int(ceil(dval - 0.5)); }
            }
            %}
            scale=getArg(1,varargin,1);
            dval = random.drand(scale);

            if dval >= 0.0
                out= floor(dval + 0.5); % Leave as double
            else
                out= ceil(dval - 0.5);
            end
        end
    end
end

% C++ Code
%{
// Store RAND_MAX as a double
static const double dRAND_MAX = (double)RAND_MAX;
Not necessary
%}

function out=rand0_1
% C++ Code
%{
// Return a random number in [0.0,1.0] as generated
// by rand()
static inline double rand0_1() {
    return ((double)rand())/dRAND_MAX;
}
%}
out=rand;

end
