%load images
camera_offset = 445;
probe_radius = 20;
Ln_spec=[CeTb_spec;Dy_spec;Eu_spec;Sm_spec];

CeTb_all1 = squeeze(MMparse('Z:\Keck\112211\CeTb_filled_serp_1'));
CeTb_all1 = double(CeTb_all1) - camera_offset;

CeTb_all2 = squeeze(MMparse('Z:\Keck\112211\CeTb_filled_serp_2'));
CeTb_all2 = double(CeTb_all2) - camera_offset;

%get device background
for n=1:5
    slice = CeTb_all1(2:300,2:30,n);
    Device_spec(n) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

Lnbkgd = [Ln_spec;Device_spec];

[CeTb_all1_u, err] = unmix(CeTb_all1, Lnbkgd);

mask = adaptivethreshold(CeTb_all1_u(:,:,3),22,-0.03);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
Ia = beadIntensities(CeTb_all1_u, CC, 3);

testspec = [CeTb_spec; Eu_spec; Device_spec];
[CeTb_all1_u, err] = unmix(CeTb_all1, testspec);

mask = adaptivethreshold(CeTb_all1_u(:,:,2),22,-0.03);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
Ib = beadIntensities(CeTb_all1_u, CC, 2);

[CeTb_all2_u, err] = unmix(CeTb_all2, testspec);
mask = adaptivethreshold(CeTb_all2_u(:,:,2),22,-0.03);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
Ib2 = beadIntensities(CeTb_all2_u, CC, 2);

CeTb_8th_1 = squeeze(MMparse('Z:\Keck\112211\CeTb_filled_serp_NoCeTb_and_1_8_Dil\Serp1_1'));
CeTb_8th_1 = double(CeTb_8th_1) - camera_offset;
CeTb_8th_2 = squeeze(MMparse('Z:\Keck\112211\CeTb_filled_serp_NoCeTb_and_1_8_Dil\Serp2_1'));
CeTb_8th_2 = double(CeTb_8th_2) - camera_offset;

[CeTb_8th1_u, err] = unmix(CeTb_8th_1, testspec);
[CeTb_8th2_u, err] = unmix(CeTb_8th_2, testspec);

mask = adaptivethreshold(CeTb_8th1_u(:,:,2),20,-0.04);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
I8th1 = beadIntensities(CeTb_8th1_u, CC, 2);

mask = adaptivethreshold(CeTb_8th2_u(:,:,2),20,-0.03);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
I8th2 = beadIntensities(CeTb_8th2_u, CC, 2);

CeTb_16th_1 = squeeze(MMparse('Z:\Keck\112211\CeTb_filled_serp_NoCeTb_and_1_16_Dil\Serp2_1'));
CeTb_16th_1 = double(CeTb_16th_1) - camera_offset;
CeTb_16th_2 = squeeze(MMparse('Z:\Keck\112211\CeTb_filled_serp_NoCeTb_and_1_16_Dil\Serp3_2'));
CeTb_16th_2 = double(CeTb_16th_2) - camera_offset;

[CeTb_16th1_u, err] = unmix(CeTb_16th_1, testspec);
[CeTb_16th2_u, err] = unmix(CeTb_16th_2, testspec);

mask = adaptivethreshold(CeTb_16th1_u(:,:,2),20,-0.04);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
I16th1 = beadIntensities(CeTb_16th1_u, CC, 2);

mask = adaptivethreshold(CeTb_16th2_u(:,:,2),20,-0.03);
mask = bwareaopen(mask, 100, 4);
mask = imclearborder(mask);
CC = bwconncomp(mask,4);
I16th2 = beadIntensities(CeTb_16th2_u, CC, 2);

%bead release timelapse
unmixstack = zeros([501 502 3 7]);
for n=1:7
    im = squeeze(MMparse(['Z:\Keck\112211\BeadRelease\Time',sprintf('%d',n),'_1']));
    im = double(im) - camera_offset;
    [u, ~] = unmix(im, testspec);
    unmixstack(:,:,:,n) = u;
end

levels = [1 0.5 0.25 0.125 0.0625 0]';

for n=1:7
    u=unmixstack(:,:,:,n);
    mask = adaptivethreshold(u(:,:,2),20,-0.03);
    mask = bwareaopen(mask, 100, 4);
    %mask = imclearborder(mask);
    CC = bwconncomp(mask,4);
    I = beadIntensities(u, CC, 2);
    T = ICP([I(:,1).medianratio]', {levels});
    evalin('base',['I',sprintf('%d',n),'=[I(:,1).medianratio]*T;']);
    imshow(mask.*T.*u(:,:,1)./u(:,:,2),[-0.2 1.2]);
    colormap('jet');
    [im,~]=frame2im(getframe);
    RGB = repmat(u(:,:,3),[1 1 3]);
    RGB = 2*RGB./max(RGB(:));
    RGB = RGB - min(RGB(:)) - 0.25;
    RGB = max(0,RGB);
    RGB = min(1,RGB);
    RGB = uint8(RGB.*255);
    mask3 = repmat(mask,[1 1 3]);
    RGB(mask3) = im(mask3);
    imwrite(RGB, 'Z:\Keck\112211\BeadRelease\test.tif', 'tif', 'Compression' , 'none', 'WriteMode', 'append');
end

%multiple power levels

[P1, err] = load_and_unmix('Z:\Keck\112211\PowerLevels\Power1_1', camera_offset, testspec);
err
[P2, err] = load_and_unmix('Z:\Keck\112211\PowerLevels\Power2_1', camera_offset, testspec);
err
[P3, err] = load_and_unmix('Z:\Keck\112211\PowerLevels\Power3_1', camera_offset, testspec);
err
[P4, err] = load_and_unmix('Z:\Keck\112211\PowerLevels\Power4_1', camera_offset, testspec);
err
[P5, err] = load_and_unmix('Z:\Keck\112211\PowerLevels\Power5_1', camera_offset, testspec);
err
[P6, err] = load_and_unmix('Z:\Keck\112211\PowerLevels\Power6_2', camera_offset, testspec);

