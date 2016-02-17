function [ registered_descriptor ] = register_descriptor ( descriptor, TFORM )
%register_descriptor - applies a transformation matrix to a descriptor
%   Applies a transformation matrix to a serpentine descriptor to bring it
%   into the image coordinate system.

registered_descriptor = descriptor;
for n=1:size(descriptor)
    switch descriptor(n).type
        case 'arc'
            registered_descriptor(n).center = tformfwd(TFORM, ...
                registered_descriptor(n).center(:,1), registered_descriptor(n).center(:,2));
        case 'line'
            registered_descriptor(n).start = tformfwd(TFORM, ...
                registered_descriptor(n).start(:,1), registered_descriptor(n).start(:,2));
            registered_descriptor(n).stop = tformfwd(TFORM, ...
                registered_descriptor(n).stop(:,1), registered_descriptor(n).stop(:,2));
    end
end