camera_offset = 446;

BeadsI_1 = squeeze(MMparse('Z:\Keck\121511\RGBeadsIFrom12142011_2_1'));
BeadsI_2 = squeeze(MMparse('Z:\Keck\121511\RGBeadsIFrom121411_3_1'));
BeadsII = squeeze(MMparse('Z:\Keck\121511\RGBeadsIIFrom121411_2_1'));

BeadsI_1 = double(BeadsI_1) - camera_offset;
BeadsI_2 = double(BeadsI_2) - camera_offset;
BeadsII = double(BeadsII) - camera_offset;


%get device background
for n=1:5
    slice = BeadsII(10:490,10:150,n);
    Device_spec(n) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

%get device background
for n=1:5
    slice = BeadsI_2(250:490,460:490,n);
    Device_spec2(n) = median(slice(:));
end
Device_spec2 = Device_spec2./sum(Device_spec2);


spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec2];

[BeadsI_1u,err] = unmix(BeadsI_1, spectra);
median(abs(err(:)./BeadsI_1(:)))
[BeadsI_2u,err] = unmix(BeadsI_2, spectra);
median(abs(err(:)./BeadsI_2(:)))
[BeadsIIu,err] = unmix(BeadsII, spectra);
median(abs(err(:)./BeadsII(:)))

mask = adaptivethreshold(BeadsI_2u(:,:,2),20,-0.03);
mask = imfill(mask,'holes');
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I_BeadsI_2 = beadIntensities(BeadsI_2u, CC, 2);

mask = adaptivethreshold(BeadsI_1u(:,:,2),20,-0.03);
mask = imfill(mask,'holes');
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
%remove fused beads
S = regionprops(CC,'Eccentricity');
badbeads = find([S.Eccentricity]>0.8);
for n=1:numel(badbeads)
    %delete fused beads
    mask(CC.PixelIdxList{badbeads(n)}) = 0;
end
CC = bwconncomp(mask,4);
I_BeadsI_1 = beadIntensities(BeadsI_1u, CC, 2);

R_BeadsI_2(:,1) = [I_BeadsI_2(:,1).medianratio];
R_BeadsI_2(:,2) = [I_BeadsI_2(:,3).medianratio];

%find cluster centroids by kmeans
[Idx, C] = kmeans(R_BeadsI_2,17);
%edit C if necessary
[Idx, C] = kmeans(R_BeadsI_2,[],'start',C);
for n=1:17
    list = Idx == n;
    Imean(n,:) = mean(R_BeadsI_2(list,:));
    Istd(n,:)= std(R_BeadsI_2(list,:));
end

%normalize levels so max = 1
R_BeadsI_2 = R_BeadsI_2./repmat(max(Imean),[191 1]);
for n=1:17
    list = Idx == n;
    Imean(n,:) = mean(R_BeadsI_2(list,:));
    Istd(n,:)= std(R_BeadsI_2(list,:));
end

