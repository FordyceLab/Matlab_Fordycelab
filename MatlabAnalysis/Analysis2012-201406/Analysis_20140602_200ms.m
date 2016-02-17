% here, i analyzed a 24 code set of beads made with Eu, Sm, and Dy and then
% also analyzed a 4 code set of beads made with Tm only.
% for future references, these code sets are:
% 20140530-01 (Eu,Sm,Dy 24 codes) imaged on 20140602
% 20140530-02 (Tm 4 codes) imaged on 20140602
% the reference spectra used are:
% Eu: 20140529-01, imaged on 20140530
% Sm: 20140529-02, imaged on 20140530
% Dy: 20140529-03, imaged on 20140602
% Tm: 20140602-01, imaged on 20140602
% for all of these, i am using 200 ms exposures to see how this affects the
% error

% use only center part of image bc of illumination irregularities
imageBoundary = 100:400; 
% size of bead radius to use
bead_radius = 5;

% open DarkField files w 200 ms exposure time
dark = MMparse_bioformats('Z:\NewImages\20140602\DarkImages_200msExposure_1\DarkImages_200msExposure_1_MMImages.ome.tif');
dark = squeeze(dark);
darkIm = mean(dark,3); %this is our darkField correction image
clear dark %to save memory

% now begin analysis to get reference spectra

% first load Eu only bead images
EuIms = squeeze(MMparse_bioformats('Z:\NewImages\20140530\20140529-01_EuOnlyBeads_200ms_NoZOffset_3\20140529-01_EuOnlyBeads_200ms_NoZOffset_3_MMImages.ome.tif'));
% subtract dark field image
EuIms = double(EuIms) - repmat(darkIm, [1 1 size(EuIms, 3)]);
EuIms = bkgd_subtract(EuIms, 'estimate', bead_radius*3);

% select only the BF image and use this for bead finding via circular Hough
% transform
BFim = EuIms(imageBoundary,imageBoundary,1);
% need to look up what these params are, for now just mess with until all
%beads are found
[A,coords,CR] = CircularHough_Grd(BFim,[4 10],median(BFim(:))/5,3,1);

%plot results - experiment with doing this, changing the parameters above,
%and checking the image until nearly all of the beads are found
clf
imshow(BFim,[])
hold on
for n=1:size(coords,1)
    plot(coords(n,1),coords(n,2),'r+')
end

%this next part uses the bead coordinates to create a mask of where the
%beads are for further calculations - if you want to look at this mask,
%type imshow(mask)
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

%loop and calculate intensities, you can check out the resultant spectrum
%by just typing plot(EuSpec)
for n=2:10
    slice = EuIms(imageBoundary,imageBoundary,n);
    EuSpec(n-1)=median(slice(mask));
end

%load Dy only beads
DyIms = squeeze(MMparse_bioformats('Z:\NewImages\20140602\20140529-03_DyOnly_200ms_2\20140529-03_DyOnly_200ms_2_MMImages.ome.tif'));
%subtract dark field image
DyIms = double(DyIms) - repmat(darkIm, [1 1 size(DyIms, 3)]);
DyIms = bkgd_subtract(DyIms, 'estimate', bead_radius*3);

%use circular hough transform to find beads only in center quadrant of
%image
BFim = DyIms(imageBoundary,imageBoundary,1);
%need to look up what these params are, for now just mess with until all
%beads are found
[A,coords,CR] = CircularHough_Grd(BFim,[4 10],median(BFim(:))/5,3,1);

%plot results
clf
imshow(BFim,[])
hold on
for n=1:size(coords,1)
    plot(coords(n,1),coords(n,2),'r+')
end

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

%loop and calculate intensities
for n=2:10
    slice = DyIms(imageBoundary,imageBoundary,n);
    DySpec(n-1)=median(slice(mask));
end

%load Sm only beads
SmIms = squeeze(MMparse_bioformats('Z:\NewImages\20140530\20140529-02_SmOnlyBeads_200ms_NoZOffset_1\20140529-02_SmOnlyBeads_200ms_NoZOffset_1_MMImages.ome.tif'));
%subtract dark field image
SmIms = double(SmIms) - repmat(darkIm, [1 1 size(SmIms, 3)]);
SmIms = bkgd_subtract(SmIms, 'estimate', bead_radius*3);

%use circular hough transform to find beads only in center quadrant of
%image
BFim = SmIms(imageBoundary,imageBoundary,1);
%need to look up what these params are, for now just mess with until all
%beads are found
[A,coords,CR] = CircularHough_Grd(BFim,[4 10],median(BFim(:))/5,3,1);

