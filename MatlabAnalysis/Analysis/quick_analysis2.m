camera_offset = 450;
%load and calculate flat-field
basedir = 'Z:\Keck\092911\COP_beads\flatfield';
clear imstack
for n=0:26
    temp = squeeze(MMparse([basedir, '\Snap', sprintf('%d',n)]));
    imstack(:,:,n+1) = double(temp);
end
imstack = imstack - camera_offset;
flatfield = mean(imstack,3);
flatfield = flatfield./mean(flatfield(:));

%first and last columns are dim
%flatfield(:,2:end-1)

%COP background
bkgd = squeeze(MMparse('Z:\Keck\092911\COP_beads\COP_bkgd_1'));
bkgd = double(bkgd) - camera_offset;
bkgd = bkgd ./ repmat(flatfield, [1 1 5]);

%time lapse
TL = squeeze(MMparse('Z:\Keck\092911\COP_beads\filled_device_320_40_TL_1'));
TL = double(TL)-camera_offset;
TL = TL ./ repmat(flatfield, [1 1 20 5]);
temp=[];
temp(:,:,1,:) = bkgd;
TLb = TL - repmat(temp, [1 1 20 1]);
TLb_serp = TLb(:,170:end,:,:); %just the area in the serpentine
TLmean = squeeze(mean(TLb_serp,3));
clear temp

%find beads
%nonEu
mask = adaptivethreshold(TLmean(:,:,3),21,-0.04);
disk = strel('disk',2);
mask = imopen(mask, disk);

maskEu = adaptivethreshold(TLmean(:,:,4),18,-0.08);
maskEu = imopen(maskEu, disk);
CC = bwconncomp(mask | maskEu);

for c = 1:size(TLb_serp,4)
    for t = 1:size(TLb_serp,3)
        im = TLb_serp(:,:,t,c);
        for n=1:CC.NumObjects            
            Imean(n,t,c) = mean(im(CC.PixelIdxList{n}));
            Isum(n,t,c) = sum(im(CC.PixelIdxList{n}));
        end
    end
end

for n=1:5
    bkgdpix = TLmean(1:220,1:60,n);
    slide_spectra(n)=mean(bkgdpix(:));
end

refLnbkgd = [refLn; slide_spectra];
for n=1:size(refLnbkgd,1);
    refLnbkgd(n,:) = refLnbkgd(n,:)./sum(refLnbkgd(n,:));
end
TLunmix=[];
TLerror=[];
for t = 1:size(TLb_serp,3)
    im = squeeze(TLb_serp(:,:,t,:));
    [u,e] = unmix(im, refLnbkgd);
    TLunmix(:,:,t,:) = u;
    TLerror(:,:,t,:) = e;
end

%image to image normalization
q = sum(Imean,1);
Imean_norm = Imean./repmat(q,[88 1 1]);
ImeanCV_norm = squeeze(std(Imean_norm,1,2)./mean(Imean_norm,2));

Cent = regionprops(CC, TLmean(:,:,4), 'MeanIntensity','WeightedCentroid');
for n=1:88
    plot3(Cent(n).WeightedCentroid(1),Cent(n).WeightedCentroid(2),Cent(n).MeanIntensity,'o');
    hold on
end
            
