function [unmixed_image, error_image] = unmix (raw_image, reference_spectra)
%unmixes a raw data cube into an unmixed data cube as defined by
%reference_spectra

%raw_image is [x y c]
%reference_spectra is [s c]
%unmixed_image is [x y s]

unmixed_image=zeros([size(raw_image,1) size(raw_image,2) size(reference_spectra,1)]);
error_image = zeros(size(raw_image));
for n=1:size(raw_image,2)
    row = squeeze(raw_image(:,n,:));
    unmixed_row = zeros([size(row,1) size(reference_spectra,1)]);
    for p=1:size(row,1)
        q = lsqnonneg(reference_spectra', row(p,:)');
        unmixed_row(p,:) = q';
    end
    %unmixed_row = row/reference_spectra; %same as  (ref'\row')'
    unmixed_image(:,n,:) = unmixed_row;
    error_image(:,n,:) = row - unmixed_row * reference_spectra;
end
    