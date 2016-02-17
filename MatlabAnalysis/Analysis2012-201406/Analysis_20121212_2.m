% Analysis of beads with Cy3 labeled peptides.

%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');

%%

dark_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_10ms_1')));
newdark_10ms = mean(double(dark_10ms),3);

% flat_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121209', 'flatField_BF_10ms_1')));
% mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 9]); %our best estimate of bias drift

clear dark_10ms flat_10ms %clear big data stacks

% dark_stack = repmat(newdark2_2s,[1 1 10]);
% % dark_stack(:,:,6:7) = repmat(newdark2_1s, [1 1 2]);
% 
% mnflat = zeros(size(mflat_10ms));
% %normalize each channel to mean of 1
% for n=1:size(mflat_10ms,3)
%     slice = mflat_10ms(:,:,n);
%     mnflat(:,:,n) = slice./mean(slice(:));
% end
% 
% meanim = mean(mnflat,3); %this is the mean intensity image
% 
% corrim = zeros(size(mnflat));
% for n=1:size(mnflat,3)
%     corrim(:,:,n) = meanim./mnflat(:,:,n);
% end
% 
% %target values for ICP
% vals = [0, 0.3, 0.70, 1];
% target={vals,vals,vals};

%%

%load images and correct for dark and flat fields
MoldBead_oldLinker_NOtween = squeeze(MMparse(fullfile(imgFolder, '20121212', 'Old bead - old linker - NO tween')));
MoldBead_oldLinker_NOtween = double(MoldBead_oldLinker_NOtween) - newdark_10ms;

preMask = ones(size(MoldBead_oldLinker_NOtween(:,:,1),1),size(MoldBead_oldLinker_NOtween(:,:,1),2));


%%
target4xbead = MoldBead_oldLinker_NOtween(408:425,148:165,1);
%%
[coords, mask, CC] = xcorrFindBeads(MoldBead_oldLinker_NOtween(:,:,1).*preMask, target4xbead, 8.5,0.8);
beadsPixels = regionprops(CC,MoldBead_oldLinker_NOtween(:,:,1), 'PixelValues', 'PixelIdxList');
beadsMeanIntensity = zeros(1,CC.NumObjects);
for ii = 1:CC.NumObjects
    beadsMeanIntensity(ii) = mean(beadsPixels(ii).PixelValues);
end

beadIntensityStruct{1,1} = 'Old bead - old linker - NO tween';
beadIntensityStruct{2,1} = 'Old bead - old linker - tween';
beadIntensityStruct{3,1} = 'Old bead - new linker - NO tween';
beadIntensityStruct{4,1} = 'Old bead - new linker - tween';
beadIntensityStruct{5,1} = 'Control - no linker - NO tween';
beadIntensityStruct{6,1} = 'Control - no linker - tween';

beadIntensityStruct{1,2} = beadsMeanIntensity;
imagesStruct{1} = MoldBead_oldLinker_NOtween;
maskStruc{1} = mask;
clear beadsMeanIntensity

for fnum = 2:6
    filename = fullfile(imgFolder, '20121212', beadIntensityStruct{fnum,1});
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - newdark_10ms;
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1).*preMask, target4xbead, 8.5, 0.8);
    size(coords,1)
    beadsPixels = regionprops(CC,rawim, 'PixelValues', 'PixelIdxList');
    beadsMeanIntensity = zeros(1,CC.NumObjects);
    for ii = 1:CC.NumObjects
        beadsMeanIntensity(ii) = mean(beadsPixels(ii).PixelValues);
    end
    beadIntensityStruct{fnum,2} = beadsMeanIntensity;
    imagesStruct{fnum} = rawim;
    maskStruct{fnum} = mask;
    clear temp_object;
end

target4xbead_tmep = imagesStruct{3}(247:269,176:198,1);
for fnum = 3:3
    filename = fullfile(imgFolder, '20121212', beadIntensityStruct{fnum,1});
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - newdark_10ms;
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1).*preMask, target4xbead_tmep, 8.5, 0.8);
    size(coords,1)
    beadsPixels = regionprops(CC,rawim, 'PixelValues', 'PixelIdxList');
    beadsMeanIntensity = zeros(1,CC.NumObjects);
    for ii = 1:CC.NumObjects
        beadsMeanIntensity(ii) = mean(beadsPixels(ii).PixelValues);
    end
    beadIntensityStruct{fnum,2} = beadsMeanIntensity;
    imagesStruct{fnum} = rawim;
    maskStruct{fnum} = mask;
    clear temp_object;
