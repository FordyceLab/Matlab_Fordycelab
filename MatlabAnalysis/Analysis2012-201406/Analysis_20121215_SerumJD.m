%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');


%%
% 
% dark_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_10ms_1')));
% newdark_10ms = mean(double(dark_10ms),3);
% 
% dark_2s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121215', 'dark_2s_1')));
% newdark_2s = mean(double(dark_2s),3);
% 
% dark_5s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121215', 'dark_5s_1')));
% newdark_5s = mean(double(dark_5s),3);
% 
% flat_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121215', 'flatField_BF_10ms_1')));
% mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 6]); %our best estimate of bias drift
% 
% clear newdark_10ms newdark_5s newdark_2s flat_10ms %clear big data stacks
%%

% dark_stack(:,:,1) = newdark_2s;
% dark_stack(:,:,2:6) = repmat(newdark_5s, [1 1 5]);
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
% vals = [0, 0.3, 0.5, 0.70, 1];
% target={vals,vals,vals};
%%


load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis', 'ReferenceSpectra', '20121030_ex292.mat'));
%we are using 435, 572, 620, 630, and 650 filters
%drop channels 2, 3, 4, 5


Ln_spectra = [Dy_spec./sum(Dy_spec);Eu_spec./sum(Eu_spec);Sm_spec./sum(Sm_spec)];
Ln_spectra(:, 2:5) = [];
%%

SerumJD_1 = squeeze(MMparse(fullfile(imgFolder, '20121215', 'Serum_JD2__1')));
SerumJD_1(:,:,2:7) = double(SerumJD_1(:,:,2:7));
temp = double(SerumJD_1(:,:,3:end));

for n=1:5
    slice = temp(100:190,365:475,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra = [Ln_spectra;Device_spec_df];

[SerumJDu,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))

%find beads
BFim = double(SerumJD_1(:,:,1));
% BFim(1:110,:)=median(BFim(:));
preMask = ones(size(BFim(:,:),1),size(BFim(:,:),2));
% preMask(130:150,52:80) = 0;
% preMask(293:300,170:178) = 0;

[A,coords,CR] = CircularHough_Grd(BFim(:,1:486),[8 11],50,3,1);
figure('name','Serum_JD_1')
imshow(BFim,[])
hold on
for n=1:size(coords,1)
    plot(coords(n,1),coords(n,2),'r+')
    text(coords(n,1),coords(n,2),num2str(n))
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
beads_SerumJD_1 = beadDataSet('oldimage', SerumJDu, CC, 2);
beads_SerumJD_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];

CCStruct{1} = CC;
imagesStruct{1} = SerumJD_1;

beads_SerumJD_all = compositeBeadDataSet(beads_SerumJD_1);

%%
for ii = 2:5
    clear CC mask coords rawim temp temp_unmixed err BFim A CR X Y newbead
    rawim = squeeze(MMparse(fullfile(imgFolder, '20121215', ['Serum_JD2__' num2str(ii)])));
    rawim(:,:,2:7) = double(rawim(:,:,2:7));
    temp = double(rawim(:,:,3:end));
    [temp_unmixed,err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))

    %find beads
    BFim = double(rawim(:,:,1));
    % BFim(1:110,:)=median(BFim(:));
    figure('name', ['Serum_JD_' num2str(ii)])
    switch ii
        case 3
            BFim(246:252,29:36) = median(BFim(:));
            BFim(229:235,59:64) = median(BFim(:));
            BFim(94:124,146:152) = median(BFim(:));
            BFim(272:288,147:165) = median(BFim(:));
            BFim(72:80,361:369) = median(BFim(:));
            BFim(:,487:end) = median(BFim(:));
        case 4
            BFim(307:321,192:213) = median(BFim(:));
            BFim(321:327,203:211) = median(BFim(:));
            BFim(251:264,214:265) = median(BFim(:));
            BFim(134:369,486:end) = median(BFim(:));
        case 5
            BFim(:,487:end) = median(BFim(:));          
    end
            
    [A,coords,CR] = CircularHough_Grd(BFim(:,:),[8 11],50,3,1);
    imshow(rawim(:,:,1),[])
    hold on
    for n=1:size(coords,1)
        plot(coords(n,1),coords(n,2),'r+')
        text(coords(n,1),coords(n,2),num2str(n))
    end

    %build mask and CC
    CC.Connectivity = 4;
    CC.ImageSize = size(BFim);
    CC.NumObjects = size(coords,1);
    [X,Y]=meshgrid(1:size(BFim,2),1:size(BFim,1));
    mask = zeros(size(BFim));
    for n=1:size(coords,1)
        newbead = (((X-coords(n,1)).^2 + (Y-coords(n,2)).^2)<=thresh);
        mask = mask | newbead;
        CC.PixelIdxList{n} = find(newbead);
    end
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_SerumJD_all.add(temp_object);
    CCStruct{ii} = CC;
    imagesStruct{ii} = rawim;
    clear temp_object;
