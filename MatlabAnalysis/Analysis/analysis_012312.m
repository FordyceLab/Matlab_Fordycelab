%analyzing 1/23/12 data
%18 Code Matrix from 1/18 = M0118
%17 Code Matrix from 12/14 = M1214
%24 Code matrix from 1/9 = M0109
%Eu:Sm 1:3 = SmEu
%
%serpentine number is _n; if multiple reps, a letter is appended 
%(e.g. _5c = serpentine 5, rep 3)

camera_offset = 445;

M0118_1 = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp1_1'));
slice = M0118_1(:,:,1);
lampI(1) = mean(slice(:));
M0118_1 = double(M0118_1) - camera_offset;

%get device background
for n=2:7
    slice = M0118_1(450:495,5:150,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec];

temp = M0118_1(:,:,2:7);
[M0118_1u,err] = unmix(temp, spectra);
median(abs(err(:)./temp(:)))

mask = gen_bead_mask2(M0118_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_1 = beadIntensities(M0118_1u, CC, 2);

M0118_2 = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp2_1'));
slice = M0118_2(:,:,1);
lampI(2) = mean(slice(:));
M0118_2 = double(M0118_2(:,:,2:7)) - camera_offset;
[M0118_2u,err] = unmix(M0118_2, spectra);
median(abs(err(:)./M0118_2(:)))
mask = gen_bead_mask2(M0118_2u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_2 = beadIntensities(M0118_2u, CC, 2);

M0118_3 = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp3_1'));
slice = M0118_3(:,:,1);
lampI(2) = mean(slice(:));
M0118_3 = double(M0118_3(:,:,2:7)) - camera_offset;
[M0118_3u,err] = unmix(M0118_3, spectra);
median(abs(err(:)./M0118_3(:)))
mask = gen_bead_mask2(M0118_3u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_3 = beadIntensities(M0118_3u, CC, 2);

M0118_4 = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp4_1'));
slice = M0118_4(:,:,1);
lampI(2) = mean(slice(:));
M0118_4 = double(M0118_4(:,:,2:7)) - camera_offset;
[M0118_4u,err] = unmix(M0118_4, spectra);
median(abs(err(:)./M0118_4(:)))
mask = gen_bead_mask2(M0118_4u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_4 = beadIntensities(M0118_4u, CC, 2);

M0118_5a = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp5Rep1_1'));
slice = M0118_5a(:,:,1);
lampI(2) = mean(slice(:));
M0118_5a = double(M0118_5a(:,:,2:7)) - camera_offset;
[M0118_5au,err] = unmix(M0118_5a, spectra);
median(abs(err(:)./M0118_5a(:)))
mask = gen_bead_mask2(M0118_5au(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_5a = beadIntensities(M0118_5au, CC, 2);

%plot all separate M0118 serpentines.
clf; hold on
plot([I_M0118_1(:,1).medianratio], [I_M0118_1(:,3).medianratio],'.');
plot([I_M0118_2(:,1).medianratio], [I_M0118_2(:,3).medianratio],'.');
plot([I_M0118_3(:,1).medianratio], [I_M0118_3(:,3).medianratio],'.');
plot([I_M0118_4(:,1).medianratio], [I_M0118_4(:,3).medianratio],'.');
plot([I_M0118_5a(:,1).medianratio], [I_M0118_5a(:,3).medianratio],'.');
title('1/18 18 code matrix; 5 serpentines imaged')
xlabel('Dy/Eu ratio'); ylabel('Sm/Eu ratio')

%cumulate data for statistical analysis
M0118_5serp(1,:) = [[I_M0118_1(:,1).medianratio],[I_M0118_2(:,1).medianratio],[I_M0118_3(:,1).medianratio],[I_M0118_4(:,1).medianratio],[I_M0118_5a(:,1).medianratio]];
M0118_5serp(2,:) = [[I_M0118_1(:,3).medianratio],[I_M0118_2(:,3).medianratio],[I_M0118_3(:,3).medianratio],[I_M0118_4(:,3).medianratio],[I_M0118_5a(:,3).medianratio]];

%also collect up centroids so we can look for positional variability
temp = [I_M0118_1(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_1_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0118_2(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_2_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0118_3(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_3_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0118_4(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_4_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0118_5a(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_5a_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_5a_centroid(2,:) = temp(2:2:end); %Y
M0118_5serp_centroid = [M0118_1_centroid, M0118_2_centroid, M0118_3_centroid, M0118_4_centroid, M0118_5a_centroid;];

%initial values for k-means clustering
vals = [0 0.12 0.25 0.5 1] * 1.6;
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)-n+1
        k(index,:)=[vals(n); vals(m)];
        index=index+1;
    end
end
%then delete [0,0], add [0.4 0.8], [0.8 0.4], and [0.8 0.8]
[Idx, M0118_5serp_mean] = kmeans(M0118_5serp',[],'start',k);
clear M0118_5serp_std
for n=1:size(M0118_5serp_mean,1)
    list = Idx == n;
    M0118_5serp_std(n,:)= std(M0118_5serp(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
for n=1:size(M0118_5serp,2)
    M0118_5serp_delta(:,n)= M0118_5serp(:,n) - M0118_5serp_mean(Idx(n),:)';
end

%plot it
clf
subplot(2,2,1)
plot(M0118_5serp_centroid(1,:),M0118_5serp_delta(1,:),'.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')
subplot(2,2,2)
plot(M0118_5serp_centroid(2,:),M0118_5serp_delta(1,:),'.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')
subplot(2,2,3)
plot(M0118_5serp_centroid(1,:),M0118_5serp_delta(2,:),'.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')
subplot(2,2,4)
plot(M0118_5serp_centroid(2,:),M0118_5serp_delta(2,:),'.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

%load other M0118_5 replicates, analyze using same mask so we can keep
%track of identical beads

M0118_5b = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp5Rep2_1'));
slice = M0118_5b(:,:,1);
lampI(2) = mean(slice(:));
M0118_5b = double(M0118_5b(:,:,2:7)) - camera_offset;
[M0118_5bu,err] = unmix(M0118_5b, spectra);
median(abs(err(:)./M0118_5b(:)))
I_M0118_5b = beadIntensities(M0118_5bu, CC, 2);

M0118_5c = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp5Rep3_1'));
slice = M0118_5c(:,:,1);
lampI(2) = mean(slice(:));
M0118_5c = double(M0118_5c(:,:,2:7)) - camera_offset;
[M0118_5cu,err] = unmix(M0118_5c, spectra);
median(abs(err(:)./M0118_5c(:)))
I_M0118_5c = beadIntensities(M0118_5cu, CC, 2);

M0118_5d = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp5Rep4_1'));
slice = M0118_5d(:,:,1);
lampI(2) = mean(slice(:));
M0118_5d = double(M0118_5d(:,:,2:7)) - camera_offset;
[M0118_5du,err] = unmix(M0118_5d, spectra);
median(abs(err(:)./M0118_5d(:)))
I_M0118_5d = beadIntensities(M0118_5du, CC, 2);

M0118_5e = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_18Codes_Serp5Rep5_1'));
slice = M0118_5e(:,:,1);
lampI(2) = mean(slice(:));
M0118_5e = double(M0118_5e(:,:,2:7)) - camera_offset;
[M0118_5eu,err] = unmix(M0118_5e, spectra);
median(abs(err(:)./M0118_5e(:)))
I_M0118_5e = beadIntensities(M0118_5eu, CC, 2);

%plotting of these data shows little systematic drift
%collect up bead ratios so we can compute mean and std. dev.
M0118_5rep(1,:,:) = [[I_M0118_5a(:,1).medianratio];[I_M0118_5b(:,1).medianratio];[I_M0118_5c(:,1).medianratio];[I_M0118_5d(:,1).medianratio];[I_M0118_5e(:,1).medianratio]];
M0118_5rep(2,:,:) = [[I_M0118_5a(:,3).medianratio];[I_M0118_5b(:,3).medianratio];[I_M0118_5c(:,3).medianratio];[I_M0118_5d(:,3).medianratio];[I_M0118_5e(:,3).medianratio]];
M0118_5rep_mean = squeeze(mean(M0118_5rep,2));
M0118_5rep_std = squeeze(std(M0118_5rep,0,2));

%now repeat this with separate masks for each channel to see the effect of
%changing masks
%extract centroids to match corresponding beads in serpentine

temp = [I_M0118_5a(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_5a_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_5a_centroid(2,:) = temp(2:2:end); %Y

mask = gen_bead_mask2(M0118_5bu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_5b = beadIntensities(M0118_5bu, CC, 2);
temp = [I_M0118_5b(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_5b_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_5b_centroid(2,:) = temp(2:2:end); %Y
order_5b = match(M0118_5b_centroid', M0118_5a_centroid');

mask = gen_bead_mask2(M0118_5cu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_5c = beadIntensities(M0118_5cu, CC, 2);
temp = [I_M0118_5c(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_5c_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_5c_centroid(2,:) = temp(2:2:end); %Y
order_5c = match(M0118_5c_centroid', M0118_5a_centroid');

mask = gen_bead_mask2(M0118_5du(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_5d = beadIntensities(M0118_5du, CC, 2);
temp = [I_M0118_5d(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_5d_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_5d_centroid(2,:) = temp(2:2:end); %Y
order_5d = match(M0118_5d_centroid', M0118_5a_centroid');

mask = gen_bead_mask2(M0118_5eu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_M0118_5e = beadIntensities(M0118_5eu, CC, 2);
temp = [I_M0118_5e(:,2).centroid]; %returns as interleaved X,Y pairs
M0118_5e_centroid(1,:) = temp(1:2:end); %deinterleave X
M0118_5e_centroid(2,:) = temp(2:2:end); %Y
order_5e = match(M0118_5e_centroid', M0118_5a_centroid');

M0118_5rep_diffmasks(1,:,:) = [[I_M0118_5a(:,1).medianratio];[I_M0118_5b(order_5b,1).medianratio];[I_M0118_5c(order_5c,1).medianratio];[I_M0118_5d(order_5d,1).medianratio];[I_M0118_5e(order_5e,1).medianratio]];
M0118_5rep_diffmasks(2,:,:) = [[I_M0118_5a(:,3).medianratio];[I_M0118_5b(order_5b,3).medianratio];[I_M0118_5c(order_5c,3).medianratio];[I_M0118_5d(order_5d,3).medianratio];[I_M0118_5e(order_5e,3).medianratio]];
M0118_5rep_mean_diffmasks = squeeze(mean(M0118_5rep_diffmasks,2));
M0118_5rep_std_diffmasks = squeeze(std(M0118_5rep_diffmasks,0,2));

%comparison plotting
clf
subplot(2,1,1); hold on;
plot(M0118_5rep_mean(1,:),M0118_5rep_std(1,:),'ok')
plot(M0118_5rep_mean_diffmasks(1,:),M0118_5rep_std_diffmasks(1,:),'sk')
title('Dy/Eu replicate imaging')
legend('Same mask for all images', 'Separate mask for each image');
xlabel('Mean ratio'); ylabel('Standard Deviation');
subplot(2,1,2); hold on;
plot(M0118_5rep_mean(2,:),M0118_5rep_std(2,:),'ok')
plot(M0118_5rep_mean_diffmasks(2,:),M0118_5rep_std_diffmasks(2,:),'sk')
title('Sm/Eu replicate imaging')
legend('Same mask for all images', 'Separate mask for each image');
xlabel('Mean ratio'); ylabel('Standard Deviation');

%comparing replicate imaging of same bead with bead-to-bead variation
clf
subplot(1,2,1); hold on;
plot(M0118_5serp_mean(:,1),M0118_5serp_std(:,1),'ok')
plot(M0118_5rep_mean_diffmasks(1,:),M0118_5rep_std_diffmasks(1,:),'.k')
title('Dy/Eu')
%legend('Different beads', 'Same beads');
xlabel('Mean ratio'); ylabel('Standard Deviation');
subplot(1,2,2); hold on;
plot(M0118_5serp_mean(:,2),M0118_5serp_std(:,2),'ok')
plot(M0118_5rep_mean_diffmasks(2,:),M0118_5rep_std_diffmasks(2,:),'.k')
title('Sm/Eu')
%legend('Different beads', 'Same beads');
xlabel('Mean ratio'); ylabel('Standard Deviation');

%load Sm/Eu only beads to look at positional variation.

SmEu = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_20111004-02_Serp1_1'));
slice = SmEu(:,:,1);
lampI(2) = mean(slice(:));
SmEu = double(SmEu(:,:,2:7)) - camera_offset;
[SmEuu,err] = unmix(SmEu, spectra);
median(abs(err(:)./SmEu(:)))
mask = gen_bead_mask2(SmEuu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_SmEu = beadIntensities(SmEuu, CC, 2);

%load Sm only beads - the ratio between each channel should be a constant,
%independent of bead position
camera_offset = 445;
probe_radius = 20;

Sm = squeeze(MMparse('Z:\Keck\011312\Sm_only_1'));
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');
mask = gen_bead_mask2(Sm(:,:,7),20,-0.04);
CC = bwconncomp(mask,4);
I_Sm = beadIntensities(Sm, CC, 2);

Eu = squeeze(MMparse('Z:\Keck\011312\Eu_only_1'));
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');
mask = gen_bead_mask2(Eu(:,:,6),20,-0.04);
CC = bwconncomp(mask,4);
I_Eu = beadIntensities(Eu, CC, 2);

clear Sm_ratio_mean Sm_ratio_std Eu_ratio_mean Eu_ratio_std
for f1=2:7
    for f2=2:7
        Sm_ratio_mean(f1-1,f2-1) = mean([I_Sm(:,f1).median]./[I_Sm(:,f2).median]);
        Sm_ratio_std(f1-1,f2-1) = std([I_Sm(:,f1).median]./[I_Sm(:,f2).median]);
        Eu_ratio_mean(f1-1,f2-1) = mean([I_Eu(:,f1).median]./[I_Eu(:,f2).median]);
        Eu_ratio_std(f1-1,f2-1) = std([I_Eu(:,f1).median]./[I_Eu(:,f2).median]);
        
    end
end
Sm_ratio_CV = Sm_ratio_std./Sm_ratio_mean;
Eu_ratio_CV = Eu_ratio_std./Eu_ratio_mean;

M1214_1 = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_Beads1From121811_Serp1_1'));
slice = M1214_1(:,:,1);
lampI(2) = mean(slice(:));
M1214_1 = double(M1214_1(:,:,2:7)) - camera_offset;
[M1214_1u,err] = unmix(M1214_1, spectra);
median(abs(err(:)./M1214_1(:)))
mask = gen_bead_mask2(M1214_1u(:,:,2),20,-0.09);
CC = bwconncomp(mask,4);
I_M1214_1 = beadIntensities(M1214_1u, CC, 2);

M1214_2a = squeeze(MMparse('Z:\Keck\012312\BeadMatrix_Beads1From121811_Serp2_1'));
slice = M1214_2a(:,:,1);
lampI(2) = mean(slice(:));
M1214_2a = double(M1214_2a(:,:,2:7)) - camera_offset;
[M1214_2au,err] = unmix(M1214_2a, spectra);
median(abs(err(:)./M1214_2a(:)))
mask = gen_bead_mask2(M1214_2au(:,:,2),20,-0.04);
CC = bwconncomp(mask,4);
I_M1214_2a = beadIntensities(M1214_2au, CC, 2);
%%
%test - are centers of beads more accurate than edges?
h=fspecial('disk',6); %will give a dsik 11 pixels in diam.
mask_disk = h >= max(h(:))/2;
props=regionprops(CC,'Centroid');

newmask=zeros([501 502],'uint8');
for n=1:size(props,1)
    coords = round(props(n).Centroid);
    newmask(coords(2),coords(1))=1;
end

newmask=im2bw(imfilter(newmask,double(mask_disk)),0.001);
CC = bwconncomp(newmask,4);
I_M1214_2ax = beadIntensities(M1214_2au, CC, 2);
%this doesn't improve things
