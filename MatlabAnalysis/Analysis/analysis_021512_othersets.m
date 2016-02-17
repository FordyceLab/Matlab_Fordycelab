bead_template = double(imread('Z:\Matlab\Analysis\target4xbead.tif'));

%ICP target values
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};

filelist = {'Z:\Images\021512\24Codes_010912_1','Z:\Images\021512\24Codes_010912_3', 'Z:\Images\021512\24Codes_010912_5',...
    'Z:\Images\021512\24Codes_010912_7', 'Z:\Images\021512\24Codes_010912_9','Z:\Images\021512\24Codes_010912_10',...
    'Z:\Images\021512\24Codes_010912_12', 'Z:\Images\021512\24Codes_010912_14', 'Z:\Images\021512\24Codes_010912_16'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7).*corrim; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra_df);
    err = median(abs(err(:)./temp(:)))
    [~, mask, CC] = xcorrFindBeads(rawim(:,:,1), bead_template, 5);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_M0109 = compositeBeadDataSet(temp_object);
    else
    	beads_M0109.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

centerbeads = find(all(beads_M0109.Centroid>100,2) & all(beads_M0109.Centroid<400,2));
plot(beads_M0109.getTransformedCodeRatio(centerbeads,lanthanideChannels.Dy),beads_M0109.getTransformedCodeRatio(centerbeads,lanthanideChannels.Sm),'k.')

%% 24 codes 2/10
%ICP target values
target={[0, 0.12, 0.27, 0.46, 0.70], [0, 0.12, 0.27, 0.46, 0.70 1.0]}; %missing top Dy level

filelist = {'Z:\Images\021512\24Codes_021012_2','Z:\Images\021512\24Codes_021012_4', 'Z:\Images\021512\24Codes_021012_6',...
    'Z:\Images\021512\24Codes_021012_8', 'Z:\Images\021512\24Codes_021012_10','Z:\Images\021512\24Codes_021012_12',...
    'Z:\Images\021512\24Codes_021012_13', 'Z:\Images\021512\24Codes_021012_15', 'Z:\Images\021512\24Codes_021012_17',...
    'Z:\Images\021512\24Codes_021012_19', 'Z:\Images\021512\24Codes_021012_21'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7).*corrim; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra_df);
    err = median(abs(err(:)./temp(:)))
    [~, mask, CC] = xcorrFindBeads(rawim(:,:,1), bead_template, 5);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_M0210 = compositeBeadDataSet(temp_object);
    else
    	beads_M0210.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

centerbeads = find(all(beads_M0210.Centroid>100,2) & all(beads_M0210.Centroid<400,2));
plot(beads_M0210.getTransformedCodeRatio(centerbeads,lanthanideChannels.Dy),beads_M0210.getTransformedCodeRatio(centerbeads,lanthanideChannels.Sm),'r.')
