%% Extract reference spectra
camera_offset = 447; %from dark image

%load images
No_320_10 = squeeze(MMparse('Z:\Keck\101711\NoLanthanide_20111010-01\NoLanthanode_20111010-01_320_10_10_10_1_1_2'));
No_320_5 = squeeze(MMparse('Z:\Keck\101711\NoLanthanide_20111010-01\NoLanthanide_20111010-01_320_5_5_5_1_1_1'));
No_290_10 = squeeze(MMparse('Z:\Keck\101711\NoLanthanide_20111010-01\NoLanthanide_20111010-01_290_10_10_10_1_1_1'));
No_290_5 = squeeze(MMparse('Z:\Keck\101711\NoLanthanide_20111010-01\NoLanthanide_20111010-01_290_5_5_5_1_1_1'));

probe_radius = 20;
imlist = {'No_290_10','No_290_5','No_320_10','No_320_5'};
for n=1:numel(imlist)
    assignin('base', imlist{n}, bkgd_subtract(eval(imlist{n}), 'estimate', probe_radius));
    assignin('base', imlist{n}, bkgd_subtract(eval(imlist{n}), 'median'));
end

RGmix_320_5 = double(squeeze(MMparse('Z:\Keck\101711\Mixed_20111014-02_03_04\Mix_320_5_5_5_1_1_1')));
RGmix_290_5 = double(squeeze(MMparse('Z:\Keck\101711\Mixed_20111014-02_03_04\Mix_290_5_5_5_1_1_1')));
RGmix_320_5 = RGmix_320_5 - camera_offset;
RGmix_290_5 = RGmix_290_5 - camera_offset;

for n=1:5
    slice = RGmix_320_5(1:200,2:40,n);
    Device_320_5(n) = double(median(slice(:)));
    slice = RGmix_290_5(1:200,2:40,n);
    Device_290_5(n) = double(median(slice(:)));
end
Device_290_5 = Device_290_5./sum(Device_290_5);
Device_320_5 = Device_320_5./sum(Device_320_5);

refLn290_5 = [Dy_290_5_spectra; Eu_290_5_spectra; Sm_290_5_spectra];
refLnbkgd290_5 = [refLn290_5; Device_290_5];
refLn320_5 = [Dy_320_5_spectra; Eu_320_5_spectra; Sm_320_5_spectra];
refLnbkgd320_5 = [refLn320_5; Device_320_5];

[RGmix320_5_unmix, RGmix320_5_err] = unmix(RGmix_320_5, refLnbkgd320_5);
[RGmix290_5_unmix, RGmix290_5_err] = unmix(RGmix_290_5, refLnbkgd290_5);

imfilt = imopen(RGmix320_5_unmix(:,:,2),strel('ball',3,1));
mask = adaptivethreshold(imfilt,22,-0.1);
mask = bwareaopen(mask,50);
RGmix320_5_mask = imclearborder(mask);

RGmix320_5_I = beadIntensities(RGmix320_5_unmix, RGmix320_5_mask, 2);

imfilt = imopen(RGmix290_5_unmix(:,:,2),strel('ball',3,1));
mask = adaptivethreshold(imfilt,22,-0.1);
mask = bwareaopen(mask,50);
RGmix290_5_mask = imclearborder(mask);

RGmix290_5_I = beadIntensities(RGmix290_5_unmix, RGmix290_5_mask, 2);

RGcode1_320_5 = double(squeeze(MMparse('Z:\Keck\101711\20111014-01\20111014-01_320_5_5_5_1_1_1')));
RGcode1_290_5 = double(squeeze(MMparse('Z:\Keck\101711\20111014-01\20111014-01_290_5_5_5_1_1_1')));
RGcode1_320_5 = RGcode1_320_5 - camera_offset;
RGcode1_290_5 = RGcode1_290_5 - camera_offset;
[RGcode1320_5_unmix, RGcode1320_5_err] = unmix(RGcode1_320_5, refLnbkgd320_5);
[RGcode1290_5_unmix, RGcode1290_5_err] = unmix(RGcode1_290_5, refLnbkgd290_5);

imfilt = imopen(RGcode1320_5_unmix(:,:,2),strel('ball',3,1));
mask = adaptivethreshold(imfilt,22,-0.1);
mask = bwareaopen(mask,50);
RGcode120_5_mask = imclearborder(mask);

RGcode1290_5_I = beadIntensities(RGcode1290_5_unmix, mask, 2);