end

%%
figure
hold on
beadsPixels = regionprops(CC,SerumJD_1(:,:,2), 'PixelValues', 'PixelIdxList');
beadsCy5Intensity = zeros(1,CC.NumObjects);
for ii = 1:CC.NumObjects
    beadsCy5Intensity(ii) = mean(beadsPixels(ii).PixelValues);
end

for ii = 1:CC.NumObjects
    color = beadsCy5Intensity(ii)/max(beadsCy5Intensity);
    plot(beads_SerumJD_1.getRatio(:,lanthanideChannels.Dy), beads_SerumJD_1.getRatio(:,lanthanideChannels.Sm),'.', 'color', [color 0 0])
end

%%
figure('name','Serum experiment 2012.12.15 - JD')
hold on
goodBeads{1} = setdiff([1:1:beads_SerumJD_all.ComponentHandles(1).NumBeads],[16 43 106 77 60 59]);
goodBeads{2} = [1:1:beads_SerumJD_all.ComponentHandles(2).NumBeads];
goodBeads{3} = setdiff([1:1:beads_SerumJD_all.ComponentHandles(3).NumBeads],[5 28 29]);
goodBeads{4} = setdiff([1:1:beads_SerumJD_all.ComponentHandles(4).NumBeads], [182 160 173]);
goodBeads{5} = setdiff([1:1:beads_SerumJD_all.ComponentHandles(5).NumBeads], [29 81 99 93 168 166 172 138 140 117 130 152 131 205 204 155 159 36]);

for ii = 1:5
    plot(beads_SerumJD_all.ComponentHandles(ii).getRatio(goodBeads{ii},lanthanideChannels.Dy),beads_SerumJD_all.ComponentHandles(ii).getRatio(goodBeads{ii},lanthanideChannels.Sm),'.', 'color','r')
end

title('Serum experiment 2012.12.15 - JD', 'fontsize', 16, 'fontweight', 'bold')
xlabel('Dy Ratio', 'fontsize', 14, 'fontweight', 'bold')
ylabel('Sm Ratio', 'fontsize', 14, 'fontweight', 'bold')


