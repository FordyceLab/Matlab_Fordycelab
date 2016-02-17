classdef abstractBeadDataSet < handle
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
        Channels         %list of channels recorded for these beads
        
        InternalStandard %Which Channel is internal standard
        
    end
    
    properties (Access = protected)
        Intensity        %NumBeads x NumChannels array of median intensities
        IntensityStdDev  %As above but standard deviation of intensities
        %for each bead in each channel
        
        Ratio           %NumBeads x NumChannels array of measured ratios for
                        %each bead in each channel, relative to internal
                        %standard
        RatioStdDev
    end
    
    properties %end-user readable & writeable
        
        Transform %transformation object that will register beads onto programmed code space        
        
        CodingChannels %which channels are registered into the coding space
        
    end
    
    properties (Abstract = true, SetAccess = protected)
        Centroid         %NumBeads x 2 array of the bead centroid (X,Y)
    end
    
    properties (Abstract = true, Dependent = true, SetAccess = protected)
        NumChannels
    end
    
    properties (Abstract = true, Dependent = true, SetAccess = private)
        NumBeads
    end
    
    
    methods (Abstract)
        %accesing values
        intensities = getIntensity(obj, bidx)
        
        ratios = getRatio(obj, bidx, channellist)        
        
        ratios = getCodeRatio(obj, bidx, varargin) %get ratios for channels that make up code space
        
        ratios = getTransformedCodeRatio(obj, bidx, varargin) %get code ratios * transform
        
    end
    
    %utility functions
    methods (Access = protected)
        function cidx = getChannelIndex(obj, channellist)
            %figure out which array indices correspond to channels
            cidx = zeros([1 numel(channellist)]);
            for n=1:numel(channellist)
                cidx(n) = find(channellist(n) == obj.Channels);
            end
        end
    end
end


