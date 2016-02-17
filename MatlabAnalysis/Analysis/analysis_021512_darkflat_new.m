%Analysis of 2/15 data with flat field correction using new bead objects

dark_1s = squeeze(MMparse('Z:\Images\021512\dark_1sec_1'));
mdark_1s = mean(double(dark_1s),3);

dark_5s = squeeze(MMparse('Z:\Images\021512\dark_5sec_1'));
mdark_5s = mean(double(dark_5s),3);

dark_10ms = squeeze(MMparse('Z:\Images\020912\dark_10ms_1'));
mdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse('Z:\Images\021512\flats_1'));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(mdark_10ms,[1 1 6]) - 8.72; %8.72 is our best estimate of bias drift

clear dark_1s dark_5s flat_10ms dark_10ms %clear big data stacks

mnflat = zeros(size(mflat_10ms));
%normalize each channel to mean of 1
for n=1:size(mflat_10ms,3)
    slice = mflat_10ms(:,:,n);
    mnflat(:,:,n) = slice./mean(slice(:));
end

meanim = mean(mnflat,3); %this is the mean intensity image

corrim = zeros(size(mnflat));
for n=1:size(mnflat,3)
    corrim(:,:,n) = meanim./mnflat(:,:,n);
end

dark_stack = repmat(mdark_5s,[1 1 5]);
dark_stack(:,:,6:7) = repmat(mdark_1s, [1 1 2]);

%target values for ICP
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};

%load images and correct for dark and flat fields

M0130df_1 = squeeze(MMparse('Z:\Images\021512\24Codes_013012_1'));
M0130df_1 = double(M0130df_1) - dark_stack;
temp = M0130df_1(:,:,2:7).*corrim; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(140:330,10:120,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec_df];

