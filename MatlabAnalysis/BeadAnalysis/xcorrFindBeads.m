function [coords, mask, CC] = xcorrFindBeads(BFim, target, bead_radius, centroid)
% uses normalized cross-correlation to find beads in a brightfield image
% by finding pixels where target is highly correlated with BFim
% returns:
% coords - a n x 2 list of bead centers
% mask - a B&W mask produced by putting a circle of bead_radius at each
% center
% CC - produced from mask by bwconncomp
%
%some possible ways to generate target from a brightfield image
%
%%Circular Hough Transform to find a bunch of beads, doesn't need extreme
%%accuracy
% [A,CC,CR] = CircularHough_Grd(BFim,[6 10],median(BFim(:))/4.1,3,1);
% imshow(BFim,[])
% hold on
% for n=1:size(CC,1)
%     plot(CC(n,1),CC(n,2),'r+')
% end
% %cutout beads
% boxsize = 8;
% beadstack = zeros([2*boxsize+1 2*boxsize+1 size(CC,1)]);
% CC= round(CC);
% for n=1:size(CC,1)
%     beadstack(:,:,n) = BFim(CC(n,2)-boxsize:CC(n,2)+boxsize, CC(n,1)-boxsize:CC(n,1)+boxsize);
% end
% meanbead = mean(beadstack,3);
% %now subpixel register all beads against this
% regstack = zeros(size(beadstack));
% 
% for rot=0:90:270; %crude rotational symmetrizing
%     for n=1:size(beadstack,3)
%         [~, r] = dftregistration(target, fft2(imrotate(beadstack(:,:,n),rot)),10);
%         regstack(:,:,nr) = abs(ifft2(r));
%         nr=nr+1;
%     end
% end
% 
% target = mean(regstack,3);

Q = normxcorr2(target,BFim);
offset = size(target);
if ~exist('centroid', 'var')
    bead_list = regionprops(Q>0.7, 'Centroid'); %hardcoded threshold
else
    bead_list = regionprops(Q>centroid, 'Centroid');
end
clear coords
for n=1:numel(bead_list)
    coords(n,:) = bead_list(n).Centroid - offset/2;
end

if ~exist('coords')
    error('No beads found')
end


%check to find minimum radius between beads
temp = pdist2(coords,coords,'euclidean','Smallest',2);
if floor(min(temp(2,:))/2) < bead_radius
    warning('Bead radius may be too large, resulting in touching beads')
end

%build mask and CC
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

%CC = bwconncomp(mask,4);