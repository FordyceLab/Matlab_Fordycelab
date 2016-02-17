function bead_props = beadIntensities( image, CC, int_std )
%beadIntensities - returns an intensity vector for each
%bead, normalized by internal standard.
% image: unmixed image stack, [x y c]
% mask: mask with bead locations
% bead_props: nbeads x nchannels structure

%CC = bwconncomp(mask,4);
std_pixels = regionprops(CC, image(:,:,int_std), 'PixelValues','WeightedCentroid');

for c = 1:size(image,3)
    c_pixels = regionprops(CC, image(:,:,c), 'PixelValues', 'PixelIdxList');
    for n=1:numel(std_pixels)
        bead_props(n,c).centroid = std_pixels(n).WeightedCentroid;
        bead_props(n,c).median = median(c_pixels(n).PixelValues);
        bead_props(n,c).ratiomedian = median(c_pixels(n).PixelValues)/median(std_pixels(n).PixelValues);
        bead_props(n,c).medianratio = median(c_pixels(n).PixelValues./std_pixels(n).PixelValues);
        bead_props(n,c).pixelidx = c_pixels(n).PixelIdxList;
    end
end

end

