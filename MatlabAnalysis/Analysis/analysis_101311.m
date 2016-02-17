%load images
P1_320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\FullPower\320nm_10_10_10_1_1_1'));
P1_270 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\FullPower\270nm_10_10_10_1_1_1'));

P2_320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power2\320nm_10_10_10_1_1_1'));
P2_270 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power2\270nm_10_10_10_1_1_1'));

P3_320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power3\320nm_10_10_10_1_1_1'));
P3_270 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power3\270nm_10_10_10_1_1_1'));

P4_320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power4\320nm_10_10_10_1_1_1'));
P4_270 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power4\270nm_10_10_10_1_1_1'));

P5_320 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power5\320nm_10_10_10_1_1_1'));
P5_270 = squeeze(MMparse('Z:\Keck\101311\Mix_20111010-2_20111004-01\PowerMeasurements\Power5\270nm_10_10_10_1_1_1'));
%%
%unmixing
camera_offset = 447;
P1_320 = double(P1_320) - camera_offset;
P1_270 = double(P1_270) - camera_offset;
P2_320 = double(P2_320) - camera_offset;
P2_270 = double(P2_270) - camera_offset;
P3_320 = double(P3_320) - camera_offset;
P3_270 = double(P3_270) - camera_offset;
P4_320 = double(P4_320) - camera_offset;
P4_270 = double(P4_270) - camera_offset;
P5_320 = double(P5_320) - camera_offset;
P5_270 = double(P5_270) - camera_offset;

for n=1:5
    slice = P1_320(1:200,2:40,n);
    Device_320_10(n) = double(median(slice(:)));
    slice = P1_270(1:200,2:40,n);
    Device_290_10(n) = double(median(slice(:)));
end
Device_290_10 = Device_290_10./sum(Device_290_10);
Device_320_10 = Device_320_10./sum(Device_320_10);

refLn290_10 = [Dy_290_10_spectra; Eu_290_10_spectra; Sm_290_10_spectra];
refLnbkgd290_10 = [refLn290_10; Device_290_10];
refLn320_10 = [Dy_320_10_spectra; Eu_320_10_spectra; Sm_320_10_spectra];
refLnbkgd320_10 = [refLn320_10; Device_320_10];

[P1_320_unmix, P1_320_err] = unmix(P1_320, refLnbkgd320_10);
[P1_270_unmix, P1_270_err] = unmix(P1_270, refLnbkgd290_10);
[P2_320_unmix, P2_320_err] = unmix(P2_320, refLnbkgd320_10);
[P2_270_unmix, P2_270_err] = unmix(P2_270, refLnbkgd290_10);
[P3_320_unmix, P3_320_err] = unmix(P3_320, refLnbkgd320_10);
[P3_270_unmix, P3_270_err] = unmix(P3_270, refLnbkgd290_10);
[P4_320_unmix, P4_320_err] = unmix(P4_320, refLnbkgd320_10);
[P4_270_unmix, P4_270_err] = unmix(P4_270, refLnbkgd290_10);
[P5_320_unmix, P5_320_err] = unmix(P5_320, refLnbkgd320_10);
[P5_270_unmix, P5_270_err] = unmix(P5_270, refLnbkgd290_10);

