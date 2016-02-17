%analysis of 7/11/12 and 7/12/12 chemical compatibility data
%using 2/15/12 reference spectra

%use old dark offsets
dark_1s = squeeze(MMparse('Z:\Images\021512\dark_1sec_1'));
mdark_1s = mean(double(dark_1s),3);

dark_5s = squeeze(MMparse('Z:\Images\021512\dark_5sec_1'));
mdark_5s = mean(double(dark_5s),3);

clear dark_1s dark_5s %clear big data stacks

dark_stack = repmat(mdark_5s,[1 1 5]);
dark_stack(:,:,6:7) = repmat(mdark_1s, [1 1 2]);


%get background spectrum
ims = double(squeeze(MMparse('Z:\Images\071112\Empty device_1'))) - dark_stack;
%regen spectra with right dark correction on device autofluor
%get device background
for n=2:7
    slice = ims(128:384,128:384,n);
    Device_spec(n-1) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);
spectra = [Dy_spec_new;Eu_spec_new;Sm_spec_new;Device_spec];

untreated = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 untreated_2'));
untreated = double(untreated) - dark_stack;
temp = untreated(:,:,2:7);
[untreated_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(untreated(:,:,1), target4xbead, 5);
beads_untreated_1 = beadDataSet('oldimage', untreated_1u, CC, 2);
beads_untreated_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_untreated_all = compositeBeadDataSet(beads_untreated_1);

for fnum = 3:12
    filename = ['Z:\Images\071112\Beads20120608-1 untreated_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_untreated_all.add(temp_object);
    clear temp_object;
end


DMF_24h = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 DMF 24hr_1'));
DMF_24h = double(DMF_24h) - dark_stack;
temp = DMF_24h(:,:,2:7);
[DMF_24h_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(DMF_24h(:,:,1), target4xbead, 5);
beads_DMF_24h_1 = beadDataSet('oldimage', DMF_24h_1u, CC, 2);
beads_DMF_24h_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_DMF_24h_all = compositeBeadDataSet(beads_DMF_24h_1);

for fnum = 2:6
    filename = ['Z:\Images\071112\Beads20120608-1 DMF 24hr_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['DMF_24h_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_DMF_24h_all.add(temp_object);
    clear temp_object;
end

Piperidine_24h = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 20% Piperifdine 24hr_1'));
Piperidine_24h = double(Piperidine_24h) - dark_stack;
temp = Piperidine_24h(:,:,2:7);
[Piperidine_24h_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(Piperidine_24h(:,:,1), target4xbead2, 5);
beads_Piperidine_24h_1 = beadDataSet('oldimage', Piperidine_24h_1u, CC, 2);
beads_Piperidine_24h_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_Piperidine_24h_all = compositeBeadDataSet(beads_Piperidine_24h_1);

for fnum = 2:3
    filename = ['Z:\Images\071112\Beads20120608-1 20% Piperifdine 24hr_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['Piperidine_24h_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead2, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_Piperidine_24h_all.add(temp_object);
    clear temp_object;
end

DIEA_24h = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 20% DIEA 24hr_1'));
DIEA_24h = double(DIEA_24h) - dark_stack;
temp = DIEA_24h(:,:,2:7);
[DIEA_24h_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(DIEA_24h(:,:,1), target4xbead2, 5);
beads_DIEA_24h_1 = beadDataSet('oldimage', DIEA_24h_1u, CC, 2);
beads_DIEA_24h_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_DIEA_24h_all = compositeBeadDataSet(beads_DIEA_24h_1);

for fnum = 2:7
    filename = ['Z:\Images\071112\Beads20120608-1 20% DIEA 24hr_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['DIEA_24h_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead2, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_DIEA_24h_all.add(temp_object);
    clear temp_object;
end

NMP_24h = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 NMP 24hr_1'));
NMP_24h = double(NMP_24h) - dark_stack;
temp = NMP_24h(:,:,2:7);
[NMP_24h_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(NMP_24h(:,:,1), target4xbead2, 5);
size(coords,1)
beads_NMP_24h_1 = beadDataSet('oldimage', NMP_24h_1u, CC, 2);
beads_NMP_24h_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_NMP_24h_all = compositeBeadDataSet(beads_NMP_24h_1);

for fnum = 2:7
    filename = ['Z:\Images\071112\Beads20120608-1 NMP 24hr_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['NMP_24h_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead2, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_NMP_24h_all.add(temp_object);
    clear temp_object;
end

MeOH_24h = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 MeOH 24hr_1'));
MeOH_24h = double(MeOH_24h) - dark_stack;
temp = MeOH_24h(:,:,2:7);
[MeOH_24h_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(MeOH_24h(:,:,1), target4xbead2, 5);
size(coords,1)
beads_MeOH_24h_1 = beadDataSet('oldimage', MeOH_24h_1u, CC, 2);
beads_MeOH_24h_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_MeOH_24h_all = compositeBeadDataSet(beads_MeOH_24h_1);

for fnum = 2:5
    filename = ['Z:\Images\071112\Beads20120608-1 MeOH 24hr_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['MeOH_24h_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead2, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_MeOH_24h_all.add(temp_object);
    clear temp_object;
end

DMSO_24h = squeeze(MMparse('Z:\Images\071112\Beads20120608-1 DMSO 24hr_1'));
DMSO_24h = double(DMSO_24h) - dark_stack;
temp = DMSO_24h(:,:,2:7);
[DMSO_24h_1u,err] = unmix(temp, spectra);
err = median(abs(err(:)./temp(:)))
[coords, mask, CC] = xcorrFindBeads(DMSO_24h(:,:,1), target4xbead2, 5);
size(coords,1)
beads_DMSO_24h_1 = beadDataSet('oldimage', DMSO_24h_1u, CC, 2);
beads_DMSO_24h_1.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
beads_DMSO_24h_all = compositeBeadDataSet(beads_DMSO_24h_1);

for fnum = 2:5
    filename = ['Z:\Images\071112\Beads20120608-1 DMSO 24hr_', sprintf('%d', fnum)];
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:7); %drop brightfield
    uname = ['DMSO_24h_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = median(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbead2, 5);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm];
    beads_DMSO_24h_all.add(temp_object);
    clear temp_object;
end

%plots
figure(1)
clf

%untreated
centerbeads = all(beads_untreated_all.Centroid>100,2) & all(beads_untreated_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_untreated_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_untreated_all.getRatio(goodlist,lanthanideChannels.Dy), beads_untreated_all.getRatio(goodlist,lanthanideChannels.Sm),'k.')
hold on
figure(2)
clf
Dy=beads_untreated_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_untreated_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'k');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'k');
hold on

%DMF, 24h
figure(1)
centerbeads = all(beads_DMF_24h_all.Centroid>100,2) & all(beads_DMF_24h_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_DMF_24h_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_DMF_24h_all.getRatio(goodlist,lanthanideChannels.Dy), beads_DMF_24h_all.getRatio(goodlist,lanthanideChannels.Sm),'r.')
figure(2)
Dy=beads_DMF_24h_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_DMF_24h_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'r');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'r');

%Piperidine, 24h
figure(1)
centerbeads = all(beads_Piperidine_24h_all.Centroid>100,2) & all(beads_Piperidine_24h_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_Piperidine_24h_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_Piperidine_24h_all.getRatio(goodlist,lanthanideChannels.Dy), beads_Piperidine_24h_all.getRatio(goodlist,lanthanideChannels.Sm),'g.')
figure(2)
Dy=beads_Piperidine_24h_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_Piperidine_24h_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'g');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'g');

%DIEA, 24h
figure(1)
centerbeads = all(beads_DIEA_24h_all.Centroid>100,2) & all(beads_DIEA_24h_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_DIEA_24h_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_DIEA_24h_all.getRatio(goodlist,lanthanideChannels.Dy), beads_DIEA_24h_all.getRatio(goodlist,lanthanideChannels.Sm),'m.')
figure(2)
Dy=beads_DIEA_24h_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_DIEA_24h_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'm');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'm');

%NMP, 24h
figure(1)
centerbeads = all(beads_NMP_24h_all.Centroid>100,2) & all(beads_NMP_24h_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_NMP_24h_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_NMP_24h_all.getRatio(goodlist,lanthanideChannels.Dy), beads_NMP_24h_all.getRatio(goodlist,lanthanideChannels.Sm),'c.')
figure(2)
Dy=beads_NMP_24h_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_NMP_24h_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'c');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'c');

%MeOH, 24h
figure(1)
centerbeads = all(beads_MeOH_24h_all.Centroid>100,2) & all(beads_MeOH_24h_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_MeOH_24h_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_MeOH_24h_all.getRatio(goodlist,lanthanideChannels.Dy), beads_MeOH_24h_all.getRatio(goodlist,lanthanideChannels.Sm),'b.')
figure(2)
Dy=beads_MeOH_24h_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_MeOH_24h_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'b');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'b');

%DMSO, 24h
figure(1)
centerbeads = all(beads_DMSO_24h_all.Centroid>100,2) & all(beads_DMSO_24h_all.Centroid<400,2);
centerlist = find(centerbeads);
goodAF = beads_DMSO_24h_all.getIntensity(:,lanthanideChannels.Device)<1100; %corresponds to 6 sigma above mean
goodlist = find(centerbeads & goodAF);
plot(beads_DMSO_24h_all.getRatio(goodlist,lanthanideChannels.Dy), beads_DMSO_24h_all.getRatio(goodlist,lanthanideChannels.Sm),'b.')
figure(2)
Dy=beads_DMSO_24h_all.getRatio(goodlist,lanthanideChannels.Dy);
Sm=beads_DMSO_24h_all.getRatio(goodlist,lanthanideChannels.Sm);
line([mean(Dy)-std(Dy) mean(Dy)+std(Dy)],[mean(Sm) mean(Sm)],'Color', 'b');
line([mean(Dy) mean(Dy)],[mean(Sm)-std(Sm) mean(Sm)+std(Sm)],'Color', 'b');