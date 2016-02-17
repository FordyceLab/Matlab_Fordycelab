%reference spectra
%use 2nd set of dark images - they are more comparable to old dark images
%(camera probably wasn't cool enough on first set)
dark_1s = squeeze(MMparse('Z:\Images\080312\dark_1s_2'));
newdark2_1s = mean(double(dark_1s),3);

dark_5s = squeeze(MMparse('Z:\Images\080312\dark_5s_2'));
newdark2_5s = mean(double(dark_5s),3);

dark_10ms = squeeze(MMparse('Z:\Images\080312\dark_10ms_1'));
newdark_10ms = mean(double(dark_10ms),3);

flat_10ms = squeeze(MMparse('Z:\Images\080312\Flat_10ms_1'));
mflat_10ms = squeeze(mean(double(flat_10ms),3)) - repmat(newdark_10ms,[1 1 6]) - 10.5; %our best estimate of bias drift

clear dark_1s dark_5s flat_10ms dark_10ms %clear big data stacks

dark_stack = repmat(newdark2_5s,[1 1 5]);
dark_stack(:,:,6:7) = repmat(newdark2_1s, [1 1 2]);

mnflat = zeros(size(mflat_10ms));
%normalize each channel to mean of 1
for n=1:size(mflat_10ms,3)
    slice = mflat_10ms(:,:,n);
    mnflat(:,:,n) = slice./mean(slice(:));
end

meanim = mean(mnflat,3); %this is the mean intensity image

corrim = zeros(size(mnflat));
for n=1:size(mnflat,3)
    corrim(:,:,n) = meanim./mnflat(:,:,n);
end

%load images and correct for dark and flat fields

B0814_01_1 = squeeze(MMparse('Z:\Images\082212\Beads20120814-01_1'));
B0814_01_1 = double(B0814_01_1) - dark_stack;
temp = B0814_01_1(:,:,2:7).*corrim; %drop brightfield

B0814_01_2 = squeeze(MMparse('Z:\Images\082212\Beads20120814-01_2'));
B0814_01_2 = double(B0814_01_2) - dark_stack;
temp = B0814_01_2(:,:,2:7).*corrim; %drop brightfield
for n=1:6
    slice = temp(50:450,10:100,n);
    bkgd(n) = median(slice(:));
end
mask = gen_bead_mask2(temp(:,:,5),8,-0.03);
for n=1:6
    slice = temp(:,:,n);
    beads(n) = median(slice(mask));
end
B0814_01_spec = beads - bkgd;

B0815_01_2 = squeeze(MMparse('Z:\Images\082212\Beads20120815-01_2'));
B0815_01_2 = double(B0815_01_2) - dark_stack;
temp = B0815_01_2(:,:,2:7).*corrim; %drop brightfield
for n=1:6
    slice = temp(50:450,10:100,n);
    bkgd(n) = median(slice(:));
end
mask = gen_bead_mask2(temp(:,:,5),8,-0.03);
for n=1:6
    slice = temp(:,:,n);
    beads(n) = median(slice(mask));
end
B0815_01_spec = beads - bkgd;


B0815_02_2 = squeeze(MMparse('Z:\Images\082212\Beads20120815-02_1'));
B0815_02_2 = double(B0815_02_2) - dark_stack;
temp = B0815_02_2(:,:,2:7).*corrim; %drop brightfield
for n=1:6
    slice = temp(50:450,10:100,n);
    bkgd(n) = median(slice(:));
end
mask = gen_bead_mask2(temp(:,:,5),8,-0.03);
for n=1:6
    slice = temp(:,:,n);
    beads(n) = median(slice(mask));
end
B0815_02_spec = beads - bkgd;


B0815_03_2 = squeeze(MMparse('Z:\Images\082212\Beads20120815-03_1'));
B0815_03_2 = double(B0815_03_2) - dark_stack;
temp = B0815_03_2(:,:,2:7).*corrim; %drop brightfield
for n=1:6
    slice = temp(50:450,10:100,n);
    bkgd(n) = median(slice(:));
end
mask = gen_bead_mask2(temp(:,:,5),8,-0.03);
for n=1:6
    slice = temp(:,:,n);
    beads(n) = median(slice(mask));
end
B0815_03_spec = beads - bkgd;


B0815_04_2 = squeeze(MMparse('Z:\Images\082212\Beads20120815-04_1'));
B0815_04_2 = double(B0815_04_2) - dark_stack;
temp = B0815_04_2(:,:,2:7).*corrim; %drop brightfield
for n=1:6
    slice = temp(50:450,10:100,n);
    bkgd(n) = median(slice(:));
end
mask = gen_bead_mask2(temp(:,:,5),8,-0.03);
for n=1:6
    slice = temp(:,:,n);
    beads(n) = median(slice(mask));
end
B0815_04_spec = beads - bkgd;