mask = adaptivethreshold(P1_270_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P1_270_mask = imclearborder(mask);
P1_270_I = beadIntensities(P1_270_unmix, P1_270_mask, 2);

mask = adaptivethreshold(P2_270_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P2_270_mask = imclearborder(mask);
P2_270_I = beadIntensities(P2_270_unmix, P2_270_mask, 2);

mask = adaptivethreshold(P3_270_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P3_270_mask = imclearborder(mask);
P3_270_I = beadIntensities(P3_270_unmix, P3_270_mask, 2);

mask = adaptivethreshold(P4_270_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P4_270_mask = imclearborder(mask);
P4_270_I = beadIntensities(P4_270_unmix, P4_270_mask, 2);

mask = adaptivethreshold(P5_270_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P5_270_mask = imclearborder(mask);
P5_270_I = beadIntensities(P5_270_unmix, P5_270_mask, 2);

mask = adaptivethreshold(P1_320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P1_320_mask = imclearborder(mask);
P1_320_I = beadIntensities(P1_320_unmix, P1_320_mask, 2);

mask = adaptivethreshold(P2_320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P2_320_mask = imclearborder(mask);
P2_320_I = beadIntensities(P2_320_unmix, P2_320_mask, 2);

mask = adaptivethreshold(P3_320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P3_320_mask = imclearborder(mask);
P3_320_I = beadIntensities(P3_320_unmix, P3_320_mask, 2);

mask = adaptivethreshold(P4_320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P4_320_mask = imclearborder(mask);
P4_320_I = beadIntensities(P4_320_unmix, P4_320_mask, 2);

mask = adaptivethreshold(P5_320_unmix(:,:,2),20,-0.04);
mask = bwareaopen(mask,100);
P5_320_mask = imclearborder(mask);
P5_320_I = beadIntensities(P5_320_unmix, P5_320_mask, 2);

Dy = [P1_270_I(:,1).medianratio] > 0.4;
Sm = [P1_270_I(:,3).medianratio] > 0.25;
Dy_mean(1) = mean([P1_270_I(Dy,1).medianratio]);
Dy_CV(1) = std([P1_270_I(Dy,1).medianratio])./Dy_mean(1);
Sm_mean(1) = mean([P1_270_I(Sm,3).medianratio]);
Sm_CV(1) = std([P1_270_I(Sm,3).medianratio])./Sm_mean(1);
Sm_I(1) = mean([P1_270_I(Sm,3).median]);
Dy_I(1) = mean([P1_270_I(Dy,1).median]);
Eu_I(1) = mean([P1_270_I(Dy,2).median, P1_270_I(Sm,2).median]);

Dy = [P2_270_I(:,1).medianratio] > 0.4;
Sm = [P2_270_I(:,3).medianratio] > 0.25;
Dy_mean(2) = mean([P2_270_I(Dy,1).medianratio]);
Dy_CV(2) = std([P2_270_I(Dy,1).medianratio])./Dy_mean(2);
Sm_mean(2) = mean([P2_270_I(Sm,3).medianratio]);
Sm_CV(2) = std([P2_270_I(Sm,3).medianratio])./Sm_mean(2);
Sm_I(2) = mean([P2_270_I(Sm,3).median]);
Dy_I(2) = mean([P2_270_I(Dy,1).median]);
Eu_I(2) = mean([P2_270_I(Dy,2).median, P2_270_I(Sm,2).median]);

Dy = [P3_270_I(:,1).medianratio] > 0.4;
Sm = [P3_270_I(:,3).medianratio] > 0.25;
Dy_mean(3) = mean([P3_270_I(Dy,1).medianratio]);
Dy_CV(3) = std([P3_270_I(Dy,1).medianratio])./Dy_mean(3);
Sm_mean(3) = mean([P3_270_I(Sm,3).medianratio]);
Sm_CV(3) = std([P3_270_I(Sm,3).medianratio])./Sm_mean(3);
Sm_I(3) = mean([P3_270_I(Sm,3).median]);
Dy_I(3) = mean([P3_270_I(Dy,1).median]);
Eu_I(3) = mean([P3_270_I(Dy,2).median, P3_270_I(Sm,2).median]);

Dy = [P4_270_I(:,1).medianratio] > 0.4;
Sm = [P4_270_I(:,3).medianratio] > 0.25;
Dy_mean(4) = mean([P4_270_I(Dy,1).medianratio]);
Dy_CV(4) = std([P4_270_I(Dy,1).medianratio])./Dy_mean(4);
Sm_mean(4) = mean([P4_270_I(Sm,3).medianratio]);
Sm_CV(4) = std([P4_270_I(Sm,3).medianratio])./Sm_mean(4);
Sm_I(4) = mean([P4_270_I(Sm,3).median]);
Dy_I(4) = mean([P4_270_I(Dy,1).median]);
Eu_I(4) = mean([P4_270_I(Dy,2).median, P4_270_I(Sm,2).median]);

Dy = [P5_270_I(:,1).medianratio] > 0.4;
Sm = [P5_270_I(:,3).medianratio] > 0.25;
Dy_mean(5) = mean([P5_270_I(Dy,1).medianratio]);
Dy_CV(5) = std([P5_270_I(Dy,1).medianratio])./Dy_mean(5);
Sm_mean(5) = mean([P5_270_I(Sm,3).medianratio]);
Sm_CV(5) = std([P5_270_I(Sm,3).medianratio])./Sm_mean(5);
Sm_I(5) = mean([P5_270_I(Sm,3).median]);
Dy_I(5) = mean([P5_270_I(Dy,1).median]);
Eu_I(5) = mean([P5_270_I(Dy,2).median, P5_270_I(Sm,2).median]);

Dy = [P1_320_I(:,1).medianratio] > 0.25;
Sm = [P1_320_I(:,3).medianratio] > 0.25;
Dy_mean(1) = mean([P1_320_I(Dy,1).medianratio]);
Dy_CV(1) = std([P1_320_I(Dy,1).medianratio])./Dy_mean(1);
Sm_mean(1) = mean([P1_320_I(Sm,3).medianratio]);
Sm_CV(1) = std([P1_320_I(Sm,3).medianratio])./Sm_mean(1);
Sm_I(1) = mean([P1_320_I(Sm,3).median]);
Dy_I(1) = mean([P1_320_I(Dy,1).median]);
Eu_I(1) = mean([P1_320_I(Dy,2).median, P1_320_I(Sm,2).median]);

Dy = [P2_320_I(:,1).medianratio] > 0.25;
Sm = [P2_320_I(:,3).medianratio] > 0.25;
Dy_mean(2) = mean([P2_320_I(Dy,1).medianratio]);
Dy_CV(2) = std([P2_320_I(Dy,1).medianratio])./Dy_mean(2);
Sm_mean(2) = mean([P2_320_I(Sm,3).medianratio]);
Sm_CV(2) = std([P2_320_I(Sm,3).medianratio])./Sm_mean(2);
Sm_I(2) = mean([P2_320_I(Sm,3).median]);
Dy_I(2) = mean([P2_320_I(Dy,1).median]);
Eu_I(2) = mean([P2_320_I(Dy,2).median, P2_320_I(Sm,2).median]);

Dy = [P3_320_I(:,1).medianratio] > 0.25;
Sm = [P3_320_I(:,3).medianratio] > 0.25;
Dy_mean(3) = mean([P3_320_I(Dy,1).medianratio]);
Dy_CV(3) = std([P3_320_I(Dy,1).medianratio])./Dy_mean(3);
Sm_mean(3) = mean([P3_320_I(Sm,3).medianratio]);
Sm_CV(3) = std([P3_320_I(Sm,3).medianratio])./Sm_mean(3);
Sm_I(3) = mean([P3_320_I(Sm,3).median]);
Dy_I(3) = mean([P3_320_I(Dy,1).median]);
Eu_I(3) = mean([P3_320_I(Dy,2).median, P3_320_I(Sm,2).median]);

Dy = [P4_320_I(:,1).medianratio] > 0.25;
Sm = [P4_320_I(:,3).medianratio] > 0.25;
Dy_mean(4) = mean([P4_320_I(Dy,1).medianratio]);
Dy_CV(4) = std([P4_320_I(Dy,1).medianratio])./Dy_mean(4);
Sm_mean(4) = mean([P4_320_I(Sm,3).medianratio]);
Sm_CV(4) = std([P4_320_I(Sm,3).medianratio])./Sm_mean(4);
Sm_I(4) = mean([P4_320_I(Sm,3).median]);
Dy_I(4) = mean([P4_320_I(Dy,1).median]);
Eu_I(4) = mean([P4_320_I(Dy,2).median, P4_320_I(Sm,2).median]);

Dy = [P5_320_I(:,1).medianratio] > 0.25;
Sm = [P5_320_I(:,3).medianratio] > 0.25;
Dy_mean(5) = mean([P5_320_I(Dy,1).medianratio]);
Dy_CV(5) = std([P5_320_I(Dy,1).medianratio])./Dy_mean(5);
Sm_mean(5) = mean([P5_320_I(Sm,3).medianratio]);
Sm_CV(5) = std([P5_320_I(Sm,3).medianratio])./Sm_mean(5);
Sm_I(5) = mean([P5_320_I(Sm,3).median]);
Dy_I(5) = mean([P5_320_I(Dy,1).median]);
Eu_I(5) = mean([P5_320_I(Dy,2).median, P5_320_I(Sm,2).median]);

satfunc = @(a,xdata) a(3)*(a(1) +(xdata./(a(2) + xdata)));
[ahat, resnorm] = lsqcurvefit(satfunc,[100 20 10000], power, Eu_I)

%inferred illumination distribution
Illumination270 = imclose(P1_270_unmix(:,:,4),strel('disk', 50));
Illumination320 = imclose(P1_320_unmix(:,:,4),strel('disk', 50));
%plot individual bead intensities vs illumination intensity
clear II
II_all = [];
Dyrat_all =[];
for n=1:size(P5_320_I)
    II(n) = Illumination320(round(P5_320_I(n,1).centroid(2)), round(P5_320_I(n,1).centroid(1)));
end
plot(II*power(5),[P5_320_I(:,1).medianratio],'.');
Dy=[P5_320_I(:,1).medianratio] >0.25;
corrcoef(II(Dy),[P5_320_I(Dy,1).medianratio])
II_all =[II_all, II(Dy).*power(5)];
Dyrat_all = [Dyrat_all, [P5_320_I(Dy,1).medianratio]];
hold on
clear II
for n=1:size(P4_320_I)
    II(n) = Illumination320(round(P4_320_I(n,1).centroid(2)), round(P4_320_I(n,1).centroid(1)));
end
plot(II*power(4),[P4_320_I(:,3).median],'.');
Dy=[P4_320_I(:,1).medianratio] >0.25;
corrcoef(II(Dy)*power(4),[P4_320_I(Dy,1).medianratio])
II_all =[II_all, II(Dy).*power(4)];
Dyrat_all = [Dyrat_all, [P4_320_I(Dy,1).medianratio]];
clear II
for n=1:size(P3_320_I)
    II(n) = Illumination320(round(P3_320_I(n,1).centroid(2)), round(P3_320_I(n,1).centroid(1)));
end
plot(II*power(3),[P3_320_I(:,3).median],'.');
Dy=[P3_320_I(:,1).medianratio] >0.25;
corrcoef(II(Dy)*power(3),[P3_320_I(Dy,1).medianratio])
II_all =[II_all, II(Dy).*power(3)];
Dyrat_all = [Dyrat_all, [P3_320_I(Dy,1).medianratio]];
clear II
for n=1:size(P2_320_I)
    II(n) = Illumination320(round(P2_320_I(n,1).centroid(2)), round(P2_320_I(n,1).centroid(1)));
end
plot(II*power(2),[P2_320_I(:,3).median],'.');
Dy=[P2_320_I(:,1).medianratio] >0.25;
corrcoef(II(Dy)*power(2),[P2_320_I(Dy,1).medianratio])
II_all =[II_all, II(Dy).*power(2)];
Dyrat_all = [Dyrat_all, [P2_320_I(Dy,1).medianratio]];
clear II
for n=1:size(P1_320_I)
    II(n) = Illumination320(round(P1_320_I(n,1).centroid(2)), round(P1_320_I(n,1).centroid(1)));
end
plot(II*power(1),[P1_320_I(:,1).medianratio],'.');
Dy=[P1_320_I(:,1).medianratio] >0.25;
corrcoef(II(Dy),[P1_320_I(Dy,1).medianratio])
II_all =[II_all, II(Dy).*power(1)];
Dyrat_all = [Dyrat_all, [P1_320_I(Dy,1).medianratio]];

%%
%Analysis of raw data
mask = adaptivethreshold(P1_320(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P1_320(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P1_320I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P1_270(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P1_270(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P1_270I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P2_320(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P2_320(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P2_320I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P2_270(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P2_270(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P2_270I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P3_320(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P3_320(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P3_320I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P3_270(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P3_270(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P3_270I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P4_320(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P4_320(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P4_320I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P4_270(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P4_270(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P4_270I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P5_320(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P5_320(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P5_320I(c) = mean(slice(mask)) - bkgd;
    end
end

mask = adaptivethreshold(P5_270(:,:,4),20,-0.04);
mask = bwareaopen(mask,50);
mask = imclearborder(mask);
props = regionprops(mask, 'PixelIdxList');
for c=1:5
    slice = P5_270(:,:,c);
    temp = slice(1:200,2:40);
    bkgd = mean(temp(:));
    for b=1:size(props)
        P5_270I(c) = mean(slice(mask)) - bkgd;
    end
end

powers = [0.58, 1, 2.1, 4.4, 6.2];