function [ transform ] = ICP ( input, target, varargin )
%ICP - Iterative Closest Point algorithm for matching measured lanthanide
%intensities to target levels
%   input: input data (n x d matrix where d is number of lanthanides and n
%          is number of measurements)
%   target: target (ideal) levels (1 x d cell matrix where each cell
%           contains the vector of levels for lanthanide d)
%   transform: resulting transform that best transforms input to best match
%              each point to the closest point in target.  Currently
%              transform is a diagonal matrix reflecting only scaling along
%              each lanthanide axis.

%sanity checks
if size(input,2) ~= size(target,2)
    error('Input and target must have the same number of columns');
end
nLn = size(input,2);
ndata = size(input,1);

%initial guess at transformation
transform = eye(nLn);
for n=1:nLn
    %force targetlevels to be a column vector
    if size(target{n},1 < size(target{n},2))
        target{n} = target{n}';
    end
    targetlevels = target{n};
    transform(n,n) = max(targetlevels)./max(input(:,n));
end

if nargin > 2; %have initial transform passed to us
    transform = varargin{1};
end



%iterative part

MAXITER = 100;
TOL = 0.0001;

delta = 1;
iter = 0;
while (iter <= MAXITER && delta > TOL)
    %transform input
    result = input*transform;
    oldtransform = transform;
    
    %find closest points
    %since matrix is diagonal, we can treat each column independently
    dist=[];
    for ln=1:nLn
        targetlevels = target{ln};
        nlevels = size(targetlevels,1);
        distances = pdist2(result(:,ln), targetlevels);
        %distances is ndata x nlevels
        [r, c] = find(distances == repmat(min(distances,[],2), [1 nlevels]));
        %construct a vector corresponding to the best match levels for each
        %data point
        
        %want to add something like this to make sure each bead is matched
        %once and only once
        %         [~,m,~] = unique(row);
        %         ru = row(m);
        %         cu = col(m);
        
        match = zeros(ndata,1);
        match(r) = targetlevels(c);
        
        %update transform
        transform(ln,ln) = input(:,ln)\match;
        %calculate rmsd
        dist(:,ln) = input(:,ln).*transform(ln,ln) - match;
    end
    %check for convergence
    delta = (transform - oldtransform).^2;
    delta = sqrt(sum(delta(:)))./sum(transform(:));
    iter = iter+1;
end
%dist
end


