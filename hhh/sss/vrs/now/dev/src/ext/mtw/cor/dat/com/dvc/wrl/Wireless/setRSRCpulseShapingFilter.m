function rsrc=setRSRCpulseShapingFilter(rsrc, rollOff)
% Used to set filter coefficients for RSRC pulse-shaping
% filter in 11 Mb/s transmitter and receiver.
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
static
void
setRSRCpulseShapingFilter(FIRFilter& rsrc,
                          double rollOff) {

    double a = rollOff; // raised cosine filter roll-off factor
    double hr = 0.0;    // real-valued raised cosine filter coefficient
    double mid = ((double)rsrc.size()-1.0)/2.0;
    static const double sqrt2 = sqrt(2.0);
%}
a = rollOff; % raised cosine filter roll-off factor
mid = (size(rsrc)-1.0)/2.0;
sqrt2 = sqrt(2.0);

% Get constants for use later
PI=constants.PI;
Ns=constants.Ns;

% C++ Code
%{
for (int i = 0; i < rsrc.size(); i++) {
%}
for ii=1:size(rsrc)

    % C++ Code
    %{
            double temp = 11.0*((double)i - mid)/Ns;
            double at = a*temp;
            double pt = PI*temp;
    %}
    temp = 11.0*((ii-1) - mid)/Ns;
    at = a*temp;
    pt =PI*temp;

    % C++ Code
    %{
            if ((temp != 0.0) && ((1.0-16.0*at*at) != 0.0)) {
    	         hr = (sin((1.0-a)*pt) + 4.0*at*cos((1.0+a)*pt))/(pt * (1.0-16.0*at*at));
            } else if (temp == 0.0) {
    	         hr = 1-a+4*a/PI;
            } else { //if((1-16*temp*temp*a*a) == 0.0)
    	         hr = (a/sqrt2)*((1+2.0/PI)*sin(PI/(4*a))+(1-2.0/PI)*cos(PI/(4*a)));
            }
            rsrc[i] = Sample(hr,0.0);
        }
    }
    %}
    if ((temp ~= 0.0) && ((1.0-16.0*at*at) ~= 0.0))
        hr = (sin((1.0-a)*pt) + 4.0*at*cos((1.0+a)*pt))/(pt * (1.0-16.0*at*at));
    elseif (temp == 0.0)
        hr = 1-a+4*a/PI;
    else
        hr = (a/sqrt2)*((1+2.0/PI)*sin(pi/(4*a))+(1-2.0/pi)*cos(PI/(4*a)));
    end
    rsrc(ii) = hr;
end