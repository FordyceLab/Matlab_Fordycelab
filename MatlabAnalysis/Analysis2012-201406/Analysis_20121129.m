%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');

%%

%reference spectra
load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis', 'ReferenceSpectra', '20121030_ex292.mat'));

%use 2nd set of dark images - they are more comparable to old dark images
%(camera probably wasn't cool enough on first set)
dark_1s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121129', 'dark_1s_1')));
newdark2_1s = mean(double(dark_1s),3);

dark_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_10ms_1')));
newdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'flatField_BF_10ms_1')));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 9]); %our best estimate of bias drift

clear dark_1s flat_10ms %clear big data stacks

dark_stack = repmat(newdark2_1s,[1 1 10]);
% dark_stack(:,:,6:7) = repmat(newdark2_1s, [1 1 2]);

mnflat = zeros(size(mflat_10ms));
%normalize each channel to mean of 1
for n=1:size(mflat_10ms,3)
    slice = mflat_10ms(:,:,n);
    mnflat(:,:,n) = slice./mean(slice(:));
end

meanim = mean(mnflat,3); %this is the mean intensity image

corrim = zeros(size(mnflat));
for n=1:size(mnflat,3)
    corrim(:,:,n) = meanim./mnflat(:,:,n);
end

%target values for ICP
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals,vals,vals};
%%
%load images and correct for dark and flat fields
M1129_2 = squeeze(MMparse(fullfile(imgFolder, '20121129', 'Beads20121129-02 Ex292_1')));
M1129_2 = double(M1129_2) - dark_stack;
temp = double(M1129_2(:,:,2:end)).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:9
    slice = temp(380:480,380:480,n);
    Device_spec_df(n) = median(double(slice(:)));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];


[M1129_2u,err] = unmix(temp, spectra_df);
err = nanmedian(abs(err(:)./double(temp(:))))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
% load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis','target4xbead.tif'));
maskDisk = ones(size(M1129_2(:,:,1),1),size(M1129_2(:,:,1),2));
for ii=1:size(maskDisk,1)
    for jj=1:size(maskDisk,2)
        if sqrt((ii-258)^2+(jj-258)^2) > 185
            maskDisk(ii,jj) = 0;
        end
    end
end

%%
load('target4xAcrylamideBead.mat');
%%
[coords, mask, CC] = xcorrFindBeads(M1129_2(:,:,9).*maskDisk, target4xbead, 9,0.7);
beads_M1129_2 = beadDataSet('oldimage', M1129_2u, CC, 2);
beads_M1129_2.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% beads_M1129_2.Transform = ICP(beads_M1129_2.getCodeRatio(:), target);
beads_M1129_2_1 = beads_M1129_2;
beads_M1129_2_all = compositeBeadDataSet(beads_M1129_2);


beads_M1129_2_struct{1} = beads_M1129_2_1;
maskStruct{1} = mask;

images_M1129_2{1} = M1129_2;

for fnum = 2:12
    filename = fullfile(imgFolder, '20121129', ['Beads20121129-02 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,9).*maskDisk, target4xbead, 9, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1129_2_struct{fnum} = temp_object;
    maskStruct{fnum} = mask;
    images_M1129_2{fnum} = rawim;
    beads_M1129_2_all.add(temp_object);
    clear temp_object;
end


% I have used the code below for plotting purposes only. Further down there
% is code for the analysis of other beads.

%%
figure
for ii=1:12
    subplot(2,6,ii)
    plot(beads_M1129_2_struct{ii}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1129_2_struct{ii}.getRatio(:,lanthanideChannels.Dy)),'.')
    axis([1 beads_M1129_2_struct{ii}.NumBeads 0 1])
end

figure
plot(beads_M1129_2_struct{1}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1129_2_struct{1}.getRatio(:,lanthanideChannels.Dy)),'.')
hold on
index = beads_M1129_2_struct{1}.NumBeads +1;
for ii=2:12
%     [beads_M1129_2_struct{ii-1}.NumBeads + 1:beads_M1129_2_struct{ii-1}.NumBeads + beads_M1129_2_struct{ii}.NumBeads]
    plot(index:index + beads_M1129_2_struct{ii}.NumBeads-1,beads_M1129_2_struct{ii}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1129_2_struct{ii}.getRatio(:,lanthanideChannels.Dy)),'.')
    index = index + beads_M1129_2_struct{ii}.NumBeads;
end

%%
ii = 1;
%%
figure(8);
imshow(images_M1129_2{ii}(:,:,9).*maskStruct{ii},[0 5000])
figure(9)
imshow(maskStruct{ii})

ii=ii+1;
%%

