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

M0706_292_1 = squeeze(MMparse('Z:\Images\080312\Beads20120706-02 0psi_1'));
M0706_292_1 = double(M0706_292_1) - dark_stack;
temp = M0706_292_1(:,:,2:7).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(140:330,10:120,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec_df];

[M0706_292_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0706_292_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
beads_M0706_292_1 = beadDataSet('oldimage', M0706_292_1u, CC, 2);
beads_M0706_292_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0706_292_1.Transform = ICP(beads_M0706_292_1.getCodeRatio(:), target);
beads_M0130df_all = compositeBeadDataSet(beads_M0706_292_1);