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
dark_2s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121206', 'dark_2s_1')));
newdark2_2s = mean(double(dark_2s),3);

dark_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_10ms_1')));
newdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121206', 'flatField_BF_10ms_1')));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 9]); %our best estimate of bias drift

clear dark_1s flat_10ms %clear big data stacks

dark_stack = repmat(newdark2_2s,[1 1 10]);
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
M1206_1 = squeeze(MMparse(fullfile(imgFolder, '20121206', 'Beads20121206-01 Ex292_2s_1')));
M1206_1 = double(M1206_1) - dark_stack;
temp = double(M1206_1(:,:,2:end)).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:9
    slice = temp(270:340,270:340,n);
    Device_spec_df(n) = median(double(slice(:)));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];


[M1206_1u,err] = unmix(temp, spectra_df);
err = nanmedian(abs(err(:)./double(temp(:))))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
% load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis','target4xbead.tif'));
maskDisk = ones(size(M1206_1(:,:,1),1),size(M1206_1(:,:,1),2));
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
[coords, mask, CC] = xcorrFindBeads(M1206_1(:,:,9).*maskDisk, target4xbead, 9,0.7);
beads_M1206_1 = beadDataSet('oldimage', M1206_1u, CC, 2);
beads_M1206_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% beads_M1129_2.Transform = ICP(beads_M1129_2.getCodeRatio(:), target);
beads_M1206_1_1 = beads_M1206_1;
beads_M1206_1_all = compositeBeadDataSet(beads_M1206_1);


beads_M1206_1_struct{1} = beads_M1206_1_1;
maskStruct{1} = mask;

images_M1206_1{1} = M1206_1;

for fnum = 2:6
    filename = fullfile(imgFolder, '20121206', ['Beads20121206-01 Ex292_2s_' sprintf('%d', fnum)]);
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
    beads_M1206_1_struct{fnum} = temp_object;
    maskStruct{fnum} = mask;
    images_M1206_1{fnum} = rawim;
    beads_M1206_1_all.add(temp_object);
    clear temp_object;
end


% I have used the code below for plotting purposes only. Further down there
% is code for the analysis of other beads.

%%

figure
plot(beads_M1206_1_struct{1}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1206_1_struct{1}.getRatio(:,lanthanideChannels.Dy)),'.')
hold on
index = beads_M1206_1_struct{1}.NumBeads +1;
for ii=2:6
%     [beads_M1129_2_struct{ii-1}.NumBeads + 1:beads_M1129_2_struct{ii-1}.NumBeads + beads_M1129_2_struct{ii}.NumBeads]
    plot(index:index + beads_M1206_1_struct{ii}.NumBeads-1,beads_M1206_1_struct{ii}.getRatio(:,lanthanideChannels.Dy)./max(beads_M1206_1_struct{ii}.getRatio(:,lanthanideChannels.Dy)),'.')
    index = index + beads_M1206_1_struct{ii}.NumBeads;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%

%reference spectra
load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis', 'ReferenceSpectra', '20121030_ex292.mat'));

%use 2nd set of dark images - they are more comparable to old dark images
%(camera probably wasn't cool enough on first set)
dark_2s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121206', 'dark_2s_1')));
newdark2_2s = mean(double(dark_2s),3);

dark_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_10ms_1')));
newdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121206', 'flatField_BF_10ms_1')));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 9]); %our best estimate of bias drift

clear dark_1s flat_10ms %clear big data stacks

dark_stack = repmat(newdark2_2s,[1 1 10]);
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
M1206_3 = squeeze(MMparse(fullfile(imgFolder, '20121206', 'Beads20121206-03 Ex292_2s_1')));
M1206_3 = double(M1206_3) - dark_stack;
temp = double(M1206_3(:,:,2:end)).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:9
    slice = temp(290:400,290:400,n);
    Device_spec_df(n) = median(double(slice(:)));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];


[M1206_3u,err] = unmix(temp, spectra_df);
err = nanmedian(abs(err(:)./double(temp(:))))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
% load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis','target4xbead.tif'));
maskDisk = ones(size(M1206_3(:,:,1),1),size(M1206_3(:,:,1),2));
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
[coords, mask, CC] = xcorrFindBeads(M1206_3(:,:,9).*maskDisk, target4xbead, 9,0.7);
beads_M1206_3 = beadDataSet('oldimage', M1206_3u, CC, 2);
beads_M1206_3.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% beads_M1129_2.Transform = ICP(beads_M1129_2.getCodeRatio(:), target);
beads_M1206_3_1 = beads_M1206_3;
beads_M1206_3_all = compositeBeadDataSet(beads_M1206_3);


beads_M1206_3_struct{1} = beads_M1206_3_1;
maskStruct{1} = mask;

images_M1206_3{1} = M1206_3;

for fnum = 2:5
    filename = fullfile(imgFolder, '20121206', ['Beads20121206-03 Ex292_2s_' sprintf('%d', fnum)]);
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
    beads_M1206_3_struct{fnum} = temp_object;
    maskStruct{fnum} = mask;
    images_M1206_3{fnum} = rawim;
    beads_M1206_3_all.add(temp_object);
    clear temp_object;
end


% I have used the code below for plotting purposes only. Further down there
% is code for the analysis of other beads.

%%

figure
plot(beads_M1206_3_struct{1}.getRatio(:,lanthanideChannels.Sm)./max(beads_M1206_3_struct{1}.getRatio(:,lanthanideChannels.Sm)),'.', 'color', 'r')
hold on
index = beads_M1206_3_struct{1}.NumBeads +1;
for ii=2:5
%     [beads_M1129_2_struct{ii-1}.NumBeads + 1:beads_M1129_2_struct{ii-1}.NumBeads + beads_M1129_2_struct{ii}.NumBeads]
    plot(index:index + beads_M1206_3_struct{ii}.NumBeads-1,beads_M1206_3_struct{ii}.getRatio(:,lanthanideChannels.Sm)./max(beads_M1206_3_struct{ii}.getRatio(:,lanthanideChannels.Sm)),'.', 'color', 'r')
    index = index + beads_M1206_3_struct{ii}.NumBeads;
end

for ii=1:5
    figure('name', ['Picture ' num2str(ii)]);
    plot(beads_M1206_3_struct{ii}.getRatio(:,lanthanideChannels.Sm)./max(beads_M1206_3_struct{ii}.getRatio(:,lanthanideChannels.Sm)),'.')
end
