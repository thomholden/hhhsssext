classdef (ConstructOnLoad) brrmm %#ok<*MCSUP,*PROP>
%BRRMM    Bayesian robust regression mixture model
%   
%   BRRMM constructs an instance of the Bayesian robust regression mixture
%   model class with a given number of inputs, outputs, non-linear effects
%   and mixture components.
%   
%   Usage: OBJ = BRRMM(NIN,NOUT,NEFF,NCOMP)
%   
%   Inputs:  NIN   - Number of inputs
%            NOUT  - Number of outputs
%            NEFF  - Number of non-linear effects
%            NCOMP - Number of mixture components
%   
%   Outputs: OBJ    - Bayesian robust regression mixture model object
%   
%   NIN and NOUT are the number of inputs and outputs, i.e. the dimensions
%   of the input-output data. NEFF is the number of non-linear effects and
%   NCOMP the number of mixture components in the model. All inputs must be
%   positive integer scalars.
%   
%   OBJ is an object of class BRRMM.
%   
%   The BRRMM class implements algorithms for simulating and estimating the
%   parameters of a finite mixture model. Mixture models are typically used
%   in cluster analysis, i.e. grouping data into categories, each category
%   represented as a mixture component. The BRRMM is especially designed
%   for input-output data containing outliers and/or missing values.
%   
%   A BRRMM object models each component as a heavy-tailed distribution
%   with component-specific parameters. Parameters are equipped with
%   conjugate prior distributions as per the Bayesian paradigm. The model
%   also contains hidden variables representing missing values in the data,
%   as well as the quality of the data. The posterior distributions over
%   both parameters parameters and hidden variables are estimated by an
%   approximate variational inference algorithm.
%   
%   See also BRRMM.SIM and BRRMM.ESTIM.
%   
%   Copyright (c) 2013-2014 Gabriel Agamennoni.
    
    % Model size.
    properties (SetAccess=private)
        nin
        nout
        neff
        ncomp
    end
    
    % Non-linear effects.
    properties
        fun
        eff
    end
    
    % Model hyper-parameters.
    properties (Dependent=true)
        prop
        stren
        gain
        scale
        noise
        shape
    end
    
    % Prior/posterior distributions.
    properties (Access=private)
        prior=struct(...
            'prop',[],...
            'stren',[],...
            'gain',[],...
            'scale',[],...
            'noise',[],...
            'shape',[])
        post=struct(...
            'prop',[],...
            'stren',[],...
            'gain',[],...
            'scale',[],...
            'noise',[],...
            'shape',[])
    end
    
    % Constructor.
    methods
        function obj=brrmm(nin,nout,neff,ncomp)
            if nargin()>0
                
                % Check number of arguments.
                if nargin()<4
                    error('BRRMM:NotEnoughInputs',...
                        'Not enough inputs.')
                end
                if nargin()>4
                    error('BRRMM:TooManyInputs',...
                        'Too many inputs.')
                end
                if nargout()>1
                    error('BRRMM:TooManyOutputs',...
                        'Too many outputs.')
                end
                
                % Check inputs.
                checksize(nin,nout,neff,ncomp)
                
                % Set model size.
                obj.nin=nin;
                obj.nout=nout;
                obj.neff=neff;
                obj.ncomp=ncomp;
                
                % Set default non-linear effects.
                obj.eff=zeros(neff,ncomp);
                
                % Set default prior distributions over parameters.
                obj.prior.prop=repval(1/ncomp,1,ncomp);
                obj.prior.stren=ones();
                obj.prior.gain=zeros(nout,nin,ncomp);
                obj.prior.scale=repval(eye(nin),3,ncomp);
                obj.prior.noise=repval(eye(nout),3,ncomp);
                obj.prior.shape=repval(nout,1,ncomp);
                
                % Set default posterior distributions over parameters.
                obj.post=obj.prior;
                
            end
        end
    end
    
    % Access methods.
    methods
        function prop=get.prop(obj)
            prop=obj.post.prop;
        end
        function stren=get.stren(obj)
            stren=obj.post.stren;
        end
        function gain=get.gain(obj)
            gain=obj.post.gain;
        end
        function scale=get.scale(obj)
            scale=obj.post.scale;
        end
        function noise=get.noise(obj)
            noise=obj.post.noise;
        end
        function shape=get.shape(obj)
            shape=obj.post.shape;
        end
    end
    methods
        function obj=set.fun(obj,fun)
            checkfun(obj,fun)
            obj.fun=fun;
        end
        function obj=set.eff(obj,eff)
            checkeff(obj,eff)
            obj.eff=eff;
        end
    end
    methods
        function obj=set.prop(obj,prop)
            checkprop(obj,prop)
            obj.prior.prop=prop;
        end
        function obj=set.stren(obj,stren)
            checkstren(obj,stren)
            obj.prior.stren=stren;
        end
        function obj=set.gain(obj,gain)
            checkgain(obj,gain)
            obj.prior.gain=gain;
        end
        function obj=set.scale(obj,scale)
            checkscale(obj,scale)
            obj.prior.scale=scale;
        end
        function obj=set.noise(obj,noise)
            checknoise(obj,noise)
            obj.prior.noise=noise;
        end
        function obj=set.shape(obj,shape)
            checkshape(obj,shape)
            obj.prior.shape=shape;
        end
    end
    
    % Simulation/estimation methods.
    methods
        [comp,weight,out]=sim(obj,in,varargin)
        [obj,bound,comp,weight]=estim(obj,in,out,varargin)
    end
    
