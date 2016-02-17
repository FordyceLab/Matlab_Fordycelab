%extract CeTb spectra for reference

CeTb = squeeze(MMparse('Z:\Keck\110411\CeTb_290_3'));
probe_radius = 20;
CeTb = bkgd_subtract(CeTb, 'estimate', probe_radius);
CeTb = bkgd_subtract(CeTb, 'median');

%extract foreground pixels
pix = find(CeTb(:,:,2)>150);
for n=1:5
    CeTb_slice = CeTb(:,:,n);
    CeTb_spectra(n)=mean(CeTb_slice(pix));
end
CeTb_spectra = CeTb_spectra./sum(CeTb_spectra);

%using 10/17 reference spectra
refLn = [Dy_290_5_spectra_1017; Eu_290_5_spectra_1017; Sm_290_5_spectra_1017];

camera_offset = 450;
Empty = squeeze(MMparse('Z:\Keck\110411\Empty_beads_1'));
Empty = double(Empty);
Empty = Empty - camera_offset;

for n=1:5
    slice = double(Empty(2:200,2:50,n));
    Device(n) = mean(slice(:));
end
Device = Device./sum(Device);

refLnbkgd = [refLn; Device];
[Empty_unmix, Empty_err] = unmix(Empty, refLnbkgd);
Dy_bkgd = Empty_unmix(80:400, 80:310, 1);
Eu_bkgd = Empty_unmix(80:400, 80:310, 2);
Sm_bkgd = Empty_unmix(80:400, 80:310, 3);

ShortTL = squeeze(MMparse('Z:\Keck\110411\EuSmDy_ShortTL_1'));
ShortTL = double(ShortTL) - camera_offset;

stacksize = size(ShortTL);
ShortTL_unmix = zeros([stacksize(1:3) 4]);
for n = 1:size(ShortTL,3)
    [u, err] = unmix(squeeze(ShortTL(:,:,n,:)), refLnbkgd);
    r = err./squeeze(ShortTL(:,:,n,:));
    median(abs(r(:)))
    ShortTL_unmix(:,:,n,:) = u;
end

mask = adaptivethreshold(ShortTL_unmix(:,:,1,2),20,-0.06);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I = beadIntensities(squeeze(ShortTL_unmix(:,:,1,:)), CC, 2);

Dyim = zeros([501 502]);
Smim = Dyim;
nim = Dyim;
npixels=[];
for n=1:size(I)
    Dyim(I(n,1).pixelidx) = I(n,1).medianratio;
    Smim(I(n,3).pixelidx) = I(n,3).medianratio;
    nim(I(n,3).pixelidx) = n;
    npixels(n) = numel(I(n,3).pixelidx);
end

clear DyratioS SmratioS DyS EuS SmS
for n=1:15    
    I = beadIntensities(squeeze(ShortTL_unmix(:,:,n,:)), CC, 2);
    DyratioS(n,:)=[I(:,1).medianratio];
    SmratioS(n,:)=[I(:,3).medianratio];
    DyS(n,:) = [I(:,1).median];
    EuS(n,:) = [I(:,2).median];    
    SmS(n,:) = [I(:,3).median];
    DevS(n,:) = [I(:,4).median];
end

LongTL = squeeze(MMparse('Z:\Keck\110411\EuSmDy_LongTL_1'));
LongTL = double(LongTL) - camera_offset;

stacksize = size(LongTL);
LongTL_unmix = zeros([stacksize(1:3) 4]);
for n = 1:size(LongTL,3)
    [u, err] = unmix(squeeze(LongTL(:,:,n,:)), refLnbkgd);
    r = err./squeeze(LongTL(:,:,n,:));
    median(abs(r(:)))
    LongTL_unmix(:,:,n,:) = u;
end

mask = adaptivethreshold(max(LongTL_unmix(:,:,:,2),[],3),20,-0.06);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I = beadIntensities(squeeze(ShortTL_unmix(:,:,1,:)), CC, 2);

