%Generate the mean intensity of each bead in replicate images and the
%standard deviation of that bead across the replicate images.

dark_1s = squeeze(MMparse('Z:\Images\021512\dark_1sec_1'));
mdark_1s = mean(double(dark_1s),3);

dark_5s = squeeze(MMparse('Z:\Images\021512\dark_5sec_1'));
mdark_5s = mean(double(dark_5s),3);

clear dark_1s dark_5s flat_10ms dark_10ms %clear big data stacks

dark_stack = repmat(mdark_5s,[1 1 5]);
dark_stack(:,:,6:7) = repmat(mdark_1s, [1 1 2]);

imstack = squeeze(MMparse('Z:\Images\021512\24Codes_010912_Reps_2'));
bead_template = double(imread('Z:\Matlab\BeadAnalysis\target4xbead.tif'));

%imstack is x y t c

[~, mask, CC] = xcorrFindBeads(imstack(:,:,1,1), bead_template, 5);

%loop over channels, calculating mean and SD for each bead
ntime = size(imstack,3);
nchan = size(imstack,4);
beadmean = zeros(CC.NumObjects, nchan-1);
beadstd = beadmean;
beadtime = zeros(CC.NumObjects, ntime);

for c = 2:nchan
    cslice = double(imstack(:,:,:,c));
    cslice = cslice - repmat(dark_stack(:,:,c),[1 1 ntime]);
    for t = 1:ntime
        slice = cslice(:,:,t);
        for b = 1:CC.NumObjects
            beadtime(b,t) = mean(slice(CC.PixelIdxList{b}));
        end
    end
    beadmean(:,c-1) = mean(beadtime,2);
    beadstd(:,c-1) = std(beadtime,[],2);
end

imstack = squeeze(MMparse('Z:\Images\021512\24Codes_013012_Reps_2'));
%imstack is x y t c

[~, mask, CC] = xcorrFindBeads(imstack(:,:,1,1), bead_template, 5);

%loop over channels, calculating mean and SD for each bead
ntime = size(imstack,3);
nchan = size(imstack,4);
beadmean2 = zeros(CC.NumObjects, nchan-1);
beadstd2 = beadmean2;
beadtime = zeros(CC.NumObjects, ntime);

for c = 2:nchan
    cslice = double(imstack(:,:,:,c));
    cslice = cslice - repmat(dark_stack(:,:,c),[1 1 ntime]);
    for t = 1:ntime
        slice = cslice(:,:,t);
        for b = 1:CC.NumObjects
            beadtime(b,t) = mean(slice(CC.PixelIdxList{b}));
        end
    end
    beadmean2(:,c-1) = mean(beadtime,2);
    beadstd2(:,c-1) = std(beadtime,[],2);
end
