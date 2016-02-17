%% Extract reference spectra
%load images
Sm = squeeze(MMparse('Z:\Keck\092211\SmBeads_5000msExp'));
Dy = squeeze(MMparse('Z:\Keck\092211\DyBeads_Better_1000sExp'));
CeTb = squeeze(MMparse('Z:\Keck\092211\CeTbBeads_5000msExp'));
Eu = squeeze(MMparse('Z:\Keck\092211\EuBeadsFullStrength_Better'));

%background subtract
probe_radius = 20;
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
CeTb = bkgd_subtract(CeTb, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);

%extract foreground pixels
Sm_slice = Sm(:,:,5);
pix = find(Sm_slice>3500);
for n=1:5
    Sm_slice = Sm(:,:,n);
    Sm_spectra(n)=mean(Sm_slice(pix));
end
%normalize
Sm_spectra = Sm_spectra./sum(Sm_spectra);
Sm_spectra = Sm_spectra/50;
    
Dy_slice = Dy(:,:,3);
pix = find(Dy_slice>100);
for n=1:5
    Dy_slice = Dy(:,:,n);
    Dy_spectra(n)=mean(Dy_slice(pix));
end
Dy_spectra = Dy_spectra./sum(Dy_spectra);
Dy_spectra = Dy_spectra/10;

CeTb_slice = CeTb(:,:,2);
pix = find(CeTb_slice>200);
for n=1:5
    CeTb_slice = CeTb(:,:,n);
    CeTb_spectra(n)=mean(CeTb_slice(pix));
end
CeTb_spectra = CeTb_spectra./sum(CeTb_spectra);
CeTb_spectra = CeTb_spectra/50;

Eu_slice = Eu(:,:,4);
pix = find(Eu_slice>600);
for n=1:5
    Eu_slice = Eu(:,:,n);
    Eu_spectra(n)=mean(Eu_slice(pix));
end
Eu_spectra = Eu_spectra./sum(Eu_spectra);
Eu_spectra = Eu_spectra/1;

%slide background
for n=1:5
    bkgdpix = CeTb(1:220,1:60,n);
    slide_spectra(n)=mean(bkgdpix(:));
end
slide_spectra = slide_spectra./sum(slide_spectra);
slide_spectra = slide_spectra/50;

%reference spectra
refLn = [CeTb_spectra; Dy_spectra; Eu_spectra; Sm_spectra];
refLnbkgd = [refLn; slide_spectra];

%%load test images and unmix
test = squeeze(MMparse('Z:\Keck\092211\AllFourBeads_1000msExpForAll'));
test = bkgd_subtract(test, 'estimate', probe_radius);
[unmixLn, errLn] = unmix(test, refLn);
[unmixLnbkgd, errLnbkgd] = unmix(test, refLnbkgd);

%save
for n=1:size(unmixLnbkgdn,3)
    tempim = unmixLnbkgdn(:,:,n);
    tempim = tempim./max(tempim(:));
    basename = 'Z:\Keck\092211\AllFourBeads_1000msExpForAll_c';
    filename = [basename, sprintf('%d',n), '.tif'];
    imwrite(tempim,filename,'tiff');
end
        