%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');

%% Extract BB05-077 PEG-DAM spectrum

BB05_077_PEGDAM = squeeze(MMparse(fullfile(imgFolder, '20130617', 'PEG-DAM 05-077_1')));
BB05_077_PEGDAM = BB05_077_PEGDAM(:,:,2:end);


for n=1:size(BB05_077_PEGDAM,3)
    backgroundSlice = BB05_077_PEGDAM(90:200,40:200,n);
    PEGDAMSlice = BB05_077_PEGDAM(350:460,350:460,n);
    BlankBead_spec(n) = mean(PEGDAMSlice(:)) - mean(backgroundSlice(:));
end


%%

%reference spectra
load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis', 'ReferenceSpectra', '20130523_ex292.mat'));

% load dark stack
load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis', 'darkstack20121129.mat'));

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Beads 20130614-01


%load images and correct for dark and flat fields
M20130614_01_1 = squeeze(MMparse(fullfile(imgFolder, '20130617', '20130614-01_1')));
M20130614_01_1 = double(M20130614_01_1) - dark_stack;
temp = double(M20130614_01_1(:,:,2:end)); %drop brightfield

%regen spectra with right dark correction on device autofluor
%get device background
for n=1:9
    slice = temp(100:160,10:60,n);
    Device_spec_df(n) = median(double(slice(:)));
end
Device_spec_df= Device_spec_df./sum(Device_spec_df);
spectra_df = [Dy_spec;Eu_spec;Sm_spec;Tm_spec; Device_spec_df];


[M20130614_01_1u,err] = unmix(temp, spectra_df);
err = nanmedian(abs(err(:)./double(temp(:))))
%mask = gen_bead_mask2(M0907_1u(:,:,2),7,-0.03);
%CC = bwconncomp(mask,4);
% load(fullfile(rootFolder, 'Matlab', 'BeadAnalysis','target4xbead.tif'));


target4xbeadBF = M20130614_01_1(89:106,340:357,1);
%%
[coords, mask, CC] = xcorrFindBeads(M20130614_01_1(:,:,1), target4xbeadBF, 7,0.7);
beads_20130614_01 = beadDataSet('oldimage', M20130614_01_1u, CC, 2);
beads_20130614_01.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
% beads_M1129_2.Transform = ICP(beads_M1129_2.getCodeRatio(:), target);
% beads_M20130510_01_1 = beads_20130510_01;
beads_M20130614_01_all = compositeBeadDataSet(beads_20130614_01);


% beads_M20130510_01_struct{1} = beads_M20130510_01_1;
% maskStruct{1} = mask;
% 
% images_M20130510_01{1} = M20130510_01_1;

for fnum = 2:6
    filename = fullfile(imgFolder, '20130617', ['20130614-01_' sprintf('%d', fnum)]);
    rawim = squeeze(MMparse(filename));
    rawim = double(rawim) - dark_stack;
    temp = rawim(:,:,2:end); %drop brightfield
    uname = ['untreated_',sprintf('%d', fnum),'u'];
    [temp_unmixed, err] = unmix(temp, spectra_df);
    eval([uname ' = temp_unmixed;']); %copy over unmixed image
    err = nanmedian(abs(err(:)./temp(:)))
    [coords, mask, CC] = xcorrFindBeads(rawim(:,:,1), target4xbeadBF, 7, 0.7);
    size(coords,1)
    temp_object = beadDataSet('oldimage', temp_unmixed, CC, 2);
    temp_object.CodingChannels = [lanthanideChannels.Dy lanthanideChannels.Sm lanthanideChannels.Tm];
%     temp_object.Transform = ICP(temp_object.getCodeRatio(:), target);
%     beads_M20130510_01_struct{fnum} = temp_object;
%     maskStruct{fnum} = mask;
%     images_M20130510_01{fnum} = rawim;
    beads_M20130614_01_all.add(temp_object);
    clear temp_object;
end


% I have used the code below for plotting purposes only. Further down there
% is code for the analysis of other beads.

%%
figure('name', 'PEG-DAM beads code set 20130614-01')
subplot(2,2,1)
plot(beads_M20130614_01_all.getRatio(:,lanthanideChannels.Dy), beads_M20130614_01_all.getRatio(:,lanthanideChannels.Sm),'.');
xlabel('Dy levels (0, 0.12, 0.27, 0.46, 0.7, 1)', 'fontweight', 'Bold', 'fontsize', 14)
ylabel('Sm levels (0, 0.12, 0.27, 0.46, 0.7, 1)', 'fontweight', 'Bold', 'fontsize', 14)
% axis([-1 4 -0.5 3])

subplot(2,2,2)
plot(beads_M20130614_01_all.getRatio(:,lanthanideChannels.Tm), beads_M20130614_01_all.getRatio(:,lanthanideChannels.Sm),'.');
xlabel('Tm levels (0, 0.12, 0.27, 0.46, 0.7, 1)', 'fontweight', 'Bold', 'fontsize', 14)
% axis([-1 2 -0.5 3])

subplot(2,2,3)
plot(beads_M20130614_01_all.getRatio(:,lanthanideChannels.Dy), beads_M20130614_01_all.getRatio(:,lanthanideChannels.Tm),'.');
ylabel('Tm levels (0, 0.12, 0.27, 0.46, 0.7, 1)', 'fontweight', 'Bold', 'fontsize', 14)
% axis([-1 4 -1 2])

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


