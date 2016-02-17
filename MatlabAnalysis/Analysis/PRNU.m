clear off m s
off=300:5:500
for n=1:numel(off)
    ratio = (paper(:,:,5) - off(n))./(paper(:,:,6)-off(n));
    m(n) = mean(ratio(~isnan(ratio) & ~isinf(ratio)));
    s(n) = std(ratio(~isnan(ratio)& ~isinf(ratio)));
end

off = 439;
for n=2:6
    ratio=(empty_camera45(:,:,n-1) - off)./(empty_camera45(:,:,n) - off);
    r=mean(ratio(:));
    figure(n+4)
    imshow(ratio, [0.9*r 1.1*r]);
    colormap('jet'); colorbar
end

for n=1:6
    q=empty(:,:,n) - off;
    std(q(:))./mean(q(:))
end

%camera 0deg
camera0 = squeeze(MMparse('C:\Users\keck\Desktop\temp\empty_6'));
camera0 = double(camera0) - off;
camera90 = squeeze(MMparse('C:\Users\keck\Desktop\temp\empty_7'));
camera90 = double(camera90) - off;

for n=2:6
    ratio=(camera0(:,:,n-1))./(camera0(:,:,n));
    r=mean(ratio(:));
    figure(n-1)
    subplot(1,2,1)
    imshow(ratio, [0.9*r 1.1*r]);
    colormap('jet'); colorbar

    
    ratio=(camera90(:,:,n-1))./(camera90(:,:,n));
    r=mean(ratio(:));
        subplot(1,2,2)
    imshow(ratio, [0.9*r 1.1*r]);
    colormap('jet'); colorbar
end