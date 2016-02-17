Eu_sub=zeros(size(Eu_only));
for n=1:5
    Eu_sub(:,:,:,n)=bkgd_subtract(Eu_only(:,:,:,n),'estimate',20);
end

temp = max(uint16(Eu_sub),[],4);
maxI=max(temp(:));
maxI=maxI/2;
RGB=zeros([501 502 3]);

RGB(:,:,1)=temp(:,:,1)./maxI;
RGB(:,:,2)=temp(:,:,3)./maxI;
RGB(:,:,3)=temp(:,:,5)./maxI;

imshow(RGB);

[x,y] = getpts;

mask=zeros([501 502]);
x=round(x);
y=round(y);
for n=1:size(x,1)
    mask(y(n),x(n)) = 1;
end

mask = min(mask,RGB(:,:,3));
final = imreconstruct(mask,RGB(:,:,3));
pix = find(final);
Eubeads=bwconncomp(final);

tempim=squeeze(Eu_sub(:,:,5,:));
clear Eu_I_beads
for n=1:5
    chan = tempim(:,:,n);
    chan = chan - mode(chan(:));
    Eu_I(n) = mean(chan(pix));
    for b=1:Eubeads.NumObjects
        Eu_I_beads(n,b) = mean(chan(Eubeads.PixelIdxList{b}));
    end
end