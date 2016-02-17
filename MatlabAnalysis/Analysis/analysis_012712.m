%analyzing data taken with both 10x, 4x objectives and 0.7x, 1x C-mounts

camera_offset = 445;

Im10x07_1 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_10x_0.7xProj_2'));
Im10x07_1 = double(Im10x07_1) - camera_offset;

%get device background
for n=2:8
    slice = Im10x07_1(10:490,5:40,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec_10x = Device_spec./sum(Device_spec);
spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec_10x];

temp = Im10x07_1(:,:,2:8); %drop brightfield
[Im10x07_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im10x07_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Im10x07_1 = beadIntensities(Im10x07_1u, CC, 2);

Im10x07_2 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_10x_0.7xProj_3'));
Im10x07_2 = double(Im10x07_2) - camera_offset;
temp = Im10x07_2(:,:,2:8); %drop brightfield
[Im10x07_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im10x07_2u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Im10x07_2 = beadIntensities(Im10x07_2u, CC, 2);

Im10x1_1 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_10x_1xProj_2'));
Im10x1_1 = double(Im10x1_1) - camera_offset;
temp = Im10x1_1(:,:,2:8); %drop brightfield
[Im10x1_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im10x1_1u(:,:,2),28,-0.08);
CC = bwconncomp(mask,4);
I_Im10x1_1 = beadIntensities(Im10x1_1u, CC, 2);

Im10x1_2 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_10x_1xProj_3'));
Im10x1_2 = double(Im10x1_2) - camera_offset;
temp = Im10x1_2(:,:,2:8); %drop brightfield
[Im10x1_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im10x1_2u(:,:,2),28,-0.08);
CC = bwconncomp(mask,4);
I_Im10x1_2 = beadIntensities(Im10x1_2u, CC, 2);

%4x images
Im4x07_1 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_0.7xProj_3'));
Im4x07_1 = double(Im4x07_1) - camera_offset;

%get device background
for n=2:8
    slice = Im4x07_1(130:280,100:150,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec_4x = Device_spec./sum(Device_spec);
spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec_4x];

temp = Im4x07_1(:,:,2:8); %drop brightfield
[Im4x07_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im4x07_1u(:,:,2),5,-0.02);
CC = bwconncomp(mask,4);
I_Im4x07_1 = beadIntensities(Im4x07_1u, CC, 2);

Im4x07_2 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_0.7xProj_4'));
Im4x07_2 = double(Im4x07_2) - camera_offset;
temp = Im4x07_2(:,:,2:8); %drop brightfield
[Im4x07_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im4x07_2u(:,:,2),5,-0.03);
CC = bwconncomp(mask,4);
I_Im4x07_2 = beadIntensities(Im4x07_2u, CC, 2);

Im4x1_1 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1xProj_2'));
Im4x1_1 = double(Im4x1_1) - camera_offset;
temp = Im4x1_1(:,:,2:8); %drop brightfield
[Im4x1_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im4x1_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_Im4x1_1 = beadIntensities(Im4x1_1u, CC, 2);

Im4x1_2 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_18codes_4x_1xProj_3'));
Im4x1_2 = double(Im4x1_2) - camera_offset;
temp = Im4x1_2(:,:,2:8); %drop brightfield
[Im4x1_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Im4x1_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_Im4x1_2 = beadIntensities(Im4x1_2u, CC, 2);

%looks like there might be a systematic shift between these two data sets
x10_1_all(1,:) = [[I_Im10x1_1(:,1).medianratio],[I_Im10x1_2(:,1).medianratio]];
x10_1_all(2,:) = [[I_Im10x1_1(:,3).medianratio],[I_Im10x1_2(:,3).medianratio]];

x10_07_all(1,:) = [[I_Im10x07_1(:,1).medianratio],[I_Im10x07_2(:,1).medianratio]];
x10_07_all(2,:) = [[I_Im10x07_1(:,3).medianratio],[I_Im10x07_2(:,3).medianratio]];

x4_1_all(1,:) = [[I_Im4x1_1(:,1).medianratio],[I_Im4x1_2(:,1).medianratio]];
x4_1_all(2,:) = [[I_Im4x1_1(:,3).medianratio],[I_Im4x1_2(:,3).medianratio]];

x4_07_all(1,:) = [[I_Im4x07_1(:,1).medianratio],[I_Im4x07_2(:,1).medianratio]];
x4_07_all(2,:) = [[I_Im4x07_1(:,3).medianratio],[I_Im4x07_2(:,3).medianratio]];

%initial values for k-means clustering
valsx = [0 0.12 0.25 0.5 1] * 1;
valsy = valsx*1.5;
clear k18
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)-n+1
        k18(index,:)=[valsx(n); valsy(m)];
        index=index+1;
    end
end
%then delete [0,0], add [0.25 0.75], [0.5 0.375], and [0.5 0.75]
[Idx, x10_1_all_mean] = kmeans(x10_1_all',[],'start',k18);
clear x10_1_all_std
for n=1:size(x10_1_all_mean,1)
    list = Idx == n;
    x10_1_all_std(n,:)= std(x10_1_all(:,list),0,2);
end

[Idx, x10_07_all_mean] = kmeans(x10_07_all',[],'start',k18);
clear x10_07_all_std
for n=1:size(x10_07_all_mean,1)
    list = Idx == n;
    x10_07_all_std(n,:)= std(x10_07_all(:,list),0,2);
end

[Idx, x4_1_all_mean] = kmeans(x4_1_all',[],'start',k18);
clear x4_1_all_std
for n=1:size(x4_1_all_mean,1)
    list = Idx == n;
    x4_1_all_std(n,:)= std(x4_1_all(:,list),0,2);
end

[Idx, x4_07_all_mean] = kmeans(x4_07_all',[],'start',k18);
clear x4_07_all_std
for n=1:size(x4_07_all_mean,1)
    list = Idx == n;
    x4_07_all_std(n,:)= std(x4_07_all(:,list),0,2);
end

clear x10_1_all_delta
for n=1:size(x10_1_all,2)
    x10_1_all_delta(:,n)= x10_1_all(:,n) - x10_1_all_mean(Idx(n),:)';
end
clear x10_07_all_delta
for n=1:size(x10_07_all,2)
    x10_07_all_delta(:,n)= x10_07_all(:,n) - x10_07_all_mean(Idx(n),:)';
end
clear x4_1_all_delta
for n=1:size(x4_1_all,2)
    x4_1_all_delta(:,n)= x4_1_all(:,n) - x4_1_all_mean(Idx(n),:)';
end
clear x4_07_all_delta
for n=1:size(x4_07_all,2)
    x4_07_all_delta(:,n)= x4_07_all(:,n) - x4_07_all_mean(Idx(n),:)';
end

%get centroids
temp = [I_Im10x1_1(:,2).centroid]; %returns as interleaved X,Y pairs
x10_1_1_centroid(1,:) = temp(1:2:end); %deinterleave X
x10_1_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Im10x1_2(:,2).centroid]; %returns as interleaved X,Y pairs
x10_1_2_centroid(1,:) = temp(1:2:end); %deinterleave X
x10_1_2_centroid(2,:) = temp(2:2:end); %Y
x10_1_centroid = [x10_1_1_centroid, x10_1_2_centroid];

temp = [I_Im10x07_1(:,2).centroid]; %returns as interleaved X,Y pairs
x10_07_1_centroid(1,:) = temp(1:2:end); %deinterleave X
x10_07_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Im10x07_2(:,2).centroid]; %returns as interleaved X,Y pairs
x10_07_2_centroid(1,:) = temp(1:2:end); %deinterleave X
x10_07_2_centroid(2,:) = temp(2:2:end); %Y
x10_07_centroid = [x10_07_1_centroid, x10_07_2_centroid];

temp = [I_Im4x1_1(:,2).centroid]; %returns as interleaved X,Y pairs
x4_1_1_centroid(1,:) = temp(1:2:end); %deinterleave X
x4_1_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Im4x1_2(:,2).centroid]; %returns as interleaved X,Y pairs
x4_1_2_centroid(1,:) = temp(1:2:end); %deinterleave X
x4_1_2_centroid(2,:) = temp(2:2:end); %Y
x4_1_centroid = [x4_1_1_centroid, x4_1_2_centroid];

temp = [I_Im4x07_1(:,2).centroid]; %returns as interleaved X,Y pairs
x4_07_1_centroid(1,:) = temp(1:2:end); %deinterleave X
x4_07_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Im4x07_2(:,2).centroid]; %returns as interleaved X,Y pairs
x4_07_2_centroid(1,:) = temp(1:2:end); %deinterleave X
x4_07_2_centroid(2,:) = temp(2:2:end); %Y
x4_07_centroid = [x4_07_1_centroid, x4_07_2_centroid];


step=50;
index = 1;
for n=step:step:500
    beads = find(x10_1_centroid(1,:)<n & x10_1_centroid(1,:)>=n-step);
    x10_1_binned_cent_X(index) = median(x10_1_centroid(1,beads));
    x10_1_all_binned_X(1,index) = median(x10_1_all_delta(1,beads));
    x10_1_all_binned_X(2,index) = median(x10_1_all_delta(2,beads));
    beads = find(x10_07_centroid(1,:)<n & x10_07_centroid(1,:)>=n-step);
    x10_07_binned_cent_X(index) = median(x10_07_centroid(1,beads));
    x10_07_all_binned_X(1,index) = median(x10_07_all_delta(1,beads));
    x10_07_all_binned_X(2,index) = median(x10_07_all_delta(2,beads));
    beads = find(x4_1_centroid(1,:)<n & x4_1_centroid(1,:)>=n-step);
    x4_1_binned_cent_X(index) = median(x4_1_centroid(1,beads));
    x4_1_all_binned_X(1,index) = median(x4_1_all_delta(1,beads));
    x4_1_all_binned_X(2,index) = median(x4_1_all_delta(2,beads));
    beads = find(x4_07_centroid(1,:)<n & x4_07_centroid(1,:)>=n-step);
    x4_07_binned_cent_X(index) = median(x4_07_centroid(1,beads));
    x4_07_all_binned_X(1,index) = median(x4_07_all_delta(1,beads));
    x4_07_all_binned_X(2,index) = median(x4_07_all_delta(2,beads));
    
    beads = find(x10_1_centroid(2,:)<n & x10_1_centroid(2,:)>=n-step);
    x10_1_binned_cent_Y(index) = median(x10_1_centroid(2,beads));
    x10_1_all_binned_Y(1,index) = median(x10_1_all_delta(1,beads));
    x10_1_all_binned_Y(2,index) = median(x10_1_all_delta(2,beads));
    beads = find(x10_07_centroid(2,:)<n & x10_07_centroid(2,:)>=n-step);
    x10_07_binned_cent_Y(index) = median(x10_07_centroid(2,beads));
    x10_07_all_binned_Y(1,index) = median(x10_07_all_delta(1,beads));
    x10_07_all_binned_Y(2,index) = median(x10_07_all_delta(2,beads));
    beads = find(x4_1_centroid(2,:)<n & x4_1_centroid(2,:)>=n-step);
    x4_1_binned_cent_Y(index) = median(x4_1_centroid(2,beads));
    x4_1_all_binned_Y(1,index) = median(x4_1_all_delta(1,beads));
    x4_1_all_binned_Y(2,index) = median(x4_1_all_delta(2,beads));
    beads = find(x4_07_centroid(2,:)<n & x4_07_centroid(2,:)>=n-step);
    x4_07_binned_cent_Y(index) = median(x4_07_centroid(2,beads));
    x4_07_all_binned_Y(1,index) = median(x4_07_all_delta(1,beads));
    x4_07_all_binned_Y(2,index) = median(x4_07_all_delta(2,beads));
    
    index = index+1;
end

%std dev plotting
x10_1_maxvals = max(x10_1_all_mean);
x10_07_maxvals = max(x10_07_all_mean);
x4_1_maxvals = max(x4_1_all_mean);
x4_07_maxvals = max(x4_07_all_mean);
figure(1)
clf
subplot(1,2,1); hold on;
plot(x10_1_all_mean(:,1)./x10_1_maxvals(1),x10_1_all_std(:,1)./x10_1_maxvals(1),'ok')
plot(x10_07_all_mean(:,1)./x10_07_maxvals(1),x10_07_all_std(:,1)./x10_07_maxvals(1),'sk')
plot(x4_1_all_mean(:,1)./x4_1_maxvals(1),x4_1_all_std(:,1)./x4_1_maxvals(1),'*k')
plot(x4_07_all_mean(:,1)./x4_07_maxvals(1),x4_07_all_std(:,1)./x4_07_maxvals(1),'pk')
xlabel('Dy/Eu Mean ratio'); ylabel('Dy/Eu Standard Deviation');
subplot(1,2,2); hold on;
plot(x10_1_all_mean(:,2)./x10_1_maxvals(2),x10_1_all_std(:,2)./x10_1_maxvals(2),'ok')
plot(x10_07_all_mean(:,2)./x10_07_maxvals(2),x10_07_all_std(:,2)./x10_07_maxvals(2),'sk')
plot(x4_1_all_mean(:,2)./x4_1_maxvals(2),x4_1_all_std(:,2)./x4_1_maxvals(2),'*k')
plot(x4_07_all_mean(:,2)./x4_07_maxvals(2),x4_07_all_std(:,2)./x4_07_maxvals(2),'pk')
xlabel('Sm/Eu Mean ratio'); ylabel('Sm/Eu Standard Deviation');

figure(2)
clf
subplot(2,2,1)
plot(x10_1_binned_cent_X, x10_1_all_binned_X(1,:),'k')
hold on
plot(x10_07_binned_cent_X, x10_07_all_binned_X(1,:),'--k')
plot(x4_1_binned_cent_X, x4_1_all_binned_X(1,:),'-.k')
plot(x4_07_binned_cent_X, x4_07_all_binned_X(1,:),':k')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,2)
plot(x10_1_binned_cent_Y, x10_1_all_binned_Y(1,:),'k')
hold on
plot(x10_07_binned_cent_Y, x10_07_all_binned_Y(1,:),'--k')
plot(x4_1_binned_cent_Y, x4_1_all_binned_Y(1,:),'-.k')
plot(x4_07_binned_cent_Y, x4_07_all_binned_Y(1,:),':k')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,3)
plot(x10_1_binned_cent_X, x10_1_all_binned_X(2,:),'k')
hold on
plot(x10_07_binned_cent_X, x10_07_all_binned_X(2,:),'--k')
plot(x4_1_binned_cent_X, x4_1_all_binned_X(2,:),'-.k')
plot(x4_07_binned_cent_X, x4_07_all_binned_X(2,:),':k')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')

subplot(2,2,4)
plot(x10_1_binned_cent_Y, x10_1_all_binned_Y(2,:),'k')
hold on
plot(x10_07_binned_cent_Y, x10_07_all_binned_Y(2,:),'--k')
plot(x4_1_binned_cent_Y, x4_1_all_binned_Y(2,:),'-.k')
plot(x4_07_binned_cent_Y, x4_07_all_binned_Y(2,:),':k')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')
