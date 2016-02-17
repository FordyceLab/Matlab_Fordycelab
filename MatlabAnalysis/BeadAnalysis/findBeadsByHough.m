function [coords, CC] = findBeadsByHough(BFim, radrange, scale, bead_radius)

[~,coords,~] = CircularHough_Grd(BFim, radrange ,median(BFim(:))/scale,3,1);
D = squareform(pdist(coords));
%mask off diagonal
D = D +eye(size(D))*100;
[r, c] = find(D < bead_radius);
duplicates = r(r>c);
coords(duplicates,:) =[];

clear CC
CC.Connectivity = 4;
CC.ImageSize = size(BFim);
CC.NumObjects = size(coords,1);
[X,Y]=meshgrid(1:size(BFim,2),1:size(BFim,1));
thresh = bead_radius^2;
mask = zeros(size(BFim));
for n=1:size(coords,1)
    newbead = (((X-coords(n,1)).^2 + (Y-coords(n,2)).^2)<=thresh);
    mask = mask | newbead;
    CC.PixelIdxList{n} = find(newbead);
end