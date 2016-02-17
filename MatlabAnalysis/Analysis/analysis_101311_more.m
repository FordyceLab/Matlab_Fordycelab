CD320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\320nmFilter\CondenserAllTheWayDown\Exp3_10_10_10_1_1_2'));
CU320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\320nmFilter\CondenserRaisedUp\Exp1_10_10_10_1_1_1'));
CDrot320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\320nmFilter\CondenserDown180Rotation\Exp1_10_10_10_1_1_1'));
CD290 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\270nmFilter\CondenserAllTheWayDown\Exp1_10_10_10_1_1_1'));
CU290 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\270nmFilter\CondenserRaisedUp\Exp1_10_10_10_1_1_1'));
CDrot290 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\270nmFilter\CondenserDown180Rotation\Exp1_10_10_10_1_1_1'));

camera_offset = 447;
CD320 = double(CD320) - camera_offset;
CU320 = double(CU320) - camera_offset;
CDrot320 = double(CDrot320) - camera_offset;
CD290 = double(CD290) - camera_offset;
CU290 = double(CU290) - camera_offset;
CDrot290 = double(CDrot290) - camera_offset;

for n=1:5
    slice = CD320(1:200,2:40,n);
    Device_320_10b(n) = double(median(slice(:)));
    slice = CD290(1:200,2:40,n);
    Device_290_10b(n) = double(median(slice(:)));
end
Device_290_10b = Device_290_10b./sum(Device_290_10b);
Device_320_10b = Device_320_10b./sum(Device_320_10b);


[CD320_unmix, CD320_err] = unmix(CD320, refLnbkgd320_10);
[CU320_unmix, CU320_err] = unmix(CU320, refLnbkgd320_10);
[CDrot320_unmix, CDrot320_err] = unmix(CDrot320, refLnbkgd320_10);
[CD290_unmix, CD290_err] = unmix(CD290, refLnbkgd290_10);
[CU290_unmix, CU290_err] = unmix(CU290, refLnbkgd290_10);
[CDrot290_unmix, CDrot290_err] = unmix(CDrot290, refLnbkgd290_10);

mask = adaptivethreshold(CD320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CD320_mask = imclearborder(mask);
CD320_I = beadIntensities(CD320_unmix, CD320_mask, 2);

mask = adaptivethreshold(CU320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CU320_mask = imclearborder(mask);
CU320_I = beadIntensities(CU320_unmix, CU320_mask, 2);

mask = adaptivethreshold(CDrot320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CDrot320_mask = imclearborder(mask);
CDrot320_I = beadIntensities(CDrot320_unmix, CDrot320_mask, 2);

mask = adaptivethreshold(CD290_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CD290_mask = imclearborder(mask);
CD290_I = beadIntensities(CD290_unmix, CD290_mask, 2);

mask = adaptivethreshold(CU290_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CU290_mask = imclearborder(mask);
CU290_I = beadIntensities(CU290_unmix, CU290_mask, 2);

mask = adaptivethreshold(CDrot290_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CDrot290_mask = imclearborder(mask);
CDrot290_I = beadIntensities(CDrot290_unmix, CDrot290_mask, 2);

%now the 5 5 5 1 1 data
CD320_5 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\320nmFilter\CondenserAllTheWayDown\Exp1_5_5_5_1_1_1\SmDyMix_5_5_5_1_1_s'));
CU320_5 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\320nmFilter\CondenserRaisedUp\Exp1_5_5_5_1_1_1'));
CDrot320_5 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\320nmFilter\CondenserDown180Rotation\Exp1_5_5_5_1_1_1'));
CD290_5 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\270nmFilter\CondenserAllTheWayDown\Exp1_5_5_5_1_1_1'));
CU290_5 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\270nmFilter\CondenserRaisedUp\Exp1_5_5_5_1_1_1'));
CDrot290_5 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\270nmFilter\CondenserDown180Rotation\Exp1_5_5_5_1_1_1'));

camera_offset = 447;
CD320_5 = double(CD320_5) - camera_offset;
CU320_5 = double(CU320_5) - camera_offset;
CDrot320_5 = double(CDrot320_5) - camera_offset;
CD290_5 = double(CD290_5) - camera_offset;
CU290_5 = double(CU290_5) - camera_offset;
CDrot290_5 = double(CDrot290_5) - camera_offset;

[CD320_5_unmix, CD320_5_err] = unmix(CD320_5, refLnbkgd320_5);
[CU320_5_unmix, CU320_5_err] = unmix(CU320_5, refLnbkgd320_5);
[CDrot320_5_unmix, CDrot320_5_err] = unmix(CDrot320_5, refLnbkgd320_5);
[CD290_5_unmix, CD290_5_err] = unmix(CD290_5, refLnbkgd290_5);
[CU290_5_unmix, CU290_5_err] = unmix(CU290_5, refLnbkgd290_5);
[CDrot290_5_unmix, CDrot290_5_err] = unmix(CDrot290_5, refLnbkgd290_5);

mask = adaptivethreshold(CD320_5_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CD320_5_mask = imclearborder(mask);
CD320_5_I = beadIntensities(CD320_5_unmix, CD320_5_mask, 2);

mask = adaptivethreshold(CU320_5_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CU320_5_mask = imclearborder(mask);
CU320_5_I = beadIntensities(CU320_5_unmix, CU320_5_mask, 2);

mask = adaptivethreshold(CDrot320_5_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CDrot320_5_mask = imclearborder(mask);
CDrot320_5_I = beadIntensities(CDrot320_5_unmix, CDrot320_5_mask, 2);

mask = adaptivethreshold(CD290_5_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CD290_5_mask = imclearborder(mask);
CD290_5_I = beadIntensities(CD290_5_unmix, CD290_5_mask, 2);

mask = adaptivethreshold(CU290_5_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CU290_5_mask = imclearborder(mask);
CU290_5_I = beadIntensities(CU290_5_unmix, CU290_5_mask, 2);

mask = adaptivethreshold(CDrot290_5_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
CDrot290_5_mask = imclearborder(mask);
CDrot290_5_I = beadIntensities(CDrot290_5_unmix, CDrot290_5_mask, 2);