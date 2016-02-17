function bead_map = map_beads_to_serpentine (regions, descriptions, bead_coordinates)

bead_centers = zeros(size(regions));
for n=1:size(bead_coordinates,1)
    coords=round(bead_coordinates(n,:));
    bead_centers(coords(2),coords(1)) = n;
end

bead_index = 1;
for n=2:size(descriptions,2)
    position =[];
    mask = regions == n;
    %get bead indices
    bead_list = bead_centers(bead_centers & mask);
    for bead = 1:numel(bead_list)
        bead_coords = bead_coordinates(bead_list(bead),:);
        switch descriptions(n).type
            case 'arc'
                %project onto arc
                position(bead,1) = atan2(descriptions(n).center(2)-bead_coords(2), descriptions(n).center(1)-bead_coords(1));
                position(bead,2) = bead_list(bead);
                
            case 'line'
                %project onto line by computing dot product
                origin = descriptions(n).start;
                centerline = descriptions(n).stop - origin;
                bead_pos = bead_coords - origin;
                position(bead,1) = dot(centerline,bead_pos);
                position(bead,2) = bead_list(bead);
        end
    end
    if ~isempty(position)
        if strcmp(descriptions(n).orientation, 'cw') || strcmp(descriptions(n).orientation, 'down')
            position = sortrows(position,1);
        elseif strcmp(descriptions(n).orientation, 'ccw') || strcmp(descriptions(n).orientation, 'up')
            position(:,1) = -position(:,1);
            position = sortrows(position,1);
        else
            disp('Unknown orientation');
        end
        %add beads to map
        for p=1:size(position,1)
            bead_map(bead_index,:) = bead_coordinates(position(p,2),:);
            bead_index = bead_index+1;
        end
    end
end