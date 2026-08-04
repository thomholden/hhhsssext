function [Power,frequencies]=ar_spec(coefficient,N,sampling_f,p0,range)
%  [Power,frequencies] =ar_spec(coefficient,N,sampling_f,p0,range)
%
% descr.: calculates the spectral component at N discrete frequencies 
%         between -sampling_f/2 and + sampling_f/2
  
  if nargin<5 | isempty(range)
    range=[];
  end
  
  if nargin<4 | isempty(p0)
    p0=1;
  else
    p0=real(p0);
  end
  
  if nargin<3 | isempty(sampling_f)
    sampling_f=1;
  end
  
  if nargin<2  | isempty(N)
    N=128;
    range=[1,N];
  elseif isempty(range)
    range=[1,N];
  end

  if nargin<1
    error('Coefficients required.');
  end
  
  coefficient=coefficient(:);
  model_order=size(coefficient,1);
  if (coefficient(1)~=1) 
    coefficient=[1; coefficient];
  end;
  Ts=1/sampling_f; 
  frequencies=(0:N-1)/N;
  frequencies=frequencies(range(1):range(2));
  frequencies=frequencies(:);
  frequencies=frequencies*sampling_f;
  no_of_frequencies=size(frequencies,1);

% loop for all values of discrete frequencies

  for counter=1:no_of_frequencies, 

     exp_vect=exp(-i*2*pi*(0:1:model_order)*Ts*frequencies(counter));
     denom=exp_vect*coefficient;
     Power(counter)=Ts*p0/(real(denom)^2+imag(denom)^2);
  end;
Power=Power';
