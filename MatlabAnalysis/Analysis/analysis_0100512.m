%reference spectra
load('Z:\Images\021512\reference_spectra.mat');

%use 2nd set of dark images - they are more comparable to old dark images
%(camera probably wasn't cool enough on first set)
dark_1s = squeeze(MMparse('Z:\Images\080312\dark_1s_2'));
newdark2_1s = mean(double(dark_1s),3);

dark_5s = squeeze(MMparse('Z:\Images\080312\dark_5s_2'));
newdark2_5s = mean(double(dark_5s),3);

dark_10ms = squeeze(MMparse('Z:\Images\080312\dark_10ms_1'));
newdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse('Z:\Images\080312\Flat_10ms_1'));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 6]) - 10.5; %our best estimate of bias drift

clear dark_1s dark_5s flat_10ms dark_10ms %clear big data stacks

dark_stack = repmat(newdark2_5s,[1 1 5]);
dark_stack(:,:,6:7) = repmat(newdark2_1s, [1 1 2]);

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
target={vals, vals};

%load images and correct for dark and flat fields

M0907_1 = squeeze(MMparse('Z:\Images\100512\Beads20120907-04_1'));
M0907_1 = double(M0907_1) - dark_stack;
temp = M0907_1(:,:,2:7).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(190:450,10:100,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec_df];

[M0907_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
[coords, mask, CC] = xcorrFindBeads(M0907_1(:,:,1), target4xbead, 5);
beads_M0907_1 = beadDataSet('oldimage', M0907_1u, CC, 2);
beads_M0907_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0907_1.Transform = ICP(beads_M0907_1.getCodeRatio(:), target);
beads_M0907_all = compositeBeadDataSet(beads_M0907_1);

for fnum = 2:4
    filename = ['Z:\Images\100512\Beads20120907-04_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M0907_all.add(temp_object);
    clear temp_object;
end

M0914_1 = squeeze(MMparse('Z:\Images\100512\Beads20120914-01_1'));
M0914_1 = double(M0914_1) - dark_stack;
temp = M0914_1(:,:,2:7).*corrim; %drop brightfield
[M0914_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0914_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
%[coords, mask, CC] = xcorrFindBeads(M0914_1(:,:,1), target4xbead, 5);
beads_M0914_1 = beadDataSet('oldimage', M0914_1u, CC, 2);
beads_M0914_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0914_1.Transform = ICP(beads_M0914_1.getCodeRatio(:), target);
beads_M0914_all = compositeBeadDataSet(beads_M0914_1);

for fnum = 2:3
    filename = ['Z:\Images\100512\Beads20120914-01_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    %uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    %eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    %[coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead, 5);
    %size(coords,1)
    mask = gen_bead_mask2(temp_unmixed(:,:,2),7,-0.03);
    CC = bwconncomp(mask,4);
    CC.NumObjects    
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
    beads_M0914_all.add(temp_object);
    clear temp_object;
end

M0917_1 = squeeze(MMparse('Z:\Images\100512\Beads20120917-02_1'));
M0917_1 = double(M0917_1) - dark_stack;
temp = M0917_1(:,:,2:7).*corrim; %drop brightfield
[M0917_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0917_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
%[coords, mask, CC] = xcorrFindBeads(M0917_1(:,:,1), target4xbead, 5);
beads_M0917_1 = beadDataSet('oldimage', M0917_1u, CC, 2);
beads_M0917_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0917_1.Transform = ICP(beads_M0917_1.getCodeRatio(:), target);
beads_M0917_all = compositeBeadDataSet(beads_M0917_1);

M0917_2 = squeeze(MMparse('Z:\Images\100512\Beads20120917-02_2'));
M0917_2 = double(M0917_2) - dark_stack;
temp = M0917_2(:,:,2:7).*corrim; %drop brightfield
[M0917_2u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0917_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
%[coords, mask, CC] = xcorrFindBeads(M0917_2(:,:,1), target4xbead, 5);
beads_M0917_2 = beadDataSet('oldimage', M0917_2u, CC, 2);
beads_M0917_2.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0917_2.Transform = ICP(beads_M0917_2.getCodeRatio(:), target);
beads_M0917_all.add(beads_M0917_2);



M1003_1 = squeeze(MMparse('Z:\Images\100512\Beads20121003-01_1'));
M1003_1 = double(M1003_1) - dark_stack;
temp = M1003_1(:,:,2:7).*corrim; %drop brightfield
[M1003_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M1003_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
%[coords, mask, CC] = xcorrFindBeads(M1003_1(:,:,1), target4xbead, 5);
beads_M1003_1 = beadDataSet('oldimage', M1003_1u, CC, 2);
beads_M1003_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M1003_1.Transform = ICP(beads_M1003_1.getCodeRatio(:), target);
beads_M1003_all = compositeBeadDataSet(beads_M1003_1);

M1003_2 = squeeze(MMparse('Z:\Images\100512\Beads20121003-01_2'));
M1003_2 = double(M1003_2) - dark_stack;
temp = M1003_2(:,:,2:7).*corrim; %drop brightfield
[M1003_2u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M1003_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
%[coords, mask, CC] = xcorrFindBeads(M1003_2(:,:,1), target4xbead, 5);
beads_M1003_2 = beadDataSet('oldimage', M1003_2u, CC, 2);
beads_M1003_2.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M1003_2.Transform = ICP(beads_M1003_2.getCodeRatio(:), target);
beads_M1003_all.add(beads_M1003_2);
