function result_image = bkgd_subtract(raw_image, flag, varargin)

%background subtracts an image cube
%flag can be one of 'mode', 'median', 'min', 'estimate', 'const', or 'image'
%
%'estimate' estimates a non-uniform background for each channel by
%morphological opening.  If specified, an optional size parameter must be
%passed
%
%if 'const' an additional array of length size(raw_image, 3) must be
%supplied; the each constant will be subtracted from the corresponding
%image of the cube
%
%if 'image' an additional image cube of the same size as raw_image must be
%supplied and will be pixel-by-pixel subtracted from raw_image

if strcmp(flag, 'image') || strcmp(flag, 'const') || strcmp(flag, 'estimate')
    if size(varargin, 2) < 1
        error('must supply an additional argument for const, image, and estimate modes');
    else
        bkgd = double(varargin{1});
    end
end

if strcmp(flag, 'estimate')
    SE = strel('disk', bkgd);
end
raw_image = double(raw_image);

if ndims(raw_image) == 3
    result_image = raw_image;
    for n=1:size(raw_image,3)
        slice = raw_image(:,:,n);
        switch flag
            case 'min'
                result_image(:,:,n) = slice - min(slice(:));
            case 'mode'
                result_image(:,:,n) = slice - mode(slice(:));
            case 'median'
                result_image(:,:,n) = slice - median(slice(:));
            case 'const'
                result_image(:,:,n) = slice - bkgd(n);
            case 'image'
                result_image(:,:,n) = slice - bkgd(:,:,n);
            case 'estimate'
                result_image(:,:,n) = slice - imopen(slice,SE);
        end
    end
end

if ndims(raw_image) == 4
    result_image = raw_image;
    for n=1:size(raw_image,3)
        for c=1:size(raw_image,4)
            slice = raw_image(:,:,n,c);
            switch flag
                case 'min'
                    result_image(:,:,n,c) = slice - min(slice(:));
                case 'mode'
                    result_image(:,:,n,c) = slice - mode(slice(:));
                case 'median'
                    result_image(:,:,n,c) = slice - median(slice(:));
                case 'const'
                    result_image(:,:,n,c) = slice - bkgd(c);
                case 'image'
                    result_image(:,:,n,c) = slice - bkgd(:,:,n,c);
                case 'estimate'
                    result_image(:,:,n,c) = slice - imopen(slice,SE);
            end
        end
    end
end