clear DyratioL SmratioL
for t=1:size(LongTL_unmix,3)    
    mask = adaptivethreshold(max(LongTL_unmix(:,:,t,2),[],3),20,-0.06);
    mask = bwareaopen(mask, 100, 4);
    mask = imclearborder(mask);
    CC = bwconncomp(mask,4);
    %remove fused beads
    S = regionprops(CC,'Eccentricity');
    badbeads = find([S.Eccentricity]>0.8);
    for n=1:numel(badbeads)
        %delete fused beads
        mask(CC.PixelIdxList{badbeads(n)}) = 0;
    end
    CC = bwconncomp(mask,4);
    I = beadIntensities(squeeze(LongTL_unmix(:,:,t,:)), CC, 2);
    t
    DyratioL{t,:}=[I(:,1).medianratio];
    SmratioL{t,:}=[I(:,3).medianratio];
    DyL{t,:} = [I(:,1).median];
    EuL{t,:} = [I(:,2).median];
    SmL{t,:} = [I(:,3).median];
    DevL{t,:} = [I(:,4).median];
end

clear meanDyrL meanSmrL meanDyL meanEuL meanSmL
for n=1:size(DyratioL,1)
    rDy = DyratioL{n};
    rSm = SmratioL{n};
    Dy = DyL{n};
    Eu = EuL{n};
    Sm = SmL{n};
    Dev = DevL{n};
    meanDyrL(n) = mean(rDy(rDy>0.2));
    meanSmrL(n) = mean(rSm(rDy<0.2));
    meanDyL(n) = mean(Dy(rDy>0.2));
    meanEuL(n) = mean(Eu);
    meanSmL(n) = mean(Sm(rDy<0.2));
    meanDevL(n) = mean(Dev);
end

%now do Z-stacks
Z2 = squeeze(MMparse('Z:\Keck\110411\EuSmDy_Z_2'));
Z2 = double(Z2) - camera_offset;

stacksize = size(Z2);
Z2_unmix = zeros([stacksize(1:3) 4]);
for n = 1:size(Z2,3)
    [u, err] = unmix(squeeze(Z2(:,:,n,:)), refLnbkgd);
    r = err./squeeze(Z2(:,:,n,:));
    median(abs(r(:)))
    Z2_unmix(:,:,n,:) = u;
end

clear DyratioZ2 SmratioZ2 DyZ2 EuZ2 SmZ2 DevZ2
for t=1:size(Z2_unmix,3)    
    mask = adaptivethreshold(max(Z2_unmix(:,:,t,2),[],3),20,-0.06);
    mask = bwareaopen(mask, 100, 4);
    mask = imclearborder(mask);
    CC = bwconncomp(mask,4);
    %remove fused beads
    S = regionprops(CC,'Eccentricity');
    badbeads = find([S.Eccentricity]>0.8);
    for n=1:numel(badbeads)
        %delete fused beads
        mask(CC.PixelIdxList{badbeads(n)}) = 0;
    end
    CC = bwconncomp(mask,4);
    I = beadIntensities(squeeze(Z2_unmix(:,:,t,:)), CC, 2);
    t
    DyratioZ2{t,:}=[I(:,1).medianratio];
    SmratioZ2{t,:}=[I(:,3).medianratio];
    DyZ2{t,:} = [I(:,1).median];
    EuZ2{t,:} = [I(:,2).median];
    SmZ2{t,:} = [I(:,3).median];
    DevZ2{t,:} = [I(:,4).median];
end

clear meanDyrZ2 meanSmrZ2 meanDyZ2 meanEuZ2 meanSmZ2
for n=1:size(DyratioZ2,1)
    rDy = DyratioZ2{n};
    rSm = SmratioZ2{n};
    Dy = DyZ2{n};
    Eu = EuZ2{n};
    Sm = SmZ2{n};
    Dev = DevZ2{n};
    meanDyrZ2(n) = mean(rDy(rDy>0.2));
    meanSmrZ2(n) = mean(rSm(rDy<0.2));
    meanDyZ2(n) = mean(Dy(rDy>0.2));
    meanEuZ2(n) = mean(Eu);
    meanSmZ2(n) = mean(Sm(rDy<0.2));
    meanDevZ2(n) = mean(Dev);
end

Z3 = squeeze(MMparse('Z:\Keck\110411\EuSmDy_Z_3'));
Z3 = double(Z3) - camera_offset;

