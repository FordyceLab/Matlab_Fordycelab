imdir='C:\Kurt\Spectral barcoding\Data\060809\epi_noise_good';
basename='nd_cropt01c';
n_ims=51;
imstack=zeros([256 256 n_ims]);
for n=1:n_ims
    fname=strcat(basename,sprintf('%d',n),'.tif');
    path=fullfile(imdir, fname);
    imstack(:,:,n)=imread(path);    
end

imstack=imstack-400;    %subtract off dark image offset

maxIP=max(imstack,[],3)/16384;
disk5=strel('disk',5);
disk6=strel('disk',6);
disk10=strel('disk',10);
maskim=imopen(maxIP,disk5)-imopen(maxIP,disk10);
mask=im2bw(maskim,0.02);
mask2=imdilate(imerode(mask,disk6),disk5);
RGB=zeros([size(mask2) 3]);
RGB(:,:,1)=maxIP./(0.8*max(maxIP(:)));
RGB(:,:,2)=mask2*0.6;
imshow(RGB)

[L,nobjs]=bwlabel(mask2);
beads=zeros([nobjs n_ims]);
for n=1:nobjs
    pix=find(L==n);
    for q=1:n_ims
        im=squeeze(imstack(:,:,q));
        beads(n,q)=mean(im(pix));
    end
end
beads=beads';
imstack_beads=imstack;