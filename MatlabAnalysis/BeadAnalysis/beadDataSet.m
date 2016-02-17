classdef beadDataSet < abstractBeadDataSet
    %The beadDataSet object stores information about individual sets of
    %spectrally encoded beads,
    %   for instance intensities in a number of channels, bead centroids,
    %   and information about the images they are derived from.  A
    %   beadDataSet object can also contain handles to other beadDataSet
    %   objects so that individual beadDataSet objects can be aggregated
    %   into larger objects.
    %
    %   beadDataSet objects are constructed by analysing an existing
    %   unmixed image stack with a supplied
    %   mask and extracting the beads and their values
    %
    %   The calling format is
    %   aBeadDataSet = beadDataSet('newimage', unmixed_image_stack, maskCC, ...
    %   internal_standard), where maskCC is the connected component from
    %   bwconncomp of the mask, and internal standard is the index of the
    %   image plane to use as the internal standard.
    
    properties (SetAccess = protected)
        Centroid         %NumBeads x 2 array of the bead centroid (X,Y)
    end
    
    properties (Dependent = true, SetAccess = protected)
        NumChannels
    end
    
    properties (Dependent = true, SetAccess = private)
        NumBeads
    end
    
    
    methods
        %Constructor
        function newbeadDataSet = beadDataSet(buildmethod, varargin)
            switch buildmethod
                case 'oldimage'  %new data set that directly stores bead values
                    if nargin < 4
                        error ('You must specify a source image, mask, and internal standard');
                    end
                    image = varargin{1};
                    CC = varargin{2};
                    internalStandard = varargin{3};
                    %convert image to floating point if necessary
                    if ~isa(image, 'float');
                        image = double(image);
                    end
                    stdPixels = regionprops(CC, image(:,:,internalStandard), 'PixelValues','WeightedCentroid');
                    
                    %preallocate arrays
                    nbeads = numel(stdPixels);
                    nchannels = size(image,3);
                    newbeadDataSet.Intensity = zeros([nbeads, nchannels]);
                    newbeadDataSet.IntensityStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Ratio = zeros([nbeads, nchannels]);
                    newbeadDataSet.RatioStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Centroid = zeros([nbeads, 2]);
                    
                    for c = 1:nchannels
                        c_pixels = regionprops(CC, image(:,:,c), 'PixelValues', 'PixelIdxList');
                        for b=1:nbeads
                            newbeadDataSet.Centroid(b,:) = stdPixels(b).WeightedCentroid;
                            newbeadDataSet.Intensity(b,c) = median(c_pixels(b).PixelValues);
                            newbeadDataSet.IntensityStdDev(b,c) = std(c_pixels(b).PixelValues);
                            newbeadDataSet.Ratio(b,c) = median(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                            newbeadDataSet.RatioStdDev(b,c) = std(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                        end
                    end
                    
                    %hardcoded for backwards compatibility
                    newbeadDataSet.Channels = [lanthanideChannels.Dy, lanthanideChannels.Eu, lanthanideChannels.Sm, lanthanideChannels.Device];
                    newbeadDataSet.InternalStandard = lanthanideChannels.Eu;
                    
                case 'oldimage_5Ln'  %new data set that directly stores bead values
                    if nargin < 4
                        error ('You must specify a source image, mask, and internal standard');
                    end
                    image = varargin{1};
                    CC = varargin{2};
                    internalStandard = varargin{3};
                    %convert image to floating point if necessary
                    if ~isa(image, 'float');
                        image = double(image);
                    end
                    stdPixels = regionprops(CC, image(:,:,internalStandard), 'PixelValues','WeightedCentroid');
                    
                    %preallocate arrays
                    nbeads = numel(stdPixels);
                    nchannels = size(image,3);
                    newbeadDataSet.Intensity = zeros([nbeads, nchannels]);
                    newbeadDataSet.IntensityStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Ratio = zeros([nbeads, nchannels]);
                    newbeadDataSet.RatioStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Centroid = zeros([nbeads, 2]);
                    
                    for c = 1:nchannels
                        c_pixels = regionprops(CC, image(:,:,c), 'PixelValues', 'PixelIdxList');
                        for b=1:nbeads
                            newbeadDataSet.Centroid(b,:) = stdPixels(b).WeightedCentroid;
                            newbeadDataSet.Intensity(b,c) = median(c_pixels(b).PixelValues);
                            newbeadDataSet.IntensityStdDev(b,c) = std(c_pixels(b).PixelValues);
                            newbeadDataSet.Ratio(b,c) = median(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                            newbeadDataSet.RatioStdDev(b,c) = std(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                        end
                    end
                    
                    %hardcoded for backwards compatibility
                    newbeadDataSet.Channels = [lanthanideChannels.CeTb, lanthanideChannels.Dy, lanthanideChannels.Eu, lanthanideChannels.Sm, lanthanideChannels.Tm, lanthanideChannels.Device];
                    newbeadDataSet.InternalStandard = lanthanideChannels.Eu;
                    
                case 'oldimage_4Ln'  %new data set that directly stores bead values
                    if nargin < 4
                        error ('You must specify a source image, mask, and internal standard');
                    end
                    image = varargin{1};
                    CC = varargin{2};
                    internalStandard = varargin{3};
                    %convert image to floating point if necessary
                    if ~isa(image, 'float');
                        image = double(image);
                    end
                    stdPixels = regionprops(CC, image(:,:,internalStandard), 'PixelValues','WeightedCentroid');
                    
                    %preallocate arrays
                    nbeads = numel(stdPixels);
                    nchannels = size(image,3);
                    newbeadDataSet.Intensity = zeros([nbeads, nchannels]);
                    newbeadDataSet.IntensityStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Ratio = zeros([nbeads, nchannels]);
                    newbeadDataSet.RatioStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Centroid = zeros([nbeads, 2]);
                    
                    for c = 1:nchannels
                        c_pixels = regionprops(CC, image(:,:,c), 'PixelValues', 'PixelIdxList');
                        for b=1:nbeads
                            newbeadDataSet.Centroid(b,:) = stdPixels(b).WeightedCentroid;
                            newbeadDataSet.Intensity(b,c) = median(c_pixels(b).PixelValues);
                            newbeadDataSet.IntensityStdDev(b,c) = std(c_pixels(b).PixelValues);
                            newbeadDataSet.Ratio(b,c) = median(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                            newbeadDataSet.RatioStdDev(b,c) = std(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                        end
                    end
                    
                    %hardcoded for backwards compatibility
                    newbeadDataSet.Channels = [lanthanideChannels.Dy, lanthanideChannels.Eu, lanthanideChannels.Sm, lanthanideChannels.Tm, lanthanideChannels.Device];
                    newbeadDataSet.InternalStandard = lanthanideChannels.Eu;
                    
                case 'newimage'   %for object-based images
                    if nargin < 4
                        error ('You must specify a source image, mask, and internal standard');
                    end
                    image = varargin{1};
                    CC = varargin{2};
                    internalStandard = varargin{3};
                    newbeadDataSet.InternalStandard = internalStandard;
                    
                    stdImage = image.getChannel(internalStandard);
                    stdPixels = regionprops(CC, stdImage, 'PixelValues','WeightedCentroid');    
                    
                    %preallocate arrays
                    nbeads = numel(stdPixels);
                    newbeadDataSet.Channels = image.channels;
                    nchannels = numel(image.channels);                    
                    newbeadDataSet.Intensity = zeros([nbeads, nchannels]);
                    newbeadDataSet.IntensityStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Ratio = zeros([nbeads, nchannels]);
                    newbeadDataSet.RatioStdDev = zeros([nbeads, nchannels]);
                    newbeadDataSet.Centroid = zeros([nbeads, 2]);
                    
                    for c = 1:nchannels
                        channelImage = image.getChannel(newbeadDataSet.Channels(c));
                        c_pixels = regionprops(CC, channelImage, 'PixelValues', 'PixelIdxList');
                        for b=1:nbeads
                            newbeadDataSet.Centroid(b,:) = stdPixels(b).WeightedCentroid;
                            newbeadDataSet.Intensity(b,c) = median(c_pixels(b).PixelValues);
                            newbeadDataSet.IntensityStdDev(b,c) = std(c_pixels(b).PixelValues);
                            newbeadDataSet.Ratio(b,c) = median(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                            newbeadDataSet.RatioStdDev(b,c) = std(c_pixels(b).PixelValues./stdPixels(b).PixelValues);
                        end
                    end
                    
                otherwise
                    error(['Unrecognized construction method: ', buildmethod]);
            end
        end
        
        %Add data for a protein bound to the beads
        %extracts a ring around the bead
        function addBindingData(obj, image, channel, beadRadius)
            circleWidth = 6; %in squared pixels
            if ~isempty(find(obj.Channels == channel))
                error('Requested channel already exists');
            else
                cidx = obj.NumChannels+1;
                obj.Channels(cidx) = channel;
            end
            coords = obj.Centroid;
            [X,Y] = meshgrid(1:size(image,2), 1:size(image,1));
            for b = 1:size(coords,1)
                %circle1 = (X - coords(b,1)).^2 + (Y - coords(b,2)).^2 <= beadRadius^2;
                %alternate
                circle1 = abs((X - coords(b,1)).^2 + (Y - coords(b,2)).^2 - beadRadius^2) <= circleWidth;
                temp = sort(image(circle1), 'descend');
%                         RGB=zeros([size(circle1) 3]);
%                         RGB(:,:,1) = circle1/2;
%                         imshow(RGB);
%                         pause
                obj.Intensity(b,cidx) = median(temp);
                obj.IntensityStdDev(b,cidx) = std(temp);
            end
        end
        
        %accesing values
        function intensities = getIntensity(obj, bidx, channellist)
            cidx = obj.getChannelIndex(channellist);
            intensities = obj.Intensity(bidx(:), cidx(:));
        end
        
        function intensitiesSD = getIntensityStdDev(obj, bidx, channellist)
            cidx = obj.getChannelIndex(channellist);
            intensitiesSD = obj.IntensityStdDev(bidx(:), cidx(:));
        end
        
        function ratios = getRatio(obj, bidx, channellist)
            cidx = obj.getChannelIndex(channellist);
            ratios = obj.Ratio(bidx(:), cidx(:));
        end
        
        function ratiosSD = getRatioStdDev(obj, bidx, channellist)
            cidx = obj.getChannelIndex(channellist);
            ratiosSD = obj.RatioStdDev(bidx(:), cidx(:));
        end
        
        function ratios = getCodeRatio(obj, bidx, varargin) %get ratios for channels that make up code space
            cidx = obj.getChannelIndex(obj.CodingChannels);
            ratios = obj.Ratio(bidx(:), cidx(:));
            if nargin > 2
                channel = varargin{1};
                if channel ~= ':' %allow use of : to return all channels
                    cidx = find(obj.CodingChannels == channel);
                    if ~isempty(cidx)
                        ratios = ratios(:,cidx);
                    else
                        error('Requested channel is not one of the coding channels');
                    end
                end
            end
        end
        
        function ratiosSD = getCodeRatioStdDev(obj, bidx, varargin) %get ratios for channels that make up code space
            cidx = obj.getChannelIndex(obj.CodingChannels);
            ratiosSD = obj.RatioStdDev(bidx(:), cidx(:));
            if nargin > 2
                channel = varargin{1};
                if channel ~= ':' %allow use of : to return all channels
                    cidx = find(obj.CodingChannels == channel);
                    if ~isempty(cidx)
                        ratiosSD = ratiosSD(:,cidx);
                    else
                        error('Requested channel is not one of the coding channels');
                    end
                end
            end
        end
        
        function ratios = getTransformedCodeRatio(obj, bidx, varargin) %get code ratios * transform
            if isempty(obj.Transform)
                error('Attempted to get Transformed Ratios without first setting Transform');
            end
            
            cidx = obj.getChannelIndex(obj.CodingChannels);
            ratios = obj.Transform.apply(obj.Ratio(bidx(:), cidx(:)));
            if nargin > 2
                channel = varargin{1};
                if channel ~= ':' %allow use of : to return all channels
                    cidx = find(obj.CodingChannels == channel);
                    if ~isempty(cidx)
                        ratios = ratios(:,cidx);
                    else
                        error('Requested channel is not of of the coding channels');
                    end
                end
            end
        end
        
        %Dependent properties
        function nchan = get.NumChannels(obj)
            nchan = numel(obj.Channels);
        end
        
        function nbead = get.NumBeads(obj)
            nbead = size(obj.Intensity, 1);
        end
    end
end


