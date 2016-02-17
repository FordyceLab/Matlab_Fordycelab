function [ out_accumulator ] = Bead_accumulate( in_accumulator, intensity_struct )
%Bead_accumulate - Glue function to handle accumulating up bead
%intensities, ratios, centroids into a single array struct
%   Detailed explanation goes here


if isempty(in_accumulator)
    out_accumulator.DyEu = [intensity_struct(:,1).medianratio];
    out_accumulator.SmEu = [intensity_struct(:,3).medianratio];
    out_accumulator.Dy = [intensity_struct(:,1).median];
    out_accumulator.Eu = [intensity_struct(:,2).median];
    out_accumulator.Sm = [intensity_struct(:,3).median];
    temp = [intensity_struct(:,2).centroid]; %returns as interleaved X,Y pairs
    out_accumulator.centroid(1,:) = temp(1:2:end); %deinterleave X
    out_accumulator.centroid(2,:) = temp(2:2:end); %Y
else
    
    out_accumulator.DyEu = [in_accumulator.DyEu, [intensity_struct(:,1).medianratio]];
    out_accumulator.SmEu = [in_accumulator.SmEu, [intensity_struct(:,3).medianratio]];
    out_accumulator.Dy = [in_accumulator.Dy, [intensity_struct(:,1).median]];
    out_accumulator.Eu = [in_accumulator.Dy, [intensity_struct(:,2).median]];
    out_accumulator.Sm = [in_accumulator.Dy, [intensity_struct(:,3).median]];
    temp = [intensity_struct(:,2).centroid]; %returns as interleaved X,Y pairs
    out_accumulator.centroid(1,:) = [in_accumulator.centroid(1,:), temp(1:2:end)]; %deinterleave X
    out_accumulator.centroid(2,:) = [in_accumulator.centroid(2,:),temp(2:2:end)]; %Y
end

end