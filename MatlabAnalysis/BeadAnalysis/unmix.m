function [unmixed_image, error_image] = unmix (raw_image, reference_spectra)
%unmixes a raw data cube into an unmixed data cube as defined by
%reference_spectra

%raw_image is [x y c]
%reference_spectra is [s c]
%unmixed_image is [x y s]

raw_image = double(raw_image);
imsize = [size(raw_image,1) size(raw_image,2)];

% unmixed_image=zeros([imsize size(reference_spectra,1)]);
% error_image = zeros(size(raw_image));

temp = reshape(raw_image,[prod(imsize) size(raw_image,3)]);
unmixed_image = temp/reference_spectra; %do the unmxing
error_image = unmixed_image * reference_spectra;
error_image = reshape(error_image, [imsize size(raw_image,3)]);
error_image = raw_image - error_image;
unmixed_image = reshape(unmixed_image, [imsize size(reference_spectra,1)]);


% for n=1:size(raw_image,2)
%     row = squeeze(raw_image(:,n,:));
%     unmixed_row = row/reference_spectra; %same as  (ref'\row')'
%     unmixed_image(:,n,:) = unmixed_row;
%     error_image(:,n,:) = row - unmixed_row * reference_spectra;
% end    