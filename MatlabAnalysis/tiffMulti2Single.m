%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');
%%
fullImageFolder = fullfile(imgFolder, '20121107', 'Beads20121107-01 Lap_4');

fileName = dir(fullfile(fullImageFolder, 'Multi'));

cd(fullfile(fullImageFolder, 'Multi'));

fileInfo = imfinfo(fileName(3).name);

num_images = numel(fileInfo);

%%
for ii=1:num_images
    stack(:,:,ii) = imread(fileName(3).name,ii);
end
%%
imagesNamesEx292 = {'img_000000000_BF_000.tif', ...
    'img_000000000_Ex292-Em435_000.tif', ...
    'img_000000000_Ex292-Em474_000.tif', ...
    'img_000000000_Ex292-Em527_000.tif', ...
    'img_000000000_Ex292-Em536_000.tif', ...
    'img_000000000_Ex292-Em546_000.tif', ...
    'img_000000000_Ex292-Em572_000.tif', ...
    'img_000000000_Ex292-Em620_000.tif', ...
    'img_000000000_Ex292-Em630_000.tif', ...
    'img_000000000_Ex292-Em650_000.tif'};
%%
imagesNamesEx320 = {'img_000000000_BF_000.tif', ...
    'img_000000000_Ex320-Em435_000.tif', ...
    'img_000000000_Ex320-Em474_000.tif', ...
    'img_000000000_Ex320-Em527_000.tif', ...
    'img_000000000_Ex320-Em536_000.tif', ...
    'img_000000000_Ex320-Em546_000.tif', ...
    'img_000000000_Ex320-Em572_000.tif', ...
    'img_000000000_Ex320-Em620_000.tif', ...
    'img_000000000_Ex320-Em630_000.tif', ...
    'img_000000000_Ex320-Em650_000.tif'};
%%
cd(fullImageFolder);

for ii=1:size(stack,3)
    imwrite(stack(:,:,ii),imagesNamesEx292{ii},'tiff');
end

clear all
clc