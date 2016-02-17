%analyzing 2/6/12 data
%data from 4x/0.2 objective with 1x C-mount with filter wheel either in
%stage up position or mounted between scope and camera
%New 24 code matrix from Rachel
%serpentine number is _n

%SU_1 is with lower pixel intensity thatn SU_2 and following

camera_offset = 445;

SU_1 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_1'));
SU_1 = double(SU_1) - camera_offset;

%get device background
for n=2:8
    slice = SU_1(10:140,145:345,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec_SU = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec_SU];
spectra(:,6)=[]; %remove 630/69 filter

temp = SU_1(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_SU_1 = beadIntensities(SU_1u, CC, 2);

SU_2 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_2'));
SU_2 = double(SU_2) - camera_offset;
temp = SU_2(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_2u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_2 = beadIntensities(SU_2u, CC, 2);

SU_3 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_3'));
SU_3 = double(SU_3) - camera_offset;
temp = SU_3(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_3u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_3 = beadIntensities(SU_3u, CC, 2);

SU_4 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_4'));
SU_4 = double(SU_4) - camera_offset;
temp = SU_4(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_4u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_4 = beadIntensities(SU_4u, CC, 2);

SU_5 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_5'));
SU_5 = double(SU_5) - camera_offset;
temp = SU_5(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_5u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_5u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_5 = beadIntensities(SU_5u, CC, 2);

SU_6 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_6'));
SU_6 = double(SU_6) - camera_offset;
temp = SU_6(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_6u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_6u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_6 = beadIntensities(SU_6u, CC, 2);

SU_7 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_7'));
SU_7 = double(SU_7) - camera_offset;
temp = SU_7(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_7u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_7u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_7 = beadIntensities(SU_7u, CC, 2);

SU_8 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_8'));
SU_8 = double(SU_8) - camera_offset;
temp = SU_8(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_8u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_8u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_8 = beadIntensities(SU_8u, CC, 2);

clear SU_all SU_all_raw
SU_all(1,:) = [[I_SU_2(:,1).medianratio],[I_SU_3(:,1).medianratio],[I_SU_4(:,1).medianratio],[I_SU_5(:,1).medianratio],[I_SU_6(:,1).medianratio],[I_SU_7(:,1).medianratio],[I_SU_8(:,1).medianratio]];
SU_all(2,:) = [[I_SU_2(:,3).medianratio],[I_SU_3(:,3).medianratio],[I_SU_4(:,3).medianratio],[I_SU_5(:,3).medianratio],[I_SU_6(:,3).medianratio],[I_SU_7(:,3).medianratio],[I_SU_8(:,3).medianratio]];

SU_all_raw(1,:) = [[I_SU_2(:,1).median],[I_SU_3(:,1).median],[I_SU_4(:,1).median],[I_SU_5(:,1).median],[I_SU_6(:,1).median],[I_SU_7(:,1).median],[I_SU_8(:,1).median]];
SU_all_raw(2,:) = [[I_SU_2(:,2).median],[I_SU_3(:,2).median],[I_SU_4(:,2).median],[I_SU_5(:,2).median],[I_SU_6(:,2).median],[I_SU_7(:,2).median],[I_SU_8(:,2).median]];
SU_all_raw(3,:) = [[I_SU_2(:,3).median],[I_SU_3(:,3).median],[I_SU_4(:,3).median],[I_SU_5(:,3).median],[I_SU_6(:,3).median],[I_SU_7(:,3).median],[I_SU_8(:,3).median]];

temp = [I_SU_2(:,2).centroid]; %returns as interleaved X,Y pairs
SU2_centroid(1,:) = temp(1:2:end); %deinterleave X
SU2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SU_3(:,2).centroid]; %returns as interleaved X,Y pairs
SU3_centroid(1,:) = temp(1:2:end); %deinterleave X
SU3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SU_4(:,2).centroid]; %returns as interleaved X,Y pairs
SU4_centroid(1,:) = temp(1:2:end); %deinterleave X
SU4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SU_5(:,2).centroid]; %returns as interleaved X,Y pairs
SU5_centroid(1,:) = temp(1:2:end); %deinterleave X
SU5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SU_6(:,2).centroid]; %returns as interleaved X,Y pairs
SU6_centroid(1,:) = temp(1:2:end); %deinterleave X
SU6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SU_7(:,2).centroid]; %returns as interleaved X,Y pairs
SU7_centroid(1,:) = temp(1:2:end); %deinterleave X
SU7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SU_8(:,2).centroid]; %returns as interleaved X,Y pairs
SU8_centroid(1,:) = temp(1:2:end); %deinterleave X
SU8_centroid(2,:) = temp(2:2:end); %Y
SU_centroid = [SU2_centroid, SU3_centroid, SU4_centroid, SU5_centroid, SU6_centroid, SU7_centroid, SU8_centroid]; 

SU_centerbeads = find(all(SU_centroid>100) & all(SU_centroid<400));

SW_1 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_sidewheel_1'));
SW_1 = double(SW_1) - camera_offset;

%get device background
for n=2:8
    slice = SU_1(10:120,145:345,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec_SW = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec_SW];
spectra(:,6)=[]; %remove 630/69 filter

temp = SW_1(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SW_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SW_1u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SW_1 = beadIntensities(SW_1u, CC, 2);

SW_2 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_sidewheel_2'));
SW_2 = double(SW_2) - camera_offset;
temp = SW_2(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SW_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SW_2u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SW_2 = beadIntensities(SW_2u, CC, 2);

SW_3 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_sidewheel_3'));
SW_3 = double(SW_3) - camera_offset;
temp = SW_3(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SW_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SW_3u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SW_3 = beadIntensities(SW_3u, CC, 2);

SW_4 = squeeze(MMparse('X:\Images\020612\BeadMatrix_24codes_4x_1x_sidewheel_4'));
SW_4 = double(SW_4) - camera_offset;
temp = SW_4(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SW_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SW_4u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SW_4 = beadIntensities(SW_4u, CC, 2);

clear SW_all SW_all_raw
SW_all(1,:) = [[I_SW_1(:,1).medianratio],[I_SW_2(:,1).medianratio],[I_SW_3(:,1).medianratio],[I_SW_4(:,1).medianratio]];
SW_all(2,:) = [[I_SW_1(:,3).medianratio],[I_SW_2(:,3).medianratio],[I_SW_3(:,3).medianratio],[I_SW_4(:,3).medianratio]];

SW_all_raw(1,:) = [[I_SW_1(:,1).median],[I_SW_2(:,1).median],[I_SW_3(:,1).median]];%,[I_SW_4(:,1).median]];
SW_all_raw(2,:) = [[I_SW_1(:,2).median],[I_SW_2(:,2).median],[I_SW_3(:,2).median]];%,[I_SW_4(:,2).median]];
SW_all_raw(3,:) = [[I_SW_1(:,3).median],[I_SW_2(:,3).median],[I_SW_3(:,3).median]];%,[I_SW_4(:,3).median]];

temp = [I_SW_1(:,2).centroid]; %returns as interleaved X,Y pairs
SW1_centroid(1,:) = temp(1:2:end); %deinterleave X
SW1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SW_2(:,2).centroid]; %returns as interleaved X,Y pairs
SW2_centroid(1,:) = temp(1:2:end); %deinterleave X
SW2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_SW_3(:,2).centroid]; %returns as interleaved X,Y pairs
SW3_centroid(1,:) = temp(1:2:end); %deinterleave X
SW3_centroid(2,:) = temp(2:2:end); %Y
%temp = [I_SW_4(:,2).centroid]; %returns as interleaved X,Y pairs
%SW4_centroid(1,:) = temp(1:2:end); %deinterleave X
%SW4_centroid(2,:) = temp(2:2:end); %Y

SW_centroid = [SW1_centroid, SW2_centroid, SW3_centroid];%, SW4_centroid];
SW_centerbeads = find(all(SW_centroid>100) & all(SW_centroid<400));

