%load images
camera_offset = 445;
probe_radius = 20;

Sm = squeeze(MMparse('Z:\Keck\112211\Sm_only_2'));
Eu = squeeze(MMparse('Z:\Keck\112211\Eu_only_3'));
Dy = squeeze(MMparse('Z:\Keck\112211\Dy_only_3'));
CeTb = squeeze(MMparse('Z:\Keck\112211\CeTb_only_1'));

Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'median');
CeTb = bkgd_subtract(CeTb, 'estimate', probe_radius);
CeTb = bkgd_subtract(CeTb, 'median');
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

RGB = zeros([501 502 3]);
slice = Sm(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Sm(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Sm(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Sm(:,:,5)>500;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Sm(:,:,n);
    Sm_spec(n)=median(slice(mask));
end
%normalize
Sm_spec = Sm_spec./sum(Sm_spec);

RGB = zeros([501 502 3]);
slice = Eu(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Eu(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Eu(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Eu(:,:,4)>1200;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Eu(:,:,n);
    Eu_spec(n)=median(slice(mask));
end
%normalize
Eu_spec = Eu_spec./sum(Eu_spec);

RGB = zeros([501 502 3]);
slice = Dy(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = Dy(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = Dy(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = Dy(:,:,3)>400;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = Dy(:,:,n);
    Dy_spec(n)=median(slice(mask));
end
%normalize
Dy_spec = Dy_spec./sum(Dy_spec);

RGB = zeros([501 502 3]);
slice = CeTb(:,:,1);
RGB(:,:,1) = slice./max(slice(:));
slice = CeTb(:,:,3);
RGB(:,:,2) = slice./max(slice(:));
slice = CeTb(:,:,5);
RGB(:,:,3) = slice./max(slice(:));
RGB = max(0,RGB);
[yi,xi,P] = impixel(RGB);
marker = zeros([501 502]);
marker(xi,yi)=1;
marker=marker>0;
mask = CeTb(:,:,2)>200;
mask = imreconstruct(marker,mask);
%extract foreground pixels
for n=1:5
    slice = CeTb(:,:,n);
    CeTb_spec(n)=median(slice(mask));
end
%normalize
CeTb_spec = CeTb_spec./sum(CeTb_spec);

Ln_spec=[CeTb_spec;Dy_spec;Eu_spec;Sm_spec];
