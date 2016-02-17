camera_offset = 446;
camera_offset_EM = 490;

BeadsI_1 = squeeze(MMparse('Z:\Keck\122011\BeadsI_1_2'));
BeadsI_2a = squeeze(MMparse('Z:\Keck\122011\BeadsI_2_1'));
BeadsI_2b = squeeze(MMparse('Z:\Keck\122011\BeadsI_2_2'));
BeadsI_2c = squeeze(MMparse('Z:\Keck\122011\BeadsI_2_3'));
BeadsI_3 = squeeze(MMparse('Z:\Keck\122011\BeadsI_3_1'));
BeadsI_3EM = squeeze(MMparse('Z:\Keck\122011\BeadsI_3_2'));

SmEu_1 = squeeze(MMparse('Z:\Keck\121511\20111004-01_Beads_1'));
SmEu_2 = squeeze(MMparse('Z:\Keck\121511\20111004-02_Beads_1'));
SmEu_3 = squeeze(MMparse('Z:\Keck\122011\Code20111004-03_1'));

BeadsI_1 = double(BeadsI_1) - camera_offset;
BeadsI_2a = double(BeadsI_2a) - camera_offset;
BeadsI_2b = double(BeadsI_2b) - camera_offset;
BeadsI_2c = double(BeadsI_2c) - camera_offset;
BeadsI_3 = double(BeadsI_3) - camera_offset;
BeadsI_3EM = double(BeadsI_3EM) - camera_offset_EM;

SmEu_1 = double(SmEu_1) - camera_offset;
SmEu_2 = double(SmEu_2) - camera_offset;
SmEu_3 = double(SmEu_3) - camera_offset;

%get device background
for n=1:5
    slice = BeadsI_1(10:250,10:50,n);
    Device_spec(n) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec];

[BeadsI_1u,err] = unmix(BeadsI_1, spectra);
median(abs(err(:)./BeadsI_1(:)))
[BeadsI_2au,err] = unmix(BeadsI_2a, spectra);
median(abs(err(:)./BeadsI_2a(:)))
[BeadsI_2bu,err] = unmix(BeadsI_2b, spectra);
median(abs(err(:)./BeadsI_2b(:)))
[BeadsI_2cu,err] = unmix(BeadsI_2c, spectra);
median(abs(err(:)./BeadsI_2c(:)))
[BeadsI_3u,err] = unmix(BeadsI_3, spectra);
median(abs(err(:)./BeadsI_3(:)))
[BeadsI_3EMu,err] = unmix(BeadsI_3EM, spectra);
median(abs(err(:)./BeadsI_3EM(:)))

[SmEu_1u,err] = unmix(SmEu_1, spectra);
median(abs(err(:)./SmEu_1(:)))
[SmEu_2u,err] = unmix(SmEu_2, spectra);
median(abs(err(:)./SmEu_2(:)))
[SmEu_3u,err] = unmix(SmEu_3, spectra);
median(abs(err(:)./SmEu_3(:)))

mask = gen_bead_mask2(BeadsI_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_BeadsI_1 = beadIntensities(BeadsI_1u, CC, 2);

mask = gen_bead_mask2(BeadsI_2au(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_BeadsI_2a = beadIntensities(BeadsI_2au, CC, 2);

mask = gen_bead_mask2(BeadsI_2bu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_BeadsI_2b = beadIntensities(BeadsI_2cu, CC, 2);

mask = gen_bead_mask2(BeadsI_2cu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_BeadsI_2c = beadIntensities(BeadsI_2cu, CC, 2);

mask = gen_bead_mask2(BeadsI_3u(:,:,2),20,-0.09);
CC = bwconncomp(mask,4);
I_BeadsI_3 = beadIntensities(BeadsI_3u, CC, 2);

mask = gen_bead_mask2(BeadsI_3EMu(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_BeadsI_3EM = beadIntensities(BeadsI_3EMu, CC, 2);

mask = gen_bead_mask2(SmEu_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_SmEu_1 = beadIntensities(SmEu_1u, CC, 2);

mask = gen_bead_mask2(SmEu_2u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_SmEu_2 = beadIntensities(SmEu_2u, CC, 2);

mask = gen_bead_mask2(SmEu_3u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_SmEu_3 = beadIntensities(SmEu_3u, CC, 2);

R_BeadsI_2(:,1) = [I_BeadsI_1(:,1).medianratio];
R_BeadsI_2(:,2) = [I_BeadsI_1(:,3).medianratio];
R_BeadsI_3(:,1) = [I_BeadsI_3(:,1).medianratio];
R_BeadsI_3(:,2) = [I_BeadsI_3(:,3).medianratio];
R_BeadsI_3EM(:,1) = [I_BeadsI_3EM(:,1).medianratio];
R_BeadsI_3EM(:,2) = [I_BeadsI_3EM(:,3).medianratio];

%find cluster centroids by kmeans
[Idx, C] = kmeans(R_BeadsI_2,17);
%edit C if necessary
[Idx, C] = kmeans(R_BeadsI_3EM,[],'start',C);
for n=1:17
    list = Idx == n;
    ImeanEM(n,:) = mean(R_BeadsI_3EM(list,:));
    IstdEM(n,:)= std(R_BeadsI_3EM(list,:));
end

%normalize levels so max = 1
R_BeadsI_2 = R_BeadsI_2./repmat(max(Imean),[191 1]);
for n=1:17
    list = Idx == n;
    Imean(n,:) = mean(R_BeadsI_2(list,:));
    Istd(n,:)= std(R_BeadsI_2(list,:));
end

