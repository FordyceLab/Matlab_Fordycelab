%analysis of Rachel's 2/10 beads treated with organic solvents by the
%DeGrado lab.

%target values for ICP
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
target={vals, vals};

dark_1s = squeeze(MMparse('Z:\Images\021512\dark_1sec_1'));
dark_1s = double(dark_1s);
mdark_1s = mean(dark_1s,3);

dark_5s = squeeze(MMparse('Z:\Images\021512\dark_5sec_1'));
dark_5s = double(dark_5s);
mdark_5s = mean(dark_5s,3);

clear dark_1s dark_5s

dark_stack = repmat(mdark_5s,[1 1 4]);
dark_stack(:,:,5:6) = repmat(mdark_1s, [1 1 2]);

starting_1 = squeeze(MMparse('Z:\Images\022912\startingcode_2'));
temp = double(starting_1(:,:,2:7)) - dark_stack; %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:6
    slice = temp(140:330,10:120,n);
    Device_spec_df(n) = median(slice(:));
end
Device_spec_= Device_spec_df./sum(Device_spec_df);
spectra = [Dy_spec;Eu_spec;Sm_spec;Device_spec];

[starting_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
mask = gen_bead_mask2(starting_1u(:,:,2),7,-0.03);
CC = bwconncomp(mask,4);
beads_starting_1 = beadDataSet('oldimage', starting_1u, CC, 2);
beads_starting_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_starting_1.Transform = ICP(beads_starting_1.getCodeRatio(:), target);
beads_starting_all = compositeBeadDataSet(beads_starting_1);
    
filelist = {'Z:\Images\022912\startingcode_3', 'Z:\Images\022912\startingcode_4', ...
    'Z:\Images\022912\startingcode_5','Z:\Images\022912\startingcode_6','Z:\Images\022912\startingcode_7',...
    'Z:\Images\022912\startingcode_9','Z:\Images\022912\startingcode_11','Z:\Images\022912\startingcode_13'};

dsnum = 2;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);    
    beads_starting_all.add(temp_object);
    clear temp_object;
    dsnum = dsnum + 1;
end

filelist = {'Z:\Images\022912\CH3OH_1', 'Z:\Images\022912\CH3OH_2', 'Z:\Images\022912\CH3OH_3'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);    
    if (dsnum == 1)
        beads_methanol = compositeBeadDataSet(temp_object);
    else
    	bead_methanol.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

%% 
filelist = {'Z:\Images\022912\DCM_1', 'Z:\Images\022912\DCM_2', 'Z:\Images\022912\DCM_3', 'Z:\Images\022912\DCM_4',...
    'Z:\Images\022912\DCM_5'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);    
    if (dsnum == 1)
        beads_DCM = compositeBeadDataSet(temp_object);
    else
    	beads_DCM.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

