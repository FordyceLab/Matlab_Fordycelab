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
dark_1s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_1s_1')));
newdark2_1s = mean(double(dark_1s),3);

dark_5s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_2s_1')));
newdark2_5s = mean(double(dark_5s),3);

dark_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_10ms_1')));
newdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'flatField_BF_10ms_1')));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 9]); %our best estimate of bias drift

clear dark_1s dark_5s flat_10ms dark_10ms %clear big data stacks

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

%load images and correct for dark and flat fields
M1105_1 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-01 Ex292_1')));
M1105_1 = double(M1105_1) - dark_stack;
temp = double(M1105_1(:,:,2:end)).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:9
    slice = temp(150:200,150:200,n);
    Device_spec_df(n) = median(double(slice(:)));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];

[M1105_1u,err] = unmix(temp, spectra_df);
err = nanmedian(abs(err(:)./double(temp(:))))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
% load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis','target4xbead.tif'));
maskDisk = ones(size(M1105_1(:,:,1),1),size(M1105_1(:,:,1),2));
for ii=1:size(maskDisk,1)
    for jj=1:size(maskDisk,2)
        if sqrt((ii-255)^2+(jj-268)^2) > 200
            maskDisk(ii,jj) = 0;
        end
    end
end
[coords, mask, CC] = xcorrFindBeads(M1105_1(:,:,8).*maskDisk, target4xbead, 4,0.7);
beads_M1105_1 = beadDataSet('oldimage', M1105_1u, CC, 2);
beads_M1105_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% beads_M1105_1.Transform = ICP(beads_M1105_1.getCodeRatio(:), target);
beads_M1105_1_1 = beads_M1105_1;
beads_M1105_all = compositeBeadDataSet(beads_M1105_1);
% 
% for fnum = 2:8
%     filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
%     rawim = squeeze(MMparse(filename));
%     rawim = double(rawim) - dark_stack;
%     temp = rawim(:,:,2:end).*corrim; %drop brightfield
%     uname = ['untreated_',sprintf('%d', fnum),'u'];
%     [temp_unmixed, err] = unmix(temp, spectra_df);
%     eval([uname ' = temp_unmixed;']); %copy over unmixed image
%     err = nanmedian(abs(err(:)./temp(:)))
%     [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*maskDisk, target4xbead, 4, 0.7);
%     size(coords,1)
%     temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
%     temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% %     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
%     beads_M1105_all.add(temp_object);
%     clear temp_object;
% end

%% Clean up each image separately

fnum = 2;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(200:250,200:250,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_2 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;
%%

fnum = 3;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(80:140,300:350,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_3 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;

%%

fnum = 4;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(350:450,250:350,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_4 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;
    
%%

fnum = 5;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(330:420,230:320,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_5 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;
    
%%

fnum = 6;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(250:320,250:320,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_6 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;
    
%%

fnum = 7;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(220:280,220:280,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    temp_maskDisk = maskDisk;
    temp_maskDisk(155:190,390:450)=0;
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*temp_maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_7 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;
    

%%

fnum = 8;
    filename = fullfile(imgFolder, '20121106', ['Beads20121105-01 Ex292_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end).*corrim; %drop brightfield
    
        %regen spectra with right dark correction on device autofluor
        %get device background
        for n=1:9
            slice = temp(90:200,190:300,n);
            Device_spec_df(n) = median(double(slice(:)));
        end
        Device_spec_df= Device_spec_df./sum(Device_spec_df);
        spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];
    
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    temp_maskDisk = maskDisk;
    temp_maskDisk(155:190,390:450)=0;
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,8).*temp_maskDisk, target4xbead, 4, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M1105_1_8 = temp_object;
    beads_M1105_all.add(temp_object);
    clear temp_object;
    
%%
% save('Analysis20121108_Tm_levels', 'beads_M1105_1_1', 'beads_M1105_1_2', 'beads_M1105_1_3', 'beads_M1105_1_4', 'beads_M1105_1_5', 'beads_M1105_1_6', 'beads_M1105_1_7', 'beads_M1105_1_8', 'beads_M1105_all');

%%
figure
beads_M1105_1_struct = {beads_M1105_1_1; beads_M1105_1_2; beads_M1105_1_3;beads_M1105_1_4;beads_M1105_1_5;beads_M1105_1_6;beads_M1105_1_7;beads_M1105_1_8};
for ii=1:8
    subplot(2,4,ii)
    plot(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)./max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)),'.')
    axis([1 beads_M1105_1_struct{ii}.NumBeads 0 1])
end

figure
plot(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),'.')
hold on
index = beads_M1105_1_struct{1}.NumBeads +1;
for ii=2:8
%     [beads_M1105_1_struct{ii-1}.NumBeads + 1:beads_M1105_1_struct{ii-1}.NumBeads + beads_M1105_1_struct{ii}.NumBeads]
    plot(index:index + beads_M1105_1_struct{ii}.NumBeads-1,beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)./max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)),'.')
    index = index + beads_M1105_1_struct{ii}.NumBeads;
end

