dark_1s = squeeze(MMparse('Z:\Images\021512\dark_1sec_1'));
dark_1s = double(dark_1s);
mdark_1s = mean(dark_1s,3);

dark_5s = squeeze(MMparse('Z:\Images\021512\dark_5sec_1'));
dark_5s = double(dark_5s);
mdark_5s = mean(dark_5s,3);

dark_10ms = squeeze(MMparse('Z:\Images\020912\dark_10ms_1'));
dark_10ms = double(dark_10ms);
mdark_10ms = mean(dark_10ms,3);

dark_1s = squeeze(MMparse('Z:\Images\020912\dark_1s_1'));
dark_1s = double(dark_1s);
mdark_1s_old = mean(dark_1s,3);

%2/9 dark image is different that 2/15 image, mostly by a constant offset
%of about 9 

flat_10ms = squeeze(MMparse('Z:\Images\020912\flat_10ms_1'));
flat_10ms = double(flat_10ms);
mflat_10ms_old = squeeze(mean(flat_10ms,3)) - repmat(mdark_10ms,[1 1 6]);

flat_10ms = squeeze(MMparse('Z:\Images\021512\flats_1'));
flat_10ms = double(flat_10ms);
mflat_10ms = squeeze(mean(flat_10ms,3)) - repmat(mdark_10ms,[1 1 6]) - 8.72; %8.72 is our best estimate of bias drift

%normalize each channel to mean of 1
for n=1:size(mflat_10ms,3)
    slice = mflat_10ms(:,:,n);
    mnflat(:,:,n) = slice./mean(slice(:));
    slice = mflat_10ms_old(:,:,n);
    mnflat_old(:,:,n) = slice./mean(slice(:));
end

meanim = mean(mnflat,3); %this is the mean intensity image
meanim_old = mean(mnflat_old,3); %this is the mean intensity image
for n=1:size(mnflat,3)
    corrim(:,:,n) = meanim./mnflat(:,:,n);
    corrim_old(:,:,n) = meanim_old./mnflat_old(:,:,n);
end

dark_stack = repmat(mdark_5s,[1 1 5]);
dark_stack(:,:,6:7) = repmat(mdark_1s, [1 1 2]);

%test to see if using right dark frames makes any difference to statistics

M0130d_1 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_1'));
M0130d_1 = double(M0130d_1) - dark_stack;
temp = M0130d_1(:,:,2:7); %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(140:330,10:120,n);
    Device_spec_d(n) = median(slice(:));
end
Device_spec_d= Device_spec_d./sum(Device_spec_d);
spectra_d = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec_d];

