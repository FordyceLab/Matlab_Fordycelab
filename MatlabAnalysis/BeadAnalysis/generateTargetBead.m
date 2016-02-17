%Circular Hough Transform to find a bunch of beads, doesn't need extreme
%accuracy
[A,CC,CR] = CircularHough_Grd(BFim,[5 6],1000,3,1);
imshow(BFim,[])
hold on
for n=1:size(CC,1)
    plot(CC(n,1),CC(n,2),'r+')
end
%cutout beads
boxsize = 8;
beadstack = zeros([2*boxsize+1 2*boxsize+1 size(CC,1)]);
CC= round(CC);
for n=1:size(CC,1)
    beadstack(:,:,n) = BFim(CC(n,2)-boxsize:CC(n,2)+boxsize, CC(n,1)-boxsize:CC(n,1)+boxsize);
end
meanbead = mean(beadstack,3);
%now subpixel register all beads against this
regstack = zeros(size(beadstack));

for rot=0:90:270; %crude rotational symmetrizing
    for n=1:size(beadstack,3)
        [~, r] = dftregistration(target, fft2(imrotate(beadstack(:,:,n),rot)),10);
        regstack(:,:,nr) = abs(ifft2(r));
        nr=nr+1;
    end
end

target = mean(regstack,3);