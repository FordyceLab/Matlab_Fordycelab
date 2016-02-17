%replicate imaging
M0109_reps = squeeze(MMparse('Z:\Images\021512\24Codes_010912_Reps_2'));
M0109_reps = double(M0109_reps) - camera_offset;
for n=1:size(M0109_reps,3) %loop over time points
    temp = squeeze(M0109_reps(:,:,n,2:7)); %drop brightfield
    [slice,err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    M0109_reps_u(:,:,:,n) = slice;
end
temp = mean(M0109_reps_u(:,:,2,:),4);
mask = gen_bead_mask2(temp,7,-0.035);
CC = bwconncomp(mask,4);
clear M0109_replicateI
for n=1:size(M0109_reps_u,4)
    temp = beadIntensities(M0109_reps_u(:,:,:,n), CC, 2);
    temp = [[temp(:,1).medianratio]; [temp(:,3).medianratio]]';
    q = ICP(temp, target);
    temp=temp*q;
    M0109_replicateI(:,1,n) = temp(:,1);
    M0109_replicateI(:,2,n) = temp(:,2);
end
M0109_replicate_mean = mean(M0109_replicateI,3);
M0109_replicate_std = std(M0109_replicateI,0,3);
%k-means cluster on single axes to group
[Idx, M0109_replicate_mean_Dy] = kmeans(M0109_replicate_mean(:,1),[],'start',vals');
for n=1:numel(M0109_replicate_mean_Dy)
    list = Idx == n;
    M0109_replicate_std_Dy(n,:)= mean(M0109_replicate_std(list,1));
end
[Idx, M0109_replicate_mean_Sm] = kmeans(M0109_replicate_mean(:,2),[],'start',vals');
for n=1:numel(M0109_replicate_mean_Sm)
    list = Idx == n;
    M0109_replicate_std_Sm(n,:)= mean(M0109_replicate_std(list,2));
end

%non replicate imaging
M0109_1 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_3'));
M0109_1 = double(M0109_1) - camera_offset;
temp = M0109_1(:,:,2:7); %drop brightfield
[M0109_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0109_1 = beadIntensities(M0109_1u, CC, 2);

M0109_2 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_5'));
M0109_2 = double(M0109_2) - camera_offset;
temp = M0109_2(:,:,2:7); %drop brightfield
[M0109_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_2u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_2 = beadIntensities(M0109_2u, CC, 2);

M0109_3 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_7'));
M0109_3 = double(M0109_3) - camera_offset;
temp = M0109_3(:,:,2:7); %drop brightfield
[M0109_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_3u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_3 = beadIntensities(M0109_3u, CC, 2);

M0109_4 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_9'));
M0109_4 = double(M0109_4) - camera_offset;
temp = M0109_4(:,:,2:7); %drop brightfield
[M0109_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_4u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_4 = beadIntensities(M0109_4u, CC, 2);

M0109_5 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_10'));
M0109_5 = double(M0109_5) - camera_offset;
temp = M0109_5(:,:,2:7); %drop brightfield
[M0109_5u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_5u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_5 = beadIntensities(M0109_5u, CC, 2);

M0109_6 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_12'));
M0109_6 = double(M0109_6) - camera_offset;
temp = M0109_6(:,:,2:7); %drop brightfield
[M0109_6u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_6u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_6 = beadIntensities(M0109_6u, CC, 2);

M0109_7 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_14'));
M0109_7 = double(M0109_7) - camera_offset;
temp = M0109_7(:,:,2:7); %drop brightfield
[M0109_7u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_7u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_7 = beadIntensities(M0109_7u, CC, 2);

M0109_8 = squeeze(MMparse('Z:\Images\021512\24Codes_010912_16'));
M0109_8 = double(M0109_8) - camera_offset;
temp = M0109_8(:,:,2:7); %drop brightfield
[M0109_8u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_8u(:,:,2),7,-0.045);
CC = bwconncomp(mask,4);
I_M0109_8 = beadIntensities(M0109_8u, CC, 2);

temp = [I_M0109_1(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_1_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_2(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_2_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_3(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_3_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_4(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_4_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_5(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_5_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_6(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_6_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_7(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_7_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0109_8(:,2).centroid]; %returns as interleaved X,Y pairs
M0109_8_centroid(1,:) = temp(1:2:end); %deinterleave X
M0109_8_centroid(2,:) = temp(2:2:end); %Y

clear M0109_centroid
M0109_centroid = [M0109_1_centroid,M0109_2_centroid, M0109_3_centroid, M0109_4_centroid, M0109_5_centroid, M0109_6_centroid, M0109_7_centroid, M0109_8_centroid,]; 

M0109_centerbeads = find(all(M0109_centroid>100) & all(M0109_centroid<400));

vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};
temp = [[I_M0109_1(:,1).medianratio]; [I_M0109_1(:,3).medianratio]]';
q = ICP(temp, target);
x_1=temp*q;

temp = [[I_M0109_2(:,1).medianratio]; [I_M0109_2(:,3).medianratio]]';
q = ICP(temp, target);
x_2=temp*q;

temp = [[I_M0109_3(:,1).medianratio]; [I_M0109_3(:,3).medianratio]]';
q = ICP(temp, target);
x_3=temp*q;

temp = [[I_M0109_4(:,1).medianratio]; [I_M0109_4(:,3).medianratio]]';
q = ICP(temp, target);
x_4=temp*q;

temp = [[I_M0109_5(:,1).medianratio]; [I_M0109_5(:,3).medianratio]]';
q = ICP(temp, target);
x_5=temp*q;

temp = [[I_M0109_6(:,1).medianratio]; [I_M0109_6(:,3).medianratio]]';
q = ICP(temp, target);
x_6=temp*q;

temp = [[I_M0109_7(:,1).medianratio]; [I_M0109_7(:,3).medianratio]]';
q = ICP(temp, target);
x_7=temp*q;

temp = [[I_M0109_8(:,1).medianratio]; [I_M0109_8(:,3).medianratio]]';
q = ICP(temp, target);
x_8=temp*q;

%all data independently transformed to account for scale errors from
%serpentine to serpentine
M0109_x_all = [x_1; x_2; x_3; x_4; x_5; x_6; x_7; x_8];

%M0109k is k without the 0.7, 0 point
temp = M0109_x_all(M0109_centerbeads,:);
[Idx, M0109_x_all_mean] = kmeans(temp,[],'start',M0109k);
clear M0109_x_all_std
for n=1:size(M0109_x_all_mean,1)
    list = Idx == n;
    M0109_x_all_std(n,:)= std(temp(list,:),0,1);
end
