function err = unmix_err_offset (offset, image, ref)

imsize = [size(image,1) size(image,2)];
image = image - repmat(offset, [imsize 5]);
[~, e] = unmix(image, ref);
err = sum(abs(e(:)));
