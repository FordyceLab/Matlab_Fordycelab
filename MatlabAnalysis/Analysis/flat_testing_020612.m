SU_2 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_2'));
SU_2 = double(SU_2) - repmat(mdark_1s,[1 1 8]);
temp = SU_2(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_2u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_2u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_2 = beadIntensities(SU_2u, CC, 2);

for n=2:8
    slice = SU_2(10:140,145:345,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec_SU = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec_SU];
spectra(:,6)=[]; %remove 630/69 filter

[SU_2uc,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
I_SU_2c = beadIntensities(SU_2uc, CC, 2);

SU_3 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_3'));
SU_3 = double(SU_3) - repmat(mdark_1s,[1 1 8]);
temp = SU_3(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_3u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_3u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_3 = beadIntensities(SU_3u, CC, 2);

SU_4 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_4'));
SU_4 = double(SU_4) - repmat(mdark_1s,[1 1 8]);
temp = SU_4(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_4u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_4u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_4 = beadIntensities(SU_4u, CC, 2);

SU_5 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_5'));
SU_5 = double(SU_5) - repmat(mdark_1s,[1 1 8]);
temp = SU_5(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_5u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_5u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_5 = beadIntensities(SU_5u, CC, 2);

SU_6 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_6'));
SU_6 = double(SU_6) - repmat(mdark_1s,[1 1 8]);
temp = SU_6(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_6u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_6u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_6 = beadIntensities(SU_6u, CC, 2);

SU_7 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_7'));
SU_7 = double(SU_7) - repmat(mdark_1s,[1 1 8]);
temp = SU_7(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_7u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_7u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_7 = beadIntensities(SU_7u, CC, 2);

SU_8 = squeeze(MMparse('Z:\Images\020612\BeadMatrix_24codes_4x_1x_8'));
SU_8 = double(SU_8) - repmat(mdark_1s,[1 1 8]);
temp = SU_8(:,:,2:8); %drop brightfield
temp(:,:,6)=[]; %drop 630/69
[SU_8u,err] = unmix(temp.*corrim, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(SU_8u(:,:,2),8,-0.045);
CC = bwconncomp(mask,4);
I_SU_8 = beadIntensities(SU_8u, CC, 2);

clear SU_all SU_all_raw
SU_allc(1,:) = [[I_SU_2(:,1).medianratio],[I_SU_3(:,1).medianratio],[I_SU_4(:,1).medianratio],[I_SU_5(:,1).medianratio],[I_SU_6(:,1).medianratio],[I_SU_7(:,1).medianratio],[I_SU_8(:,1).medianratio]];
SU_allc(2,:) = [[I_SU_2(:,3).medianratio],[I_SU_3(:,3).medianratio],[I_SU_4(:,3).medianratio],[I_SU_5(:,3).medianratio],[I_SU_6(:,3).medianratio],[I_SU_7(:,3).medianratio],[I_SU_8(:,3).medianratio]];
