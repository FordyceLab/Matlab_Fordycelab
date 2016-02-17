function [ transform ] = ICP2 ( data, target, type, varargin )
%ICP - Iterative Closest Point algorithm for matching measured lanthanide
%intensities to target levels
%   input: input data (n x d matrix where d is number of lanthanides and n
%          is number of measurements)
%   target: target levels (m x d matrix where d is number of lanthanides
%           and m is number of codes)
%   transform: transform object that best transforms input to best match
%              each point to the closest point in target.  Currently
%              transform is a diagonal matrix reflecting only scaling along
%              each lanthanide axis.

%sanity checks
if size(data,2) ~= size(target,2)
    error('Input and target must have the same number of columns');
end
nLn = size(data,2);
nData = size(data,1);

%initial guess at transformation
scale = eye(nLn);
offset = zeros(1,nLn);
for n=1:nLn
    scale(n,n) = mean(target(:,n))./mean(data(:,n));
end

transform = beadTransform(type, scale, offset);

if nargin > 3; %have initial transform passed to us
    transform = varargin{1};
    transform.Type = type; %override existing type
end

%iterative part

MAXITER = 100;
TOL = 0.0001;

delta = 1;
iter = 0;
while (iter <= MAXITER && delta > TOL)
    %transform input
    result = transform.apply(data);
    %calculate rmsd
    oldtransform = transform;
    %find closest points
    distances = pdist2(result, target);
    %distances is ndata x nlevels
    [~, matchedCode] = min(distances,[],2);
    matchedLevels = target(matchedCode, :);
    %dist = result - matchedLevels;
    %err = sum(abs(dist(:)));
    
    %update transform
    switch type
        case 'linear'
            %linear transform with offset
            for n=1:nLn
                m = fitlm(data(:,n), matchedLevels(:,n));
                offset(n) = m.Coefficients.Estimate(1);
                scale(n,n) = m.Coefficients.Estimate(2);
            end
            transform = beadTransform('linear', scale, offset);
            
        case 'scale'
            for n=1:nLn
                scale(n,n) = data(:,n)\matchedLevels(:,n);
            end
            transform = beadTransform('scale', scale);
            
        case 'matrix'
            d = [data, ones([size(data,1) 1])];
            m = d\matchedLevels;
            matrix = m(1:end-1, :);
            offset = m(end,:);
            transform = beadTransform('matrix', matrix, offset);
            
        otherwise
            error('Invalid Transform Type')
    end
    %check for convergence
    delta = transform.difference(oldtransform);
    iter = iter+1;
end