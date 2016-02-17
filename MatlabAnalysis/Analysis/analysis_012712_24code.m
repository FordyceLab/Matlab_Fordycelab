%analyzing 1/27/12 data, part 2
%data from 4x/0.2 objective with 1x C-mount
%18 Code Matrix from 1/18 = M0118
%24 Code matrix from 1/9 = M0109
%serpentine number is _n
%assume camera_offset, spectra already defined.

M0109_1 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_1'));
M0109_1 = double(M0109_1) - camera_offset;
temp = M0109_1(:,:,2:8); %drop brightfield
[M0109_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0109_1 = beadIntensities(M0109_1u, CC, 2);

M0109_2 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_2'));
M0109_2 = double(M0109_2) - camera_offset;
temp = M0109_2(:,:,2:8); %drop brightfield
[M0109_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_2u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_2 = beadIntensities(M0109_2u, CC, 2);

M0109_3 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_3'));
M0109_3 = double(M0109_3) - camera_offset;
temp = M0109_3(:,:,2:8); %drop brightfield
[M0109_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_3u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_3 = beadIntensities(M0109_3u, CC, 2);

M0109_4 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_4'));
M0109_4 = double(M0109_4) - camera_offset;
temp = M0109_4(:,:,2:8); %drop brightfield
[M0109_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_4u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_4 = beadIntensities(M0109_4u, CC, 2);

M0109_5 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_5'));
M0109_5 = double(M0109_5) - camera_offset;
temp = M0109_5(:,:,2:8); %drop brightfield
[M0109_5u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_5u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_5 = beadIntensities(M0109_5u, CC, 2);

M0109_6 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_6'));
M0109_6 = double(M0109_6) - camera_offset;
temp = M0109_6(:,:,2:8); %drop brightfield
[M0109_6u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_6u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_6 = beadIntensities(M0109_6u, CC, 2);

M0109_7 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_7'));
M0109_7 = double(M0109_7) - camera_offset;
temp = M0109_7(:,:,2:8); %drop brightfield
[M0109_7u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_7u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_7 = beadIntensities(M0109_7u, CC, 2);

M0109_8 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_8'));
M0109_8 = double(M0109_8) - camera_offset;
temp = M0109_8(:,:,2:8); %drop brightfield
[M0109_8u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_8u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_8 = beadIntensities(M0109_8u, CC, 2);

M0109_9 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_9'));
M0109_9 = double(M0109_9) - camera_offset;
temp = M0109_9(:,:,2:8); %drop brightfield
[M0109_9u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_9u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_9 = beadIntensities(M0109_9u, CC, 2);

M0109_10 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_10'));
M0109_10 = double(M0109_10) - camera_offset;
temp = M0109_10(:,:,2:8); %drop brightfield
[M0109_10u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_10u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_10 = beadIntensities(M0109_10u, CC, 2);

M0109_11 = squeeze(MMparse('Z:\Keck\012712\BeadMatrix_24codes_4x_1x_11'));
M0109_11 = double(M0109_11) - camera_offset;
temp = M0109_11(:,:,2:8); %drop brightfield
[M0109_11u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0109_11u(:,:,2),7,-0.04);
CC = bwconncomp(mask,4);
I_M0109_11 = beadIntensities(M0109_11u, CC, 2);

M0109_all(1,:) = [[I_M0109_1(:,1).medianratio],[I_M0109_2(:,1).medianratio],[I_M0109_3(:,1).medianratio],[I_M0109_3(:,1).medianratio],[I_M0109_4(:,1).medianratio],[I_M0109_5(:,1).medianratio],[I_M0109_6(:,1).medianratio],[I_M0109_7(:,1).medianratio],[I_M0109_8(:,1).medianratio],[I_M0109_9(:,1).medianratio],[I_M0109_10(:,1).medianratio],[I_M0109_11(:,1).medianratio]];
M0109_all(2,:) = [[I_M0109_1(:,3).medianratio],[I_M0109_2(:,3).medianratio],[I_M0109_3(:,3).medianratio],[I_M0109_3(:,3).medianratio],[I_M0109_4(:,3).medianratio],[I_M0109_5(:,3).medianratio],[I_M0109_6(:,3).medianratio],[I_M0109_7(:,3).medianratio],[I_M0109_8(:,3).medianratio],[I_M0109_9(:,3).medianratio],[I_M0109_10(:,3).medianratio],[I_M0109_11(:,3).medianratio]];

%initial values for k-means clustering
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
valsx = vals*1.3;
valsy = vals*1.5;
clear k
index=1;
for n=1:numel(valsx)
    for m=1:numel(valsx)-n+1
        k(index,:)=[valsx(n); valsy(m)];
        index=index+1;
    end
end
%then delete [0.91,0], add [0.351 1.055], [0.598 0.69], and [0.91 0.405]
[Idx, M0109_all_mean] = kmeans(M0109_all',[],'start',k);
clear M0109_all_std
for n=1:size(M0109_all_mean,1)
    list = Idx == n;
    M0109_all_std(n,:)= std(M0109_all(:,list),0,2);
end


%parts for figure 5
%scatter plot; rescale so cluster max centroid is at 1.0 on each axis
maxvals = max(M0109_all_mean);
figure(1)
clf
plot(M0109_all(1,:)./maxvals(1), M0109_all(2,:)./maxvals(2),'.k')
bins = -0.05:0.01:1.2;
[Y,X] = hist(M0109_all(1,:)./maxvals(1), bins);
sixgauss = @(x) x(13)*normpdf(X,x(1),x(7)) + x(14)*normpdf(X,x(2),x(8)) + x(15)*normpdf(X,x(3),x(9)) + x(16)*normpdf(X,x(4),x(10)) + x(17)*normpdf(X,x(5),x(11)) + x(18)*normpdf(X,x(6),x(12));
sixgauss_err = @(x) sum((Y-sixgauss(x)).^2);
gauss_params = fminsearch(sixgauss_err,[0 0.13 .28 .47 .7 1 .01 .01 .02 .03 .03 .05 5 5 5 5 2 1])
gauss_params = fminsearch(sixgauss_err, gauss_params)
figure(2)
clf
hist(M0109_all(1,:)./maxvals(1), bins)
hold on
plot(X, sixgauss(gauss_params),'r')
figure(4)
plot(gauss_params(1:6),gauss_params(7:12),'ok')
hold on
xlabel('Mean ratio');ylabel('Distribution width')

[Y,X] = hist(M0109_all(2,:)./maxvals(2), bins);
sixgauss = @(x) x(13)*normpdf(X,x(1),x(7)) + x(14)*normpdf(X,x(2),x(8)) + x(15)*normpdf(X,x(3),x(9)) + x(16)*normpdf(X,x(4),x(10)) + x(17)*normpdf(X,x(5),x(11)) + x(18)*normpdf(X,x(6),x(12));
sixgauss_err = @(x) sum((Y-sixgauss(x)).^2);
gauss_params = fminsearch(sixgauss_err,[0 0.13 .28 .47 .7 1 .01 .01 .02 .03 .03 .05 5 5 5 5 2 1])
gauss_params = fminsearch(sixgauss_err, gauss_params)
figure(3)
clf
hist(M0109_all(2,:)./maxvals(2), bins)
hold on
plot(X, sixgauss(gauss_params),'r')
figure(4)
plot(gauss_params(1:6),gauss_params(7:12),'sk')


%std dev plotting
clf
subplot(1,2,1); hold on;
plot(M0109_all_mean(:,1)./maxvals(1),M0109_all_std(:,1)./maxvals(1),'ok')
xlabel('Dy/Eu Mean ratio'); ylabel('Dy/Eu Standard Deviation');
subplot(1,2,2);
plot(M0109_all_mean(:,2)./maxvals(2),M0109_all_std(:,2)./maxvals(2),'ok')
xlabel('Sm/Eu Mean ratio'); ylabel('Sm/Eu Standard Deviation');

plot(M0109_all_mean(:,2)./maxvals(2),M0109_all_std(:,1)./maxvals(1),'ok')

clf
plot(M0109_all_mean(:,1)./maxvals(1),M0109_all_std(:,1)./maxvals(1),'ok')
hold on
plot(M0109_all_mean(:,2)./maxvals(2),M0109_all_std(:,2)./maxvals(2),'sk')

%generate comparison between target levels and actual cluster centroids
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
transform = ICP(M0109_all_mean,{vals',vals'})
clear target
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)-n+1
        target(index,:)=[vals(n); vals(m)];
        index=index+1;
    end
end
figure(1);clf
M0109_all_mean_T = M0109_all_mean*transform;
plot(M0109_all_mean_T(:,1), M0109_all_mean_T(:,2),'*k');
hold on
plot(target(:,1), target(:,2), 'ok')
axis equal

M0109_all_T = M0109_all'*transform;
maxvals = max(M0109_all_T);
clf
hold on
for n=1:size(M0109_all_T,1)
    C = [M0109_all_T(n,2)/maxvals(2) 0 M0109_all_T(n,1)/maxvals(1)];
    C = max(C,0);
    C = min(C,1);
    plot(M0109_all_T(n,1), M0109_all_T(n,2), '.', 'MarkerEdgeColor', C)
end
xlabel('Dy/Eu'); ylabel('Sm/Eu')


