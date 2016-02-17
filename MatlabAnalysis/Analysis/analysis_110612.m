% Analysis of Acrylamide beads
%% Em292
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


M1105_3_1 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex292_1')));
M1105_3_1 = double(M1105_3_1) - repmat(newdark2_1s, [1 1 10]);
Eu_1 = M1105_3_1(:,:,2:end); %drop brightfield
Eu_1 = bkgd_subtract(Eu_1, 'estimate', probe_radius);
Eu_1 = bkgd_subtract(Eu_1, 'median');

mask = gen_bead_mask2(Eu_1(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Eu_1(:,:,7)>200;

figure
imshow(mask)

for n=1:size(Eu_1,3)
    slice = Eu_1(:,:,n);
    Eu_1_spec(n) = mean(slice(mask));
end

specPlotHandle = figure;
hold on
plot([1:1:9], Eu_1_spec./max(Eu_1_spec), 'color', 'b');


M1105_3_2 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex292_2')));
M1105_3_2 = double(M1105_3_2) - repmat(newdark2_1s, [1 1 10]);
Eu_2 = M1105_3_2(:,:,2:end); %drop brightfield
Eu_2 = bkgd_subtract(Eu_2, 'estimate', probe_radius);
Eu_2 = bkgd_subtract(Eu_2, 'median');

mask = gen_bead_mask2(Eu_2(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Eu_2(:,:,7)>200;


for n=1:size(Eu_2,3)
    slice = Eu_2(:,:,n);
    Eu_2_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_2_spec./max(Eu_2_spec), 'color', 'r');


M1105_3_3 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex292_3')));
M1105_3_3 = double(M1105_3_3) - repmat(newdark2_1s, [1 1 10]);
Eu_3 = M1105_3_3(:,:,2:end); %drop brightfield
Eu_3 = bkgd_subtract(Eu_3, 'estimate', probe_radius);
Eu_3 = bkgd_subtract(Eu_3, 'median');

mask = gen_bead_mask2(Eu_3(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Eu_3(:,:,7)>200;


for n=1:size(Eu_3,3)
    slice = Eu_3(:,:,n);
    Eu_3_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_3_spec./max(Eu_3_spec), 'color', 'c');


M1105_3_4 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex292_4')));
M1105_3_4 = double(M1105_3_4) - repmat(newdark2_1s, [1 1 10]);
Eu_4 = M1105_3_4(:,:,2:end); %drop brightfield
Eu_4 = bkgd_subtract(Eu_4, 'estimate', probe_radius);
Eu_4 = bkgd_subtract(Eu_4, 'median');

mask = gen_bead_mask2(Eu_4(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
mask = mask & Eu_4(:,:,7)>200;


for n=1:size(Eu_4,3)
    slice = Eu_4(:,:,n);
    Eu_4_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_4_spec./max(Eu_4_spec), 'color', 'g');

acrylamideEu_spec_292 ={Eu_1_spec;Eu_2_spec;Eu_3_spec;Eu_4_spec};

%% Em320
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


M1105_3_1 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex320_1')));
M1105_3_1 = double(M1105_3_1) - repmat(newdark2_1s, [1 1 10]);
Eu_1 = M1105_3_1(:,:,2:end); %drop brightfield
Eu_1 = bkgd_subtract(Eu_1, 'estimate', probe_radius);
Eu_1 = bkgd_subtract(Eu_1, 'median');

mask = gen_bead_mask2(Eu_1(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
for ii=284:323
    for jj = 176:202
        mask(jj,ii) = 0;
    end
end
mask = mask & Eu_1(:,:,7)>200;

figure
imshow(mask)

for n=1:size(Eu_1,3)
    slice = Eu_1(:,:,n);
    Eu_1_spec(n) = mean(slice(mask));
end

specPlotHandle = figure;
hold on
plot([1:1:9], Eu_1_spec./max(Eu_1_spec), 'color', 'b');


M1105_3_2 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex320_2')));
M1105_3_2 = double(M1105_3_2) - repmat(newdark2_1s, [1 1 10]);
Eu_2 = M1105_3_2(:,:,2:end); %drop brightfield
Eu_2 = bkgd_subtract(Eu_2, 'estimate', probe_radius);
Eu_2 = bkgd_subtract(Eu_2, 'median');

mask = gen_bead_mask2(Eu_2(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
for ii=284:323
    for jj = 176:202
        mask(jj,ii) = 0;
    end
end
mask = mask & Eu_2(:,:,7)>200;


for n=1:size(Eu_2,3)
    slice = Eu_2(:,:,n);
    Eu_2_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_2_spec./max(Eu_2_spec), 'color', 'r');


M1105_3_3 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex320_3')));
M1105_3_3 = double(M1105_3_3) - repmat(newdark2_1s, [1 1 10]);
Eu_3 = M1105_3_3(:,:,2:end); %drop brightfield
Eu_3 = bkgd_subtract(Eu_3, 'estimate', probe_radius);
Eu_3 = bkgd_subtract(Eu_3, 'median');

mask = gen_bead_mask2(Eu_3(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
for ii=284:323
    for jj = 176:202
        mask(jj,ii) = 0;
    end
end
mask = mask & Eu_3(:,:,7)>200;


for n=1:size(Eu_3,3)
    slice = Eu_3(:,:,n);
    Eu_3_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_3_spec./max(Eu_3_spec), 'color', 'c');


M1105_3_4 = squeeze(MMparse(fullfile(imgFolder, '20121106', 'Beads20121105-03 Ex320_4')));
M1105_3_4 = double(M1105_3_4) - repmat(newdark2_1s, [1 1 10]);
Eu_4 = M1105_3_4(:,:,2:end); %drop brightfield
Eu_4 = bkgd_subtract(Eu_4, 'estimate', probe_radius);
Eu_4 = bkgd_subtract(Eu_4, 'median');

mask = gen_bead_mask2(Eu_4(:,:,7),7,-0.03);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end
for ii=284:323
    for jj = 176:202
        mask(jj,ii) = 0;
    end
end
mask = mask & Eu_4(:,:,7)>200;


for n=1:size(Eu_4,3)
    slice = Eu_4(:,:,n);
    Eu_4_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
plot([1:1:9], Eu_4_spec./max(Eu_4_spec), 'color', 'g');

acrylamideEu_spec_320 ={Eu_1_spec;Eu_2_spec;Eu_3_spec;Eu_4_spec};

