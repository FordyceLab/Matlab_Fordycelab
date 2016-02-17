dark_10ms = squeeze(MMparse('Z:\Images\020912\dark_10ms_1'));
dark_10ms = double(dark_10ms);
mdark_10ms = mean(dark_10ms,3);

dark_1s = squeeze(MMparse('Z:\Images\020912\dark_1s_1'));
dark_1s = double(dark_1s);
mdark_1s = mean(dark_1s,3);

flat_10ms = squeeze(MMparse('Z:\Images\020912\flat_10ms_1'));
flat_10ms = double(flat_10ms);
mflat_10ms = squeeze(mean(flat_10ms,3)) - repmat(mdark_10ms,[1 1 6]);

%normalize each channel to mean of 1
for n=1:size(mflat_10ms,3)
    slice = mflat_10ms(:,:,n);
    mnflat(:,:,n) = slice./mean(slice(:));
end

meanim = mean(mnflat,3); %this is the mean intensity image
for n=1:size(mnflat,3)
    corrim(:,:,n) = meanim./mnflat(:,:,n);
end

redslide = squeeze(MMparse('Z:\Images\020912\redslide_1'));
redslide = double(redslide) - repmat(mdark_10ms,[1 1 6]);
redslide_corr = redslide.*corrim;

redslide2 = squeeze(MMparse('Z:\Images\020912\redslide_2'));
redslide2 = double(redslide2) - repmat(mdark_10ms,[1 1 6]);
redslide2_corr = redslide2.*corrim;

redslide3 = squeeze(MMparse('Z:\Images\020912\redslide_UVblock_1'));
redslide3 = double(redslide3) - repmat(mdark_10ms,[1 1 6]);
redslide3_corr = redslide3.*corrim;

redslide4 = squeeze(MMparse('Z:\Images\020912\redslide_UVblock_2'));
redslide4 = double(redslide4) - repmat(mdark_10ms,[1 1 6]);
redslide4_corr = redslide4.*corrim;

rat1 = redslide(:,:,5)./redslide(:,:,6);
rat1c = redslide_corr(:,:,5)./redslide_corr(:,:,6);
rat1=rat1./mean(rat1(:));
rat1c=rat1c./mean(rat1c(:));
rat2 = redslide2(:,:,5)./redslide2(:,:,6);
rat2c = redslide2_corr(:,:,5)./redslide2_corr(:,:,6);
rat2=rat2./mean(rat2(:));
rat2c=rat2c./mean(rat2c(:));

rat3 = redslide3(:,:,5)./redslide3(:,:,6);
rat3c = redslide3_corr(:,:,5)./redslide3_corr(:,:,6);
rat3=rat3./mean(rat3(:));
rat3c=rat3c./mean(rat3c(:));

rat4 = redslide4(:,:,5)./redslide4(:,:,6);
rat4c = redslide4_corr(:,:,5)./redslide4_corr(:,:,6);
rat4=rat4./mean(rat4(:));
rat4c=rat4c./mean(rat4c(:));

figure(1)
subplot(1,2,1)
imshow(rat1,[0.97 1.03]);
%colormap('jet');
colorbar
subplot(1,2,2)
imshow(rat1c,[0.97 1.03]);
%colormap('jet');
colorbar

