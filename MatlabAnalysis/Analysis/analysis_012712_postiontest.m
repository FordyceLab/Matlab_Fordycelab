%analyzing 1/27/12 data, part 2
%data from 4x/0.2 objective with 1x C-mount
%18 Code Matrix in multiple positions to see if edges of field are bad
%serpentine number is _n
%assume camera_offset, spectra already defined.

spectra_92 = spectra;
spectra_92(:,7)=[]; %remove 630/69 filter
spectra_69 = spectra;
spectra_69(:,6) = []; %remove 630/92 filter

PT_1 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_BottomLeft_1'));
PT_1 = double(PT_1) - camera_offset;
temp = PT_1(:,:,2:8); %drop brightfield
[PT_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_1 = beadIntensities(PT_1u, CC, 2);

PT_2 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_BottomLeft_2'));
PT_2 = double(PT_2) - camera_offset;
temp = PT_2(:,:,2:8); %drop brightfield
[PT_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_2 = beadIntensities(PT_2u, CC, 2);

PT_3 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_BottomRight_1'));
PT_3 = double(PT_3) - camera_offset;
temp = PT_3(:,:,2:8); %drop brightfield
[PT_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_3 = beadIntensities(PT_3u, CC, 2);

PT_4 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_BottomRight_2'));
PT_4 = double(PT_4) - camera_offset;
temp = PT_4(:,:,2:8); %drop brightfield
[PT_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_4 = beadIntensities(PT_4u, CC, 2);

PT_5 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_Center_1'));
PT_5 = double(PT_5) - camera_offset;
temp = PT_5(:,:,2:8); %drop brightfield
[PT_5u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_5 = beadIntensities(PT_5u, CC, 2);

PT_6 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_Center_2'));
PT_6 = double(PT_6) - camera_offset;
temp = PT_6(:,:,2:8); %drop brightfield
[PT_6u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_6 = beadIntensities(PT_6u, CC, 2);

PT_7 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_TopLeft_1'));
PT_7 = double(PT_7) - camera_offset;
temp = PT_7(:,:,2:8); %drop brightfield
[PT_7u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_7 = beadIntensities(PT_7u, CC, 2);

PT_8 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_TopLeft_2'));
PT_8 = double(PT_8) - camera_offset;
temp = PT_8(:,:,2:8); %drop brightfield
[PT_8u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_8 = beadIntensities(PT_8u, CC, 2);

PT_9 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_TopRight_1'));
PT_9 = double(PT_9) - camera_offset;
temp = PT_9(:,:,2:8); %drop brightfield
[PT_9u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_9 = beadIntensities(PT_9u, CC, 2);

PT_10 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1x_PositionTest_TopRight_2'));
PT_10 = double(PT_10) - camera_offset;
temp = PT_10(:,:,2:8); %drop brightfield
[PT_10u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_10 = beadIntensities(PT_10u, CC, 2);

PT_all(1,:) = [[I_PT_1(:,1).medianratio],[I_PT_2(:,1).medianratio],[I_PT_3(:,1).medianratio],[I_PT_4(:,1).medianratio],[I_PT_5(:,1).medianratio],[I_PT_6(:,1).medianratio],[I_PT_7(:,1).medianratio],[I_PT_8(:,1).medianratio],[I_PT_9(:,1).medianratio],[I_PT_10(:,1).medianratio]];
PT_all(2,:) = [[I_PT_1(:,3).medianratio],[I_PT_2(:,3).medianratio],[I_PT_3(:,3).medianratio],[I_PT_4(:,3).medianratio],[I_PT_5(:,3).medianratio],[I_PT_6(:,3).medianratio],[I_PT_7(:,3).medianratio],[I_PT_8(:,3).medianratio],[I_PT_9(:,3).medianratio],[I_PT_10(:,3).medianratio]];

%collect up centroids so we can look for positional variability
temp = [I_PT_1(:,2).centroid]; %returns as interleaved X,Y pairs
PT1_centroid(1,:) = temp(1:2:end); %deinterleave X
PT1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_2(:,2).centroid]; %returns as interleaved X,Y pairs
PT2_centroid(1,:) = temp(1:2:end); %deinterleave X
PT2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_3(:,2).centroid]; %returns as interleaved X,Y pairs
PT3_centroid(1,:) = temp(1:2:end); %deinterleave X
PT3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_4(:,2).centroid]; %returns as interleaved X,Y pairs
PT4_centroid(1,:) = temp(1:2:end); %deinterleave X
PT4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_5(:,2).centroid]; %returns as interleaved X,Y pairs
PT5_centroid(1,:) = temp(1:2:end); %deinterleave X
PT5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_6(:,2).centroid]; %returns as interleaved X,Y pairs
PT6_centroid(1,:) = temp(1:2:end); %deinterleave X
PT6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_7(:,2).centroid]; %returns as interleaved X,Y pairs
PT7_centroid(1,:) = temp(1:2:end); %deinterleave X
PT7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_8(:,2).centroid]; %returns as interleaved X,Y pairs
PT8_centroid(1,:) = temp(1:2:end); %deinterleave X
PT8_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_9(:,2).centroid]; %returns as interleaved X,Y pairs
PT9_centroid(1,:) = temp(1:2:end); %deinterleave X
PT9_centroid(2,:) = temp(2:2:end); %Y
temp = [I_PT_10(:,2).centroid]; %returns as interleaved X,Y pairs
PT10_centroid(1,:) = temp(1:2:end); %deinterleave X
PT10_centroid(2,:) = temp(2:2:end); %Y
PT_centroid = [PT1_centroid, PT2_centroid, PT3_centroid, PT4_centroid, PT5_centroid, PT6_centroid, PT7_centroid, PT8_centroid, PT9_centroid, PT10_centroid]; 


%initial values for k-means clustering
vals = [0, 0.125, 0.25, 0.5, 1];
valsx = vals*1;
valsy = vals*1.4;
clear k
index=1;
for n=1:numel(valsx)
    for m=1:numel(valsx)-n+1
        k(index,:)=[valsx(n); valsy(m)];
        index=index+1;
    end
end
%then delete [0,0], add [0.25 .7], [0.5 0.7], and [0.5 0.35]
[Idx, PT_all_mean] = kmeans(PT_all',[],'start',k);
clear PT_all_std
for n=1:size(PT_all_mean,1)
    list = Idx == n;
    PT_all_std(n,:)= std(PT_all(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear PT_all_delta
for n=1:size(PT_all,2)
    PT_all_delta(:,n)= PT_all(:,n) - PT_all_mean(Idx(n),:)';
end

%plot it
figure(1)
clf
subplot(2,2,1)
plot(PT_centroid(1,:),PT_all_delta(1,:),'b.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,2)
plot(PT_centroid(2,:),PT_all_delta(1,:),'b.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,3)
plot(PT_centroid(1,:),PT_all_delta(2,:),'b.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')

subplot(2,2,4)
plot(PT_centroid(2,:),PT_all_delta(2,:),'b.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

%now repeat, dropping 630/69 or 630/92
temp = PT_1(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_1u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_1(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_1u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_1_92 = beadIntensities(PT_1u_92, CC, 2);
I_PT_1_69 = beadIntensities(PT_1u_69, CC, 2);

temp = PT_2(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_2u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_2(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_2u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_2_92 = beadIntensities(PT_2u_92, CC, 2);
I_PT_2_69 = beadIntensities(PT_2u_69, CC, 2);

temp = PT_3(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_3u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_3(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_3u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_3_92 = beadIntensities(PT_3u_92, CC, 2);
I_PT_3_69 = beadIntensities(PT_3u_69, CC, 2);

temp = PT_4(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_4u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_4(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_4u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_4_92 = beadIntensities(PT_4u_92, CC, 2);
I_PT_4_69 = beadIntensities(PT_4u_69, CC, 2);

temp = PT_5(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_5u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_5(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_5u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_5_92 = beadIntensities(PT_5u_92, CC, 2);
I_PT_5_69 = beadIntensities(PT_5u_69, CC, 2);

temp = PT_6(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_6u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_6(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_6u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_6_92 = beadIntensities(PT_6u_92, CC, 2);
I_PT_6_69 = beadIntensities(PT_6u_69, CC, 2);

temp = PT_7(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_7u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_7(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_7u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_7_92 = beadIntensities(PT_7u_92, CC, 2);
I_PT_7_69 = beadIntensities(PT_7u_69, CC, 2);

temp = PT_8(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_8u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_8(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_8u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_8_92 = beadIntensities(PT_8u_92, CC, 2);
I_PT_8_69 = beadIntensities(PT_8u_69, CC, 2);

temp = PT_9(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_9u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_9(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_9u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_9_92 = beadIntensities(PT_9u_92, CC, 2);
I_PT_9_69 = beadIntensities(PT_9u_69, CC, 2);

temp = PT_10(:,:,2:8); %drop brightfield
temp(:,:,7) =[];
[PT_10u_92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
temp = PT_10(:,:,2:8); %drop brightfield
temp(:,:,6) =[];
[PT_10u_69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(PT_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_PT_10_92 = beadIntensities(PT_10u_92, CC, 2);
I_PT_10_69 = beadIntensities(PT_10u_69, CC, 2);

PT_all_92(1,:) = [[I_PT_1_92(:,1).medianratio],[I_PT_2_92(:,1).medianratio],[I_PT_3_92(:,1).medianratio],[I_PT_4_92(:,1).medianratio],[I_PT_5_92(:,1).medianratio],[I_PT_6_92(:,1).medianratio],[I_PT_7_92(:,1).medianratio],[I_PT_8_92(:,1).medianratio],[I_PT_9_92(:,1).medianratio],[I_PT_10_92(:,1).medianratio]];
PT_all_92(2,:) = [[I_PT_1_92(:,3).medianratio],[I_PT_2_92(:,3).medianratio],[I_PT_3_92(:,3).medianratio],[I_PT_4_92(:,3).medianratio],[I_PT_5_92(:,3).medianratio],[I_PT_6_92(:,3).medianratio],[I_PT_7_92(:,3).medianratio],[I_PT_8_92(:,3).medianratio],[I_PT_9_92(:,3).medianratio],[I_PT_10_92(:,3).medianratio]];
PT_all_69(1,:) = [[I_PT_1_69(:,1).medianratio],[I_PT_2_69(:,1).medianratio],[I_PT_3_69(:,1).medianratio],[I_PT_4_69(:,1).medianratio],[I_PT_5_69(:,1).medianratio],[I_PT_6_69(:,1).medianratio],[I_PT_7_69(:,1).medianratio],[I_PT_8_69(:,1).medianratio],[I_PT_9_69(:,1).medianratio],[I_PT_10_69(:,1).medianratio]];
PT_all_69(2,:) = [[I_PT_1_69(:,3).medianratio],[I_PT_2_69(:,3).medianratio],[I_PT_3_69(:,3).medianratio],[I_PT_4_69(:,3).medianratio],[I_PT_5_69(:,3).medianratio],[I_PT_6_69(:,3).medianratio],[I_PT_7_69(:,3).medianratio],[I_PT_8_69(:,3).medianratio],[I_PT_9_69(:,3).medianratio],[I_PT_10_69(:,3).medianratio]];

[Idx, PT_all_92_mean] = kmeans(PT_all_92',[],'start',k);
clear PT_all_92_std
for n=1:size(PT_all_92_mean,1)
    list = Idx == n;
    PT_all_92_std(n,:)= std(PT_all_92(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear PT_all_92_delta
for n=1:size(PT_all_92,2)
    PT_all_92_delta(:,n)= PT_all_92(:,n) - PT_all_92_mean(Idx(n),:)';
end

[Idx, PT_all_69_mean] = kmeans(PT_all_69',[],'start',k);
clear PT_all_69_std
for n=1:size(PT_all_69_mean,1)
    list = Idx == n;
    PT_all_69_std(n,:)= std(PT_all_69(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear PT_all_69_delta
for n=1:size(PT_all_69,2)
    PT_all_69_delta(:,n)= PT_all_69(:,n) - PT_all_69_mean(Idx(n),:)';
end

figure(1)
clf
subplot(2,2,1)
plot(PT_centroid(1,:),PT_all_delta(1,:),'b.')
hold on
plot(PT_centroid(1,:),PT_all_92_delta(1,:),'g.')
plot(PT_centroid(1,:),PT_all_69_delta(1,:),'r.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,2)
plot(PT_centroid(2,:),PT_all_delta(1,:),'b.')
hold on
plot(PT_centroid(2,:),PT_all_92_delta(1,:),'g.')
plot(PT_centroid(2,:),PT_all_69_delta(1,:),'r.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,3)
plot(PT_centroid(1,:),PT_all_delta(2,:),'b.')
hold on
plot(PT_centroid(1,:),PT_all_92_delta(2,:),'g.')
plot(PT_centroid(1,:),PT_all_69_delta(2,:),'r.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')

subplot(2,2,4)
plot(PT_centroid(2,:),PT_all_delta(2,:),'b.')
hold on
plot(PT_centroid(2,:),PT_all_92_delta(2,:),'g.')
plot(PT_centroid(2,:),PT_all_69_delta(2,:),'r.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

step=50;
index = 1;
for n=step:step:500
    beads = find(PT_centroid(1,:)<n & PT_centroid(1,:)>=n-step);
    PT_binned_cent_X(index) = median(PT_centroid(1,beads));
    PT_all_binned_X(1,index) = median(PT_all_delta(1,beads));
    PT_all_binned_X(2,index) = median(PT_all_delta(2,beads));
    PT_all_69_binned_X(1,index) = median(PT_all_69_delta(1,beads));
    PT_all_69_binned_X(2,index) = median(PT_all_69_delta(2,beads)); 
    PT_all_92_binned_X(1,index) = median(PT_all_92_delta(1,beads));
    PT_all_92_binned_X(2,index) = median(PT_all_92_delta(2,beads));
    
    beads = find(PT_centroid(2,:)<n & PT_centroid(2,:)>=n-step);
    PT_binned_cent_Y(index) = median(PT_centroid(2,beads));
    PT_all_binned_Y(1,index) = median(PT_all_delta(1,beads));
    PT_all_binned_Y(2,index) = median(PT_all_delta(2,beads));
    PT_all_69_binned_Y(1,index) = median(PT_all_69_delta(1,beads));
    PT_all_69_binned_Y(2,index) = median(PT_all_69_delta(2,beads)); 
    PT_all_92_binned_Y(1,index) = median(PT_all_92_delta(1,beads));
    PT_all_92_binned_Y(2,index) = median(PT_all_92_delta(2,beads));
    index = index+1;
end

figure(2)
clf
subplot(2,2,1)
plot(PT_binned_cent_X,PT_all_binned_X(1,:),'k')
hold on
plot(PT_binned_cent_X,PT_all_92_binned_X(1,:),'--k')
plot(PT_binned_cent_X,PT_all_69_binned_X(1,:),':k')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,2)
plot(PT_binned_cent_Y,PT_all_binned_Y(1,:),'k')
hold on
plot(PT_binned_cent_Y,PT_all_92_binned_Y(1,:),'--k')
plot(PT_binned_cent_Y,PT_all_69_binned_Y(1,:),':k')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,3)
plot(PT_binned_cent_X,PT_all_binned_X(2,:),'k')
hold on
plot(PT_binned_cent_X,PT_all_92_binned_X(2,:),'--k')
plot(PT_binned_cent_X,PT_all_69_binned_X(2,:),':k')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')

subplot(2,2,4)
plot(PT_binned_cent_Y,PT_all_binned_Y(2,:),'k')
hold on
plot(PT_binned_cent_Y,PT_all_92_binned_Y(2,:),'--k')
plot(PT_binned_cent_Y,PT_all_69_binned_Y(2,:),':k')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

maxvals = max(PT_all_mean);
maxvals_92 = max(PT_all_92_mean);
maxvals_69 = max(PT_all_69_mean);

figure(3)
clf
subplot(1,2,1); hold on;
plot(PT_all_mean(:,1)./maxvals(1),PT_all_std(:,1)./maxvals(1),'ok')
hold on
plot(PT_all_92_mean(:,1)./maxvals_92(1),PT_all_92_std(:,1)./maxvals_92(1),'sk')
plot(PT_all_69_mean(:,1)./maxvals_69(1),PT_all_69_std(:,1)./maxvals_69(1),'*k')
xlabel('Dy/Eu Mean ratio'); ylabel('Dy/Eu Standard Deviation');
subplot(1,2,2);
plot(PT_all_mean(:,2)./maxvals(2),PT_all_std(:,2)./maxvals(2),'ok')
hold on
plot(PT_all_92_mean(:,2)./maxvals_92(2),PT_all_92_std(:,2)./maxvals_92(2),'sk')
plot(PT_all_69_mean(:,2)./maxvals_69(2),PT_all_69_std(:,2)./maxvals_69(2),'*k')
xlabel('Sm/Eu Mean ratio'); ylabel('Sm/Eu Standard Deviation');

