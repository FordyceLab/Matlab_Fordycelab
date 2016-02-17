function [L, num,centroids] = gen_bead_mask(source_im, bead_size)
%return a labeled image (L) and number of beads (num) from a bead image.
%beads are assumed to be 27 pixels in diameter

disk = strel('disk', round(bead_size/2));
h=fspecial('disk',bead_size);
mask_disk = h > max(h(:))/2;
ballsize = round(bead_size*0.6);
ball=strel('ball',ballsize,ballsize-1);

imfilt=double(imopen(source_im,ball));
mask = adaptivethreshold(imfilt,bead_size,-0.04);
mask = bwareaopen(mask,100);
mask = imclearborder(mask);
mask=imopen(mask,disk);
imshow(mask)
props=regionprops(mask,source_im,'WeightedCentroid');

newmask=zeros([501 502],'uint8');
for n=1:size(props,1)
    coords = round(props(n).WeightedCentroid);
    newmask(coords(2),coords(1))=1;
    centroids(n,:)=coords;
end

newmask=im2bw(imfilter(newmask,double(mask_disk)),0.001);
[L,num]=bwlabel(newmask);