subplot(1,2,1)
plot(SU_all(1,SU_centerbeads),SU_all(2,SU_centerbeads),'.')
title('Stage-up Wheel')
xlabel('Dy/Eu'); ylabel('Sm/Eu');

subplot(1,2,2)
plot(SW_all(1,SW_centerbeads),SW_all(2,SW_centerbeads),'.')
title('Side Wheel')
xlabel('Dy/Eu'); ylabel('Sm/Eu');

%plot raw data
clf
subplot(1,3,1)
plot(SU_all_raw(1,:), SU_all_raw(2,:),'.')
xlabel('Dy'); ylabel('Eu')
subplot(1,3,2)
plot(SU_all_raw(3,:), SU_all_raw(2,:),'.')
xlabel('Sm'); ylabel('Eu')
subplot(1,3,3)
plot(SU_all_raw(1,:), SU_all_raw(3,:),'.')
xlabel('Dy'); ylabel('Sm')

clf
subplot(1,3,1)
plot(SW_all_raw(1,:), SW_all_raw(2,:),'.')
xlabel('Dy'); ylabel('Eu')
subplot(1,3,2)
plot(SW_all_raw(3,:), SW_all_raw(2,:),'.')
xlabel('Sm'); ylabel('Eu')
subplot(1,3,3)
plot(SW_all_raw(1,:), SW_all_raw(3,:),'.')
xlabel('Dy'); ylabel('Sm')

figure
clf
hold on
R=sqrt(sum(SW_centroid.^2));
for n=1:size(SW_all_raw,2)
    C = [R(n)/max(R) 0 0];
    C = max(C,0);
    C = min(C,1);
    plot(SW_all_raw(3,n), SW_all_raw(2,n), '.', 'MarkerEdgeColor', C)
end
