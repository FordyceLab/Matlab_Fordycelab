%% Extract reference spectra
camera_offset = 447; %from dark image

%load images
Eu_290_10 = squeeze(MMparse('Z:\Keck\101711\EuOnly_20111004-04\EuOnly_20111004-04_290_10_10_10_1_1_1'));
Eu_290_5 = squeeze(MMparse('Z:\Keck\101711\EuOnly_20111004-04\EuOnly_20111004-04_290_5_5_5_1_1_1'));
Eu_320_10 = squeeze(MMparse('Z:\Keck\101711\EuOnly_20111004-04\EuOnly_20111004-04_320_10_10_10_1_1_2'));
Eu_320_5 = squeeze(MMparse('Z:\Keck\101711\EuOnly_20111004-04\EuOnly_20111004-04_320_5_5_5_1_1_4'));

Sm_290_10 = squeeze(MMparse('Z:\Keck\101711\SmOnly_20110920-03\SmOnly_2011-0920-03_290_10_10_10_1_1_1'));
Sm_290_5 = squeeze(MMparse('Z:\Keck\101711\SmOnly_20110920-03\SmOnly_2011-0920-03_290_5_5_5_1_1_1'));
Sm_320_10 = squeeze(MMparse('Z:\Keck\101711\SmOnly_20110920-03\SmOnly_2011-0920-03_320_10_10_10_1_1_3'));
Sm_320_5 = squeeze(MMparse('Z:\Keck\101711\SmOnly_20110920-03\SmOnly_2011-0920-03_320_5_5_5_1_1_1'));

Dy_290_10 = squeeze(MMparse('Z:\Keck\101711\DyOnly_20110920-02\DyOnly_2011-0920-02_290_10_10_10_1_1_1'));
Dy_290_5 = squeeze(MMparse('Z:\Keck\101711\DyOnly_20110920-02\DyOnly_2011-0920-02_290_5_5_5_1_1_1'));
Dy_320_10 = squeeze(MMparse('Z:\Keck\101711\DyOnly_20110920-02\DyOnly_2011-0920-02_320_10_10_10_1_1_1'));
Dy_320_5 = squeeze(MMparse('Z:\Keck\101711\DyOnly_20110920-02\DyOnly_2011-0920-02_320_5_5_5_1_1_2'));

%background subtract
probe_radius = 20;
imlist = {'Eu_290_10','Eu_290_5','Eu_320_10','Eu_320_5','Dy_290_10','Dy_290_5','Dy_320_10','Dy_320_5','Sm_290_10','Sm_290_5','Sm_320_10','Sm_320_5'};
for n=1:numel(imlist)
    assignin('base', imlist{n}, bkgd_subtract(eval(imlist{n}), 'estimate', probe_radius));
    assignin('base', imlist{n}, bkgd_subtract(eval(imlist{n}), 'median'));
end
%%
RGB = zeros([501 502 3]);
slice = Dy_290_10(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Dy_290_10(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Dy_290_10(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Dy_290_10(:,:,3)>1800;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Dy_290_10(:,:,n);
    Dy_290_10_spectra(n)=median(slice(mask));
end
%normalize
Dy_290_10_spectra = Dy_290_10_spectra./sum(Dy_290_10_spectra);

RGB = zeros([501 502 3]);
slice = Dy_290_5(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Dy_290_5(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Dy_290_5(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Dy_290_5(:,:,3)>1000;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Dy_290_5(:,:,n);
    Dy_290_5_spectra(n)=median(slice(mask));
end
%normalize
Dy_290_5_spectra = Dy_290_5_spectra./sum(Dy_290_5_spectra);

RGB = zeros([501 502 3]);
slice = Dy_320_10(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Dy_320_10(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Dy_320_10(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Dy_320_10(:,:,3)>1200;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Dy_320_10(:,:,n);
    Dy_320_10_spectra(n)=median(slice(mask));
end
%normalize
Dy_320_10_spectra = Dy_320_10_spectra./sum(Dy_320_10_spectra);

RGB = zeros([501 502 3]);
slice = Dy_320_5(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Dy_320_5(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Dy_320_5(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Dy_320_5(:,:,3)>600;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Dy_320_5(:,:,n);
    Dy_320_5_spectra(n)=median(slice(mask));
end
%normalize
Dy_320_5_spectra = Dy_320_5_spectra./sum(Dy_320_5_spectra);

RGB = zeros([501 502 3]);
slice = Sm_290_10(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Sm_290_10(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Sm_290_10(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Sm_290_10(:,:,3)>1500;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Sm_290_10(:,:,n);
    Sm_290_10_spectra(n)=median(slice(mask));
end
%normalize
Sm_290_10_spectra = Sm_290_10_spectra./sum(Sm_290_10_spectra);

RGB = zeros([501 502 3]);
slice = Sm_290_5(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Sm_290_5(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Sm_290_5(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Sm_290_5(:,:,3)>800;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Sm_290_5(:,:,n);
    Sm_290_5_spectra(n)=median(slice(mask));
end
%normalize
Sm_290_5_spectra = Sm_290_5_spectra./sum(Sm_290_5_spectra);

RGB = zeros([501 502 3]);
slice = Sm_320_10(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Sm_320_10(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Sm_320_10(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Sm_320_10(:,:,3)>2500;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Sm_320_10(:,:,n);
    Sm_320_10_spectra(n)=median(slice(mask));
end
%normalize
Sm_320_10_spectra = Sm_320_10_spectra./sum(Sm_320_10_spectra);

RGB = zeros([501 502 3]);
slice = Sm_320_5(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Sm_320_5(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Sm_320_5(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Sm_320_5(:,:,3)>1200;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Sm_320_5(:,:,n);
    Sm_320_5_spectra(n)=median(slice(mask));
end
%normalize
Sm_320_5_spectra = Sm_320_5_spectra./sum(Sm_320_5_spectra);

RGB = zeros([501 502 3]);
slice = Eu_290_10(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Eu_290_10(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Eu_290_10(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Eu_290_10(:,:,4)>4500;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Eu_290_10(:,:,n);
    Eu_290_10_spectra(n)=median(slice(mask));
end
%normalize
Eu_290_10_spectra = Eu_290_10_spectra./sum(Eu_290_10_spectra);

RGB = zeros([501 502 3]);
slice = Eu_290_5(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Eu_290_5(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Eu_290_5(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Eu_290_5(:,:,4)>4500;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Eu_290_5(:,:,n);
    Eu_290_5_spectra(n)=median(slice(mask));
end
%normalize
Eu_290_5_spectra = Eu_290_5_spectra./sum(Eu_290_5_spectra);

RGB = zeros([501 502 3]);
slice = Eu_320_10(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Eu_320_10(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Eu_320_10(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Eu_320_10(:,:,4)>5000;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Eu_320_10(:,:,n);
    Eu_320_10_spectra(n)=median(slice(mask));
end
%normalize
Eu_320_10_spectra = Eu_320_10_spectra./sum(Eu_320_10_spectra);

RGB = zeros([501 502 3]);
slice = Eu_320_5(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Eu_320_5(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Eu_320_5(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Eu_320_5(:,:,4)>5000;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Eu_320_5(:,:,n);
    Eu_320_5_spectra(n)=median(slice(mask));
end
%normalize
Eu_320_5_spectra = Eu_320_5_spectra./sum(Eu_320_5_spectra);