%plot results
clf
imshow(BFim,[])
hold on
for n=1:size(coords,1)
    plot(coords(n,1),coords(n,2),'r+')
end

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

%this field of view had a single Eu bead in it, need to remove that
contaminationMask = SmIms(imageBoundary,imageBoundary,8) > 1000;
mask = mask &~ contaminationMask;

%loop and calculate intensities
for n=2:10
    slice = SmIms(imageBoundary,imageBoundary,n);
    SmSpec(n-1)=median(slice(mask));
end

%load Tm only beads
TmIms = squeeze(MMparse_bioformats('Z:\NewImages\20140602\20140602-01_TmOnly_200ms_1\20140602-01_TmOnly_200ms_1_MMImages.ome.tif'));
TmIms = double(TmIms) - repmat(darkIm, [1 1 size(TmIms, 3)]);
TmIms = bkgd_subtract(TmIms, 'estimate', bead_radius*3);

%use circular hough transform to find beads only in center quadrant of
%image
BFim = TmIms(imageBoundary,imageBoundary,1);
%need to look up what these params are, for now just mess with until all
%beads are found
[A,coords,CR] = CircularHough_Grd(BFim,[4 10],median(BFim(:))/5,3,1);

%plot results
clf
imshow(BFim,[])
hold on
for n=1:size(coords,1)
    plot(coords(n,1),coords(n,2),'r+')
end

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

%loop and calculate intensities
for n=2:10
    slice = TmIms(imageBoundary,imageBoundary,n);
    TmSpec(n-1)=median(slice(mask));
end

%attempting to extract background from Tm images because actual code set
%images are too full
temp = TmIms(imageBoundary,imageBoundary,2:end);
for n=1:9
    slice = temp(60:100,60:100,n);
    BkgdSpec(n)=median(slice(:));
end

%following notation is element by element division
DySpec = DySpec./sum(DySpec);
SmSpec = SmSpec./sum(SmSpec);
EuSpec = EuSpec./sum(EuSpec);
TmSpec = TmSpec./sum(TmSpec);
BkgdSpec = BkgdSpec./sum(BkgdSpec);

%for now, just analyzing 24 code set
spectra = [DySpec;EuSpec;SmSpec;BkgdSpec]; %final spectrum array

% loading up first test image from 24 code set
codeIms = squeeze(MMparse_bioformats('Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_1\20140530-01_EuSmDy24LevelCodeSet_200ms_1_MMImages.ome.tif'));
codeIms = double(codeIms) - repmat(darkIm, [1 1 size(codeIms, 3)]);

%target values for ICP
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};

