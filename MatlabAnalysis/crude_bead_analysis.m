ims = squeeze(MMparse('Z:\Keck\051310\Water_postH2O2_Spectra_0',1));
im=mean(ims(:,:,34:35),3);


    h=fspecial('disk',12);
    mask_disk = h > max(h(:))/2;

[A,CC,CR]=CircularHough_Grd(im,[8, 14],40,4,1);
newmask=zeros([501 502],'uint8');
CC=round(CC);
for n=1:size(CC,1)
    newmask(CC(n,2),CC(n,1)) = 1;
end
newmask=im2bw(imfilter(newmask,double(mask_disk)),0.001);
objects=bwconncomp(newmask);

clear I
for t=1:size(ims,3)
    im=ims(:,:,t);
    for n=1:objects.NumObjects
        I(t,n) = mean(im(objects.PixelIdxList{n}));
    end
end

I=I-repmat(min(I,[],1),[61 1]);
I=I./repmat(max(I,[],1),[61 1]);
spec_h2o_5 = I;