stacksize = size(Z3);
Z3_unmix = zeros([stacksize(1:3) 4]);
for n = 1:size(Z3,3)
    [u, err] = unmix(squeeze(Z3(:,:,n,:)), refLnbkgd);
    r = err./squeeze(Z3(:,:,n,:));
    median(abs(r(:)))
    Z3_unmix(:,:,n,:) = u;
end

clear DyratioZ3 SmratioZ3 DyZ3 EuZ3 SmZ3 DevZ3
for t=1:size(Z3_unmix,3)    
    mask = adaptivethreshold(max(Z3_unmix(:,:,t,2),[],3),20,-0.06);
    mask = bwareaopen(mask, 100, 4);
    mask = imclearborder(mask);
    CC = bwconncomp(mask,4);
    %remove fused beads
    S = regionprops(CC,'Eccentricity');
    badbeads = find([S.Eccentricity]>0.8);
    for n=1:numel(badbeads)
        %delete fused beads
        mask(CC.PixelIdxList{badbeads(n)}) = 0;
    end
    CC = bwconncomp(mask,4);
    I = beadIntensities(squeeze(Z3_unmix(:,:,t,:)), CC, 2);
    t
    DyratioZ3{t,:}=[I(:,1).medianratio];
    SmratioZ3{t,:}=[I(:,3).medianratio];
    DyZ3{t,:} = [I(:,1).median];
    EuZ3{t,:} = [I(:,2).median];
    SmZ3{t,:} = [I(:,3).median];
    DevZ3{t,:} = [I(:,4).median];
end

clear meanDyrZ3 meanSmrZ3 meanDyZ3 meanEuZ3 meanSmZ3
for n=1:size(DyratioZ3,1)
    rDy = DyratioZ3{n};
    rSm = SmratioZ3{n};
    Dy = DyZ3{n};
    Eu = EuZ3{n};
    Sm = SmZ3{n};
    Dev = DevZ3{n};
    meanDyrZ3(n) = mean(rDy(rDy>0.2));
    meanSmrZ3(n) = mean(rSm(rDy<0.2));
    meanDyZ3(n) = mean(Dy(rDy>0.2));
    meanEuZ3(n) = mean(Eu);
    meanSmZ3(n) = mean(Sm(rDy<0.2));
    meanDevZ3(n) = mean(Dev);
end

%get raw image intensities
%Z2, t1
t=1
mask = adaptivethreshold(max(Z2_unmix(:,:,t,2),[],3),20,-0.06);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I = beadIntensities(squeeze(Z2(:,:,t,:)), CC, 2);


for n=1:5
    Z2C(n,:) = [I(:,n).median];
    slice = Z2(2:208,2:40,1,n);
    Z2bkgd(n) = median(slice(:));
end

%LongTL, t15
t=8
mask = adaptivethreshold(max(LongTL_unmix(:,:,t,2),[],3),20,-0.06);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I = beadIntensities(squeeze(LongTL(:,:,t,:)), CC, 2);


for n=1:5
    TLC(n,:) = [I(:,n).median];
    slice = LongTL(2:208,2:40,1,n);
    LongTLbkgd(n) = median(slice(:));
end

LongTL_unmix_O = zeros([501 502 8 4]);
for n = 1:size(LongTL,3)    
    f = @(x)unmix_err_offset (x, squeeze(LongTL(:,:,n,:)), refLnbkgd);
    [offset, ~] = fminunc(f, 0)
    [u, err] = unmix(squeeze(LongTL(:,:,n,:))-offset, refLnbkgd);
    r = err./squeeze(LongTL(:,:,n,:));
    median(abs(r(:)))
    LongTL_unmix_O(:,:,n,:) = u;
end
clear DyratioLO SmratioLO
for t=1:size(LongTL_unmix_O,3)    
    mask = adaptivethreshold(max(LongTL_unmix_O(:,:,t,2),[],3),20,-0.06);
    mask = bwareaopen(mask, 100, 4);
    mask = imclearborder(mask);
    CC = bwconncomp(mask,4);
    %remove fused beads
    S = regionprops(CC,'Eccentricity');
    badbeads = find([S.Eccentricity]>0.8);
    for n=1:numel(badbeads)
        %delete fused beads
        mask(CC.PixelIdxList{badbeads(n)}) = 0;
    end
    CC = bwconncomp(mask,4);
    I = beadIntensities(squeeze(LongTL_unmix_O(:,:,t,:)), CC, 2);
    t
    DyratioLO{t,:}=[I(:,1).medianratio];
    SmratioLO{t,:}=[I(:,3).medianratio];
    DyLO{t,:} = [I(:,1).median];
    EuLO{t,:} = [I(:,2).median];
    SmLO{t,:} = [I(:,3).median];
    DevLO{t,:} = [I(:,4).median];
