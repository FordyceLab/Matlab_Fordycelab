% Analysis of Acrylamide beads
%%
probe_radius = 20;

if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');

dark_1s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_1s_1')));
newdark2_1s = mean(double(dark_1s),3);
clear dark_1s


M1109_2_292_2 = squeeze(MMparse(fullfile(imgFolder, '20121112', 'Beads20121109-02 Ex292_2')));
M1109_2_292_2 = double(M1109_2_292_2) - repmat(newdark2_1s, [1 1 10]);
Acryl_292_2 = M1109_2_292_2(:,:,2:end); %drop brightfield
Acryl_292_2 = bkgd_subtract(Acryl_292_2, 'estimate', probe_radius);
Acryl_292_2 = bkgd_subtract(Acryl_292_2, 'median');

M1109_2_320_2 = squeeze(MMparse(fullfile(imgFolder, '20121112', 'Beads20121109-02 Ex320_2')));
M1109_2_320_2 = double(M1109_2_320_2) - repmat(newdark2_1s, [1 1 10]);
Acryl_320_2 = M1109_2_320_2(:,:,2:end); %drop brightfield
Acryl_320_2 = bkgd_subtract(Acryl_320_2, 'estimate', probe_radius);
Acryl_320_2 = bkgd_subtract(Acryl_320_2, 'median');

mask = gen_bead_mask2(Acryl_292_2(:,:,2),18,-0.02);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-198)^2+(jj-250)^2) > 200
            mask(ii,jj) = 0;
        end
    end
end
% remove dust
mask(15:100,325:420) = 0;
mask(190:220,140:165) = 0;
mask(397:417,223:244) = 0;
mask(230:245,200:237) = 0;
mask(145:164,404:420) = 0;

% mask = mask & Acryl_1(:,:,7)>200;

figure
imshow(mask)

for n=1:size(Acryl_292_2,3)
    slice = Acryl_292_2(:,:,n);
    Acryl_292_2_spec(n) = mean(slice(mask));
end

for n=1:size(Acryl_320_2,3)
    slice = Acryl_320_2(:,:,n);
    Acryl_320_2_spec(n) = mean(slice(mask));
end

specPlotHandle = figure;
subplot(1,2,1)
hold on
% plot([1:1:9], Acryl_292_2_spec, 'color', 'b');
subplot(1,2,2)
hold on
% plot([1:1:9], Acryl_320_2_spec, 'color', 'b');



M1109_2_292_3 = squeeze(MMparse(fullfile(imgFolder, '20121112', 'Beads20121109-02 Ex292_3')));
M1109_2_292_3 = double(M1109_2_292_3) - repmat(newdark2_1s, [1 1 10]);
Acryl_292_3 = M1109_2_292_3(:,:,2:end); %drop brightfield
Acryl_292_3 = bkgd_subtract(Acryl_292_3, 'estimate', probe_radius);
Acryl_292_3 = bkgd_subtract(Acryl_292_3, 'median');

M1109_2_320_3 = squeeze(MMparse(fullfile(imgFolder, '20121112', 'Beads20121109-02 Ex320_3')));
M1109_2_320_3 = double(M1109_2_320_3) - repmat(newdark2_1s, [1 1 10]);
Acryl_320_3 = M1109_2_320_3(:,:,2:end); %drop brightfield
Acryl_320_3 = bkgd_subtract(Acryl_320_3, 'estimate', probe_radius);
Acryl_320_3 = bkgd_subtract(Acryl_320_3, 'median');

mask = gen_bead_mask2(Acryl_292_3(:,:,2),18,-0.02);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-198)^2+(jj-250)^2) > 200
            mask(ii,jj) = 0;
        end
    end
end
mask(262:277,223:238) = 0;



for n=1:size(Acryl_292_3,3)
    slice = Acryl_292_3(:,:,n);
    Acryl_292_3_spec(n) = mean(slice(mask));
end

for n=1:size(Acryl_320_3,3)
    slice = Acryl_320_3(:,:,n);
    Acryl_320_3_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
subplot(1,2,1)
plot([1:1:9], Acryl_292_3_spec, 'color', 'r');
axis([1 9 0 3000])
subplot(1,2,2)
plot([1:1:9], Acryl_320_3_spec, 'color', 'r');
axis([1 9 0 3000])

%%
figure
plot([1:1:9], Acryl_292_3_spec, 'color', 'b');
hold on
plot([1:1:9], Acryl_320_3_spec, 'color', 'r');
title('Spectra of Acrylamide beads under Ex292 and Ex320','fontsize', 16, 'FontWeight','bold')