%%
figure
hold on
for ii = 1:10
    plot(beads_SerumJD_all.ComponentHandles(ii).getRatio(:,lanthanideChannels.Dy)./max(beads_SerumJD_all.ComponentHandles(ii).getRatio(:,lanthanideChannels.Dy)),beads_SerumJD_all.ComponentHandles(ii).getRatio(:,lanthanideChannels.Sm)./max(beads_SerumJD_all.ComponentHandles(ii).getRatio(:,lanthanideChannels.Dy)),'.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Extract Cy5 intensity
for jj = 1:5
    counter = 1;
    beadsPixels = regionprops(CCStruct{jj},imagesStruct{jj}(:,:,2), 'PixelValues', 'PixelIdxList');
    beadsMeanCy5Intensity{jj} = [];
    for ii = goodBeads{jj}
        beadsMeanCy5Intensity{jj}(counter) = mean(beadsPixels(ii).PixelValues);
        counter = counter + 1;
    end
end



allDyIntensities = [beads_SerumJD_all.ComponentHandles(1).getRatio(goodBeads{1},lanthanideChannels.Dy)]';
allDyIntensities = [allDyIntensities beads_SerumJD_all.ComponentHandles(2).getRatio(goodBeads{2},lanthanideChannels.Dy)'];
allDyIntensities = [allDyIntensities beads_SerumJD_all.ComponentHandles(3).getRatio(goodBeads{3},lanthanideChannels.Dy)'];
allDyIntensities = [allDyIntensities beads_SerumJD_all.ComponentHandles(4).getRatio(goodBeads{4},lanthanideChannels.Dy)'];
allDyIntensities = [allDyIntensities beads_SerumJD_all.ComponentHandles(5).getRatio(goodBeads{5},lanthanideChannels.Dy)'];

allSmIntensities = [beads_SerumJD_all.ComponentHandles(1).getRatio(goodBeads{1},lanthanideChannels.Sm)]';
allSmIntensities = [allSmIntensities beads_SerumJD_all.ComponentHandles(2).getRatio(goodBeads{2},lanthanideChannels.Sm)'];
allSmIntensities = [allSmIntensities beads_SerumJD_all.ComponentHandles(3).getRatio(goodBeads{3},lanthanideChannels.Sm)'];
allSmIntensities = [allSmIntensities beads_SerumJD_all.ComponentHandles(4).getRatio(goodBeads{4},lanthanideChannels.Sm)'];
allSmIntensities = [allSmIntensities beads_SerumJD_all.ComponentHandles(5).getRatio(goodBeads{5},lanthanideChannels.Sm)'];

allCy5Intensities = beadsMeanCy5Intensity{1};
for ii = 2:5
    allCy5Intensities = [allCy5Intensities beadsMeanCy5Intensity{ii}];
end

beadIntensitiesCode1 = [];
beadIntensitiesCode4 = [];
beadIntensitiesCode5 = [];
beadIntensitiesCode6 = [];
beadIntensitiesCode7 = [];
beadIntensitiesCode8 = [];
beadIntensitiesCode13 = [];

counter = 1;
for ii = 1: length(allDyIntensities)
    if (allDyIntensities(ii) > -0.2 && allDyIntensities(ii) <-0.03) && allSmIntensities(ii)<0
        beadIntensitiesCode1(counter,1) = ii;
        beadIntensitiesCode1(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode1(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode1(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

counter = 1;
for ii = 1: length(allDyIntensities)
    if allDyIntensities(ii) >0.3 && allSmIntensities(ii)<0
        beadIntensitiesCode4(counter,1) = ii;
        beadIntensitiesCode4(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode4(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode4(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

counter = 1;
for ii = 1: length(allDyIntensities)
    if (allDyIntensities(ii) > 0.1 && allDyIntensities(ii) <0.2) && allSmIntensities(ii)<0
        beadIntensitiesCode5(counter,1) = ii;
        beadIntensitiesCode5(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode5(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode5(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

counter = 1;
for ii = 1: length(allDyIntensities)
    if (allDyIntensities(ii) > -0.02 && allDyIntensities(ii) <0.1) && allSmIntensities(ii)<0
        beadIntensitiesCode6(counter,1) = ii;
        beadIntensitiesCode6(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode6(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode6(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

counter = 1;
for ii = 1: length(allDyIntensities)
    if allDyIntensities(ii) <-0.2 && allSmIntensities(ii)>0.5
        beadIntensitiesCode7(counter,1) = ii;
        beadIntensitiesCode7(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode7(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode7(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

counter = 1;
for ii = 1: length(allDyIntensities)
    if (allDyIntensities(ii) > -0.2 && allDyIntensities(ii) <-0.02) && (allSmIntensities(ii) > 0 && allSmIntensities(ii)<0.5)
        beadIntensitiesCode8(counter,1) = ii;
        beadIntensitiesCode8(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode8(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode8(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

counter = 1;
for ii = 1: length(allDyIntensities)
    if (allDyIntensities(ii) > 0.1 && allDyIntensities(ii) <0.3) && (allSmIntensities(ii) > 0 && allSmIntensities(ii)<0.5)
        beadIntensitiesCode13(counter,1) = ii;
        beadIntensitiesCode13(counter,2) = allDyIntensities(ii);
        beadIntensitiesCode13(counter,3) = allSmIntensities(ii);
        beadIntensitiesCode13(counter,4) = allCy5Intensities(ii);
        counter = counter + 1;
    end
end

figure('name', '7 codes')
plot(beadIntensitiesCode1(:,2), beadIntensitiesCode1(:,3),'.')
axis([-0.8 0.6 -0.2 1.4])
hold on
plot(beadIntensitiesCode4(:,2), beadIntensitiesCode4(:,3),'.', 'color', 'r')
plot(beadIntensitiesCode5(:,2), beadIntensitiesCode5(:,3),'.', 'color', 'g')
plot(beadIntensitiesCode6(:,2), beadIntensitiesCode6(:,3),'.', 'color', 'y')
plot(beadIntensitiesCode7(:,2), beadIntensitiesCode7(:,3),'.', 'color', 'c')
plot(beadIntensitiesCode8(:,2), beadIntensitiesCode8(:,3),'.', 'color', 'm')
plot(beadIntensitiesCode13(:,2), beadIntensitiesCode13(:,3),'.', 'color', 'b')
plot(beadIntensitiesCode13(:,2), beadIntensitiesCode13(:,3),'.', 'color', 'black')

title('Identified codes SerumJD', 'fontsize', 16, 'fontweight', 'bold')
xlabel('Dy Ratio', 'fontsize', 14, 'fontweight', 'bold')
ylabel('Sm Ratio', 'fontsize', 14, 'fontweight', 'bold')

%%
beadIntensitiesStruct{1,1} = 'Code 1';
beadIntensitiesStruct{2,1} = 'Code 4';
beadIntensitiesStruct{3,1} = 'Code 5';
beadIntensitiesStruct{4,1} = 'Code 6';
beadIntensitiesStruct{5,1} = 'Code 7';
beadIntensitiesStruct{6,1} = 'Code 8';
beadIntensitiesStruct{7,1} = 'Code 13';

for ii = 1:length(beadIntensitiesCode1)
    beadIntensitiesCode1(ii,5) = 1;
end

for ii = 1:length(beadIntensitiesCode4)
    beadIntensitiesCode4(ii,5) = 4;
end

for ii = 1:length(beadIntensitiesCode5)
    beadIntensitiesCode5(ii,5) = 5;
end

for ii = 1:length(beadIntensitiesCode6)
    beadIntensitiesCode6(ii,5) = 6;
end

for ii = 1:length(beadIntensitiesCode7)
    beadIntensitiesCode7(ii,5) = 7;
end

for ii = 1:length(beadIntensitiesCode8)
    beadIntensitiesCode8(ii,5) = 8;
end

for ii = 1:length(beadIntensitiesCode13)
    beadIntensitiesCode13(ii,5) = 13;
end

beadIntensitiesStruct{1,2} = beadIntensitiesCode1;
beadIntensitiesStruct{2,2} = beadIntensitiesCode4;
beadIntensitiesStruct{3,2} = beadIntensitiesCode5;
beadIntensitiesStruct{4,2} = beadIntensitiesCode6;
beadIntensitiesStruct{5,2} = beadIntensitiesCode7;
beadIntensitiesStruct{6,2} = beadIntensitiesCode8;
beadIntensitiesStruct{7,2} = beadIntensitiesCode13;


cy5Means = zeros(1,7);
cy5Std = zeros(1,7);
for ii = 1:7
    cy5Means(ii) = median(double(beadIntensitiesStruct{ii,2}(:,4)));
    cy5Std(ii) = std(double(beadIntensitiesStruct{ii,2}(:,4)));
end

figure('name', 'Mean Cy5 intensities of Serum JD')
plot(cy5Means,'.','markersize', 40)
errorbar(1:7,cy5Means,cy5Std, '.','color', 'red')
title('Mean Cy5 intensity of Serum JD on each code', 'fontsize', 16, 'fontweight', 'bold')
xlabel('Code', 'fontsize', 14, 'fontweight', 'bold')
ylabel('Mean intensity', 'fontsize', 14, 'fontweight', 'bold')

%%
data2Save = beadIntensitiesStruct{1,2};
for ii = 2:7
    data2Save = [data2Save; beadIntensitiesStruct{ii,2}];
end
        
xlswrite('SerumJD intensities per code',data2Save);