temp = codeIms(imageBoundary,imageBoundary,2:end);
[codeIms_u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(codeIms_u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);

beads_0602_1 = beadDataSet('oldimage', codeIms_u, CC, 2);
beads_0602_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_0602_1.Transform = ICP(beads_0602_1.getCodeRatio(:), target);
beads_0602_all = compositeBeadDataSet(beads_0602_1);

filelist = {'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_2\20140530-01_EuSmDy24LevelCodeSet_200ms_2_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_3\20140530-01_EuSmDy24LevelCodeSet_200ms_3_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_4\20140530-01_EuSmDy24LevelCodeSet_200ms_4_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_5\20140530-01_EuSmDy24LevelCodeSet_200ms_5_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_6\20140530-01_EuSmDy24LevelCodeSet_200ms_6_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_7\20140530-01_EuSmDy24LevelCodeSet_200ms_7_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_8\20140530-01_EuSmDy24LevelCodeSet_200ms_8_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_9\20140530-01_EuSmDy24LevelCodeSet_200ms_9_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_10\20140530-01_EuSmDy24LevelCodeSet_200ms_10_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_11\20140530-01_EuSmDy24LevelCodeSet_200ms_11_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-01_EuSmDy24LevelCodeSet_200ms_12\20140530-01_EuSmDy24LevelCodeSet_200ms_12_MMImages.ome.tif',
    };

figure
hold on
plot(beads_0602_1.getTransformedCodeRatio(:,lanthanideChannels.Dy),beads_0602_1.getTransformedCodeRatio(:,lanthanideChannels.Sm),'r.')

dsnum = 2;
for f=1:numel(filelist)
    rawim = squeeze(MMparse_bioformats(filelist{f}));
    rawim = double(rawim) - repmat(darkIm, [1 1 size(codeIms, 3)]);
    temp = rawim(imageBoundary,imageBoundary,2:end); %drop brightfield
    uname = ['codeIms_',sprintf('%d', dsnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    plot(temp_object.getTransformedCodeRatio(:,lanthanideChannels.Dy),temp_object.getTransformedCodeRatio(:,lanthanideChannels.Sm),'.','color',rand(1,3))
    beads_0602_all.add(temp_object);
    clear temp_object;
    dsnum = dsnum + 1;
end

%now calculate standard deviations
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)
        if vals(n)+vals(m) <= 1
            k(index,:)=[vals(n); vals(m)];
            index=index+1;
        end
    end
end

temp = beads_0602_all.getTransformedCodeRatio(:);
[Idx, beads0602_all_mean] = kmeans(temp,[],'start',k);

for n=1:size(beads0602_all_mean,1)
    list = Idx == n;
    beads0602_all_std(n,:)= std(temp(list,:),0,1);
end

% ran Kurt's levelSpacing code here in order to calculate the number of
% potential levels we should be able to resolve

% now attempting to analyze 4 code Tm set w 200 ms integration times
newSpectra = [DySpec;EuSpec;SmSpec;TmSpec;BkgdSpec]; %final spectrum array

% loading up first test image
tmCodeIms = squeeze(MMparse_bioformats('Z:\NewImages\20140602\20140530-02_Tm4LevelCodeSet_200ms_1\20140530-02_Tm4LevelCodeSet_200ms_1_MMImages.ome.tif'));
tmCodeIms = double(tmCodeIms) - repmat(darkIm, [1 1 size(tmCodeIms, 3)]);

%target values for ICP
tmVals = [0, 0.25, 0.5, 1];
target={tmVals};

temp = tmCodeIms(imageBoundary,imageBoundary,2:end);
[tmCodeIms_u,err] = unmix(temp, newSpectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(tmCodeIms_u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);

beads_0602_Tm_1 = beadDataSet_PMF('oldimage', tmCodeIms_u, CC, 2);
beads_0602_Tm_1.CodingChannels = [lanthanideChannels.Tm];
beads_0602_Tm_1.Transform = ICP(beads_0602_Tm_1.getCodeRatio(:), target);
beads_0602_Tm_all = compositeBeadDataSet(beads_0602_Tm_1);

filelist = {'Z:\NewImages\20140602\20140530-02_Tm4LevelCodeSet_200ms_2\20140530-02_Tm4LevelCodeSet_200ms_2_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-02_Tm4LevelCodeSet_200ms_3\20140530-02_Tm4LevelCodeSet_200ms_3_MMImages.ome.tif',
    'Z:\NewImages\20140602\20140530-02_Tm4LevelCodeSet_200ms_4\20140530-02_Tm4LevelCodeSet_200ms_4_MMImages.ome.tif'
    };

figure
hold on
xArray = zeros(size(beads_0602_Tm_1.getTransformedCodeRatio(:,lanthanideChannels.Tm)));
plot(xArray,beads_0602_Tm_1.getTransformedCodeRatio(:,lanthanideChannels.Tm),'r.')

dsnum = 2;
for f=1:numel(filelist)
    rawim = squeeze(MMparse_bioformats(filelist{f}));
    rawim = double(rawim) - repmat(darkIm, [1 1 size(codeIms, 3)]);
    temp = rawim(imageBoundary,imageBoundary,2:end); %drop brightfield
    uname = ['codeIms_',sprintf('%d', dsnum),'u'];
    [temp_unmixed, err] = unmix(temp, newSpectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet_PMF('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Tm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    xArray = zeros(size(temp_object.getCodeRatio(:,lanthanideChannels.Tm)));
    plot(xArray,temp_object.getTransformedCodeRatio(:,lanthanideChannels.Tm),'.','color',rand(1,3))
    beads_0602_Tm_all.add(temp_object);
    clear temp_object;
    dsnum = dsnum + 1;
end

%now calculate standard deviations
vals = [0, 0.25, 0.5, 1.0];
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)
        if vals(n)+vals(m) <= 1
            k(index,:)=[vals(n); vals(m)];
            index=index+1;
        end
    end
end

temp = beads_0602_Tm_1.getTransformedCodeRatio(:);
[IDX, beads0602_Tm_1_mean] = kmeans(temp,4);

for n=1:size(beads0602_Tm_1_mean,1)
    clear list
    list = IDX == n;
    beads0602_Tm_1_std(n,:)= std(temp(list));
end

temp = beads_0602_Tm_all.getTransformedCodeRatio(:);
[IDX, beads0602_Tm_all_mean] = kmeans(temp,4);

for n=1:size(beads0602_Tm_all_mean,1)
    clear list
    list = IDX == n;
    beads0602_Tm_all_std(n,:)= std(temp(list));
end

