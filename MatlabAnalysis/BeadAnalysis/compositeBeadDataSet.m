classdef compositeBeadDataSet < abstractBeadDataSet
    %compositeBeadDataSet implements compositing of multiple beadDataSets
    %together
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        ComponentHandles;
    end
    
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
        function newDataSet = compositeBeadDataSet(handlelist)
            
            handlelist = handlelist(:);
            %loop over handles, checking to make sure they all refer to the
            %same channels so concatenating them is valid
            %newDataSet = newDataSet@beadDataSet('composite');
            %all subsequent structures must use the same channellist as the
            %first
            channellist = handlelist(1).Channels;
            internalstandard = handlelist(1).InternalStandard;
            codingchannellist = handlelist(1).CodingChannels;
            
            if numel(handlelist) > 1
                for n=2:numel(handlelist)
                    newchannellist = handlelist(n).Channels;
                    if numel(channellist) ~= numel(newchannellist)
                        error('Data sets have different numbers of channels')
                    elseif any(newchannellist ~= channellist)
                        error('Data sets have different channels or order of channels in them')
                    elseif (internalstandard ~= handlelist(n).InternalStandard)
                        error('Data sets have different internal standards')
                    elseif (codingchannellist ~= handlelist(n).CodingChannels)
                        error('Data sets have different coding channels')
                    end
                end
            end
            %no errors, so assign handlelist
            newDataSet.ComponentHandles = handlelist(:);
            newDataSet.Channels = channellist;
            newDataSet.InternalStandard = internalstandard;
            newDataSet.CodingChannels = codingchannellist;
        end
        
        %add a new data set
        function add(obj, handlelist)
            handlelist = handlelist(:);            
            
            %test to make sure data sets are the same type
            %should probably move this code to a separate testing function
            for n=1:numel(handlelist)
                newchannellist = handlelist(n).Channels;
                if numel(obj.Channels) ~= numel(newchannellist)
                    error('Data sets have different numbers of channels')
                elseif any(newchannellist ~= obj.Channels)
                    error('Data sets have different channels or order of channels in them')
                elseif (obj.InternalStandard ~= handlelist(n).InternalStandard)
                    error('Data sets have different internal standards')
                elseif (obj.CodingChannels ~= handlelist(n).CodingChannels)
                    error('Data sets have different coding channels')
                end
            end
            %no errors, so assign handlelist
            obj.ComponentHandles = [obj.ComponentHandles, handlelist];          
        end
        
        %accessing properties
        function intensities = getIntensity(obj, bidx, channellist)
            intensities=[];
            if (channellist == ':')
                channellist = obj.Channels;
            end
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    intensities = [intensities; obj.ComponentHandles(n).getIntensity(bidx, channellist)];
                end
                
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    intensities = [intensities; obj.ComponentHandles(n).getIntensity(beads, channellist)];
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function intensitiesSD = getIntensityStdDev(obj, bidx, channellist)
            intensitiesSD=[];
            if (channellist == ':')
                channellist = obj.Channels;
            end
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    intensitiesSD = [intensitiesSD; obj.ComponentHandles(n).getIntensityStdDev(bidx, channellist)];
                end
                
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    intensitiesSD = [intensitiesSD; obj.ComponentHandles(n).getIntensityStdDev(beads, channellist)];
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function ratios = getRatio(obj, bidx, channellist)
            ratios=[];
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    ratios = [ratios; obj.ComponentHandles(n).getRatio(bidx, channellist)];
                end
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    ratios = [ratios; obj.ComponentHandles(n).getRatio(beads, channellist)];
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function ratiosSD = getRatioStdDev(obj, bidx, channellist)
            ratiosSD=[];
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    ratiosSD = [ratiosSD; obj.ComponentHandles(n).getRatioStdDev(bidx, channellist)];
                end
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    ratiosSD = [ratiosSD; obj.ComponentHandles(n).getRatioStdDev(beads, channellist)];
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function ratios = getCodeRatio(obj, bidx, varargin) %get ratios for channels that make up code space
            ratios=[];
            if nargin > 2
                channel = varargin{1};
            end
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    if nargin>2
                        ratios = [ratios; obj.ComponentHandles(n).getCodeRatio(bidx,channel)];
                    else
                        ratios = [ratios; obj.ComponentHandles(n).getCodeRatio(bidx)];
                    end
                end
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    if nargin>2
                        ratios = [ratios; obj.ComponentHandles(n).getCodeRatio(beads,channel)];
                    else
                        ratios = [ratios; obj.ComponentHandles(n).getCodeRatio(beads)];
                    end
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function ratiosSD = getCodeRatioStdDev(obj, bidx, varargin) %get ratios for channels that make up code space
            ratiosSD=[];
            if nargin > 2
                channel = varargin{1};
            end
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    if nargin>2
                        ratiosSD = [ratiosSD; obj.ComponentHandles(n).getCodeRatioStdDev(bidx,channel)];
                    else
                        ratiosSD = [ratiosSD; obj.ComponentHandles(n).getCodeRatioStdDev(bidx)];
                    end
                end
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    if nargin>2
                        ratiosSD = [ratiosSD; obj.ComponentHandles(n).getCodeRatioStdDev(beads,channel)];
                    else
                        ratiosSD = [ratiosSD; obj.ComponentHandles(n).getCodeRatioStdDev(beads)];
                    end
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function ratios = getTransformedCodeRatio(obj, bidx, varargin) %get code ratios * transform
            ratios=[];
            if nargin > 2
                channel = varargin{1};
            end
            if (bidx ==':')
                for n=1:numel(obj.ComponentHandles)
                    if nargin>2
                        ratios = [ratios; obj.ComponentHandles(n).getTransformedCodeRatio(bidx,channel)];
                    else
                        ratios = [ratios; obj.ComponentHandles(n).getTransformedCodeRatio(bidx)];
                    end
                end
            else
                for n=1:numel(obj.ComponentHandles)
                    beads = bidx(bidx>=1 & bidx <= obj.ComponentHandles(n).NumBeads);
                    if nargin>2
                        ratios = [ratios; obj.ComponentHandles(n).getTransformedCodeRatio(beads,channel)];
                    else
                        ratios = [ratios; obj.ComponentHandles(n).getTransformedCodeRatio(beads)];
                    end
                    bidx = bidx - obj.ComponentHandles(n).NumBeads; %offset bidx so that indexes for the n+1st set now start at 1
                end
            end
        end
        
        function nbead = get.NumBeads(obj)
            nbead = 0;
            for n=1:numel(obj.ComponentHandles)
                nbead = nbead + obj.ComponentHandles(n).NumBeads;
            end
        end
        
        function centroids = get.Centroid(obj)
            centroids=[];
            for n=1:numel(obj.ComponentHandles)
                centroids = [centroids; obj.ComponentHandles(n).Centroid];
            end
        end
    end
    
end