figure(2)
subplot(1,2,1)
imshow(rat2,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(rat2c,[0.97 1.03]);
colormap('jet');colorbar

figure(3)
subplot(1,2,1)
imshow(rat3,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(rat3c,[0.97 1.03]);
colormap('jet');colorbar

figure(4)
subplot(1,2,1)
imshow(rat4,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(rat4c,[0.97 1.03]);
colormap('jet');colorbar

BiSm = squeeze(MMparse('Z:\Images\020912\BiSm_1'));
BiSm = double(BiSm) - repmat(mdark_1s,[1 1 6]);
BiSm_corr = BiSm.*corrim;
BiSmR = BiSm(:,:,5)./BiSm(:,:,6);
BiSm_corrR = BiSm_corr(:,:,5)./BiSm_corr(:,:,6);
BiSmR=BiSmR./mean(BiSmR(:));
BiSm_corrR=BiSm_corrR./mean(BiSm_corrR(:));

figure(5)
subplot(1,2,1)
imshow(BiSmR,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(BiSm_corrR,[0.97 1.03]);
colormap('jet');colorbar

BiSm2 = squeeze(MMparse('Z:\Images\020912\BiSm_2'));
BiSm2 = double(BiSm2(:,:,2:3)) - repmat(mdark_1s,[1 1 2]);
BiSm2_corr = BiSm2.*corrim(:,:,5:6);
BiSm2R = BiSm2(:,:,1)./BiSm2(:,:,2);
BiSm2_corrR = BiSm2_corr(:,:,1)./BiSm2_corr(:,:,2);
BiSm2R=BiSm2R./mean(BiSm2R(:));
BiSm2_corrR=BiSm2_corrR./mean(BiSm2_corrR(:));
figure(5)
subplot(1,2,1)
imshow(BiSm2R,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(BiSm2_corrR,[0.97 1.03]);
colormap('jet');colorbar

BiEu1 = squeeze(MMparse('Z:\Images\020912\BiEu_1'));
BiEu1 = double(BiEu1) - repmat(mdark_1s,[1 1 2]);
BiEu1_corr = BiEu1.*corrim(:,:,5:6);
BiEu1R = BiEu1(:,:,1)./BiEu1(:,:,2);
BiEu1_corrR = BiEu1_corr(:,:,1)./BiEu1_corr(:,:,2);
BiEu1R=BiEu1R./mean(BiEu1R(:));
BiEu1_corrR=BiEu1_corrR./mean(BiEu1_corrR(:));
figure(5)
subplot(1,2,1)
imshow(BiEu1R,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(BiEu1_corrR,[0.97 1.03]);
colormap('jet');colorbar

BiEu2 = squeeze(MMparse('Z:\Images\020912\BiEu_2'));
BiEu2 = double(BiEu2) - repmat(mdark_1s,[1 1 2]);
BiEu2_corr = BiEu2.*corrim(:,:,5:6);
BiEu2R = BiEu2(:,:,1)./BiEu2(:,:,2);
BiEu2_corrR = BiEu2_corr(:,:,1)./BiEu2_corr(:,:,2);
BiEu2R=BiEu2R./mean(BiEu2R(:));
BiEu2_corrR=BiEu2_corrR./mean(BiEu2_corrR(:));
figure(6)
subplot(1,2,1)
imshow(BiEu2R,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(BiEu2_corrR,[0.97 1.03]);
colormap('jet');colorbar

BiEu3 = squeeze(MMparse('Z:\Images\020912\BiEu_6'));
BiEu3 = double(BiEu3) - repmat(mdark_1s,[1 1 2]);
BiEu3_corr = BiEu3.*corrim(:,:,5:6);
BiEu3R = BiEu3(:,:,1)./BiEu3(:,:,2);
BiEu3_corrR = BiEu3_corr(:,:,1)./BiEu3_corr(:,:,2);
BiEu3R=BiEu3R./mean(BiEu3R(:));
BiEu3_corrR=BiEu3_corrR./mean(BiEu3_corrR(:));
figure(7)
subplot(1,2,1)
imshow(BiEu3R,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(BiEu3_corrR,[0.97 1.03]);
colormap('jet');colorbar

%BiEu8 is two sequential exposures at 615 and 630

BiEu8 = squeeze(MMparse('Z:\Images\020912\BiEu_8'));
BiEu8 = double(BiEu8) - repmat(mdark_1s,[1 1 2 2]);
BiEu8_corr(:,:,1,1) = BiEu8(:,:,1,1).*corrim(:,:,5);
BiEu8_corr(:,:,1,2) = BiEu8(:,:,1,2).*corrim(:,:,6);
BiEu8_corr(:,:,2,1) = BiEu8(:,:,2,1).*corrim(:,:,5);
BiEu8_corr(:,:,2,2) = BiEu8(:,:,2,2).*corrim(:,:,6);
BiEu3R = BiEu3(:,:,1)./BiEu3(:,:,2);
BiEu3_corrR = BiEu3_corr(:,:,1)./BiEu3_corr(:,:,2);
BiEu3R=BiEu3R./mean(BiEu3R(:));
BiEu3_corrR=BiEu3_corrR./mean(BiEu3_corrR(:));
figure(7)
subplot(1,2,1)
imshow(BiEu3R,[0.97 1.03]);
colormap('jet');colorbar
subplot(1,2,2)
imshow(BiEu3_corrR,[0.97 1.03]);
colormap('jet');colorbar

%generate theoretical perfect data and then apply the correction images to
%it to see how much error this may be contributing in theory

SU_2 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_2'));
SU_2 = double(SU_2) - repmat(mdark_1s,[1 1 8]);
temp = SU_2(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_2u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_2 = beadIntensities(SU_2u, CC, 2);

%generate theoretical perfect data for these codes
%initial values for k-means clustering
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
valsx = vals;
valsy = vals;
clear k
index=1;
for n=1:numel(valsx)
    for m=1:numel(valsx)-n+1
        k(index,:)=[valsx(n); valsy(m)];
        index=index+1;
    end
end
%then delete [0.91,0], add [0.351 1.055], [0.598 0.69], and [0.91 0.405]
Eu = spectra(2,:);
Eu = repmat(reshape(Eu,[1 1 6]), [501 502 1]);
Dev = spectra(4,:)*3;
Dev = repmat(reshape(Dev,[1 1 6]), [501 502 1]);
clear synth_all_dy synth_all_sm
for n=1:size(k,1)
    Dy = spectra(1,:).*k(n,1);
    Dy = repmat(reshape(Dy,[1 1 6]), [501 502 1]);
    Sm = spectra(3,:).*k(n,2);
    Sm = repmat(reshape(Sm,[1 1 6]), [501 502 1]);
    synthim = Eu+Dy+Sm+Dev;
    synthim = synthim./corrim; %inverse of correction
    [u,err]=unmix(synthim,spectra);
    err = median(abs(err(:)./synthim(:)))
    I_synth = beadIntensities(u, CC, 2);
    if ~exist('synth_all_dy','var')
        synth_all_dy = [[I_synth(:,1).medianratio]];
        synth_all_sm = [[I_synth(:,3).medianratio]];
    else
        synth_all_dy = [synth_all_dy,[I_synth(:,1).medianratio]];
        synth_all_sm = [synth_all_sm,[I_synth(:,3).medianratio]];
    end
end

q(:,1)=k(:,1)*1.3;
q(:,2)=k(:,2)*2;
[Idx, SU_all_mean] = kmeans(SU_all',[],'start',q);
