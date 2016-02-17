function [L, num,centroids] = gen_bead_mask(source_im)
%return a labeled image (L) and number of beads (num) from a bead image.
%beads are assumed to be 27 pixels in diameter
persistent disk mask_disk ball

if isempty(disk)
    disk=strel('disk',5);
end
if isempty(mask_disk)
    h=fspecial('disk',12);
    mask_disk = h > max(h(:))/2;
end
if isempty(ball)
    ball=strel('ball',7,11);
end
imfilt=double(imopen(source_im,ball));
mask = adaptivethreshold(imfilt,30,-0.04);
mask = bwareaopen(mask,100);
mask = imclearborder(mask);
%mask=imopen(mask,disk);
%imshow(mask)
props=regionprops(mask,source_im,'WeightedCentroid');

newmask=zeros([501 502],'uint8');
for n=1:size(props,1)
    coords = round(props(n).WeightedCentroid);
    newmask(coords(2),coords(1))=1;
    centroids(n,:)=coords;
end

newmask=im2bw(imfilter(newmask,double(mask_disk)),0.001);
[L,num]=bwlabel(newmask);