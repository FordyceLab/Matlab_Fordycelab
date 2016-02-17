%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');
%% Analysis of 320nm excitation

probe_radius = 20;

dark_1s = squeeze(MMparse(fullfile(rootFolder,'NewImages', '20121107', 'dark_1s_1')));
newdark2_1s = mean(double(dark_1s),3);
clear dark_1s

%%
M1107_1_LAP = squeeze(MMparse(fullfile(imgFolder, '20121107', 'Beads20121107-01 Lap_2')));
M1107_1_LAP = double(M1107_1_LAP) - repmat(newdark2_1s, [1 1 10]);
Eu = M1107_1_LAP(:,:,2:end); %drop brightfield
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

mask = gen_bead_mask2(Eu(:,:,7),7,-0.01);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end

mask = mask & Eu(:,:,7)>500;

for n=1:size(Eu,3)
    slice = Eu(:,:,n);
    Eu_spec(n) = mean(slice(mask));
end

specPlotHandle = figure;
hold on
plot([1:1:9], Eu_spec, 'color', 'b');



%%
M1107_1_noLAP = squeeze(MMparse(fullfile(imgFolder, '20121107', 'Beads20121107-01 noLap_2')));
M1107_1_noLAP = double(M1107_1_noLAP) - repmat(newdark2_1s, [1 1 10]);
Eu = M1107_1_noLAP(:,:,2:end); %drop brightfield
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

mask = gen_bead_mask2(Eu(:,:,7),7,-0.01);

for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        if sqrt((ii-size(mask,1)/2)^2+(jj-size(mask,2)/2)^2) > 230
            mask(ii,jj) = 0;
        end
    end
end

mask = mask & Eu(:,:,7)>500;


for n=1:size(Eu,3)
    slice = Eu(:,:,n);
    Eu_spec(n) = mean(slice(mask));
end

figure(specPlotHandle)
hold on
plot([1:1:9], Eu_spec, 'color', 'r');