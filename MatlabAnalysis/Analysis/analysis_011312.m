camera_offset = 445;

Beads1_1 = squeeze(MMparse('Z:\Keck\011312\Matrix_24Codes_2_1'));
slice = Beads1_1(:,:,1);
lampI(1) = mean(slice(:));
Beads1_1 = double(Beads1_1) - camera_offset;


%get device background
for n=2:7
    slice = Beads1_1(2:250,2:35,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec];

temp = Beads1_1(:,:,2:7);
[Beads1_1u,err] = unmix(temp, spectra);
median(abs(err(:)./temp(:)))

mask = gen_bead_mask2(Beads1_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads1_1 = beadIntensities(Beads1_1u, CC, 2);

Beads3_1 = squeeze(MMparse('Z:\Keck\011312\Matrix_24Codes_3_1'));
slice = Beads3_1(:,:,1);
lampI(2) = mean(slice(:));
Beads3_1 = double(Beads3_1(:,:,2:7)) - camera_offset;
[Beads3_1u,err] = unmix(Beads3_1, spectra);
median(abs(err(:)./Beads3_1(:)))
mask = gen_bead_mask2(Beads3_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads3_1 = beadIntensities(Beads3_1u, CC, 2);

Beads4_1 = squeeze(MMparse('Z:\Keck\011312\Matrix_24Codes_4_1'));
slice = Beads4_1(:,:,1);
lampI(3) = mean(slice(:));
Beads4_1 = double(Beads4_1(:,:,2:7)) - camera_offset;
[Beads4_1u,err] = unmix(Beads4_1, spectra);
median(abs(err(:)./Beads4_1(:)))
mask = gen_bead_mask2(Beads4_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads4_1 = beadIntensities(Beads4_1u, CC, 2);

Beads5_1 = squeeze(MMparse('Z:\Keck\011312\Matrix_24Codes_5_1'));
slice = Beads5_1(:,:,1);
lampI(4) = mean(slice(:));
Beads5_1 = double(Beads5_1(:,:,2:7)) - camera_offset;
[Beads5_1u,err] = unmix(Beads5_1, spectra);
median(abs(err(:)./Beads5_1(:)))
mask = gen_bead_mask2(Beads5_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads5_1 = beadIntensities(Beads5_1u, CC, 2);

Beads6_1 = squeeze(MMparse('Z:\Keck\011312\Matrix_24Codes_6_1'));
slice = Beads6_1(:,:,1);
lampI(5) = mean(slice(:));
Beads6_1 = double(Beads6_1(:,:,2:7)) - camera_offset;
[Beads6_1u,err] = unmix(Beads6_1, spectra);
median(abs(err(:)./Beads6_1(:)))
mask = gen_bead_mask2(Beads6_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads6_1 = beadIntensities(Beads6_1u, CC, 2);

Beads7_1 = squeeze(MMparse('Z:\Keck\011312\Matrix_24Codes_7_1'));
slice = Beads7_1(:,:,1);
lampI(6) = mean(slice(:));
Beads7_1 = double(Beads7_1(:,:,2:7)) - camera_offset;
[Beads7_1u,err] = unmix(Beads7_1, spectra);
median(abs(err(:)./Beads7_1(:)))
mask = gen_bead_mask2(Beads7_1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads7_1 = beadIntensities(Beads7_1u, CC, 2);

%testing if 510/84 filter is bad somehow.
temp = Beads4_1(:,:,[1,3:end]);
[Beads4_1u2,err] = unmix(temp, spectra(:,[1,3:end]));
median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(Beads4_1u2(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Beads4_12 = beadIntensities(Beads4_1u2, CC, 2);

%initial values for k-means clustering
%theoretical values are[0 0.12 0.27 0.46 0.7 1]
vals = [0 0.12 0.27 0.46 0.7 1] * 1.6;
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)-n+1
        k(index,:)=[vals(n); vals(m)];
        index=index+1;
    end
end
%have to add [0.432 1.12], [1.12 0.432], [0.736 0.736] and remove [1.12 0]

R_Beads1(:,1) = [I_Beads1_1(:,1).medianratio];
R_Beads1(:,2) = [I_Beads1_1(:,3).medianratio];
R_Beads3(:,1) = [I_Beads3_1(:,1).medianratio];
R_Beads3(:,2) = [I_Beads3_1(:,3).medianratio];
R_Beads4(:,1) = [I_Beads4_1(:,1).medianratio];
R_Beads4(:,2) = [I_Beads4_1(:,3).medianratio];
R_Beads5(:,1) = [I_Beads5_1(:,1).medianratio];
R_Beads5(:,2) = [I_Beads5_1(:,3).medianratio];
R_Beads6(:,1) = [I_Beads6_1(:,1).medianratio];
R_Beads6(:,2) = [I_Beads6_1(:,3).medianratio];
R_Beads7(:,1) = [I_Beads7_1(:,1).medianratio];
R_Beads7(:,2) = [I_Beads7_1(:,3).medianratio];

%find cluster centroids by kmeans
[Idx, Imean1] = kmeans(R_Beads1,[],'start',k);
for n=1:size(Imean1,1)
    list = Idx == n;
    Istd1(n,:)= std(R_Beads1(list,:));
end
[Idx, Imean3] = kmeans(R_Beads3,[],'start',k);
for n=1:size(Imean3,1)
    list = Idx == n;
    Istd3(n,:)= std(R_Beads3(list,:));
end
[Idx, Imean4] = kmeans(R_Beads4,[],'start',k);
for n=1:size(Imean4,1)
    list = Idx == n;
    Istd4(n,:)= std(R_Beads4(list,:));
end
[Idx, Imean5] = kmeans(R_Beads5,[],'start',k);
for n=1:size(Imean5,1)
    list = Idx == n;
    Istd5(n,:)= std(R_Beads5(list,:));
end
[Idx, Imean6] = kmeans(R_Beads6,[],'start',k);
for n=1:size(Imean6,1)
    list = Idx == n;
    Istd6(n,:)= std(R_Beads6(list,:));
end
[Idx, Imean7] = kmeans(R_Beads7,[],'start',k);
for n=1:size(Imean7,1)
    list = Idx == n;
    Istd7(n,:)= std(R_Beads7(list,:));
end

R_Beads_all=[R_Beads1;R_Beads3;R_Beads4;R_Beads5;R_Beads6;R_Beads7];
[Idx, Imean_all] = kmeans(R_Beads_all,[],'start',k);
for n=1:size(Imean_all,1)
    list = Idx == n;
    Istd_all(n,:)= std(R_Beads_all(list,:));
end

delta(1) = mean(Imean3(:,1) - Imean1(:,1));
delta(2) = mean(Imean4(:,1) - Imean1(:,1));
delta(3) = mean(Imean5(:,1) - Imean1(:,1));
delta(4) = mean(Imean6(:,1) - Imean1(:,1));
delta(5) = mean(Imean7(:,1) - Imean1(:,1));

delta2(1) = mean(Imean3(:,2) - Imean1(:,2));
delta2(2) = mean(Imean4(:,2) - Imean1(:,2));
delta2(3) = mean(Imean5(:,2) - Imean1(:,2));
delta2(4) = mean(Imean6(:,2) - Imean1(:,2));
delta2(5) = mean(Imean7(:,2) - Imean1(:,2));

EuI1 = mean([I_Beads1_1(:,2).median]);
dEuI(1) = mean([I_Beads3_1(:,2).median]) - EuI1;
dEuI(2) = mean([I_Beads4_1(:,2).median]) - EuI1;
dEuI(3) = mean([I_Beads5_1(:,2).median]) - EuI1;
dEuI(4) = mean([I_Beads6_1(:,2).median]) - EuI1;
dEuI(5) = mean([I_Beads7_1(:,2).median]) - EuI1;
dlampI = lampI(2:end) - lampI(1);