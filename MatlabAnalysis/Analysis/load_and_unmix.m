function [ unmixed_image, varargout ] = load_and_unmix( filename, camera_offset, reference_spectrum )
%Load a micromanager file and unmix it
%   Detailed explanation goes here
image = squeeze(MMparse(filename));
image = double(image) - camera_offset;
[unmixed_image, err_image] = unmix(image, reference_spectrum);
if nargout > 1
   varargout{1} = median(abs(err_image(:)./image(:)));
end
if nargout > 2
   varargout{2} = err_image;
end

end