end

clear meanDyrLO meanSmrLO meanDyLO meanEuLO meanSmLO
for n=1:size(DyratioLO,1)
    rDy = DyratioLO{n};
    rSm = SmratioLO{n};
    Dy = DyLO{n};
    Eu = EuLO{n};
    Sm = SmLO{n};
    Dev = DevLO{n};
    meanDyrLO(n) = mean(rDy(rDy>0.2));
    meanSmrLO(n) = mean(rSm(rDy<0.2));
    meanDyLO(n) = mean(Dy(rDy>0.2));
    meanEuLO(n) = mean(Eu);
    meanSmLO(n) = mean(Sm(rDy<0.2));
    meanDevLO(n) = mean(Dev);
end


Z2_unmix_O = zeros([501 502 7 4]);
for n = 1:size(Z2,3)    
    f = @(x)unmix_err_offset (x, squeeze(Z2(:,:,n,:)), refLnbkgd);
    [offset, ~] = fminunc(f, 0)
    [u, err] = unmix(squeeze(Z2(:,:,n,:))-offset, refLnbkgd);
    r = err./squeeze(Z2(:,:,n,:));
    median(abs(r(:)))
    Z2_unmix_O(:,:,n,:) = u;
end

clear DyratioZ2O SmratioZ2O DyZ2O EuZ2O SmZ2O DevZ2O
for t=1:size(Z2_unmix_O,3)    
    mask = adaptivethreshold(max(Z2_unmix_O(:,:,t,2),[],3),20,-0.06);
    mask = bwareaopen(mask, 100, 4);
    mask = imclearborder(mask);
    CC = bwconncomp(mask,4);
    %remove fused beads
    S = regionprops(CC,'Eccentricity');
    badbeads = find([S.Eccentricity]>0.8);
    for n=1:numel(badbeads)
        %delete fused beads
        mask(CC.PixelIdxList{badbeads(n)}) = 0;
    end
    CC = bwconncomp(mask,4);
    I = beadIntensities(squeeze(Z2_unmix_O(:,:,t,:)), CC, 2);
    t
    DyratioZ2O{t,:}=[I(:,1).medianratio];
    SmratioZ2O{t,:}=[I(:,3).medianratio];
    DyZ2O{t,:} = [I(:,1).median];
    EuZ2O{t,:} = [I(:,2).median];
    SmZ2O{t,:} = [I(:,3).median];
    DevZ2O{t,:} = [I(:,4).median];
end

clear meanDyrZ2O meanSmrZ2O meanDyZ2O meanEuZ2O meanSmZ2O
for n=1:size(DyratioZ2O,1)
    rDy = DyratioZ2O{n};
    rSm = SmratioZ2O{n};
    Dy = DyZ2O{n};
    Eu = EuZ2O{n};
    Sm = SmZ2O{n};
    Dev = DevZ2O{n};
    meanDyrZ2O(n) = mean(rDy(rDy>0.2));
    meanSmrZ2O(n) = mean(rSm(rDy<0.2));
    meanDyZ2O(n) = mean(Dy(rDy>0.2));
    meanEuZ2O(n) = mean(Eu);
    meanSmZ2O(n) = mean(Sm(rDy<0.2));
    meanDevZ2O(n) = mean(Dev);
end

%look at 4x data

ims = squeeze(MMparse('Z:\Keck\110411\EuSmDy_4x_1'));
ims = double(ims) -camera_offset;
for n=1:5
    slice = ims(2:150,2:200,n);
    Device(n) = mean(slice(:));
end
Device =Device./sum(Device);

[unmix_4x,err] = unmix(ims, refLnbkgd);
mask = adaptivethreshold(unmix_4x(:,:,2),8,-0.05);
mask = bwareaopen(mask, 16, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I4x = beadIntensities(unmix_4x,CC,2);

