%analyzing 2/15/12 data
%data from 4x/0.2 objective with 1x C-mount 
% 2/10/12 matrix = M0210_n, where n=serpentine number
% 1/30/12 matrix = M0130_n, where n=serpentine number

camera_offset = 445;

M0210_1 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_2'));
M0210_1 = double(M0210_1) - camera_offset;

%get device background
for n=2:7
    slice = M0210_1(140:330,10:140,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec= Device_spec./sum(Device_spec);

spectra = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec];

temp = M0210_1(:,:,2:7); %drop brightfield
[M0210_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_1 = beadIntensities(M0210_1u, CC, 2);

M0210_2 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_4'));
M0210_2 = double(M0210_2) - camera_offset;
temp = M0210_2(:,:,2:7); %drop brightfield
[M0210_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_2 = beadIntensities(M0210_2u, CC, 2);

M0210_3 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_6'));
M0210_3 = double(M0210_3) - camera_offset;
temp = M0210_3(:,:,2:7); %drop brightfield
[M0210_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_3 = beadIntensities(M0210_3u, CC, 2);

M0210_4 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_8'));
M0210_4 = double(M0210_4) - camera_offset;
temp = M0210_4(:,:,2:7); %drop brightfield
[M0210_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_4 = beadIntensities(M0210_4u, CC, 2);

M0210_5 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_10'));
M0210_5 = double(M0210_5) - camera_offset;
temp = M0210_5(:,:,2:7); %drop brightfield
[M0210_5u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_5 = beadIntensities(M0210_5u, CC, 2);

M0210_6 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_12'));
M0210_6 = double(M0210_6) - camera_offset;
temp = M0210_6(:,:,2:7); %drop brightfield
[M0210_6u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_6 = beadIntensities(M0210_6u, CC, 2);

M0210_7 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_13'));
M0210_7 = double(M0210_7) - camera_offset;
temp = M0210_7(:,:,2:7); %drop brightfield
[M0210_7u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_7 = beadIntensities(M0210_7u, CC, 2);

M0210_8 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_15'));
M0210_8 = double(M0210_8) - camera_offset;
temp = M0210_8(:,:,2:7); %drop brightfield
[M0210_8u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_8 = beadIntensities(M0210_8u, CC, 2);

M0210_9 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_17'));
M0210_9 = double(M0210_9) - camera_offset;
temp = M0210_9(:,:,2:7); %drop brightfield
[M0210_9u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_9 = beadIntensities(M0210_9u, CC, 2);

M0210_10 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_19'));
M0210_10 = double(M0210_10) - camera_offset;
temp = M0210_10(:,:,2:7); %drop brightfield
[M0210_10u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_10 = beadIntensities(M0210_10u, CC, 2);

M0210_11 = squeeze(MMparse('Z:\Images\021512\24Codes_021012_21'));
M0210_11 = double(M0210_11) - camera_offset;
temp = M0210_11(:,:,2:7); %drop brightfield
[M0210_11u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0210_11u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0210_11 = beadIntensities(M0210_11u, CC, 2);

%1/30/2012 beads
M0130_1 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_1'));
M0130_1 = double(M0130_1) - camera_offset;
temp = M0130_1(:,:,2:7); %drop brightfield
[M0130_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_1 = beadIntensities(M0130_1u, CC, 2);

M0130_2 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_3'));
M0130_2 = double(M0130_2) - camera_offset;
temp = M0130_2(:,:,2:7); %drop brightfield
[M0130_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_2u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_2 = beadIntensities(M0130_2u, CC, 2);

M0130_3 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_5'));
M0130_3 = double(M0130_3) - camera_offset;
temp = M0130_3(:,:,2:7); %drop brightfield
[M0130_3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_3u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_3 = beadIntensities(M0130_3u, CC, 2);

M0130_4 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_7'));
M0130_4 = double(M0130_4) - camera_offset;
temp = M0130_4(:,:,2:7); %drop brightfield
[M0130_4u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_4u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_4 = beadIntensities(M0130_4u, CC, 2);

M0130_5 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_8'));
M0130_5 = double(M0130_5) - camera_offset;
temp = M0130_5(:,:,2:7); %drop brightfield
[M0130_5u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_5u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_5 = beadIntensities(M0130_5u, CC, 2);

M0130_6 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_10'));
M0130_6 = double(M0130_6) - camera_offset;
temp = M0130_6(:,:,2:7); %drop brightfield
[M0130_6u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_6u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_6 = beadIntensities(M0130_6u, CC, 2);

M0130_7 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_12'));
M0130_7 = double(M0130_7) - camera_offset;
temp = M0130_7(:,:,2:7); %drop brightfield
[M0130_7u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_7u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_7 = beadIntensities(M0130_7u, CC, 2);

M0130_8 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_14'));
M0130_8 = double(M0130_8) - camera_offset;
temp = M0130_8(:,:,2:7); %drop brightfield
[M0130_8u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_8u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_8 = beadIntensities(M0130_8u, CC, 2);

M0130_9 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_16'));
M0130_9 = double(M0130_9) - camera_offset;
temp = M0130_9(:,:,2:7); %drop brightfield
[M0130_9u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_9u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_9 = beadIntensities(M0130_9u, CC, 2);

M0130_10 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_19'));
M0130_10 = double(M0130_10) - camera_offset;
temp = M0130_10(:,:,2:7); %drop brightfield
[M0130_10u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130_10u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
I_M0130_10 = beadIntensities(M0130_10u, CC, 2);

clear M0130_all M0130_all_raw
M0130_all(1,:) = [[I_M0130_1(:,1).medianratio],[I_M0130_2(:,1).medianratio],[I_M0130_3(:,1).medianratio],[I_M0130_4(:,1).medianratio],[I_M0130_5(:,1).medianratio],[I_M0130_6(:,1).medianratio],[I_M0130_7(:,1).medianratio],[I_M0130_8(:,1).medianratio],[I_M0130_9(:,1).medianratio],[I_M0130_10(:,1).medianratio]];
M0130_all(2,:) = [[I_M0130_1(:,3).medianratio],[I_M0130_2(:,3).medianratio],[I_M0130_3(:,3).medianratio],[I_M0130_4(:,3).medianratio],[I_M0130_5(:,3).medianratio],[I_M0130_6(:,3).medianratio],[I_M0130_7(:,3).medianratio],[I_M0130_8(:,3).medianratio],[I_M0130_9(:,3).medianratio],[I_M0130_10(:,3).medianratio]];

M0130_all_raw(1,:) = [[I_M0130_2(:,1).median],[I_M0130_3(:,1).median],[I_M0130_4(:,1).median],[I_M0130_5(:,1).median],[I_M0130_6(:,1).median],[I_M0130_7(:,1).median],[I_M0130_8(:,1).median]];
M0130_all_raw(2,:) = [[I_M0130_2(:,2).median],[I_M0130_3(:,2).median],[I_M0130_4(:,2).median],[I_M0130_5(:,2).median],[I_M0130_6(:,2).median],[I_M0130_7(:,2).median],[I_M0130_8(:,2).median]];
M0130_all_raw(3,:) = [[I_M0130_2(:,3).median],[I_M0130_3(:,3).median],[I_M0130_4(:,3).median],[I_M0130_5(:,3).median],[I_M0130_6(:,3).median],[I_M0130_7(:,3).median],[I_M0130_8(:,3).median]];

temp = [I_M0130_1(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_1_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_2(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_2_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_3(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_3_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_3_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_4(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_4_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_4_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_5(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_5_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_5_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_6(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_6_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_6_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_7(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_7_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_7_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_8(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_8_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_8_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_9(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_9_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_9_centroid(2,:) = temp(2:2:end); %Y
temp = [I_M0130_10(:,2).centroid]; %returns as interleaved X,Y pairs
M0130_10_centroid(1,:) = temp(1:2:end); %deinterleave X
M0130_10_centroid(2,:) = temp(2:2:end); %Y

clear M0130_centroid
M0130_centroid = [M0130_1_centroid,M0130_2_centroid, M0130_3_centroid, M0130_4_centroid, M0130_5_centroid, M0130_6_centroid, M0130_7_centroid, M0130_8_centroid, M0130_9_centroid, M0130_10_centroid]; 

M0130_centerbeads = find(all(M0130_centroid>100) & all(M0130_centroid<400));

vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};
temp = [[I_M0130_1(:,1).medianratio]; [I_M0130_1(:,3).medianratio]]';
q = ICP(temp, target);
x_1=temp*q;

temp = [[I_M0130_2(:,1).medianratio]; [I_M0130_2(:,3).medianratio]]';
q = ICP(temp, target);
x_2=temp*q;

temp = [[I_M0130_3(:,1).medianratio]; [I_M0130_3(:,3).medianratio]]';
q = ICP(temp, target);
x_3=temp*q;

temp = [[I_M0130_4(:,1).medianratio]; [I_M0130_4(:,3).medianratio]]';
q = ICP(temp, target);
x_4=temp*q;

temp = [[I_M0130_5(:,1).medianratio]; [I_M0130_5(:,3).medianratio]]';
q = ICP(temp, target);
x_5=temp*q;

temp = [[I_M0130_6(:,1).medianratio]; [I_M0130_6(:,3).medianratio]]';
q = ICP(temp, target);
x_6=temp*q;

temp = [[I_M0130_7(:,1).medianratio]; [I_M0130_7(:,3).medianratio]]';
q = ICP(temp, target);
x_7=temp*q;

temp = [[I_M0130_8(:,1).medianratio]; [I_M0130_8(:,3).medianratio]]';
q = ICP(temp, target);
x_8=temp*q;

temp = [[I_M0130_9(:,1).medianratio]; [I_M0130_9(:,3).medianratio]]';
q = ICP(temp, target);
x_9=temp*q;

temp = [[I_M0130_10(:,1).medianratio]; [I_M0130_10(:,3).medianratio]]';
q = ICP(temp, target);
x_10=temp*q;

%all data independently transformed to account for scale errors from
%serpentine to serpentine
x_all = [x_1; x_2; x_3; x_4; x_5; x_6; x_7; x_8; x_9; x_10];

%global transformation for comparison:
q = ICP(M0130_all', target);
M0130_all_x = M0130_all' * q;

%now calculate standard deviations
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)-n+1
        k(index,:)=[vals(n); vals(m)];
        index=index+1;
    end
end
%then add [0.351 1.055], [0.598 0.69], and [0.91 0.405]
temp =M0130_all_x(M0130_centerbeads,:);
[Idx, M0130_all_mean] = kmeans(temp,[],'start',k);
clear M0130_all_std
for n=1:size(M0130_all_mean,1)
    list = Idx == n;
    M0130_all_std(n,:)= std(temp(list,:),0,1);
end

temp = x_all(M0130_centerbeads,:);
[Idx, M0130_x_all_mean] = kmeans(temp,[],'start',k);
clear M0130_x_all_std
for n=1:size(M0130_x_all_mean,1)
    list = Idx == n;
    M0130_x_all_std(n,:)= std(temp(list,:),0,1);
end

%replicate imaging
M0130_reps = squeeze(MMparse('Z:\Images\021512\24Codes_013012_Reps_2'));
M0130_reps = double(M0130_reps) - camera_offset;
for n=1:size(M0130_reps,3) %loop over time points
    temp = squeeze(M0130_reps(:,:,n,2:7)); %drop brightfield
    [slice,err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    M0130_reps_u(:,:,:,n) = slice;
end
temp = mean(M0130_reps_u(:,:,2,:),4);
mask = gen_bead_mask2(temp,7,-0.035);
CC = bwconncomp(mask,4);
clear M0130_replicateI
for n=1:size(M0130_reps_u,4)
    temp = beadIntensities(M0130_reps_u(:,:,:,n), CC, 2);
    temp = [[temp(:,1).medianratio]; [temp(:,3).medianratio]]';
    q = ICP(temp, target);
    temp=temp*q;
    M0130_replicateI(:,1,n) = temp(:,1);
    M0130_replicateI(:,2,n) = temp(:,2);
end
M0130_replicate_mean = mean(M0130_replicateI,3);
M0130_replicate_std = std(M0130_replicateI,0,3);
%k-means cluster on single axes to group
[Idx, M0130_replicate_mean_Dy] = kmeans(M0130_replicate_mean(:,1),[],'start',vals');
for n=1:numel(M0130_replicate_mean_Dy)
    list = Idx == n;
    M0130_replicate_std_Dy(n,:)= mean(M0130_replicate_std(list,1));
end
[Idx, M0130_replicate_mean_Sm] = kmeans(M0130_replicate_mean(:,2),[],'start',vals');
for n=1:numel(M0130_replicate_mean_Sm)
    list = Idx == n;
    M0130_replicate_std_Sm(n,:)= mean(M0130_replicate_std(list,2));
end

%figures

figure(1)
clf
plot(x_all(M0130_centerbeads,1), x_all(M0130_centerbeads,2), '.k')
xlabel('Dy/Eu mean'); ylabel('Sm/Eu mean')

figure(2)
clf
subplot(1,2,1)
plot(M0130_all_mean(:,1), M0130_all_std(:,1), 'ok');
hold on
plot(M0130_x_all_mean(:,1), M0130_x_all_std(:,1), 'sk');
xlabel('Dy/Eu mean');ylabel('Sm/Eu stdev')

subplot(1,2,2)
plot(M0130_all_mean(:,2), M0130_all_std(:,2), 'ok');
hold on
plot(M0130_x_all_mean(:,2), M0130_x_all_std(:,2), 'sk');
xlabel('Sm/Eu mean');ylabel('Sm/Eu stdev')

%making figure 5 for the paper
figure(3)
clf
%scatter plot
axes('Position', [0.2 0.2 0.7 0.7])
%plot(x_all(M0130_centerbeads,1), x_all(M0130_centerbeads,2), '.k')
%fancy coloring
temp = M0130dfx_all(M0130df_centerbeads,:);
hold on
for n=1:size(temp,1)
    C = [temp(n,2) 0 temp(n,1)];
    C = max(C,0);
    C = min(C,1);
    plot(temp(n,1), temp(n,2), '.', 'MarkerEdgeColor', C)
end
xlim([-0.1 1.2]);
ylim([-0.1 1.2]);
set(gca, 'XTickLabel',[],'YTickLabel',[], 'DataAspectRatio', [1 1 1], 'Box', 'on');% 'DataAspectRatioMode', 'manual', 'PlotBoxAspectRatioMode', 'manual');

%bottom histogram
axes('Position', [0.2 0.1 0.7 0.1])
[Y,X] = hist(M0130dfx_all(M0130df_centerbeads,1), bins);
bar(X,Y,'k')
hold on
sixgauss = @(x) x(13)*normpdf(X,x(1),x(7)) + x(14)*normpdf(X,x(2),x(8)) + x(15)*normpdf(X,x(3),x(9)) + x(16)*normpdf(X,x(4),x(10)) + x(17)*normpdf(X,x(5),x(11)) + x(18)*normpdf(X,x(6),x(12));
sixgauss_err = @(x) sum((Y-sixgauss(x)).^2);
gauss_params = fminsearch(sixgauss_err,[0 0.12 .27 .46 .7 0.97 .01 .01 .02 .02 .02 .03 5 4 4 3 2 1])
gauss_params = fminsearch(sixgauss_err, gauss_params)
plot(X, sixgauss(gauss_params),'r')
set(gca,'YDir','reverse','YTickLabel',[]);
xlim([-0.1 1.2]);
xlabel('Dy/Eu ratio')

figure(4)
clf
plot(gauss_params(1:6),gauss_params(7:12),'bo')
hold on
xlabel('Mean ratio');ylabel('Distribution width')
figure(3)
%side histogram
axes('Position', [0.1 0.2 0.1 0.7])
[Y,X] = hist(M0130dfx_all(M0130df_centerbeads,2), bins);
barh(X,Y,'k')
hold on
sixgauss = @(x) x(13)*normpdf(X,x(1),x(7)) + x(14)*normpdf(X,x(2),x(8)) + x(15)*normpdf(X,x(3),x(9)) + x(16)*normpdf(X,x(4),x(10)) + x(17)*normpdf(X,x(5),x(11)) + x(18)*normpdf(X,x(6),x(12));
sixgauss_err = @(x) sum((Y-sixgauss(x)).^2);
gauss_params = fminsearch(sixgauss_err,[0 0.12 .27 .46 .7 1 .01 .01 .02 .02 .03 .04 5 4 4 3 2 1])
gauss_params = fminsearch(sixgauss_err, gauss_params)
plot(sixgauss(gauss_params), X,'r')
set(gca,'XDir','reverse','XTickLabel',[]);
ylim([-0.1 1.2]);
ylabel('Sm/Eu ratio')
figure(4)
plot(gauss_params(1:6),gauss_params(7:12),'ro')

%add in statistical error
figure(4)
plot((M0130_replicate_mean_Dy+M0109_replicate_mean_Dy)/2, (M0130_replicate_std_Sm+M0109_replicate_std_Dy)/2, 'sb')
plot((M0130_replicate_mean_Sm+M0109_replicate_mean_Sm)/2, (M0130_replicate_std_Sm+M0109_replicate_std_Sm)/2, 'sr')
xlim([-0.1 1.2]);
ylim auto

%inset
figure(5)
clf
plot(k(:,1), k(:,2), 'b.')
hold on
plot(M0130dfx_all_mean(:,1), M0130dfx_all_mean(:,2), 'r.')
xlim([-0.05 1.05]);
ylim([-0.05 1.05]);
set(gca, 'XTick',[0 0.5 1.0], 'YTick',[0 0.5 1.0])
axis square

%mean deviation from target
mean(sqrt(sum((k-M0130_x_all_mean).^2,2)))

%pieces for unmixing figure
for n=1:10
    imname = ['M0130_',sprintf('%d', n), '(:,:,2)'];
    figure(n)
    imshow(eval(imname), [])
end

for n=1:7
    figure(n)
    q=imrotate(M0130_10(:,:,n),-3,'bilinear','crop');
    imshow(q(120:400,115:395),[])
    im = q(120:400,115:395);
    im = im - min(im(:));
    im = im./max(im(:));
    im=uint8(im*255);
    imwrite(im, ['C:\Kurt\Spectral barcoding\Paper I\rawimage',sprintf('%d',n),'.tif']);
    axis image
end

for n=1:4
    figure(n)
    q=imrotate(M0130_10u(:,:,n),-3,'bilinear','crop');
    im = q(120:400,115:395);
    im = im - min(im(:));
    im = im./max(im(:));
    imshow(im,stretchlim(im,[0.001, 0.999]))
    %im=imadjust(im,stretchlim(im, [0.001, 0.999]),[]);
    im=uint8(im*255);
    imwrite(im, ['C:\Kurt\Spectral barcoding\Paper I\unmixedimage',sprintf('%d',n),'.tif']);
    axis image
end


q=imrotate(M0130_10u(:,:,1),-3,'bilinear','crop');
im = q(120:400,115:395);
im = im - min(im(:));
im = im./max(im(:));
RGB=zeros([size(im) 3]);
RGB(:,:,3) = im; %Dy
q=imrotate(M0130_10u(:,:,2),-3,'bilinear','crop');
im = q(120:400,115:395);
im = im - min(im(:));
im = im./max(im(:));
RGB(:,:,1) = im; %Eu
q=imrotate(M0130_10u(:,:,3),-3,'bilinear','crop');
im = q(120:400,115:395);
im = im - min(im(:));
im = im./max(im(:));
RGB(:,:,2) = im; %Sm

%work out number of sigmas each data point falls from its cluster centroid
temp = x_all(M0130_centerbeads,:);
[Idx, M0130_x_all_mean] = kmeans(temp,[],'start',k);
clear M0130_x_all_std
for n=1:size(M0130_x_all_mean,1)
    list = Idx == n;
    M0130_x_all_std(n,:)= std(temp(list,:),0,1);
end

nsigmas=[];
for n=1:size(M0130_x_all_mean,1)
    list = Idx == n;
    currdata = temp(list,:);
    %subtract mean and divide by sigma
    currdata = currdata - repmat(M0130_x_all_mean(n,:),[size(currdata,1) 1]);
    currdata = currdata ./ repmat(M0130_x_all_std(n,:),[size(currdata,1) 1]);
    nsigmas=[nsigmas; currdata];
end

nsigmas =sqrt(sum(nsigmas.^2,2));
