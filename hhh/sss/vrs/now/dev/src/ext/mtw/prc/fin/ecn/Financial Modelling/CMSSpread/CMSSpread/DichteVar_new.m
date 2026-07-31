% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau and Sven Glaser
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.


function y = DichteVar_new(v,T,kappa,xi,V )
% calculates the density for the integrated variance
% as described in Chapter 4

% the following is hard coded but can be made an input argument
    eps = 1e-06;        % stopping the Newton search level 
    maxiter = 20;       % max iterations for Newton search
    eps1 = 1e-10;       % used for approx the derivative
    
    b = .125*ones(size(v,2),1)/pi;  % starting values
    b(1) = 0;
    x = v(1,:)';
    a = 1./x;
    a(isnan(a))=100000; % for nan we use a very high value
    
    % Zero search starts here assumes x is monotone increasing
    N = length(x(x<10));
    for k = 2:N % case x=0 does not have a zero
        h = @(u) x(k)*u+imag(eta(u*1i,kappa,xi,T,V))-.5*pi;
        b(k) = fzero(h,[0,10^16]);
    end
    
    N = N+1;
    h = @(u) x(N:end).*u+imag(eta(u*1i,kappa,xi,T,V))-.5*pi;
    bn = b(N:end);
    hbn = h(b(N:end));
    for i =1:maxiter     
        bn = bn - hbn * eps1 ./ (h(bn+eps1)-hbn);
        hbn = h(bn);
        if min(abs(hbn)) < eps
            break;
        end
    end
    b(N:end) = bn;
    
    % Gauss Legendre Integration
    lowerBound = 1e-6; upperBound = 1; NumberPoints = 64;
    [points, weights] = GaussLegInput(lowerBound,upperBound,NumberPoints);
    
    % time can be reduced by supplying the points and weights as arrays!
    %points = [0.000348478784634732;0.00183093978408078;0.00449430976831355; ...
    % 0.00833286472581390;0.0133375727684584;0.0194965806783723;0.0267952857764858; ...
    % 0.0352163787186162;0.0447398867218171;0.0553432216601659;0.0670012339226526; ...
    % 0.0796862721883579;0.0933682490712587;0.108014712514509;0.123590922779688; ...
    % 0.140059934855120;0.157382686091040;0.175518088855407;0.194423127991481; ...
    % 0.214052962846506;0.234361033629785;0.255299171848046;0.276817714556277; ...
    % 0.298865622153083;0.321390599441245;0.344339219666330;0.367657051239197; ...
    % 0.391288786841818;0.415178374610214;0.439269151083349;0.463503975602661; ...
    % 0.487825365843434;0.512175634156566;0.536497024397339;0.560731848916651; ...
    % 0.584822625389786;0.608712213158182;0.632343948760803;0.655661780333670; ...
    % 0.678610400558755;0.701135377846917;0.723183285443723;0.744701828151954; ...
    % 0.765639966370215;0.785948037153494;0.805577872008519;0.824482911144593; ...
    % 0.842618313908960;0.859941065144880;0.876410077220312;0.891986287485491; ...
    % 0.906632750928741;0.920314727811642;0.932999766077347;0.944657778339834; ...
    % 0.955261113278183;0.964784621281384;0.973205714223514;0.980504419321628; ...
    % 0.986663427231542;0.991668135274186;0.995506690231686;0.998170060215919; ...
    % 0.999652521215365];
    %weights = [0.000891638926660465;0.00207351455478027;0.00325222573217419; ...
    % 0.00442337548979251;0.00558406414599411;0.00673151382945151;0.00786300537325880; ...
    % 0.00897584765852548;0.0100674006911429;0.0111350752185869;0.0121763387293225; ...
    % 0.0131887214041500;0.0141698219503289;0.0151173132859006;0.0160289480536029; ...
    % 0.0169025639483423;0.0177360888442634;0.0185275457086281;0.0192750572905305; ...
    % 0.0199768505731648;0.0206312609789921;0.0212367363177815;0.0217918404681320; ...
    % 0.0222952567837242;0.0227457912162115;0.0231423751473367;0.0234840679235524; ...
    % 0.0237700590871298;0.0239996702984620;0.0241723569450016;0.0242877094330156; ...
    % 0.0243454541590913;0.0243454541590913;0.0242877094330156;0.0241723569450016; ...
    % 0.0239996702984620;0.0237700590871298;0.0234840679235524;0.0231423751473367; ...
    % 0.0227457912162115;0.0222952567837242;0.0217918404681320;0.0212367363177815; ...
    % 0.0206312609789921;0.0199768505731648;0.0192750572905305;0.0185275457086281; ...
    % 0.0177360888442634;0.0169025639483423;0.0160289480536029;0.0151173132859006; ...
    % 0.0141698219503289;0.0131887214041500;0.0121763387293225;0.0111350752185869; ...
    % 0.0100674006911429;0.00897584765852548;0.00786300537325880;0.00673151382945151; ...
    % 0.00558406414599411;0.00442337548979251;0.00325222573217419;0.00207351455478027; ...
    % 0.000891638926660465];
      
    mat_a = repmat(a,1,NumberPoints);
    mat_b = repmat(b,1,NumberPoints);
    mat_x = repmat(x,1,NumberPoints);
    
    points_mat = repmat(points',length(x),1);
    weights_mat = repmat(weights',length(x),1);
    
    arg1 = mat_a-3*log(points_mat).*(mat_b*1i-mat_a);
    
    integral_val = sum(weights_mat.*imag(exp(mat_x.*arg1) ...
        .* exp(eta(arg1,kappa,xi,T,V)).*(3./points_mat).*(mat_b*1i-mat_a)),2);
    
    y = repmat(max(integral_val,0)',size(v,1),1)/pi;
        
end