end



function checksize(nin,nout,neff,ncomp)

% Initialize argument counter.
arg=0;

% Check number of inputs.
arg=arg+1;
if ~isnumeric(nin)
    error('BRRMM:BadInputClass',...
        'Input %d must be numeric.',arg)
end
if ~isreal(nin)
    error('BRRMM:BadInputClass',...
        'Input %d must be real.',arg)
end
if isempty(nin)
    error('BRRMM:BadInputSize',...
        'Input %d must be non-empty.',arg)
end
if ndims(nin)>2||numel(nin)>1
    error('BRRMM:BadInputSize',...
        'Input %d must be a scalar.',arg)
end
if isnan(nin)||isinf(nin)
    error('BRRMM:BadInputValue',...
        'Input %d must contain a finite number.',arg)
end
if round(nin)~=nin||nin<=0
    error('BRRMM:BadInputValue',...
        'Input %d must contain a positive integer.',arg)
end

% Check number of outputs.
arg=arg+1;
if ~isnumeric(nout)
    error('BRRMM:BadInputClass',...
        'Input %d must be numeric.',arg)
end
if ~isreal(nout)
    error('BRRMM:BadInputClass',...
        'Input %d must be real.',arg)
end
if isempty(nout)
    error('BRRMM:BadInputSize',...
        'Input %d must be non-empty.',arg)
end
if ndims(nout)>2||numel(nout)>1
    error('BRRMM:BadInputSize',...
        'Input %d must be a scalar.',arg)
end
if isnan(nout)||isinf(nout)
    error('BRRMM:BadInputValue',...
        'Input %d must contain a finite number.',arg)
end
if round(nout)~=nout||nout<=0
    error('BRRMM:BadInputValue',...
        'Input %d must contain a positive integer.',arg)
end

% Check number of non-linear effects.
arg=arg+1;
if ~isnumeric(neff)
    error('BRRMM:BadInputClass',...
        'Input %d must be numeric.',arg)
end
if ~isreal(neff)
    error('BRRMM:BadInputClass',...
        'Input %d must be real.',arg)
end
if isempty(neff)
    error('BRRMM:BadInputSize',...
        'Input %d must be non-empty.',arg)
end
if ndims(neff)>2||numel(neff)>1
    error('BRRMM:BadInputSize',...
        'Input %d must be a scalar.',arg)
end
if isnan(neff)||isinf(neff)
    error('BRRMM:BadInputValue',...
        'Input %d must contain a finite number.',arg)
end
if round(neff)~=neff||neff<0
    error('BRRMM:BadInputValue',...
        'Input %d must contain a non-negative integer.',arg)
end

% Check number of components.
arg=arg+1;
if ~isnumeric(ncomp)
    error('BRRMM:BadInputClass',...
        'Input %d must be numeric.',arg)
end
if ~isreal(ncomp)
    error('BRRMM:BadInputClass',...
        'Input %d must be real.',arg)
end
if isempty(ncomp)
    error('BRRMM:BadInputSize',...
        'Input %d must be non-empty.',arg)
