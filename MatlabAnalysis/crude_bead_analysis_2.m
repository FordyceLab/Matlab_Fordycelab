ims = squeeze(MMparse('Z:\Keck\052710\3bead_bleach_0'));
im=mean(ims,3);

h=fspecial('disk',12);
mask_disk = h > max(h(:))/2;

%615 channel
[A,CC,CR]=CircularHough_Grd(im(:,:,4),[11, 17],40,8,1);
newmask=zeros([501 502],'uint8');
CC=round(CC);
for n=1:size(CC,1)
    newmask(CC(n,2),CC(n,1)) = 1;
end
newmask=im2bw(imfilter(newmask,double(mask_disk)),0.001);
Eubeads=bwconncomp(newmask);

%480 channel
[A,CC,CR]=CircularHough_Grd(im(:,:,1),[11, 17],20,8,1);
newmask=zeros([501 502],'uint8');
CC=round(CC);
for n=1:size(CC,1)
    newmask(CC(n,2),CC(n,1)) = 1;
end
newmask=im2bw(imfilter(newmask,double(mask_disk)),0.001);
Dybeads=bwconncomp(newmask);

clear I
for t=1:size(ims,3)
    for l=1:size(ims,4)
        im=ims(:,:,t,l);
        for n=1:Eubeads.NumObjects
            I(t,n,l) = mean(im(Eubeads.PixelIdxList{n})) - bkgd_I(l);
        end
    end
end
Eu_h2o_1 = I;

clear I
for t=1:size(ims,3)
    for l=1:size(ims,4)
        im=ims(:,:,t,l);
        for n=1:Dybeads.NumObjects
            I(t,n,l) = mean(im(Dybeads.PixelIdxList{n})) - bkgd_I(l);
        end
    end
end
Dy_h2o_1 = I;