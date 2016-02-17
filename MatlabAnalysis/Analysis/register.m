function [ regions, description ] = align_serpentine_to_image(serpentine_model, target, debug)
%align_serpentine_to_image - aligns a serpentine model to a target image
% returns regions, and image with areas set to integers corresponding to
% the piece of the serpentine model described in description

if nargin < 3
    debug = false;
else
    debug = true;
end

%register mask on serpentine image

[mask, regions, mask_desc] = draw_serpentine_mask(serpentine_model);
outline = bwperim(mask, 8);
[mask_pts, target_pts] = cpselect(outline, target, 'Wait', true);
TFORM = cp2tform(mask_pts, target_pts, 'nonreflective similarity');
mask_xform = imtransform(mask, TFORM, 'XData', [1 size(target,2)], 'YData', [1 size(target,1)]);

%transform points so we can do cross-correlation to improve
xform_mask_pts = tformfwd(TFORM, mask_pts(:,1), mask_pts(:,2));
outline_xform = bwperim(mask_xform, 8);
mask_pts_2=cpcorr(xform_mask_pts, target_pts, outline_xform, target);
TFORM2 = cp2tform(mask_pts_2, target_pts, 'nonreflective similarity');
mask_final = imtransform(mask_xform, TFORM2, 'XData', [1 size(target,2)], 'YData', [1 size(target,1)]);

if debug
    RGB=zeros([size(target) 3]);
    RGB(:,:,2)=target;
    RGB(:,:,2)=RGB(:,:,2)-double(min(target(:)));
    RGB=RGB./max(RGB(:));
    RGB(:,:,1)=double(mask_final)/2;
    figure()
    imshow(RGB)
end

%adjust region image and descriptors

regions_aligned = imtransform(regions, TFORM, 'XData', [1 size(target,2)], 'YData', [1 size(target,1)]);
regions = imtransform(regions_aligned, TFORM2, 'XData', [1 size(target,2)], 'YData', [1 size(target,1)]);
final_desc = register_descriptor(mask_desc, TFORM);
description = register_descriptor(final_desc, TFORM2);