%% 
filelist = {'Z:\Images\022912\DIEA_maybecontaminatedwithDCM_1',...
    'Z:\Images\022912\DIEA_maybecontaminatedwithDCM_3', 'Z:\Images\022912\DIEA_maybecontaminatedwithDCM_4'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_DIEA = compositeBeadDataSet(temp_object);
    else
    	beads_DIEA.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

%% 
filelist = {'Z:\Images\022912\DMF_3','Z:\Images\022912\DMF_4', 'Z:\Images\022912\DMF_5'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_DMF = compositeBeadDataSet(temp_object);
    else
    	beads_DMF.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

%% 
filelist = {'Z:\Images\022912\DMSO_1','Z:\Images\022912\DMSO_2', 'Z:\Images\022912\DMSO_3', 'Z:\Images\022912\DMSO_4'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_DMSO = compositeBeadDataSet(temp_object);
    else
    	beads_DMSO.add(temp_object);
    end
    clear temp_object; 
    dsnum = dsnum + 1;
end

%%  
filelist = {'Z:\Images\022912\NMP_1','Z:\Images\022912\NMP_2', 'Z:\Images\022912\NMP_3'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_NMP = compositeBeadDataSet(temp_object);
    else
    	beads_NMP.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end

%%  
filelist = {'Z:\Images\022912\Piperidine_1','Z:\Images\022912\Piperidine_2', 'Z:\Images\022912\Piperidine_3',...
    'Z:\Images\022912\Piperidine_4'};
dsnum = 1;
for f=1:numel(filelist)
    rawim = squeeze(MMparse(filelist{f}));
    rawim = double(rawim);
    temp = rawim(:,:,2:7) - dark_stack; %drop brightfield
    [temp_unmixed, err] = unmix(temp, spectra);
    err = median(abs(err(:)./temp(:)))
    mask = gen_bead_mask2(temp_unmixed(:,:,2), 7, -0.03);
    subplot(1,2,1); imshow(rawim(:,:,1),[]);
    subplot(1,2,2); imshow(mask); pause
    CC = bwconncomp(mask,4);
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    temp_object.Transform = ICP(temp_object.getCodeRatio(:), target); 
    if (dsnum == 1)
        beads_Piperidine = compositeBeadDataSet(temp_object);
    else
    	beads_Piperidine.add(temp_object);
    end
    clear temp_object;
    dsnum = dsnum + 1;
end


centerbeads = find(all(beads_starting_all.Centroid>100,2) & all(beads_starting_all.Centroid<400,2));
plot(beads_starting_all.getRatio(centerbeads,lanthanideChannels.Dy),beads_starting_all.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
hold on
centerbeads = find(all(beads_DMSO.Centroid>100,2) & all(beads_DMSO.Centroid<400,2));
plot(beads_DMSO.getRatio(centerbeads,lanthanideChannels.Dy),beads_DMSO.getRatio(centerbeads,lanthanideChannels.Sm),'b.')
centerbeads = find(all(beads_DMF.Centroid>100,2) & all(beads_DMF.Centroid<400,2));
plot(beads_DMF.getRatio(centerbeads,lanthanideChannels.Dy),beads_DMF.getRatio(centerbeads,lanthanideChannels.Sm),'g.')
centerbeads = find(all(beads_NMP.Centroid>100,2) & all(beads_NMP.Centroid<400,2));
plot(beads_NMP.getRatio(centerbeads,lanthanideChannels.Dy),beads_NMP.getRatio(centerbeads,lanthanideChannels.Sm),'r.')
centerbeads = find(all(beads_Piperidine.Centroid>100,2) & all(beads_Piperidine.Centroid<400,2));
plot(beads_Piperidine.getRatio(centerbeads,lanthanideChannels.Dy),beads_Piperidine.getRatio(centerbeads,lanthanideChannels.Sm),'c.')
centerbeads = find(all(beads_methanol.Centroid>100,2) & all(beads_methanol.Centroid<400,2));
plot(beads_methanol.getRatio(centerbeads,lanthanideChannels.Dy),beads_methanol.getRatio(centerbeads,lanthanideChannels.Sm),'m.')

subplot(4,2,1)
centerbeads = find(all(beads_starting_all.Centroid>100,2) & all(beads_starting_all.Centroid<400,2));
plot(beads_starting_all.getRatio(centerbeads,lanthanideChannels.Dy),beads_starting_all.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
title('Untreated')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,2)
centerbeads = find(all(beads_DMSO.Centroid>100,2) & all(beads_DMSO.Centroid<400,2));
plot(beads_DMSO.getRatio(centerbeads,lanthanideChannels.Dy),beads_DMSO.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('DMSO')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,3)
centerbeads = find(all(beads_methanol.Centroid>100,2) & all(beads_methanol.Centroid<400,2));
plot(beads_methanol.getRatio(centerbeads,lanthanideChannels.Dy),beads_methanol.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('methanol')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,4)
centerbeads = find(all(beads_DMF.Centroid>100,2) & all(beads_DMF.Centroid<400,2));
plot(beads_DMF.getRatio(centerbeads,lanthanideChannels.Dy),beads_DMF.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('DMF')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,5)
centerbeads = find(all(beads_NMP.Centroid>100,2) & all(beads_NMP.Centroid<400,2));
plot(beads_NMP.getRatio(centerbeads,lanthanideChannels.Dy),beads_NMP.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('NMP')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,6)
centerbeads = find(all(beads_DCM.Centroid>100,2) & all(beads_DCM.Centroid<400,2));
plot(beads_DCM.getRatio(centerbeads,lanthanideChannels.Dy),beads_DCM.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('DCM')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,7)
centerbeads = find(all(beads_DIEA.Centroid>100,2) & all(beads_DIEA.Centroid<400,2));
plot(beads_DIEA.getRatio(centerbeads,lanthanideChannels.Dy),beads_DIEA.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('DIEA')
xlim([-0.05 0.45]); ylim([-0.1 1])

subplot(4,2,8)
centerbeads = find(all(beads_Piperidine.Centroid>100,2) & all(beads_Piperidine.Centroid<400,2));
plot(beads_Piperidine.getRatio(centerbeads,lanthanideChannels.Dy),beads_Piperidine.getRatio(centerbeads,lanthanideChannels.Sm),'k.')
axis tight
title('Piperidine')
xlim([-0.05 0.45]); ylim([-0.1 1])