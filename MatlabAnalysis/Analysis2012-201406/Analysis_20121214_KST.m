load('Z:\Matlab\BeadAnalysis\ReferenceSpectra\20121030_ex292.mat');
%we are using 435, 572, 620, 630, and 650 filters
%drop channels 2, 3, 4, 5

Ln_spectra = [Dy_spec./sum(Dy_spec);Eu_spec./sum(Eu_spec);Sm_spec./sum(Sm_spec)];
Ln_spectra(:, 2:5) = [];

SerumJD_1 = squeeze(MMparse('Z:\NewImages\20121214\Serum_JD_2'));
temp = double(SerumJD_1(:,:,3:end));

for n=1:5
    slice = temp(20:240,270:490,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra = [Ln_spectra;Device_spec_df];

[JD1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))

%find beads
BFim = double(SerumJD_1(:,:,1));
BFim(1:110,:)=median(BFim(:));

[A,coords,CR] = CircularHough_Grd(BFim,[8 11],50,3,1);
imshow(BFim,[])
hold on
for n=1:size(coords,1)
    plot(coords(n,1),coords(n,2),'r+')
end
bead_radius = 9;

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

%[coords, mask, CC] = xcorrFindBeads(SerumJD_1(:,:,1), target_new_bead, 5);
beads_JD_1 = beadDataSet('oldimage', JD1u, CC, 2);
beads_JD_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0907_1.Transform = ICP(beads_M0907_1.getCodeRatio(:), target);
beads_M0907_all = compositeBeadDataSet(beads_M0907_1);