[M0130d_1u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_1 = beadIntensities(M0130d_1u, CC, 2);

M0130d_2 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_3'));
M0130d_2 = double(M0130d_2) - dark_stack;
temp = M0130d_2(:,:,2:7); %drop brightfield
[M0130d_2u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_2 = beadIntensities(M0130d_2u, CC, 2);

M0130d_3 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_5'));
M0130d_3 = double(M0130d_3) - dark_stack;
temp = M0130d_3(:,:,2:7); %drop brightfield
[M0130d_3u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_3 = beadIntensities(M0130d_3u, CC, 2);

M0130d_4 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_7'));
M0130d_4 = double(M0130d_4) - dark_stack;
temp = M0130d_4(:,:,2:7); %drop brightfield
[M0130d_4u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_4 = beadIntensities(M0130d_4u, CC, 2);

M0130d_5 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_8'));
M0130d_5 = double(M0130d_5) - dark_stack;
temp = M0130d_5(:,:,2:7); %drop brightfield
[M0130d_5u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_5 = beadIntensities(M0130d_5u, CC, 2);

M0130d_6 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_10'));
M0130d_6 = double(M0130d_6) - dark_stack;
temp = M0130d_6(:,:,2:7); %drop brightfield
[M0130d_6u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_6 = beadIntensities(M0130d_6u, CC, 2);

M0130d_7 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_12'));
M0130d_7 = double(M0130d_7) - dark_stack;
temp = M0130d_7(:,:,2:7); %drop brightfield
[M0130d_7u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_7 = beadIntensities(M0130d_7u, CC, 2);

M0130d_8 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_14'));
M0130d_8 = double(M0130d_8) - dark_stack;
temp = M0130d_8(:,:,2:7); %drop brightfield
[M0130d_8u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_8 = beadIntensities(M0130d_8u, CC, 2);

M0130d_9 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_16'));
M0130d_9 = double(M0130d_9) - dark_stack;
temp = M0130d_9(:,:,2:7); %drop brightfield
[M0130d_9u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_9 = beadIntensities(M0130d_9u, CC, 2);

M0130d_10 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_19'));
M0130d_10 = double(M0130d_10) - dark_stack;
temp = M0130d_10(:,:,2:7); %drop brightfield
[M0130d_10u,err] = unmix(temp, spectra_d);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130d_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130d_10 = beadIntensities(M0130d_10u, CC, 2);

clear M0130d_all M0130d_all_raw
M0130d_all(1,:) = [[I_M0130d_1(:,1).medianratio],[I_M0130d_2(:,1).medianratio],[I_M0130d_3(:,1).medianratio],[I_M0130d_4(:,1).medianratio],[I_M0130d_5(:,1).medianratio],[I_M0130d_6(:,1).medianratio],[I_M0130d_7(:,1).medianratio],[I_M0130d_8(:,1).medianratio],[I_M0130d_9(:,1).medianratio],[I_M0130d_10(:,1).medianratio]];
M0130d_all(2,:) = [[I_M0130d_1(:,3).medianratio],[I_M0130d_2(:,3).medianratio],[I_M0130d_3(:,3).medianratio],[I_M0130d_4(:,3).medianratio],[I_M0130d_5(:,3).medianratio],[I_M0130d_6(:,3).medianratio],[I_M0130d_7(:,3).medianratio],[I_M0130d_8(:,3).medianratio],[I_M0130d_9(:,3).medianratio],[I_M0130d_10(:,3).medianratio]];

vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};
temp = [[I_M0130d_1(:,1).medianratio]; [I_M0130d_1(:,3).medianratio]]';
q = ICP(temp, target);
x_1=temp*q;

temp = [[I_M0130d_2(:,1).medianratio]; [I_M0130d_2(:,3).medianratio]]';
q = ICP(temp, target);
x_2=temp*q;

temp = [[I_M0130d_3(:,1).medianratio]; [I_M0130d_3(:,3).medianratio]]';
q = ICP(temp, target);
x_3=temp*q;

temp = [[I_M0130d_4(:,1).medianratio]; [I_M0130d_4(:,3).medianratio]]';
q = ICP(temp, target);
x_4=temp*q;

temp = [[I_M0130d_5(:,1).medianratio]; [I_M0130d_5(:,3).medianratio]]';
q = ICP(temp, target);
x_5=temp*q;

temp = [[I_M0130d_6(:,1).medianratio]; [I_M0130d_6(:,3).medianratio]]';
q = ICP(temp, target);
x_6=temp*q;

temp = [[I_M0130d_7(:,1).medianratio]; [I_M0130d_7(:,3).medianratio]]';
q = ICP(temp, target);
x_7=temp*q;

temp = [[I_M0130d_8(:,1).medianratio]; [I_M0130d_8(:,3).medianratio]]';
q = ICP(temp, target);
x_8=temp*q;

temp = [[I_M0130d_9(:,1).medianratio]; [I_M0130d_9(:,3).medianratio]]';
q = ICP(temp, target);
x_9=temp*q;

temp = [[I_M0130d_10(:,1).medianratio]; [I_M0130d_10(:,3).medianratio]]';
q = ICP(temp, target);
x_10=temp*q;

%all data independently transformed to account for scale errors from
%serpentine to serpentine
M0130dx_all = [x_1; x_2; x_3; x_4; x_5; x_6; x_7; x_8; x_9; x_10];

temp = [I_M0130d_1(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_1_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_2(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_2_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_3(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_3_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_4(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_4_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_5(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_5_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_6(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_6_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_7(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_7_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_8(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_8_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_8_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_9(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_9_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_9_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130d_10(:,2).centroid]; %returns as interleaved X,Y pairs
M0130d_10_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130d_10_centroid(2,:) = temp(2:2:end); %Y

clear M0130d_centroid
M0130d_centroid = [M0130d_1_centroid,M0130d_2_centroid, M0130d_3_centroid, M0130d_4_centroid, M0130d_5_centroid, M0130d_6_centroid, M0130d_7_centroid, M0130d_8_centroid, M0130d_9_centroid, M0130d_10_centroid]; 

M0130d_centerbeads = find(all(M0130d_centroid>100) & all(M0130d_centroid<400));


temp = M0130dx_all(M0130d_centerbeads,:);
[Idx, M0130dx_all_mean] = kmeans(temp,[],'start',k);
clear M0130dx_all_std
for n=1:size(M0130dx_all_mean,1)
    list = Idx == n;
    M0130dx_all_std(n,:)= std(temp(list,:),0,1);
end

%now look at flat field correction
M0130df_1 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_1'));
M0130df_1 = double(M0130df_1) - dark_stack;
temp = M0130df_1(:,:,2:7).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(140:330,10:120,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec_df];

[M0130df_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_1 = beadIntensities(M0130df_1u, CC, 2);

M0130df_2 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_3'));
M0130df_2 = double(M0130df_2) - dark_stack;
temp = M0130df_2(:,:,2:7).*corrim; %drop brightfield
[M0130df_2u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_2 = beadIntensities(M0130df_2u, CC, 2);

M0130df_3 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_5'));
M0130df_3 = double(M0130df_3) - dark_stack;
temp = M0130df_3(:,:,2:7).*corrim; %drop brightfield
[M0130df_3u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_3 = beadIntensities(M0130df_3u, CC, 2);

M0130df_4 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_7'));
M0130df_4 = double(M0130df_4) - dark_stack;
temp = M0130df_4(:,:,2:7).*corrim; %drop brightfield
[M0130df_4u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_4 = beadIntensities(M0130df_4u, CC, 2);

M0130df_5 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_8'));
M0130df_5 = double(M0130df_5) - dark_stack;
temp = M0130df_5(:,:,2:7).*corrim; %drop brightfield
[M0130df_5u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_5 = beadIntensities(M0130df_5u, CC, 2);

M0130df_6 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_10'));
M0130df_6 = double(M0130df_6) - dark_stack;
temp = M0130df_6(:,:,2:7).*corrim; %drop brightfield
[M0130df_6u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_6 = beadIntensities(M0130df_6u, CC, 2);

M0130df_7 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_12'));
M0130df_7 = double(M0130df_7) - dark_stack;
temp = M0130df_7(:,:,2:7).*corrim; %drop brightfield
[M0130df_7u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_7 = beadIntensities(M0130df_7u, CC, 2);

M0130df_8 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_14'));
M0130df_8 = double(M0130df_8) - dark_stack;
temp = M0130df_8(:,:,2:7).*corrim; %drop brightfield
[M0130df_8u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_8 = beadIntensities(M0130df_8u, CC, 2);

M0130df_9 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_16'));
M0130df_9 = double(M0130df_9) - dark_stack;
temp = M0130df_9(:,:,2:7).*corrim; %drop brightfield
[M0130df_9u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_9 = beadIntensities(M0130df_9u, CC, 2);

M0130df_10 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_19'));
M0130df_10 = double(M0130df_10) - dark_stack;
temp = M0130df_10(:,:,2:7).*corrim; %drop brightfield
[M0130df_10u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df_10 = beadIntensities(M0130df_10u, CC, 2);

clear M0130df_all M0130df_all_raw
M0130df_all(1,:) = [[I_M0130df_1(:,1).medianratio],[I_M0130df_2(:,1).medianratio],[I_M0130df_3(:,1).medianratio],[I_M0130df_4(:,1).medianratio],[I_M0130df_5(:,1).medianratio],[I_M0130df_6(:,1).medianratio],[I_M0130df_7(:,1).medianratio],[I_M0130df_8(:,1).medianratio],[I_M0130df_9(:,1).medianratio],[I_M0130df_10(:,1).medianratio]];
M0130df_all(2,:) = [[I_M0130df_1(:,3).medianratio],[I_M0130df_2(:,3).medianratio],[I_M0130df_3(:,3).medianratio],[I_M0130df_4(:,3).medianratio],[I_M0130df_5(:,3).medianratio],[I_M0130df_6(:,3).medianratio],[I_M0130df_7(:,3).medianratio],[I_M0130df_8(:,3).medianratio],[I_M0130df_9(:,3).medianratio],[I_M0130df_10(:,3).medianratio]];

vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};
temp = [[I_M0130df_1(:,1).medianratio]; [I_M0130df_1(:,3).medianratio]]';
q = ICP(temp, target);
x_1=temp*q;

temp = [[I_M0130df_2(:,1).medianratio]; [I_M0130df_2(:,3).medianratio]]';
q = ICP(temp, target);
x_2=temp*q;

temp = [[I_M0130df_3(:,1).medianratio]; [I_M0130df_3(:,3).medianratio]]';
q = ICP(temp, target);
x_3=temp*q;

temp = [[I_M0130df_4(:,1).medianratio]; [I_M0130df_4(:,3).medianratio]]';
q = ICP(temp, target);
x_4=temp*q;

temp = [[I_M0130df_5(:,1).medianratio]; [I_M0130df_5(:,3).medianratio]]';
q = ICP(temp, target);
x_5=temp*q;

temp = [[I_M0130df_6(:,1).medianratio]; [I_M0130df_6(:,3).medianratio]]';
q = ICP(temp, target);
x_6=temp*q;

temp = [[I_M0130df_7(:,1).medianratio]; [I_M0130df_7(:,3).medianratio]]';
q = ICP(temp, target);
x_7=temp*q;

temp = [[I_M0130df_8(:,1).medianratio]; [I_M0130df_8(:,3).medianratio]]';
q = ICP(temp, target);
x_8=temp*q;

temp = [[I_M0130df_9(:,1).medianratio]; [I_M0130df_9(:,3).medianratio]]';
q = ICP(temp, target);
x_9=temp*q;

temp = [[I_M0130df_10(:,1).medianratio]; [I_M0130df_10(:,3).medianratio]]';
q = ICP(temp, target);
x_10=temp*q;

%all data independently transformed to account for scale errors from
%serpentine to serpentine
M0130dfx_all = [x_1; x_2; x_3; x_4; x_5; x_6; x_7; x_8; x_9; x_10];

temp = [I_M0130df_1(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_1_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_2(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_2_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_3(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_3_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_4(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_4_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_5(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_5_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_6(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_6_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_7(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_7_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_8(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_8_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_8_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_9(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_9_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_9_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df_10(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df_10_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df_10_centroid(2,:) = temp(2:2:end); %Y

clear M0130df_centroid
M0130df_centroid = [M0130df_1_centroid,M0130df_2_centroid, M0130df_3_centroid, M0130df_4_centroid, M0130df_5_centroid, M0130df_6_centroid, M0130df_7_centroid, M0130df_8_centroid, M0130df_9_centroid, M0130df_10_centroid]; 

M0130df_centerbeads = find(all(M0130df_centroid>100) & all(M0130df_centroid<400));

temp = M0130dfx_all(M0130df_centerbeads,:);
[Idx, M0130dfx_all_mean] = kmeans(temp,[],'start',k);
clear M0130dfx_all_std
for n=1:size(M0130dfx_all_mean,1)
    list = Idx == n;
    M0130dfx_all_std(n,:)= std(temp(list,:),0,1);
end

%now look at flat field correction - a diffent way
corrim = 1./mnflat;
M0130df2_1 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_1'));
M0130df2_1 = double(M0130df2_1) - dark_stack;
temp = M0130df2_1(:,:,2:7).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(140:330,10:120,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec_df];

[M0130df2_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_1 = beadIntensities(M0130df2_1u, CC, 2);

M0130df2_2 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_3'));
M0130df2_2 = double(M0130df2_2) - dark_stack;
temp = M0130df2_2(:,:,2:7).*corrim; %drop brightfield
[M0130df2_2u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_2 = beadIntensities(M0130df2_2u, CC, 2);

M0130df2_3 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_5'));
M0130df2_3 = double(M0130df2_3) - dark_stack;
temp = M0130df2_3(:,:,2:7).*corrim; %drop brightfield
[M0130df2_3u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_3 = beadIntensities(M0130df2_3u, CC, 2);

M0130df2_4 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_7'));
M0130df2_4 = double(M0130df2_4) - dark_stack;
temp = M0130df2_4(:,:,2:7).*corrim; %drop brightfield
[M0130df2_4u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_4 = beadIntensities(M0130df2_4u, CC, 2);

M0130df2_5 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_8'));
M0130df2_5 = double(M0130df2_5) - dark_stack;
temp = M0130df2_5(:,:,2:7).*corrim; %drop brightfield
[M0130df2_5u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_5 = beadIntensities(M0130df2_5u, CC, 2);

M0130df2_6 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_10'));
M0130df2_6 = double(M0130df2_6) - dark_stack;
temp = M0130df2_6(:,:,2:7).*corrim; %drop brightfield
[M0130df2_6u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_6 = beadIntensities(M0130df2_6u, CC, 2);

M0130df2_7 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_12'));
M0130df2_7 = double(M0130df2_7) - dark_stack;
temp = M0130df2_7(:,:,2:7).*corrim; %drop brightfield
[M0130df2_7u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_7 = beadIntensities(M0130df2_7u, CC, 2);

M0130df2_8 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_14'));
M0130df2_8 = double(M0130df2_8) - dark_stack;
temp = M0130df2_8(:,:,2:7).*corrim; %drop brightfield
[M0130df2_8u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_8 = beadIntensities(M0130df2_8u, CC, 2);

M0130df2_9 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_16'));
M0130df2_9 = double(M0130df2_9) - dark_stack;
temp = M0130df2_9(:,:,2:7).*corrim; %drop brightfield
[M0130df2_9u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_9 = beadIntensities(M0130df2_9u, CC, 2);

M0130df2_10 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_19'));
M0130df2_10 = double(M0130df2_10) - dark_stack;
temp = M0130df2_10(:,:,2:7).*corrim; %drop brightfield
[M0130df2_10u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df2_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130df2_10 = beadIntensities(M0130df2_10u, CC, 2);

clear M0130df2_all M0130df2_all_raw
M0130df2_all(1,:) = [[I_M0130df2_1(:,1).medianratio],[I_M0130df2_2(:,1).medianratio],[I_M0130df2_3(:,1).medianratio],[I_M0130df2_4(:,1).medianratio],[I_M0130df2_5(:,1).medianratio],[I_M0130df2_6(:,1).medianratio],[I_M0130df2_7(:,1).medianratio],[I_M0130df2_8(:,1).medianratio],[I_M0130df2_9(:,1).medianratio],[I_M0130df2_10(:,1).medianratio]];
M0130df2_all(2,:) = [[I_M0130df2_1(:,3).medianratio],[I_M0130df2_2(:,3).medianratio],[I_M0130df2_3(:,3).medianratio],[I_M0130df2_4(:,3).medianratio],[I_M0130df2_5(:,3).medianratio],[I_M0130df2_6(:,3).medianratio],[I_M0130df2_7(:,3).medianratio],[I_M0130df2_8(:,3).medianratio],[I_M0130df2_9(:,3).medianratio],[I_M0130df2_10(:,3).medianratio]];

vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};
temp = [[I_M0130df2_1(:,1).medianratio]; [I_M0130df2_1(:,3).medianratio]]';
q = ICP(temp, target);
x_1=temp*q;

temp = [[I_M0130df2_2(:,1).medianratio]; [I_M0130df2_2(:,3).medianratio]]';
q = ICP(temp, target);
x_2=temp*q;

temp = [[I_M0130df2_3(:,1).medianratio]; [I_M0130df2_3(:,3).medianratio]]';
q = ICP(temp, target);
x_3=temp*q;

temp = [[I_M0130df2_4(:,1).medianratio]; [I_M0130df2_4(:,3).medianratio]]';
q = ICP(temp, target);
x_4=temp*q;

temp = [[I_M0130df2_5(:,1).medianratio]; [I_M0130df2_5(:,3).medianratio]]';
q = ICP(temp, target);
x_5=temp*q;

temp = [[I_M0130df2_6(:,1).medianratio]; [I_M0130df2_6(:,3).medianratio]]';
q = ICP(temp, target);
x_6=temp*q;

temp = [[I_M0130df2_7(:,1).medianratio]; [I_M0130df2_7(:,3).medianratio]]';
q = ICP(temp, target);
x_7=temp*q;

temp = [[I_M0130df2_8(:,1).medianratio]; [I_M0130df2_8(:,3).medianratio]]';
q = ICP(temp, target);
x_8=temp*q;

temp = [[I_M0130df2_9(:,1).medianratio]; [I_M0130df2_9(:,3).medianratio]]';
q = ICP(temp, target);
x_9=temp*q;

temp = [[I_M0130df2_10(:,1).medianratio]; [I_M0130df2_10(:,3).medianratio]]';
q = ICP(temp, target);
x_10=temp*q;

%all data independently transformed to account for scale errors from
%serpentine to serpentine
M0130df2x_all = [x_1; x_2; x_3; x_4; x_5; x_6; x_7; x_8; x_9; x_10];

temp = [I_M0130df2_1(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_1_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_2(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_2_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_3(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_3_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_4(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_4_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_5(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_5_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_6(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_6_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_7(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_7_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_8(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_8_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_8_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_9(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_9_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_9_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130df2_10(:,2).centroid]; %returns as interleaved X,Y pairs
M0130df2_10_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130df2_10_centroid(2,:) = temp(2:2:end); %Y

clear M0130df2_centroid
M0130df2_centroid = [M0130df2_1_centroid,M0130df2_2_centroid, M0130df2_3_centroid, M0130df2_4_centroid, M0130df2_5_centroid, M0130df2_6_centroid, M0130df2_7_centroid, M0130df2_8_centroid, M0130df2_9_centroid, M0130df2_10_centroid]; 

M0130df2_centerbeads = find(all(M0130df2_centroid>100) & all(M0130df2_centroid<400));

temp = M0130df2x_all(M0130df2_centerbeads,:);
[Idx, M0130df2x_all_mean] = kmeans(temp,[],'start',k);
clear M0130df2x_all_std
for n=1:size(M0130df2x_all_mean,1)
    list = Idx == n;
    M0130df2x_all_std(n,:)= std(temp(list,:),0,1);
end


%mean deviation from target
mean(sqrt(sum((k-M0130_x_all_mean).^2,2))) %0.0119
mean(sqrt(sum((k-M0130dx_all_mean).^2,2))) %0.0135
mean(sqrt(sum((k-M0130dfx_all_mean).^2,2))) %0.0132
mean(sqrt(sum((k-M0130df2x_all_mean).^2,2))) %0.0135

%std dev improvements
mean(M0130_x_all_std - M0130dx_all_std) % 0.00039 0.00022
mean(M0130_x_all_std - M0130dfx_all_std)% 0.0004 0.0014
mean(M0130_x_all_std - M0130df2x_all_std)% 0.0004 0.0014

%work out number of sigmas each data point falls from its cluster centroid
temp = M0130dfx_all(M0130df_centerbeads,:);
[Idx, M0130dfx_all_mean] = kmeans(temp,[],'start',k);
clear M0130dfx_all_std
for n=1:size(M0130dfx_all_mean,1)
    list = Idx == n;
    M0130dfx_all_std(n,:)= std(temp(list,:),0,1);
end

nsigmas=[];
for n=1:size(M0130dfx_all_mean,1)
    list = Idx == n;
    currdata = temp(list,:);
    %subtract mean and divide by sigma
    currdata = currdata - repmat(M0130dfx_all_mean(n,:),[size(currdata,1) 1]);
    currdata = currdata ./ repmat(M0130dfx_all_std(n,:),[size(currdata,1) 1]);
    nsigmas=[nsigmas; currdata];
end

nsigmas =sqrt(sum(nsigmas.^2,2));