end

% I have used the code below for plotting purposes only. Further down there
% is code for the analysis of other beads.

%%
plotColors = {'blue' 'red' 'green' 'black' 'cyan' 'magenta'};

for ii = 1:6
    [n, out] = hist(beadIntensityStruct{ii,2});
    histData{ii} = {n out};
end
%%
figure('name', 'Cy3 labeled peptide linking test')
hold on
for ii = 1:6
    bar(histData{ii}{2}, histData{ii}{1},plotColors{ii})
end
%%
figure('name', 'Cy3 labeled peptide linking Tween NO-Tween test - Subplots')
for ii = 1:6
    subplot(2,3,ii)
    bar(histData{ii}{2}, histData{ii}{1},plotColors{ii})
    title(beadIntensityStruct{ii,1}, 'fontweight', 'bold', 'Fontsize', 16)
%     axis([0 1200 0 40])
end

subplot(2,3,1)
axis([0 3000 0 80])
subplot(2,3,2)
axis([0 3000 0 120])
subplot(2,3,3)
axis([0 3000 0 3])
subplot(2,3,4)
axis([0 3000 0 15])
subplot(2,3,5)
axis([0 3000 0 90])
subplot(2,3,6)
axis([0 3000 0 50])
%%
figure('name', 'Old bead - Old linker')
bar(histData{1}{2}, histData{1}{1},plotColors{1})
hold on
bar(histData{2}{2}, histData{2}{1},plotColors{2})
title(beadIntensityStruct{1,1}(1:end-10), 'fontweight', 'bold', 'Fontsize', 16)
legend(beadIntensityStruct{1,1}(end-8:end),beadIntensityStruct{2,1}(end-5:end))

figure('name', 'Old bead - New linker')
bar(histData{3}{2}, histData{3}{1},plotColors{3})
hold on
bar(histData{4}{2}, histData{4}{1},plotColors{4})
title(beadIntensityStruct{3,1}(1:end-10), 'fontweight', 'bold', 'Fontsize', 16)
legend(beadIntensityStruct{3,1}(end-8:end),beadIntensityStruct{4,1}(end-5:end))

figure('name', 'Control - no linker')
bar(histData{5}{2}, histData{5}{1},plotColors{5})
hold on
bar(histData{6}{2}, histData{6}{1},plotColors{6})
title(beadIntensityStruct{5,1}(1:end-10), 'fontweight', 'bold', 'Fontsize', 16)
legend(beadIntensityStruct{5,1}(end-8:end),beadIntensityStruct{6,1}(end-5:end))

%%
figure('name', 'Cy3 labeled peptide linking Tween NO-Tween test - Subplots')
subplot(1,3,1)
bar(histData{1}{2}, histData{1}{1},plotColors{1})
hold on
bar(histData{2}{2}, histData{2}{1},plotColors{2})
title(beadIntensityStruct{1,1}(1:end-10), 'fontweight', 'bold', 'Fontsize', 16)
legend(beadIntensityStruct{1,1}(end-8:end),beadIntensityStruct{2,1}(end-5:end))

subplot(1,3,2)
bar(histData{3}{2}, histData{3}{1},plotColors{3})
hold on
bar(histData{4}{2}, histData{4}{1},plotColors{4})
title(beadIntensityStruct{3,1}(1:end-10), 'fontweight', 'bold', 'Fontsize', 16)
legend(beadIntensityStruct{3,1}(end-8:end),beadIntensityStruct{4,1}(end-5:end))

subplot(1,3,3)
bar(histData{5}{2}, histData{5}{1},plotColors{5})
hold on
bar(histData{6}{2}, histData{6}{1},plotColors{6})
title(beadIntensityStruct{5,1}(1:end-10), 'fontweight', 'bold', 'Fontsize', 16)
legend(beadIntensityStruct{5,1}(end-8:end),beadIntensityStruct{6,1}(end-5:end))

