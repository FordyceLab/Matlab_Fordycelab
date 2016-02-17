probe_radius = 20;

dark_1s = squeeze(MMparse('Z:\Images\080312\dark_1s_2'));
newdark2_1s = mean(double(dark_1s),3);
clear dark_1s


M1025_1 = squeeze(MMparse('Z:\NewImages\20121030\Beads20121025-01 Ex292_1'));
M1025_1 = double(M1025_1) - repmat(newdark2_1s, [1 1 10]);
Dy = M1025_1(:,:,2:end); %drop brightfield
Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'median');

mask = gen_bead_mask2(Dy(:,:,6),7,-0.03);
mask = mask & Dy(:,:,6)>500;

for n=1:size(Dy,3)
    slice = Dy(:,:,n);
    Dy_spec(n) = mean(slice(mask));
end


M1026_1 = squeeze(MMparse('Z:\NewImages\20121030\Beads20121026-01 Ex292_1'));
M1026_1 = double(M1026_1) - repmat(newdark2_1s, [1 1 10]);
Sm = M1026_1(:,:,2:end); %drop brightfield
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');

mask = gen_bead_mask2(Sm(:,:,8),7,-0.03);
mask = mask & Sm(:,:,8)>2000;

for n=1:size(Sm,3)
    slice = Sm(:,:,n);
    Sm_spec(n) = mean(slice(mask));
end


M1026_4 = squeeze(MMparse('Z:\NewImages\20121030\Beads20121026-04 Ex292_1'));
M1026_4 = double(M1026_4) - repmat(newdark2_1s, [1 1 10]);
Eu = M1026_4(:,:,2:end); %drop brightfield
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

%remove dust
Eu(125:290,205:325,:) = 0;

mask = gen_bead_mask2(Eu(:,:,7),7,-0.03);
mask = mask & Eu(:,:,7)>800;

for n=1:size(Eu,3)
    slice = Eu(:,:,n);
    Eu_spec(n) = mean(slice(mask));
end

M1029_1 = squeeze(MMparse('Z:\NewImages\20121030\Beads20121029-01 Ex292_1'));
M1029_1 = double(M1029_1) - repmat(newdark2_1s, [1 1 10]);
Tm = M1029_1(:,:,2:end); %drop brightfield
Tm = bkgd_subtract(Tm, 'estimate', probe_radius);
Tm = bkgd_subtract(Tm, 'median');

mask = gen_bead_mask2(Tm(:,:,2),7,-0.03);
mask = mask & Tm(:,:,2)>400;

for n=1:size(Tm,3)
    slice = Tm(:,:,n);
    Tm_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Tm_spec./max(Tm_spec), 'color', 'g');


imgFolder = [filesep() fullfile('','Volumes', 'data', 'NewImages')];

M1029_2 = squeeze(MMparse(fullfile(imgFolder, '20121030', 'Beads20121029-02 Ex292_1')));
M1029_2 = double(M1029_2) - repmat(newdark2_1s, [1 1 10]);
CeTb = M1029_2(:,:,2:end); %drop brightfield
CeTb = bkgd_subtract(CeTb, 'estimate', probe_radius);
CeTb = bkgd_subtract(CeTb, 'median');

mask = gen_bead_mask2(CeTb(:,:,4),6,-0.02);
for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & CeTb(:,:,4)>100;

for n=1:size(CeTb,3)
    slice = CeTb(:,:,n);
    CeTb_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], CeTb_spec./max(CeTb_spec), 'color', 'black');

%% Analysis of 320nm excitation

probe_radius = 20;

imgFolder = [filesep() fullfile('','Volumes', 'data', 'NewImages')];

dark_1s = squeeze(MMparse(['/' fullfile('Volumes','data','Images', '080312', 'dark_1s_2')]));
newdark2_1s = mean(double(dark_1s),3);
clear dark_1s


M1025_1 = squeeze(MMparse(fullfile(imgFolder, '20121030', 'Beads20121025-01 Ex320_1')));
M1025_1 = double(M1025_1) - repmat(newdark2_1s, [1 1 10]);
Dy = M1025_1(:,:,2:end); %drop brightfield
Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'median');

mask = gen_bead_mask2(Dy(:,:,6),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Dy(:,:,6)>500;

figure
imshow(mask)

for n=1:size(Dy,3)
    slice = Dy(:,:,n);
    Dy_spec(n) = mean(slice(mask));
end

specPlotHandle = figure;
hold on
plot([1:1:9], Dy_spec./max(Dy_spec), 'color', 'b');



M1026_1 = squeeze(MMparse(fullfile(imgFolder, '20121030', 'Beads20121026-01 Ex320_1')));
M1026_1 = double(M1026_1) - repmat(newdark2_1s, [1 1 10]);
Sm = M1026_1(:,:,2:end); %drop brightfield
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');

mask = gen_bead_mask2(Sm(:,:,8),7,-0.03);
for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Sm(:,:,8)>2000;

figure
imshow(mask)

for n=1:size(Sm,3)
    slice = Sm(:,:,n);
    Sm_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Sm_spec./max(Sm_spec), 'color', 'r');


M1026_4 = squeeze(MMparse(fullfile(imgFolder, '20121030', 'Beads20121026-04 Ex320_1')));
M1026_4 = double(M1026_4) - repmat(newdark2_1s, [1 1 10]);
Eu = M1026_4(:,:,2:end); %drop brightfield
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

%remove dust
Eu(125:290,205:325,:) = 0;

mask = gen_bead_mask2(Eu(:,:,7),7,-0.03);
for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Eu(:,:,7)>800;

figure
imshow(mask)

for n=1:size(Eu,3)
    slice = Eu(:,:,n);
    Eu_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_spec./max(Eu_spec), 'color', 'c');


% Tm doesn't show on 320nm excitation


