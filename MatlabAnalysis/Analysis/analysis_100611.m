%% Extract reference spectra
%load images
Sm = squeeze(MMparse('Z:\Keck\100611\Sm_only_Quartz_4'));
Eu = squeeze(MMparse('Z:\Keck\100611\Eu_only_Quartz_2'));
Device = squeeze(MMparse('Z:\Keck\100611\EmptyDevice_0'));

%background subtract
probe_radius = 20;
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);

Sm = bkgd_subtract(Sm, 'median');
Eu = bkgd_subtract(Eu, 'median');

Device = Device - 460; %approx camera offset

%extract foreground pixels
Sm_slice = Sm(:,:,5);
pix = find(Sm_slice>1500);
for n=1:5
    Sm_slice = Sm(:,:,n);
    Sm_spectra(n)=mean(Sm_slice(pix));
end
%normalize
Sm_spectra = Sm_spectra./sum(Sm_spectra);

Eu_slice = Eu(:,:,4);
pix = find(Eu_slice>5000);
for n=1:5
    Eu_slice = Eu(:,:,n);
    Eu_spectra(n)=mean(Eu_slice(pix));
end
Eu_spectra = Eu_spectra./sum(Eu_spectra);

for n=1:5
    Device_slice = Device(:,:,n);
    Device_spectra(n)=median(Device_slice(:));
end
Device_spectra = double(Device_spectra)./sum(Device_spectra);

%%load test data

mix = squeeze(MMparse('Z:\Keck\100611\Code20111004-All4Mix_0'));
mix = double(mix) - 460;
code1 = squeeze(MMparse('Z:\Keck\100611\Eu+1Sm_0'));
code1 = double(code1) - 460;
code2_1 = squeeze(MMparse('Z:\Keck\100611\Code20111004-02 Fill1_0'));
code2_1 = double(code2_1) - 460;
code2_2 = squeeze(MMparse('Z:\Keck\100611\Code20111004-02 Fill2_1'));
code2_2 = double(code2_2) - 460;
code3 = squeeze(MMparse('Z:\Keck\100611\Code20111004-03 Fill1_0'));
code3 = double(code3) - 460;
code4_1 = squeeze(MMparse('Z:\Keck\100611\Code20111004-04_0'));
code4_1 = double(code4_1) - 460;
code4_2 = squeeze(MMparse('Z:\Keck\100611\Code20111004-04 Fill2_0'));
code4_2 = double(code4_2) - 460;

refLn = [Eu_spectra; Sm_spectra];
refLnbkgd = [refLn; Device_spectra];

%%load test images and unmix
%[unmixLn, errLn] = unmix(Test, refLn);
[mix_unmix, mix_err] = unmix(mix, refLnbkgd);
[code1_unmix, code1_err] = unmix(code1, refLnbkgd);
[code2_1_unmix, code2_1_err] = unmix(code2_1, refLnbkgd);
[code2_2_unmix, code2_2_err] = unmix(code2_2, refLnbkgd);
[code3_unmix, code3_err] = unmix(code3, refLnbkgd);
[code4_1_unmix, code4_1_err] = unmix(code4_1, refLnbkgd);
[code4_2_unmix, code4_2_err] = unmix(code4_2, refLnbkgd);

%for now this is a good enough way to find beads
Code1_mask = adaptivethreshold(code1_unmix(:,:,1),20,-0.04);
Code1_mask = imclearborder(Code1_mask);
Code1_mask(1:50,450:end) = 0; %remove dust
Code2_1_mask = adaptivethreshold(code2_1_unmix(:,:,1),20,-0.04);
Code2_1_mask = imclearborder(Code2_1_mask);
Code2_2_mask = adaptivethreshold(code2_2_unmix(:,:,1),20,-0.04);
Code2_2_mask = imclearborder(Code2_2_mask);
Code3_mask = adaptivethreshold(code3_unmix(:,:,1),20,-0.04);
Code3_mask = imclearborder(Code3_mask);
Code4_1_mask = adaptivethreshold(code4_1_unmix(:,:,1),20,-0.04);
Code4_1_mask = imclearborder(Code4_1_mask);
Code4_2_mask = adaptivethreshold(code4_2_unmix(:,:,1),20,-0.04);
Code4_2_mask = imclearborder(Code4_2_mask);
mix_mask = adaptivethreshold(mix_unmix(:,:,1),20,-0.04);
mix_mask = imclearborder(mix_mask);

Code1_I = beadIntensities(code1_unmix, Code1_mask);
Code2_1_I = beadIntensities(code2_1_unmix, Code2_1_mask);
Code2_2_I = beadIntensities(code2_2_unmix, Code2_2_mask);
Code3_I = beadIntensities(code3_unmix, Code3_mask);
Code4_1_I = beadIntensities(code4_1_unmix, Code4_1_mask);
Code4_2_I = beadIntensities(code4_2_unmix, Code4_2_mask);
mix_I = beadIntensities(mix_unmix, mix_mask);

%generate bead images showing average ratios in bead positons
props = regionprops(Code1_mask, 'PixelIdxList');
Code1_synth = zeros(size(Code1_mask));
for n=1:numel(props)
    Code1_synth(props(n).PixelIdxList) = Code1_I(n).medianratio;
end
props = regionprops(Code2_1_mask, 'PixelIdxList');
Code2_1_synth = zeros(size(Code2_1_mask));
for n=1:numel(props)
    Code2_1_synth(props(n).PixelIdxList) = Code2_1_I(n).medianratio;
end
props = regionprops(Code2_2_mask, 'PixelIdxList');
Code2_2_synth = zeros(size(Code2_2_mask));
for n=1:numel(props)
    Code2_2_synth(props(n).PixelIdxList) = Code2_2_I(n).medianratio;
end
props = regionprops(Code3_mask, 'PixelIdxList');
Code3_synth = zeros(size(Code3_mask));
for n=1:numel(props)
    Code3_synth(props(n).PixelIdxList) = Code3_I(n).medianratio;
end

props = regionprops(Code3_mask, 'PixelIdxList');
for n=1:numel(props)
    Code3_ExI(n)= median(Code3_illum(props(n).PixelIdxList));
end
props = regionprops(Code1_mask, 'PixelIdxList');
for n=1:numel(props)
    Code1_ExI(n)= median(Code1_illum(props(n).PixelIdxList));
end

%%Export unmixed images
basedir = 'Z:\Keck\100611';
imagelist = {'code1_unmix','code2_1_unmix','code2_2_unmix','code3_unmix','code4_1_unmix','code4_2_unmix','mix_unmix'};
Eumax = 0;
Smmax = 0;
for n=1:numel(imagelist)
    im = eval(imagelist{n});
    Eu = im(:,:,1);
    Sm = im(:,:,2);
    Eumax = max(Eumax, max(Eu(:)));
    Smmax = max(Smmax, max(Sm(:)));
end
for n=1:numel(imagelist)
    im = eval(imagelist{n});    
    Eu = im(:,:,1)./Eumax;
    Eu = max(Eu,0)*(2^16-1);
    Eu = uint16(Eu);
    Sm = im(:,:,2)./Smmax;
    Sm = max(Sm,0)*(2^16-1);
    Sm = uint16(Sm);
    imwrite(Eu,fullfile(basedir,'processed',[imagelist{n},'_Eu.tif']),'tiff');
    imwrite(Sm,fullfile(basedir,'processed',[imagelist{n},'_Sm.tif']),'tiff');
end
