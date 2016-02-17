%analysing 1/26/12 data
%all images are of 1/18 18 code matrix
%Rot = Rotal data
%Rot = 90 degree rotated data (same beads as Rot)
%Foc = acquired with focused illumination, 90 degree rotation
%
%appended u is unmixed with all filters
%u92 uses only 630/92; u69 uses only 630/69


camera_offset = 445;

Norm1 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_1'));
slice = Norm1(:,:,1);
lampI(1) = mean(slice(:));
Norm1 = double(Norm1) - camera_offset;

%get device background
for n=2:8
    slice = Norm1(15:40,130:490,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec];
spectra_92 = spectra;
spectra_92(:,7)=[]; %remove 630/69 filter
spectra_69 = spectra;
spectra_69(:,6) = []; %remove 630/92 filter

errors=[]; %all filters
errors_92=[]; %only 630/92
errors_69=[]; % only 630/69
temp = Norm1(:,:,2:8);
[Norm1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Norm1(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Norm1u92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Norm1(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Norm1u69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Norm1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Norm1 = beadIntensities(Norm1u, CC, 2);
I_Norm1_92 = beadIntensities(Norm1u92, CC, 2);
I_Norm1_69 = beadIntensities(Norm1u69, CC, 2);


Norm2 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_2'));
Norm2 = double(Norm2) - camera_offset;
temp = Norm2(:,:,2:8);
[Norm2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Norm2(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Norm2u92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Norm2(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Norm2u69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Norm2u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Norm2 = beadIntensities(Norm2u, CC, 2);
I_Norm2_92 = beadIntensities(Norm2u92, CC, 2);
I_Norm2_69 = beadIntensities(Norm2u69, CC, 2);


Norm3 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_3'));
Norm3 = double(Norm3) - camera_offset;
temp = Norm3(:,:,2:8);
[Norm3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Norm3(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Norm3u92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Norm3(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Norm3u69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Norm3u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Norm3 = beadIntensities(Norm3u, CC, 2);
I_Norm3_92 = beadIntensities(Norm3u92, CC, 2);
I_Norm3_69 = beadIntensities(Rot3u69, CC, 2);

Rot1 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_90deg_1'));
Rot1 = double(Rot1) - camera_offset;
temp = Rot1(:,:,2:8);
[Rot1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Rot1(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Rot1u92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Rot1(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Rot1u69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Rot1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Rot1 = beadIntensities(Rot1u, CC, 2);
I_Rot1_92 = beadIntensities(Rot1u92, CC, 2);
I_Rot1_69 = beadIntensities(Rot1u69, CC, 2);


Rot2 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_90deg_2'));
Rot2 = double(Rot2) - camera_offset;
temp = Rot2(:,:,2:8);
[Rot2u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Rot2(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Rot2u92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Rot2(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Rot2u69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Rot2u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Rot2 = beadIntensities(Rot2u, CC, 2);
I_Rot2_92 = beadIntensities(Rot2u92, CC, 2);
I_Rot2_69 = beadIntensities(Rot2u69, CC, 2);


Rot3 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_90deg_3'));
Rot3 = double(Rot3) - camera_offset;
temp = Rot3(:,:,2:8);
[Rot3u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Rot3(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Rot3u92,err] = unmix(temp, spectra_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Rot3(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Rot3u69,err] = unmix(temp, spectra_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Rot3u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Rot3 = beadIntensities(Rot3u, CC, 2);
I_Rot3_92 = beadIntensities(Rot3u92, CC, 2);
I_Rot3_69 = beadIntensities(Rot3u69, CC, 2);


Foc1 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_90deg_focused_1'));
Foc1 = double(Foc1) - camera_offset;

%get device background
for n=2:8
    slice = Foc1(190:390,460:490,n);
    Device_spec_foc(n-1) = median(slice(:));
end
Device_spec_foc = Device_spec_foc./sum(Device_spec_foc);

spectra_foc = [Dy_spec;Eu_spec;Sm_spec;Device_spec_foc];
spectra_foc_92 = spectra;
spectra_foc_92(:,7)=[]; %remove 630/69 filter
spectra_foc_69 = spectra;
spectra_foc_69(:,6) = []; %remove 630/92 filter

temp = Foc1(:,:,2:8);
[Foc1u,err] = unmix(temp, spectra_foc);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Foc1(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Foc1u92,err] = unmix(temp, spectra_foc_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Foc1(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Foc1u69,err] = unmix(temp, spectra_foc_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Foc1u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Foc1 = beadIntensities(Foc1u, CC, 2);
I_Foc1_92 = beadIntensities(Foc1u92, CC, 2);
I_Foc1_69 = beadIntensities(Foc1u69, CC, 2);


Foc2 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_90deg_focused_2'));
Foc2 = double(Foc2) - camera_offset;
temp = Foc2(:,:,2:8);
[Foc2u,err] = unmix(temp, spectra_foc);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Foc2(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Foc2u92,err] = unmix(temp, spectra_foc_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Foc2(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Foc2u69,err] = unmix(temp, spectra_foc_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Foc2u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Foc2 = beadIntensities(Foc2u, CC, 2);
I_Foc2_92 = beadIntensities(Foc2u92, CC, 2);
I_Foc2_69 = beadIntensities(Foc2u69, CC, 2);


Foc3 = squeeze(MMparse('Z:\Keck\012612\BeadMatrix_18Codes_BothFilters_90deg_focused_3'));
Foc3 = double(Foc3) - camera_offset;
temp = Foc3(:,:,2:8);
[Foc3u,err] = unmix(temp, spectra_foc);
err = median(abs(err(:)./temp(:)))
errors = [errors, err];

temp = Foc3(:,:,2:8);
temp(:,:,7) = []; %remove 630/69 filter
[Foc3u92,err] = unmix(temp, spectra_foc_92);
err = median(abs(err(:)./temp(:)))
errors_92 = [errors_92, err];

temp = Foc3(:,:,2:8);
temp(:,:,6) = []; %remove 630/92 filter
[Foc3u69,err] = unmix(temp, spectra_foc_69);
err = median(abs(err(:)./temp(:)))
errors_69 = [errors_69, err];

mask = gen_bead_mask2(Foc3u(:,:,2),20,-0.08);
CC = bwconncomp(mask,4);
I_Foc3 = beadIntensities(Foc3u, CC, 2);
I_Foc3_92 = beadIntensities(Foc3u92, CC, 2);
I_Foc3_69 = beadIntensities(Foc3u69, CC, 2);

%cumulate data for statistical analysis
Norm_all(1,:) = [[I_Norm1(:,1).medianratio],[I_Norm2(:,1).medianratio],[I_Norm3(:,1).medianratio]];
Norm_all(2,:) = [[I_Norm1(:,3).medianratio],[I_Norm2(:,3).medianratio],[I_Norm3(:,3).medianratio]];
Norm_69(1,:) = [[I_Norm1_69(:,1).medianratio],[I_Norm2_69(:,1).medianratio],[I_Norm3_69(:,1).medianratio]];
Norm_69(2,:) = [[I_Norm1_69(:,3).medianratio],[I_Norm2_69(:,3).medianratio],[I_Norm3_69(:,3).medianratio]];
Norm_92(1,:) = [[I_Norm1_92(:,1).medianratio],[I_Norm2_92(:,1).medianratio],[I_Norm3_92(:,1).medianratio]];
Norm_92(2,:) = [[I_Norm1_92(:,3).medianratio],[I_Norm2_92(:,3).medianratio],[I_Norm3_92(:,3).medianratio]];
Rot_all(1,:) = [[I_Rot1(:,1).medianratio],[I_Rot2(:,1).medianratio],[I_Rot3(:,1).medianratio]];
Rot_all(2,:) = [[I_Rot1(:,3).medianratio],[I_Rot2(:,3).medianratio],[I_Rot3(:,3).medianratio]];
Rot_69(1,:) = [[I_Rot1_69(:,1).medianratio],[I_Rot2_69(:,1).medianratio],[I_Rot3_69(:,1).medianratio]];
Rot_69(2,:) = [[I_Rot1_69(:,3).medianratio],[I_Rot2_69(:,3).medianratio],[I_Rot3_69(:,3).medianratio]];
Rot_92(1,:) = [[I_Rot1_92(:,1).medianratio],[I_Rot2_92(:,1).medianratio],[I_Rot3_92(:,1).medianratio]];
Rot_92(2,:) = [[I_Rot1_92(:,3).medianratio],[I_Rot2_92(:,3).medianratio],[I_Rot3_92(:,3).medianratio]];
Foc_all(1,:) = [[I_Foc1(:,1).medianratio],[I_Foc2(:,1).medianratio],[I_Foc3(:,1).medianratio]];
Foc_all(2,:) = [[I_Foc1(:,3).medianratio],[I_Foc2(:,3).medianratio],[I_Foc3(:,3).medianratio]];
Foc_69(1,:) = [[I_Foc1_69(:,1).medianratio],[I_Foc2_69(:,1).medianratio],[I_Foc3_69(:,1).medianratio]];
Foc_69(2,:) = [[I_Foc1_69(:,3).medianratio],[I_Foc2_69(:,3).medianratio],[I_Foc3_69(:,3).medianratio]];
Foc_92(1,:) = [[I_Foc1_92(:,1).medianratio],[I_Foc2_92(:,1).medianratio],[I_Foc3_92(:,1).medianratio]];
Foc_92(2,:) = [[I_Foc1_92(:,3).medianratio],[I_Foc2_92(:,3).medianratio],[I_Foc3_92(:,3).medianratio]];


%also collect up centroids so we can look for positional variability
temp = [I_Norm1(:,2).centroid]; %returns as interleaved X,Y pairs
Norm1_centroid(1,:) = temp(1:2:end); %deinterleave X
Norm1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Norm2(:,2).centroid]; %returns as interleaved X,Y pairs
Norm2_centroid(1,:) = temp(1:2:end); %deinterleave X
Norm2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Norm3(:,2).centroid]; %returns as interleaved X,Y pairs
Norm3_centroid(1,:) = temp(1:2:end); %deinterleave X
Norm3_centroid(2,:) = temp(2:2:end); %Y
Norm_centroid = [Norm1_centroid, Norm2_centroid, Norm3_centroid];
temp = [I_Rot1(:,2).centroid]; %returns as interleaved X,Y pairs
Rot1_centroid(1,:) = temp(1:2:end); %deinterleave X
Rot1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Rot2(:,2).centroid]; %returns as interleaved X,Y pairs
Rot2_centroid(1,:) = temp(1:2:end); %deinterleave X
Rot2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Rot3(:,2).centroid]; %returns as interleaved X,Y pairs
Rot3_centroid(1,:) = temp(1:2:end); %deinterleave X
Rot3_centroid(2,:) = temp(2:2:end); %Y
Rot_centroid = [Rot1_centroid, Rot2_centroid, Rot3_centroid];
temp = [I_Foc1(:,2).centroid]; %returns as interleaved X,Y pairs
Foc1_centroid(1,:) = temp(1:2:end); %deinterleave X
Foc1_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Foc2(:,2).centroid]; %returns as interleaved X,Y pairs
Foc2_centroid(1,:) = temp(1:2:end); %deinterleave X
Foc2_centroid(2,:) = temp(2:2:end); %Y
temp = [I_Foc3(:,2).centroid]; %returns as interleaved X,Y pairs
Foc3_centroid(1,:) = temp(1:2:end); %deinterleave X
Foc3_centroid(2,:) = temp(2:2:end); %Y
Foc_centroid = [Foc1_centroid, Foc2_centroid, Foc3_centroid];
%initial values for k-means clustering
valsx = [0 0.12 0.25 0.5 1] * 1;
valsy = valsx*1.5;
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)-n+1
        k(index,:)=[valsx(n); valsy(m)];
        index=index+1;
    end
end
%then delete [0,0], add [0.25 0.75], [0.5 0.375], and [0.5 0.75]
[Idx, Norm_all_mean] = kmeans(Norm_all',[],'start',k);
clear Norm_all_std
for n=1:size(Norm_all_mean,1)
    list = Idx == n;
    Norm_all_std(n,:)= std(Norm_all(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Norm_all_delta
for n=1:size(Norm_all,2)
    Norm_all_delta(:,n)= Norm_all(:,n) - Norm_all_mean(Idx(n),:)';
end

[Idx, Norm_69_mean] = kmeans(Norm_69',[],'start',k);
clear Norm_69_std
for n=1:size(Norm_69_mean,1)
    list = Idx == n;
    Norm_69_std(n,:)= std(Norm_69(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Norm_69_delta
for n=1:size(Norm_69,2)
    Norm_69_delta(:,n)= Norm_69(:,n) - Norm_69_mean(Idx(n),:)';
end

[Idx, Norm_92_mean] = kmeans(Norm_92',[],'start',k);
clear Norm_92_std
for n=1:size(Norm_92_mean,1)
    list = Idx == n;
    Norm_92_std(n,:)= std(Norm_92(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Norm_92_delta
for n=1:size(Norm_92,2)
    Norm_92_delta(:,n)= Norm_92(:,n) - Norm_92_mean(Idx(n),:)';
end

%now rotated serpentines
[Idx, Rot_all_mean] = kmeans(Rot_all',[],'start',k);
clear Rot_all_std
for n=1:size(Rot_all_mean,1)
    list = Idx == n;
    Rot_all_std(n,:)= std(Rot_all(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Rot_all_delta
for n=1:size(Rot_all,2)
    Rot_all_delta(:,n)= Rot_all(:,n) - Rot_all_mean(Idx(n),:)';
end

[Idx, Rot_69_mean] = kmeans(Rot_69',[],'start',k);
clear Rot_69_std
for n=1:size(Rot_69_mean,1)
    list = Idx == n;
    Rot_69_std(n,:)= std(Rot_69(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Rot_69_delta
for n=1:size(Rot_69,2)
    Rot_69_delta(:,n)= Rot_69(:,n) - Rot_69_mean(Idx(n),:)';
end

[Idx, Rot_92_mean] = kmeans(Rot_92',[],'start',k);
clear Rot_92_std
for n=1:size(Rot_92_mean,1)
    list = Idx == n;
    Rot_92_std(n,:)= std(Rot_92(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Rot_92_delta
for n=1:size(Rot_92,2)
    Rot_92_delta(:,n)= Rot_92(:,n) - Rot_92_mean(Idx(n),:)';
end


%now focused serpentines
[Idx, Foc_all_mean] = kmeans(Foc_all',[],'start',k);
clear Foc_all_std
for n=1:size(Foc_all_mean,1)
    list = Idx == n;
    Foc_all_std(n,:)= std(Foc_all(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Foc_all_delta
for n=1:size(Foc_all,2)
    Foc_all_delta(:,n)= Foc_all(:,n) - Foc_all_mean(Idx(n),:)';
end

[Idx, Foc_69_mean] = kmeans(Foc_69',[],'start',k);
clear Foc_69_std
for n=1:size(Foc_69_mean,1)
    list = Idx == n;
    Foc_69_std(n,:)= std(Foc_69(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Foc_69_delta
for n=1:size(Foc_69,2)
    Foc_69_delta(:,n)= Foc_69(:,n) - Foc_69_mean(Idx(n),:)';
end

[Idx, Foc_92_mean] = kmeans(Foc_92',[],'start',k);
clear Foc_92_std
for n=1:size(Foc_92_mean,1)
    list = Idx == n;
    Foc_92_std(n,:)= std(Foc_92(:,list),0,2);
end

%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear Foc_92_delta
for n=1:size(Foc_92,2)
    Foc_92_delta(:,n)= Foc_92(:,n) - Foc_92_mean(Idx(n),:)';
end


%plot it
figure(1)
clf
subplot(2,2,1)
plot(Norm_centroid(1,:),Norm_all_delta(1,:),'b.')
hold on
plot(Norm_centroid(1,:),Norm_69_delta(1,:),'r.')
plot(Norm_centroid(1,:),Norm_92_delta(1,:),'g.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')
subplot(2,2,2)
plot(Norm_centroid(2,:),Norm_all_delta(1,:),'b.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')
hold on
plot(Norm_centroid(2,:),Norm_69_delta(1,:),'r.')
plot(Norm_centroid(2,:),Norm_92_delta(1,:),'g.')
subplot(2,2,3)
plot(Norm_centroid(1,:),Norm_all_delta(2,:),'b.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')
hold on
plot(Norm_centroid(1,:),Norm_69_delta(2,:),'r.')
plot(Norm_centroid(1,:),Norm_92_delta(2,:),'g.')
subplot(2,2,4)
plot(Norm_centroid(2,:),Norm_all_delta(2,:),'b.')
hold on
plot(Norm_centroid(2,:),Norm_69_delta(2,:),'r.')
plot(Norm_centroid(2,:),Norm_92_delta(2,:),'g.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

%plot it
figure(2)
clf
subplot(2,2,1)
plot(Rot_centroid(1,:),Rot_all_delta(1,:),'b.')
hold on
plot(Rot_centroid(1,:),Rot_69_delta(1,:),'r.')
plot(Rot_centroid(1,:),Rot_92_delta(1,:),'g.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')
subplot(2,2,2)
plot(Rot_centroid(2,:),Rot_all_delta(1,:),'b.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')
hold on
plot(Rot_centroid(2,:),Rot_69_delta(1,:),'r.')
plot(Rot_centroid(2,:),Rot_92_delta(1,:),'g.')
subplot(2,2,3)
plot(Rot_centroid(1,:),Rot_all_delta(2,:),'b.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')
hold on
plot(Rot_centroid(1,:),Rot_69_delta(2,:),'r.')
plot(Rot_centroid(1,:),Rot_92_delta(2,:),'g.')
subplot(2,2,4)
plot(Rot_centroid(2,:),Rot_all_delta(2,:),'b.')
hold on
plot(Rot_centroid(2,:),Rot_69_delta(2,:),'r.')
plot(Rot_centroid(2,:),Rot_92_delta(2,:),'g.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

%plot it
figure(3)
clf
subplot(2,2,1)
plot(Foc_centroid(1,:),Foc_all_delta(1,:),'b.')
hold on
plot(Foc_centroid(1,:),Foc_69_delta(1,:),'r.')
plot(Foc_centroid(1,:),Foc_92_delta(1,:),'g.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')
subplot(2,2,2)
plot(Foc_centroid(2,:),Foc_all_delta(1,:),'b.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')
hold on
plot(Foc_centroid(2,:),Foc_69_delta(1,:),'r.')
plot(Foc_centroid(2,:),Foc_92_delta(1,:),'g.')
subplot(2,2,3)
plot(Foc_centroid(1,:),Foc_all_delta(2,:),'b.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')
hold on
plot(Foc_centroid(1,:),Foc_69_delta(2,:),'r.')
plot(Foc_centroid(1,:),Foc_92_delta(2,:),'g.')
subplot(2,2,4)
plot(Foc_centroid(2,:),Foc_all_delta(2,:),'b.')
hold on
plot(Foc_centroid(2,:),Foc_69_delta(2,:),'r.')
plot(Foc_centroid(2,:),Foc_92_delta(2,:),'g.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

figure(4)
clf
subplot(2,2,1)
plot(Norm_centroid(1,:),Norm_all_delta(1,:),'b.')
hold on
plot(Rot_centroid(1,:),Rot_all_delta(1,:),'r.')
plot(Foc_centroid(1,:),Foc_all_delta(1,:),'g.')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')
subplot(2,2,2)
plot(Norm_centroid(2,:),Norm_all_delta(1,:),'b.')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')
hold on
plot(Rot_centroid(2,:),Rot_all_delta(1,:),'r.')
plot(Foc_centroid(2,:),Foc_all_delta(1,:),'g.')
subplot(2,2,3)
plot(Norm_centroid(1,:),Norm_all_delta(2,:),'b.')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')
hold on
plot(Rot_centroid(1,:),Rot_all_delta(2,:),'r.')
plot(Foc_centroid(1,:),Foc_all_delta(2,:),'g.')
subplot(2,2,4)
plot(Norm_centroid(2,:),Norm_all_delta(2,:),'b.')
hold on
plot(Rot_centroid(2,:),Rot_all_delta(2,:),'r.')
plot(Foc_centroid(2,:),Foc_all_delta(2,:),'g.')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

%scatter plot data
figure(3)
clf
plot(Norm_all(1,:),Norm_all(2,:),'.k');
centerbeads = find(Norm_centroid(2,:)>125 & Norm_centroid(2,:)<375 & Norm_centroid(1,:)>125 & Norm_centroid(1,:)<375);

figure(4)
plot(Norm_all(1,centerbeads),Norm_all(2,centerbeads),'.k');

%std dev plotting
Norm_maxvals = max(Norm_all_mean);
Rot_maxvals = max(Rot_all_mean);
Foc_maxvals = max(Foc_all_mean);
clf
subplot(1,2,1); hold on;
plot(Norm_all_mean(:,1)./Norm_maxvals(1),Norm_all_std(:,1)./Norm_maxvals(1),'ok')
plot(Rot_all_mean(:,1)./Rot_maxvals(1),Rot_all_std(:,1)./Rot_maxvals(1),'sk')
plot(Foc_all_mean(:,1)./Foc_maxvals(1),Foc_all_std(:,1)./Foc_maxvals(1),'*k')
xlabel('Dy/Eu Mean ratio'); ylabel('Dy/Eu Standard Deviation');
subplot(1,2,2); hold on;
plot(Norm_all_mean(:,2)./Norm_maxvals(2),Norm_all_std(:,2)./Norm_maxvals(2),'ok')
plot(Rot_all_mean(:,2)./Rot_maxvals(2),Rot_all_std(:,2)./Rot_maxvals(2),'sk')
plot(Foc_all_mean(:,2)./Foc_maxvals(2),Foc_all_std(:,2)./Foc_maxvals(2),'*k')
xlabel('Sm/Eu Mean ratio'); ylabel('Sm/Eu Standard Deviation');

%bin positional variation data
step=50;
index = 1;
for n=step:step:500
    beads = find(Norm_centroid(1,:)<n & Norm_centroid(1,:)>=n-step);
    Norm_binned_cent_X(index) = median(Norm_centroid(1,beads));
    Norm_delta_binned_X(1,index) = median(Norm_all_delta(1,beads));
    Norm_delta_binned_X(2,index) = median(Norm_all_delta(2,beads));
    beads = find(Norm_centroid(2,:)<n & Norm_centroid(2,:)>=n-step);
    Norm_binned_cent_Y(index) = median(Norm_centroid(2,beads));
    Norm_delta_binned_Y(1,index) = median(Norm_all_delta(1,beads));
    Norm_delta_binned_Y(2,index) = median(Norm_all_delta(2,beads));
    
    beads = find(Rot_centroid(1,:)<n & Rot_centroid(1,:)>=n-step);
    Rot_binned_cent_X(index) = median(Rot_centroid(1,beads));
    Rot_delta_binned_X(1,index) = median(Rot_all_delta(1,beads));
    Rot_delta_binned_X(2,index) = median(Rot_all_delta(2,beads));
    beads = find(Rot_centroid(2,:)<n & Rot_centroid(2,:)>=n-step);
    Rot_binned_cent_Y(index) = median(Rot_centroid(2,beads));
    Rot_delta_binned_Y(1,index) = median(Rot_all_delta(1,beads));
    Rot_delta_binned_Y(2,index) = median(Rot_all_delta(2,beads));
    
    beads = find(Foc_centroid(1,:)<n & Foc_centroid(1,:)>=n-step);
    Foc_binned_cent_X(index) = median(Foc_centroid(1,beads));
    Foc_delta_binned_X(1,index) = median(Foc_all_delta(1,beads));
    Foc_delta_binned_X(2,index) = median(Foc_all_delta(2,beads));
    beads = find(Foc_centroid(2,:)<n & Foc_centroid(2,:)>=n-step);
    Foc_binned_cent_Y(index) = median(Foc_centroid(2,beads));
    Foc_delta_binned_Y(1,index) = median(Foc_all_delta(1,beads));
    Foc_delta_binned_Y(2,index) = median(Foc_all_delta(2,beads));
    
    index = index+1;
end
figure(2)
clf
subplot(2,2,1)
plot(Norm_binned_cent_X, Norm_delta_binned_X(1,:),'k')
hold on
plot(Rot_binned_cent_X, Rot_delta_binned_X(1,:),'--k')
plot(Foc_binned_cent_X, Foc_delta_binned_X(1,:),':k')
xlabel('X coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,2)
plot(Norm_binned_cent_Y, Norm_delta_binned_Y(1,:),'k')
hold on
plot(Rot_binned_cent_Y, Rot_delta_binned_Y(1,:),'--k')
plot(Foc_binned_cent_Y, Foc_delta_binned_Y(1,:),':k')
xlabel('Y coordinate'); ylabel('\DeltaDy/Eu')

subplot(2,2,3)
plot(Norm_binned_cent_X, Norm_delta_binned_X(2,:),'k')
hold on
plot(Rot_binned_cent_X, Rot_delta_binned_X(2,:),'--k')
plot(Foc_binned_cent_X, Foc_delta_binned_X(2,:),':k')
xlabel('X coordinate'); ylabel('\DeltaSm/Eu')

subplot(2,2,4)
plot(Norm_binned_cent_Y, Norm_delta_binned_Y(2,:),'k')
hold on
plot(Rot_binned_cent_Y, Rot_delta_binned_Y(2,:),'--k')
plot(Foc_binned_cent_Y, Foc_delta_binned_Y(2,:),':k')
xlabel('Y coordinate'); ylabel('\DeltaSm/Eu')

%iterate over all filters, dropping one at a time to see if there is a
%large effect on unmixing error or spatial nonuniformity
mask = gen_bead_mask2(Norm1u(:,:,2),20,-0.08);
CC1 = bwconncomp(mask,4);
mask = gen_bead_mask2(Norm2u(:,:,2),20,-0.08);
CC2 = bwconncomp(mask,4);
mask = gen_bead_mask2(Norm3u(:,:,2),20,-0.08);
CC3 = bwconncomp(mask,4);
for filter=1:size(spectra,2)    
    tempspectra = spectra;
    tempspectra(:,filter) =[];
    temp = Norm1(:,:,2:8);
    temp(:,:,filter) = []; %remove filter
    [tempu,err] = unmix(temp, tempspectra);
    filter_err(1,filter) = median(abs(err(:)./temp(:)));
    I1 = beadIntensities(tempu, CC1, 2);
    
    temp = Norm2(:,:,2:8);
    temp(:,:,filter) = []; %remove filter
    [tempu,err] = unmix(temp, tempspectra);
    filter_err(2,filter) = median(abs(err(:)./temp(:)));
    I2 = beadIntensities(tempu, CC2, 2);
    
    temp = Norm3(:,:,2:8);
    temp(:,:,filter) = []; %remove 630/69 filter
    [tempu,err] = unmix(temp, tempspectra);
    filter_err(3,filter) = median(abs(err(:)./temp(:)));
    I3 = beadIntensities(tempu, CC3, 2);
    
    filterI(1,filter,:) = [[I1(:,1).medianratio], [I2(:,1).medianratio], [I3(:,1).medianratio]];
    filterI(2,filter,:) = [[I1(:,3).medianratio], [I2(:,3).medianratio], [I3(:,3).medianratio]];
end