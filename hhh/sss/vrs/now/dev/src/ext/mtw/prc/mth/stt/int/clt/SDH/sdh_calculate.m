function S = sdh_calculate(D, M, varargin)

% SDH_CALCULATE Calculate Smoothened Data-Histogram of data on SOM
%
%  S = sdh_calculate(sData, sMap, [argID, value, ...])
% 
%   S = sdh_calculate(sData, sMap);
%   S = sdh_calculate(sData, sMap, 'interp.ntimes', 2, 'frame', 'off');
%
%   Input and output arguments ([]'s are optional): 
%     sData   (struct) SOM Toolbox data structure
%             (matrix) training data, size dlen x dim
%     sMap    (struct) SOM Toolbox map structure (rectangular lattice)
%             (matrix) codebook 
%    [argID,  (string) See below.  The values which are unambiguous can 
%     value]  (scalar) be given without the preceeding argID.
%
%     S       (struct) smoothened data histogram structure.
%
%   Here are the valid argument IDs and corresponding values. The values 
%   which are unambiguous (marked with '*') can be given without the
%   preceeding argID.
%     'msize'          (vector) map size, only necessary when sMap is not map struct
%     'spread'         (scalar) SDH spread parameter, default = 3.
%     'method'        *(string) SDH calculation method: 'labels', 'gaussian', '1/n', 'knn', or 'ranking' (default)
%     'frame'         *(string) add frame to round off SDH: 'off' or 'on' (default)
%     'interp.ntimes'  (scalar) expands the matrix by interleaving interpolates
%                                between every element, working recurively for ntimes.
%                                see INTERP2 for details. default is 2, when set to 0 
%                                no intermediate values are calculated.
%     'interp.method' *(string) interpolation method: 'nearest', 'linear', 'spline', 
%                                or 'cubic' (default). see INTERP2 for details.
%
%  See also SDH_VISUALIZE, INTERP2.

% elias 25/04/2002
% elias 10/02/2003 added dist_som features

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

% defaults
spread = 3;
method = 'ranking';
frame = 'on';
interp.ntimes = 2;
interp.method = 'linear';
msize = [];
dist_som = 0; %% flag: if 1 then use dist_som else use default
labels = [];

if isstruct(D) 
    if isfield(D,'data'),
        D = D.data;
    else
        dist_som = 1;
    end
end
[vecs dims] = size(D);

if isstruct(M) 
    msize = M.topol.msize;
    if dist_som | isfield(M,'dist_codebook'),
        M = M.dist_codebook;
        dist_som = 1;
    else    
        if isfield(M,'labels'),
            labels = M.labels;
        end
        M = M.codebook;
    end
end

% varargin
i=1; 
while i<=length(varargin), 
    argok = 1; 
    if ischar(varargin{i}), 
        switch varargin{i}, 
            % argument IDs
            case 'msize',         i=i+1; msize = varargin{i}; 
            case 'spread',        i=i+1; spread = varargin{i}; 
            case 'method',        i=i+1; method = varargin{i}; 
            case 'frame',         i=i+1; frame = varargin{i}; 
            case 'interp.ntimes', i=i+1; interp.ntimes = varargin{i}; 
            case 'interp.method', i=i+1; interp.method = varargin{i};
                % unambiguous values
            case {'on','off'}, frame = varargin{i};
            case {'ranking','1/n','knn','gaussian','labels'}, method = varargin{i}; 
            case {'nearest','linear','cubic','spline'}, interp.method = varargin{i};
            otherwise argok=0; 
        end
    else
        argok = 0; 
    end
    if ~argok, 
        disp(['(sdh_calculate) Ignoring invalid argument #' num2str(i+1)]); 
    end
    i = i+1; 
end

if isempty(msize),
    error('(sdh_calculate) msize not specified!')
end

S.type = 'sdh';
S.msize = msize;
S.frame = frame;
S.method = method;
S.spread = spread;
S.interp.ntimes = interp.ntimes;
S.interp.method = interp.method;
%% To be filled in coming versions:
% S.data_centers: to create html image maps
% S.peeks: to label mountains

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START
rows = msize(1);
cols = msize(2);

if ~dist_som,
    Dist = repmat(sum(M.^2,2),1,vecs)-M*2*D'; % munits x vecs
else
    Dist = D(:,M);
end
m = zeros(rows*cols,1);

switch method,
    case 'ranking', c = (spread:-1:1)';
        for i=1:vecs,
            if dist_som,
                [d idx] = sort(Dist(i,:));
            else
                [d idx] = sort(Dist(:,i));
            end
            idx = idx(1:spread); 
            m(idx) = m(idx) + c;
        end
        m = reshape(m,rows,cols);
    case 'knn', c = ones(spread,1);
        for i=1:vecs,
            [d idx] = sort(Dist(:,i));
            idx = idx(1:spread); 
            m(idx) = m(idx) + c;
        end
        m = reshape(m,rows,cols);
    case 'labels',
        if isempty(labels),
            error('sMap.labels not defined');
        end
        for i=1:size(labels,1),
            m(i) = sum(~strcmp(labels(i,:),''));
        end
        m = reshape(m,rows,cols);
    case '1/n', c = (1./(1:spread))';
        for i=1:vecs,
            [d idx] = sort(Dist(:,i));
            idx = idx(1:spread); 
            m(idx) = m(idx) + c;
        end
        m = reshape(m,rows,cols);
    case 'gaussian', 
        [dummy b] = min(Dist);
        
        % init gmm
        variance = zeros(rows*cols,dims,dims);
        pri = zeros(1,rows*cols);
        for i=1:rows*cols,
            variance(i,:,:) = cov(D(b==i,:)); % covariance
            pri(i) = sum(b==i)/vecs; % priors
        end
        
        if spread, % fixed covariance
            idx=diag(ones(dims,1));
            for i=1:rows*cols,
                variance(i,~logical(idx(:))) = 0;
                variance(i,logical(idx(:))) = spread;
            end
        end
        
        for i=1:rows*cols,
            d = D-repmat(M(i,:),vecs,1);
            s = -.5*inv(squeeze(variance(i,:,:)))*d';
            c = pri(i)*sqrt(det(squeeze(variance(i,:,:))));
            for j=1:vecs,
                post(j,i) = c*exp(d(j,:)*s(:,j));
            end
        end
        
        for iter=1:10,
            % calc new priors
            Lix = post.*repmat(pri,vecs,1); 
            Sx = sum(Lix,2); 
            Pix = Lix./repmat(Sx,1,rows*cols); 
            pri = sum(Pix,1)./vecs; 
            
            clear s d
            for i=1:rows*cols, % new covariance
                d = D-repmat(M(i,:),vecs,1);
                dt = (repmat(Pix(:,i),1,dims).*d)';
                if ~spread,
                    s = 0;
                    for j=1:vecs,
                        s = s + dt(:,j)*d(j,:);
                    end
                    variance(i,:) = reshape(1/(sum(Pix(:,i),1)-1) * s, 1, dims^2);
                end
            end
            clear s d c
            for i=1:rows*cols,
                d = D-repmat(M(i,:),vecs,1);
                s = -1/2*inv(squeeze(variance(i,:,:)))*d';
                c = pri(i)*sqrt(det(squeeze(variance(i,:,:))));
                for j=1:vecs,
                    post(j,i) = c*exp(d(j,:)*s(:,j));
                end
            end
            disp([num2str(iter),': ',num2str(sum(log(sum(post,2))))]);
        end
        for i=1:rows*cols,
            d = M-repmat(M(i,:),rows*cols,1);
            s = -1/2*inv(squeeze(variance(i,:,:)))*d';
            c = pri(i)*sqrt(det(squeeze(variance(i,:,:))));
            for j=1:vecs,
                postm(j,i) = c*exp(d(j,:)*s(:,j));
            end
        end
        
        m = reshape(sum(postm,2),rows,cols);
    otherwise error('(shd_calculate) unknown method.');
end

if strcmp(frame,'on'), 
    m = sdh_addframe(m);
end

S.matrix = interp2(m,interp.ntimes,interp.method);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