end
if ndims(ncomp)>2||numel(ncomp)>1
    error('BRRMM:BadInputSize',...
        'Input %d must be a scalar.',arg)
end
if isnan(ncomp)||isinf(ncomp)
    error('BRRMM:BadInputValue',...
        'Input %d must contain a finite number.',arg)
end
if round(ncomp)~=ncomp||ncomp<=0
    error('BRRMM:BadInputValue',...
        'Input %d must contain a positive integer.',arg)
end

end



function checkfun(~,fun)

% Check non-linear function.
if isa(fun,'function_handle')
    if isempty(fun)
        error('BRRMM:BadInputSize',...
            'Input must be non-empty.')
    end
    if ndims(fun)>2||numel(fun)>1
        error('BRRMM:BadInputSize',...
            'Input must be a scalar.')
    end
else
    if ~ischar(fun)
        error('BRRMM:BadInputClass',...
            'Input must be a string.')
    end
    if isempty(fun)
        error('BRRMM:BadInputSize',...
            'Input must be non-empty.')
    end
    if ndims(fun)>2||size(fun,1)>1
        error('BRRMM:BadInputSize',...
            'Input must contain a string.')
    end
    if ~exist(fun,'file')
        error('BRRMM:BadInputValue',...
            'Input must contain a valid file name.')
    end
end
if any(nargin(fun)==0:1)
    error('BRRMM:BadInputSize',...
        'Input must accept at least %d input argument.',2)
end
if any(nargout(fun)==0:1)
    error('BRRMM:BadInputSize',...
        'Input must return at least %d output arguments.',2)
end

end



function checkeff(obj,eff)

% Store model size.
neff=obj.neff;
ncomp=obj.ncomp;

% Check non-linear effects.
if ~isnumeric(eff)
    error('BRMM:BadInputClass',...
        'Input argument must be numeric.')
