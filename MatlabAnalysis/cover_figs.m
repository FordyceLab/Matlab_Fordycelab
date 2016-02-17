q=imrotate(M0130df_10u(:,:,1),-3,'bilinear','crop');
im = q(120:400,115:395);
im = im - min(im(:));
im = im./max(im(:));
RGB=zeros([size(im) 3]);
RGB(:,:,3) = im; %Dy
q=imrotate(M0130df_10u(:,:,2),-3,'bilinear','crop');
im = q(120:400,115:395);
im = im - min(im(:));
im = im./max(im(:));
RGB(:,:,1) = im; %Eu
q=imrotate(M0130df_10u(:,:,3),-3,'bilinear','crop');
im = q(120:400,115:395);
im = im - min(im(:));
im = im./max(im(:));
RGB(:,:,2) = im; %Sm
RGB_orig = RGB;

PSF = fspecial('gaussian',5,0.5);
RGB= imfilter(RGB_orig,PSF,'symmetric','conv');

p1= -log10(RGB);
p1 = padarray(p1,[5 5 0], 1);
p2 = RGB;
p2(:,:,1) = RGB(:,:,2);
p2(:,:,2) = RGB(:,:,1);
p2 = -log10(p2);
p2 = padarray(p2,[5 5 0], 1);

p3=RGB;
p3(:,:,1) = RGB(:,:,3);
p3(:,:,3) = RGB(:,:,1);
p3=-log10(p3);
p3 = padarray(p3,[5 5 0], 1);

p4=RGB;
p4(:,:,2) = RGB(:,:,3);
p4(:,:,3) = RGB(:,:,2);
p4=-log10(p4);
p4 = padarray(p4,[5 5 0], 1);

finalim=[p1,p2,p3;p3,p1,p2;p2,p3,p1];
imwrite(finalim, ['C:\Kurt\Spectral barcoding\Paper I\cover1.tif']);

p4=-log10(RGB);
p4(:,:,1)=RGB(:,:,1);
p4 = padarray(p4,[5 5 0], 1);

p5=-log10(RGB);
p5(:,:,2)=RGB(:,:,2);
p5 = padarray(p5,[5 5 0], 1);

p6=-log10(RGB);
p6(:,:,3)=RGB(:,:,3);
p6 = padarray(p6,[5 5 0], 1);

p7=RGB;
p7 = padarray(p7,[5 5 0], 1);

p8=RGB;
p8(:,:,1) = RGB(:,:,2);
p8(:,:,2) = RGB(:,:,1);
p8 = padarray(p8,[5 5 0], 1);

p9=RGB;
p9(:,:,1) = RGB(:,:,3);
p9(:,:,3) = RGB(:,:,1);
p9 = padarray(p9,[5 5 0], 1);

finalim=[p1,p2,p3;p4,p5,p6;p7,p8,p9];
imwrite(finalim, ['C:\Kurt\Spectral barcoding\Paper I\cover2.tif']);