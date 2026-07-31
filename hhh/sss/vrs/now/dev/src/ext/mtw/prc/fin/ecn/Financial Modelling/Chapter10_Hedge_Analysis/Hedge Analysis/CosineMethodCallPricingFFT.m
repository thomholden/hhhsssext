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
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [call_price_fft, call_delta_fft,call_gamma_fft] = CosineMethodCallPricingFFT(N,L,model,S,K,T,r,d)
    
    % this function calculates prices of european put options via a fourier cosine expansion
    % the call prices are derived via put/call parity
    
    M = length(K);
    
    x = log(S)-log(K);

    %cumulants
    [c1, c2, c4] = getCumulants(T,r,d,model);
    
    % truncation range
    a = c1 - L*sqrt(abs(c2) + sqrt(abs(c4)));
    b = 2*c1 - a;

    
    k = (0:N-1)';
    tmp = k*pi/(b-a);


    [chi, psi] = cosine_coeff_Vanilla(a,0,a,b,tmp);
    
    % price coefficient
    U_k = -2 * (chi - psi) / (b-a);

    mat1 = repmat(tmp',M,1);%(tmp*ones(1,M))';
    mat2 = repmat(x-a,1,N);%((x-a)*ones(1,N(i)));
    mat = exp(1i * (mat1.*mat2));
    mat(:,1) = 0.5*mat(:,1);

    mat_tmp = 1i*mat1;

    phi = exp(feval(@CharacteristicFunctionLib, model,tmp,T,r,d,model.params));
    
    call_price_fft = exp(-r*T)*K.*(real(mat * (phi.*U_k))-1) + S*exp(-d*T);
    call_delta_fft = exp(-r*T)*K.*real((mat.*mat_tmp) * (phi.*U_k))/S + exp(-d*T);
    call_gamma_fft = exp(-r*T)*K.*real((mat.*(mat_tmp.*(mat_tmp-1))) * (phi.*U_k))/S^2;
    
%     lb = 0.1e-30;
%     if call_price_fft < 0
%         call_price_fft = lb;
%     end
%     if call_delta_fft < 0
%         call_delta_fft = lb;
%     end
%     if call_delta_fft > 1
%         call_delta_fft = 1;
%     end
%     if call_gamma_fft < 0
%         call_gamma_fft = lb;
%     end

    
end


function [c1, c2, c4] = getCumulants(T,r,d,model)

    if strcmp(model.ID,'BlackScholes')
        BS_sigma = model.params(1);
        c1 = (r-d-0.5*BS_sigma^2)*T;
        c2 = BS_sigma^2*T;
        c4 = 0.0;
    elseif strcmp(model.ID,'Heston')
        vInst = model.params(1); vLong = model.params(2); kappa = model.params(3);
        omega = model.params(4); rho = model.params(5);
        c1 = (r-d)*T + 0.5*((1-exp(-kappa*T))*(vLong-vInst)/kappa - vLong*T);
        c2 = 1/8/kappa^2*(omega*T*exp(-kappa*T)*(vInst-vLong)*(8*kappa*rho-4*omega)...
                        +8*rho*omega*(1-exp(-kappa*T))*(2*vLong-vInst)...
                        +2*vLong*T*(-4*kappa*rho*omega + omega^2 + 4*kappa^2)...
                        +omega^2/kappa*((vLong-2*vInst)*exp(-2*kappa*T)+vLong*(6*exp(-kappa*T)-7)+2*vInst)...
                        +8*kappa*(vInst-vLong)*(1-exp(-kappa*T)));
        c4 = 0.0;
    elseif strcmp(model.ID,'VarianceGamma')
        VG_sigma = model.params(1); VG_nu = model.params(2); VG_theta = model.params(3);
        omega = 1/VG_nu * log(1 - VG_theta * VG_nu - 0.5 * VG_nu * VG_sigma^2);
        
        c1 = (r-d+omega+VG_theta)*T;
        c2 = (VG_sigma^2+VG_nu*VG_theta^2)*T;
        c4 = 3*(VG_sigma^4*VG_nu+2*VG_theta^4*VG_nu^3+4*VG_sigma^2*VG_theta^2*VG_nu^2)*T;
    elseif strcmp(model.ID,'CGMY')
        CGMY_C = model.params(1); CGMY_G = model.params(2); CGMY_M = model.params(3); CGMY_Y = model.params(4);
        c1 = (r-d)*T + CGMY_C*T*gamma(1-CGMY_Y)*(CGMY_M^(CGMY_Y-1)-CGMY_G^(CGMY_Y-1));
        c2 = CGMY_C*T*gamma(2-CGMY_Y)*(CGMY_M^(CGMY_Y-2)+CGMY_G^(CGMY_Y-2));
        c4 = CGMY_C*T*gamma(4-CGMY_Y)*(CGMY_M^(CGMY_Y-4)+CGMY_G^(CGMY_Y-4));
    elseif strcmp(model.ID,'NIG')    
        alphaNIG = model.params(1); betaNIG = model.params(2); deltaNIG = model.params(3);     
        mu = r - d;
        c1 = ((betaNIG*deltaNIG)/(sqrt(alphaNIG^2 - betaNIG^2)) + mu) * T;
        c2 = T * alphaNIG^2 * deltaNIG / ((alphaNIG^2 - betaNIG^2)^(3/2));
        c4 = 3 * T * alphaNIG^2 * (alphaNIG^2 + 4*betaNIG^2) * deltaNIG / ((alphaNIG^2 - betaNIG^2)^(7/2));
    elseif strcmp(model.ID,'Bates')    
        vInst = model.params(1); vLong = model.params(2); kappa = model.params(3);
        omega = model.params(4); rho = model.params(5); lambda = model.params(6);
        muj = model.params(7); sigmaj = model.params(8);
        c1 = (r-d).*T + 0.5*((1-exp(-kappa*T))*(vLong-vInst)/kappa - vLong*T) + lambda*muj*T;
        c2 = 1/8/kappa^2*(omega*T.*exp(-kappa*T)*(vInst-vLong)*(8*kappa*rho-4*omega)...
             +8*rho*omega*(1-exp(-kappa*T))*(2*vLong-vInst)...
             +2*vLong*T*(-4*kappa*rho*omega + omega^2 + 4*kappa^2)...
             +omega^2/kappa*((vLong-2*vInst)*exp(-2*kappa*T)...
             +vLong*(6*exp(-kappa*T)-7)+2*vInst)...
             +8*kappa*(vInst-vLong)*(1-exp(-kappa*T))) + lambda*(sigmaj^2+muj^2)*T;
        c4 = 0.0 + lambda * (3*sigmaj^2*(sigmaj^2+2*muj^2)+muj^4).*T;
    
    end

end


function [chi, psi] = cosine_coeff_Vanilla(c,d,a,b,tmp)

    %tmp = k*pi/(b-a);
    x1 = (d-a)*tmp;
    x2 = (c-a)*tmp;

    exp_c = exp(c);
    exp_d = exp(d);


    chi = ( cos(x1)*exp_d - cos(x2)*exp_c + tmp.*(sin(x1)*exp_d-sin(x2)*exp_c) ) ./ ( 1 + tmp.^2 );

    
    psi = (sin(x1)-sin(x2)) ./ tmp;
    psi(1) = d-c;
    
end

