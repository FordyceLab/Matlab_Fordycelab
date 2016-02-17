%align serpentine model
target = Serpentine6;
S = get_serpentine_model('60');
[regions, descriptions] = align_serpentine_to_image(S, target,'debug');

%find beads
%Circular Hough Transform
%[A,CC,CR] = CircularHough_Grd(target,[13 16],10,3,1);

%cross - correlation
clear CC
Q = normxcorr2(test_bead,target);
offset = size(test_bead);
bead_list = regionprops(Q>0.5, 'Centroid');
for n=1:numel(bead_list)
    CC(n,:) = bead_list(n).Centroid - offset/2;
end

RGB = double(repmat(target, [1 1 3]));
RGB = RGB-double(min(target(:)));
RGB = (RGB./max(RGB(:)))*0.75;

bead_centers = zeros(size(target));
for n=1:size(CC,1)
    coords=round(CC(n,:));
    RGB(coords(2),coords(1),1) = 1;
    bead_centers(coords(2),coords(1)) = n;
end

%%
figure()
RGB = double(repmat(target, [1 1 3]));
RGB = RGB-double(min(target(:)));
RGB = RGB./max(RGB(:));
imshow(RGB);
%now project beads onto serpentine
 bead_map = map_beads_to_serpentine (regions, descriptions, CC);

%
for p=1:size(bead_map,1)
    coords = bead_map(p,:);
    text(coords(1),coords(2),sprintf('%d',p),'Color','r')
end
