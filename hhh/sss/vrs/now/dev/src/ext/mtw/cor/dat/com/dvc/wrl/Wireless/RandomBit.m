% RandomBit CLass
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
class RandomBit {
%}
classdef RandomBit < handle
    properties (Constant=true, GetAccess='private')
        % C++ Code
        %{
        enum {IB3=4, IB20=524288 };
        %}
        IB3=uint32(4);
        IB20=uint32(524288);
    end
    properties (GetAccess='private', SetAccess='private')
        % C++ Code
        %{
        private:
         // Shift register
         unsigned m_seed;
          };
        %}
        m_seed=uint32(0);
    end
    methods
        function hObj=RandomBit()
            % C++ Code
            %{
            // ..Initialize seed before first call of RandomBit::nextBit()
            RandomBit::RandomBit() {
                m_seed = 0x80000;
            }
            %}
            hObj.m_seed = uint32(hex2dec('80000'));
        end
        % C++ Code
        %{
        //virtual
        RandomBit::~RandomBit() {
        }
        Not necesssary
        %}

        function bit=nextBit(hObj)
            % C++ Code
            %{
            // Generate the next random bit
            bool
            RandomBit::nextBit() {
            unsigned int newbit = ((m_seed & IB20) >> 19) ^ ((m_seed & IB3) >> 2);
            m_seed = (m_seed << 1) | newbit;
            bitxor==^
            bitshift == <<
                return (newbit > 0);
            	//return false;
            }
            %}
            newbit = bitxor( bitshift(bitand(hObj.m_seed, hObj.IB20), -19) , bitshift(bitand(hObj.m_seed, hObj.IB3), -2));
            hObj.m_seed = bitor(bitshift(hObj.m_seed, 1), newbit);
            bit=newbit>0;
        end
        function bits=nextNBits(hObj,N)
            % C++ Code
            %{
            // Generate the next N random bits
            Bits
            RandomBit::nextNBits(int N) {
            Bits bits(N);
            for (int i=0; i<N; ++i) {
                bits[i] = nextBit();
            }
            return bits;
            }
            %}
            bits=zeros(N,1);

            for ii = 1:N
                newbit = bitxor( bitshift(bitand(hObj.m_seed, hObj.IB20), -19) , bitshift(bitand(hObj.m_seed, hObj.IB3), -2));
                hObj.m_seed = bitor(bitshift(hObj.m_seed, 1), newbit);
                bits(ii)=newbit>0;
            end
        end
    end
    methods (Static)
        function bits=fillWith01(N)
            % C++ Code
            %{
            // Fill the bits with consecutive 0 and 1
            // for test purpose
            Bits
            RandomBit::fillWith01(int N) {
            Bits bits(N,false);
            for(int i=0; i<N; i+=2)
            bits[i] = true;

             return bits;
            }
            %}
            bits=zeros(N,1);
            bits(1:2:end)=1;
        end
    end
end