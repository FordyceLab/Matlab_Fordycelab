classdef beadTransform
    % beadTransform stores information about the transformation derived from
    % the ICP registration process.
    %
    % Currently three types of transformations are defined
    % 'scale' - the transformation is just a simple scaling along each axis
    % 'linear' - a linear transformation with scale and offset
    % 'matrix' - a full matrix transformation, allowing rotation,
    % scaling, shearing, etc.
    %
    % Constructor: beadTransform(type, matrix, offset (optional))
    
    properties
        Type    %Type of transformation
        Matrix  %Scaling matrix (diagonal in case of 'scale' and 'linear' types
        Offset  %Offset matrix
    end
    
    methods
        %Constructor
        function newTransform = beadTransform(transformType, varargin)
            newTransform.Type = transformType;
            switch transformType
                case 'scale'
                    if nargin < 2
                        error ('No scaling matrix provided');
                    end
                    newTransform.Matrix = varargin{1};
                    newTransform.Offset = zeros([1 size(newTransform.Matrix,1)]);
           
                case {'linear', 'matrix'}
                    if nargin < 3
                        error ('Not enough parameters: must supply scaling matrix and offset');
                    end
                    newTransform.Matrix = varargin{1};
                    newTransform.Offset = varargin{2};
                    
%                 case 'matrix'                    
%                     if nargin < 2
%                         error ('No scaling matrix provided');
%                     end
%                     newTransform.Matrix = varargin{1};
%                     newTransform.Offset = zeros([1 size(newTransform.Matrix,1)]);
            end
        end
        
        function result = apply(obj, data)
            %apply transform
            nData = size(data,1);
            result = data * obj.Matrix + repmat(obj.Offset, [nData 1]);
        end
        
        function result = applyToTarget(obj, data)
            %inverse transfor - transforms target matrix to register onto
            %beads
            %apply transform
            nData = size(data,1);
            result = data / obj.Matrix - repmat(obj.Offset, [nData 1]);
        end
        
        function delta = difference(obj, transform)
            if ~strcmp(obj.Type, transform.Type)
                error('Transforms are of different types');
            end
            d = sum((obj.Matrix(:) - transform.Matrix(:)).^2);
            d = d + sum((obj.Offset(:) - transform.Offset(:)).^2);
            n = sum(obj.Matrix(:).^2) + sum(obj.Offset(:).^2);
            delta = sqrt(d/n);
        end
        
    end
end