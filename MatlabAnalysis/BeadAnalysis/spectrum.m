classdef spectrum
    %SPECTRUM - class for storing spectra for unmixing
    %data array is nComponents x nChannels
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Component;
        Channel;
        Exposure; %Exposure time for each channel
        Array; %the nComponents x nChannels data array
    end
    
    properties (Dependent = true, SetAccess = protected)
        NumChannels; %number of acquisition channels
        NumComponents;
    end
    
    methods
        function obj = addSpectrum(obj, component, acqdata, mask)            
            channellist = acqdata.Channel;
            exposure = acqdata.Exposure;
            
            spectrum = acqdata.spectrum(mask);
            
            if isempty(obj.Array)
                %this is the first component added
                obj.Array = spectrum;
                obj.Component = component;
                obj.Channel = channellist;
                obj.Exposure = exposure;
                
            else
                %check to see if new component has same channels, etc.
                if any(obj.Component == component)
                    error('Can''t duplicate a component');
                end
                if size(spectrum,2) ~= numel(channellist) || ~all(strcmp(obj.Channel, channellist))
                    error('Channels are not identical to previously stored channels');
                end
                if size(spectrum,2) ~= numel(exposure) || ~all(obj.Exposure == exposure)
                    error('Exposures are not identical to previously stored exposures');
                end
                 
                obj.Array(obj.NumComponents+1,:) = spectrum;
                obj.Component(obj.NumComponents+1) = component;
            end
        end
        
        %Dependent properties
        function nchan = get.NumChannels(obj)
            nchan = numel(obj.Channel);
        end
        
        function ncomp = get.NumComponents(obj)
            ncomp = numel(obj.Component);
        end
        
    end
    
end