figure
for ii=1:beads_M1129_2_struct{1}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{1}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{1}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii,beads_M1129_2_struct{1}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{1}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii,beads_M1129_2_struct{1}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{1}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{2}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{2}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{2}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30,beads_M1129_2_struct{2}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{2}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'g')
    text(ii+30,beads_M1129_2_struct{2}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{2}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{3}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{3}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{3}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23,beads_M1129_2_struct{3}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{3}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23,beads_M1129_2_struct{3}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{3}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end


for ii=1:beads_M1129_2_struct{4}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{4}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{4}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17,beads_M1129_2_struct{4}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{4}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'g')
    text(ii+30+23+17,beads_M1129_2_struct{4}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{4}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{5}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{5}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{5}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18,beads_M1129_2_struct{5}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{5}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23+17+18,beads_M1129_2_struct{5}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{5}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{6}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{6}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{6}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38,beads_M1129_2_struct{6}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{6}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'g')
    text(ii+30+23+17+18+38,beads_M1129_2_struct{6}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{6}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{7}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{7}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{7}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38+44,beads_M1129_2_struct{7}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{7}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23+17+18+38+44,beads_M1129_2_struct{7}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{7}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{8}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{8}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{8}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38+44+26,beads_M1129_2_struct{8}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{8}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'g')
    text(ii+30+23+17+18+38+44+26,beads_M1129_2_struct{8}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{8}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{9}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{9}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{9}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38+44+26+15,beads_M1129_2_struct{9}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{9}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23+17+18+38+44+26+15,beads_M1129_2_struct{9}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{9}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{10}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{10}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{10}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38+44+26+15+18,beads_M1129_2_struct{10}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{10}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23+17+18+38+44+26+15+18,beads_M1129_2_struct{10}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{10}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{11}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{11}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{11}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38+44+26+15+18+65,beads_M1129_2_struct{11}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{11}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23+17+18+38+44+26+15+18+65,beads_M1129_2_struct{11}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{11}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1129_2_struct{12}.NumBeads
    relCentroid = sqrt((beads_M1129_2_struct{12}.Centroid(ii,1)-226)^2 + (beads_M1129_2_struct{12}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+30+23+17+18+38+44+26+15+18+65+10,beads_M1129_2_struct{12}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{12}.getRatio(:,lanthanideChannels.Dy)),'.', 'color', 'b')
    text(ii+30+23+17+18+38+44+26+15+18+65+10,beads_M1129_2_struct{12}.getRatio(ii,lanthanideChannels.Dy)./max(beads_M1129_2_struct{12}.getRatio(:,lanthanideChannels.Dy)),num2str(ii), 'color', 'r')
    hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%


%load images and correct for dark and flat fields
M1129_1 = squeeze(MMparse(fullfile(imgFolder, '20121129', 'Beads20121129-02 Ex292_1')));
M1129_1 = double(M1129_1) - dark_stack;
temp = double(M1129_1(:,:,2:end)).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:9
    slice = temp(250:300,110:180,n);
    Device_spec_df(n) = median(double(slice(:)));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];


[M1129_1u,err] = unmix(temp, spectra_df);
err = nanmedian(abs(err(:)./double(temp(:))))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
% load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis','target4xbead.tif'));
maskDisk = ones(size(M1129_1(:,:,1),1),size(M1129_1(:,:,1),2));
for ii=1:size(maskDisk,1)
    for jj=1:size(maskDisk,2)
        if sqrt((ii-258)^2+(jj-258)^2) > 185
            maskDisk(ii,jj) = 0;
        end
    end
end

%%
target4xbead = M1129_1(241:261,229:249,8);
%%
[coords, mask, CC] = xcorrFindBeads(M1129_1(:,:,8).*maskDisk, target4xbead, 9,0.7);
beads_M1129_1 = beadDataSet('oldimage', M1129_1u, CC, 2);
beads_M1129_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% beads_M1129_1.Transform = ICP(beads_M1129_1.getCodeRatio(:), target);
beads_M1129_1_1 = beads_M1129_1;
beads_M1129_1_all = compositeBeadDataSet(beads_M1129_1);


beads_M1129_1_struct{1} = beads_M1129_1_1;
maskStruct{1} = mask;

images_M1129_1{1} = M1129_1;

for fnum = 2:10
    filename = fullfile(imgFolder, '20121129', ['Beads20121129-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,9).*maskDisk, target4xbead, 9, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1129_1_struct{fnum} = temp_object;
    maskStruct{fnum} = mask;
    images_M1129_1{fnum} = rawim;
    beads_M1129_1_all.add(temp_object);
    clear temp_object;
end

%%
figure
for ii=1:10
    subplot(2,6,ii)
    plot(beads_M1129_1_struct{ii}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1129_1_struct{ii}.getRatio(:,lanthanideChannels.Dy)),'.')
    axis([1 beads_M1129_1_struct{ii}.NumBeads 0 1])
end

figure
plot(beads_M1129_1_struct{1}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1129_1_struct{1}.getRatio(:,lanthanideChannels.Dy)),'.')
hold on
index = beads_M1129_1_struct{1}.NumBeads +1;
for ii=2:10
%     [beads_M1129_1_struct{ii-1}.NumBeads + 1:beads_M1129_1_struct{ii-1}.NumBeads + beads_M1129_1_struct{ii}.NumBeads]
    plot(index:index + beads_M1129_1_struct{ii}.NumBeads-1,beads_M1129_1_struct{ii}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1129_1_struct{ii}.getRatio(:,lanthanideChannels.Dy)),'.')
    index = index + beads_M1129_1_struct{ii}.NumBeads;
end

%%
ii = 1;
%%
figure(80);
imshow(images_M1129_1{ii}(:,:,9).*maskStruct{ii},[0 5000])
figure(90)
imshow(maskStruct{ii})

ii=ii+1;
