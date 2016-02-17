classdef unmixedImage
    %the unmixedImage stores an unmixed set of images along with their
    %channel assignments
    
    
    properties (SetAccess = protected)
        imageStack; %the stack of images; dimensions x, y, c
        channels; %the corresponding channel labels
    end
    
    methods
        
        function newImage = unmixedImage(images, channels);
            if numel(channels) ~= size(images, 3)
                error('Number of channels does not match number of images')
            end
            if numel(channels) ~= numel(unique(channels))
                error('Duplicate channel entry')
            end
            
            newImage.imageStack = images;
            newImage.channels = channels;
        end
        
        function outImage = getChannel(obj, channelName)
            cidx = find(obj.channels == channelName);
            outImage = obj.imageStack(:,:,cidx);
        end
        
    end
end
