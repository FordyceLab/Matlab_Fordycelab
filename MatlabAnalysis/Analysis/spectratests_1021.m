Empty = double(squeeze(MMparse('Z:\Keck\101711\EmptyDevice\270nm_10_10_10_1_1_1')));
Empty = Empty - camera_offset;
[yi,xi,P] = impixel(Empty(:,:,1)./max(max(Empty(:,:,1))));
hold off
for n=1:size(xi,1)
    for c = 1:5
        pix = Empty(xi(n)-5:xi(n)+5,yi(n)-5:yi(n)+5,c);
        spec(c) = mean(pix(:));
    end
    plot(spec)
    hold on
end

Empty2 = double(squeeze(MMparse('Z:\Keck\101811\COP_device290_10s_1')));
Empty2 = Empty2 - camera_offset;
[yi,xi,P] = impixel(Empty2(:,:,1)./max(max(Empty2(:,:,1))));
hold off
for n=1:size(xi,1)
    for c = 1:5
        pix = Empty2(xi(n)-5:xi(n)+5,yi(n)-5:yi(n)+5,c);
        spec2(n,c) = mean(pix(:));
    end
end

Empty_5 = double(squeeze(MMparse('Z:\Keck\101711\EmptyDevice\270nm_5_5_5_1_1_1')));
Empty_5 = Empty_5 - camera_offset;
[Background_spec,S,L] = princomp(reshape(Empty_5, [size(Empty_5,1)*size(Empty_5,2) size(Empty_5,3)]));

refLnbkgd_1 = [refLn290_5; Background_spec(:,1)'];
refLnbkgd_2 = [refLnbkgd_1; Background_spec(:,2)'];

[RGmix290_5_unmix1,RGmix290_5_err1] = unmix(RGmix_290_5, refLnbkgd_1);
[RGmix290_5_unmix2,RGmix290_5_err2] = unmix(RGmix_290_5, refLnbkgd_2);

blank = double(squeeze(MMparse('Z:\Keck\101811\Collimated2_290_1')));
blank = blank - camera_offset;
[B,S,L] = princomp(reshape(blank, [size(blank,1)*size(blank,2) size(blank,3)]));