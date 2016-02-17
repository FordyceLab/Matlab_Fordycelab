function [ Y ] = lwsmooth_nd( Xi, Yi, X, tau  )
% lwsmooth_nd: n-dimensional smoothing by locally weighted linear fits
%   Xi is an npts x ndim set of coordinates and Yi is a function measured at
%   the corresponding points in Xi
%   X is an mpts x ndim list of points we want data returned at
%   tau is the weighting radius

npts = size(Xi,1);
ndim = size(Xi,2);
Xic = Xi;
Xic(:,ndim+1) = 1; %add constant term
Y = zeros([size(X,1) 1]);

for n=1:size(X,1)
    R = sum((Xi-repmat(X(n,:),[npts,1])).^2,2);
    W = exp(-R/(2*tau^2));
    p = lscov(Xic, Yi, W);
    Y(n) = [X(n,:) 1]*p;
end


end