[M0130df_1u,err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(M0130df_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
beads_M0130df_1 = beadDataSet('oldimage', M0130df_1u, CC, 2);
beads_M0130df_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_M0130df_1.Transform = ICP(beads_M0130df_1.getCodeRatio(:), target);
beads_M0130df_all = compositeBeadDataSet(beads_M0130df_1);
    
filelist = {'Z:\Images\021512\24Codes_013012_3', 'Z:\Images\021512\24Codes_013012_5', 'Z:\Images\021512\24Codes_013012_7',...
    'Z:\Images\021512\24Codes_013012_8','Z:\Images\021512\24Codes_013012_10','Z:\Images\021512\24Codes_013012_12',...
    'Z:\Images\021512\24Codes_013012_14','Z:\Images\021512\24Codes_013012_16','Z:\Images\021512\24Codes_013012_19'};

dsnum = 2;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7).*corrim; %drop brightfield
    uname = ['M0130df_',sprintf('%d', dsnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);    
    beads_M0130df_all.add(temp_object);
    clear temp_object;
    dsnum = dsnum + 1;
end

M0130df_centerbeads = all(beads_M0130df_all.Centroid>100,2) & all(beads_M0130df_all.Centroid<400,2);
M0130df_centerlist = find(M0130df_centerbeads);
M0130df_goodAF = beads_M0130df_all.getIntensity(:,lanthanideChannels.Device)<2310; %corresponds to 6 sigma above mean
M0130df_goodAF_list = find(M0130df_centerbeads & M0130df_goodAF);

%now calculate standard deviations
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
clear k
index=1;
for n=1:numel(vals)
    for m=1:numel(vals)
        if vals(n)+vals(m) <= 1
            k(index,:)=[vals(n); vals(m)];
            index=index+1;
        end
    end
end

temp = beads_M0130df_all.getTransformedCodeRatio(M0130df_goodAF_list);
[Idx, M0130dfx_all_mean] = kmeans(temp,[],'start',k);
clear M0130dfx_all_std
for n=1:size(M0130dfx_all_mean,1)
    list = Idx == n;
    M0130dfx_all_std(n,:)= std(temp(list,:),0,1);
end

%work out number of sigmas to 
D = pdist2( beads_M0130df_all.getTransformedCodeRatio(M0130df_goodAF_list), M0130dfx_all_mean);
D = sort(D,2);
Dratio = (D(:,2)./D(:,1));
pctD = (D(:,2)-D(:,1))./D(:,1);
pctDs = sort(pctD);

nsigmas=[];
for n=1:size(M0130dfx_all_mean,1)
    list = Idx == n;
    currdata = temp(list,:);
    %subtract mean and divide by sigma
    currdata = currdata - repmat(M0130dfx_all_mean(n,:),[size(currdata,1) 1]);
    currdata = currdata ./ repmat(M0130dfx_all_std(n,:),[size(currdata,1) 1]);
    nsigmas=[nsigmas; currdata];
end

nsigmas =sqrt(sum(nsigmas.^2,2));

%Rafael's fractional error
%can we express the cluster centroid deviations as the distance of the expected 
%to measured centroids divided by the distance between the expected centroid 
%and the origin? This will only exclude the 0,0 code, instead of excluding 
%all 0,y and x,0 codes the way you have it right now.

%measure-programmed difference
Derr = sqrt(sum((M0130dfx_all_mean-k).^2,2));
Dorigin = sqrt(sum(k.^2,2));
Ferr = Derr./Dorigin;
Ferr = mean(Ferr(~isinf(Ferr)))

%Do the same for scatter within a cluster
temp = beads_M0130df_all.getTransformedCodeRatio(M0130df_goodAF_list);
[Idx, M0130dfx_all_mean] = kmeans(temp,[],'start',k);
delta = temp - M0130dfx_all_mean(Idx,:);
delta = sqrt(sum(delta.^2,2)); %rmsd
Dorigin = sqrt(sum(M0130dfx_all_mean(Idx,:).^2,2));
nonzero = Idx ~= 1;
Fscatter = delta(nonzero)./Dorigin(nonzero);

%alternative, global transformation without independent scaling
temp = beads_M0130df_all.getCodeRatio(M0130df_goodAF_list);
xform = ICP(temp, target);
temp = temp*xform;
[Idx, M0130df_all_mean] = kmeans(temp,[],'start',k);
clear M0130df_all_std
for n=1:size(M0130df_all_mean,1)
    list = Idx == n;
    M0130df_all_std(n,:)= std(temp(list,:),0,1);
end

%look for residual spatial variation after flat-field correction
%iterate over beads, calculating difference between bead intensity and
%cluster centroid
clear M0130dfx_delta
temp = beads_M0130df_all.getTransformedCodeRatio(:);
[Idx, M0130dfx_all_mean] = kmeans(temp,[],'start',k);

for n=1:size(temp,1)
    M0130dfx_delta(n,:)= temp(n,:) - M0130dfx_all_mean(Idx(n),:);
end
[X,Y] = meshgrid(1:10:501, 1:10:501);
tau=35;

Dyoff = lwsmooth_nd(beads_M0130df_all.Centroid(:,:), M0130dfx_delta(:,1), [X(:), Y(:)], tau);
Euoff = lwsmooth_nd(beads_M0130df_all.Centroid(:,:), M0130dfx_delta(:,2), [X(:), Y(:)], tau);

Dyoff = reshape(Dyoff, size(X));
Euoff = reshape(Euoff, size(X));


%reload beads without correction image for comparision
filelist = {'Z:\Images\021512\24Codes_013012_3', 'Z:\Images\021512\24Codes_013012_5', 'Z:\Images\021512\24Codes_013012_7',...
    'Z:\Images\021512\24Codes_013012_8','Z:\Images\021512\24Codes_013012_10','Z:\Images\021512\24Codes_013012_12',...
    'Z:\Images\021512\24Codes_013012_14','Z:\Images\021512\24Codes_013012_16','Z:\Images\021512\24Codes_013012_19'};

rawim = squeeze(MMparse('Z:\Images\021512\24Codes_013012_1'));
rawim = double(rawim) - dark_stack;
temp = rawim(:,:,2:7); %drop brightfield
[temp_unmixed, err] = unmix(temp, spectra_df);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
CC = bwconncomp(mask,4);
temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
beads_M0130df_nocorr_all=compositeBeadDataSet(temp_object);
clear temp_object;

dsnum = 2;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra_df);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);    
    beads_M0130df_nocorr_all.add(temp_object);
    clear temp_object;
    dsnum = dsnum + 1;
end

clear M0130dfx_nocorr_delta
temp = beads_M0130df_nocorr_all.getTransformedCodeRatio(:);
[Idx, M0130dfx_nocorr_all_mean] = kmeans(temp,[],'start',k);

for n=1:size(temp,1)
    M0130dfx_nocorr_delta(n,:)= temp(n,:) - M0130dfx_nocorr_all_mean(Idx(n),:);
end

Dyoff_nocorr = lwsmooth_nd(beads_M0130df_nocorr_all.Centroid(:,:), M0130dfx_nocorr_delta(:,1), [X(:), Y(:)], tau);
Euoff_nocorr = lwsmooth_nd(beads_M0130df_nocorr_all.Centroid(:,:), M0130dfx_nocorr_delta(:,2), [X(:), Y(:)], tau);

Dyoff_nocorr = reshape(Dyoff_nocorr, size(X));
Euoff_nocorr = reshape(Euoff_nocorr, size(X));