end
if ~isreal(eff)
    error('BRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(eff)
    error('BRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(eff)>2
    error('BRMM:BadInputSize',...
        'Input must be a matrix.')
end
if size(eff,1)~=neff
    error('BRMM:BadInputSize',...
        'Input must have %d rows.',neff)
end
if size(eff,2)~=ncomp
    error('BRMM:BadInputSize',...
        'Input must have %d columns.',ncomp)
end
if any(isnan(eff(:))|isinf(eff(:)))
    error('BRMM:BadInputValue',...
        'Input must contain finite numbers.')
end

end



function checkprop(obj,prop)

% Store model size.
ncomp=obj.ncomp;

% Check proportion hyper-parameters.
if ~isnumeric(prop)
    error('BRRMM:BadInputClass',...
        'Input must be numeric.')
end
if ~isreal(prop)
    error('BRRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(prop)
    error('BRRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(prop)>2||min(size(prop))>1
    error('BRRMM:BadInputSize',...
        'Input must be a vector.')
end
if numel(prop)~=ncomp
    error('BRRMM:BadInputSize',...
        'Input must have %d elements.',ncomp)
end
if any(isnan(prop)|isinf(prop))
    error('BRRMM:BadInputValue',...
        'Input must contain finite numbers.')
end
if any(prop<=0)||abs(sum(prop)-1)>eps()*ncomp
    error('BRRMM:BadInputValue',...
        'Input must contain values on the unit simplex.')
end

end



function checkstren(~,stren)

% Check strength hyper-parameter.
if ~isnumeric(stren)
    error('BRRMM:BadInputClass',...
        'Input must be numeric.')
end
if ~isreal(stren)
    error('BRRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(stren)
    error('BRRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(stren)>2||numel(stren)>1
    error('BRRMM:BadInputSize',...
        'Input must be a scalar.')
end
if isnan(stren)||stren<=0
    error('BRRMM:BadInputValue',...
        'Input must contain a positive number.')
end

end



function checkgain(obj,gain)

% Store model size.
nin=obj.nin;
nout=obj.nout;
ncomp=obj.ncomp;

% Check gain hyper-parameters.
if ~isnumeric(gain)
    error('BRRMM:BadInputClass',...
        'Input argument must be numeric.')
end
if ~isreal(gain)
    error('BRRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(gain)
    error('BRRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(gain)>3
    error('BRRMM:BadInputSize',...
        'Input must be a %d-dimensional array.',3)
end
if size(gain,1)~=nout
    error('BRRMM:BadInputSize',...
        'Input must have %d rows.',nout)
end
if size(gain,2)~=nin
    error('BRRMM:BadInputSize',...
        'Input must have %d columns.',nin)
end
if size(gain,3)~=ncomp
    error('BRRMM:BadInputSize',...
        'Input must have %d pages.',ncomp)
end
if any(isnan(gain(:))|isinf(gain(:)))
    error('BRRMM:BadInputValue',...
        'Input must contain finite numbers.')
end

end



function checkscale(obj,scale)

% Store model size.
nin=obj.nin;
ncomp=obj.ncomp;

% Check scale hyper-parameters.
if ~isnumeric(scale)
    error('BRRMM:BadInputClass',...
        'Input must be numeric.')
end
if ~isreal(scale)
    error('BRRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(scale)
    error('BRRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(scale)>3
    error('BRRMM:BadInputSize',...
        'Input must be a %d-dimensional array.',3)
end
if size(scale,1)~=nin
    error('BRRMM:BadInputSize',...
        'Input must have %d rows.',nin)
end
if size(scale,2)~=nin
    error('BRRMM:BadInputSize',...
        'Input must have %d columns.',nin)
end
if size(scale,3)~=ncomp
    error('BRRMM:BadInputSize',...
        'Input must have %d pages.',ncomp)
end
if any(isnan(scale(:))|isinf(scale(:)))
    error('BRRMM:BadInputValue',...
        'Input must contain finite numbers.')
end
for i=1:ncomp
    asymm=abs(scale(:,:,i)-scale(:,:,i)');
    if any(asymm(:)>eps()*nin)
        error('BRRMM:BadInputValue',...
            'Input must contain symmetric matrices.')
    end
    [~,sing]=chol(scale(:,:,i));
    if sing>0
        error('BRRMM:BadInputValue',...
            'Input must contain positive-definite matrices.')
    end
end

end



function checknoise(obj,noise)

% Store model size.
nout=obj.nout;
ncomp=obj.ncomp;

% Check noise hyper-parameters.
if ~isnumeric(noise)
    error('BRRMM:BadInputClass',...
        'Input must be numeric.')
end
if ~isreal(noise)
    error('BRRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(noise)
    error('BRRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(noise)>3
    error('BRRMM:BadInputSize',...
        'Input must be a %d-dimensional array.',3)
end
if size(noise,1)~=nout
    error('BRRMM:BadInputSize',...
        'Input must have %d rows.',nout)
end
if size(noise,2)~=nout
    error('BRRMM:BadInputSize',...
        'Input must have %d columns.',nout)
end
if size(noise,3)~=ncomp
    error('BRRMM:BadInputSize',...
        'Input must have %d pages.',ncomp)
end
if any(isnan(noise(:))|isinf(noise(:)))
    error('BRRMM:BadInputValue',...
        'Input must contain finite numbers.')
end
for i=1:ncomp
    asymm=abs(noise(:,:,i)-noise(:,:,i)');
    if any(asymm(:)>eps()*nout)
        error('BRRMM:BadInputValue',...
            'Input must contain symmetric matrices.')
    end
    [~,sing]=chol(noise(:,:,i));
    if sing>0
        error('BRRMM:BadInputValue',...
            'Input must contain positive-definite matrices.')
    end
end

end



function checkshape(obj,shape)

% Store model size.
nout=obj.nout;
ncomp=obj.ncomp;

% Check shape hyper-parameters.
if ~isnumeric(shape)
    error('BRRMM:BadInputClass',...
        'Input must be numeric.')
end
if ~isreal(shape)
    error('BRRMM:BadInputClass',...
        'Input must be real.')
end
if isempty(shape)
    error('BRRMM:BadInputSize',...
        'Input must be non-empty.')
end
if ndims(shape)>2||min(size(shape))>1
    error('BRRMM:BadInputSize',...
        'Input must be a vector.')
end
if numel(shape)~=ncomp
    error('BRRMM:BadInputSize',...
        'Input must have %d elements.',ncomp)
end
if any(isnan(shape)|shape<=nout-1)
    error('BRRMM:BadInputValue',...
        'Input must contain values greater than %d.',nout-1)
end

end