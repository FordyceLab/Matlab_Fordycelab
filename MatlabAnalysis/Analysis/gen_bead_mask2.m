function [ mask ] = gen_bead_mask2( image, bead_size, offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mask = adaptivethreshold(medfilt2(image), bead_size, offset);
mask = imfill(mask,'holes');
mask = bwareaopen(mask, bead_size*5, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end


end

