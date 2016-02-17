function [Smask, Rmask, Rdesc] = draw_serpentine_mask(serpentine_model)

S = serpentine_model;
padding = S.channel_width *2;
%calculate total size needed for mask
fullwidth = (S.number * S.vertical_spacing) + S.channel_width;
outerradius = S.vertical_spacing + S.channel_width/2;
fullheight = S.vertical_length + 2*outerradius;
origin=[padding,outerradius+padding];

Smask = zeros([fullwidth+padding*2, fullheight+padding*2]);
Rmask = Smask;

%draw verticals
vx0 = origin(1) -S.channel_width/2 : origin(1) +S.channel_width/2;
region_padding = (S.vertical_spacing - S.channel_width) * 0.1; %pad regions by 10%
Rx0 = origin(1) -(S.channel_width+region_padding)/2 : origin(1) + (S.channel_width+region_padding)/2;
vy = origin(2):origin(2)+S.vertical_length;
%make sure these are integers, since we're going to use them as indices.
vx0 = round(vx0);
Rx0 = round(Rx0);
vy = round(vy);
for n=0:S.number-1
    vx = vx0 + n*S.vertical_spacing;
    Rx = Rx0 + n*S.vertical_spacing;
    Smask(vy,vx) = 1;
    region = (S.number * 2) +1 - n*2;
    Rmask(vy,Rx) = region;
    %generate region descriptor
    Rdesc(region).type = 'line';
    Rdesc(region).start = [origin(1) + n*S.vertical_spacing, origin(2)];
    Rdesc(region).stop = [origin(1) + n*S.vertical_spacing, origin(2) + S.vertical_length];
    if n/2 == round(n/2)
        Rdesc(region).orientation = 'down';
    else
        Rdesc(region).orientation = 'up';
    end
end

%now add curves
%for n odd, arc y is at origin, for n even, arc y is at
%origin+S.vertical_length

[X,Y] = ndgrid(1:size(Smask,1), 1:size(Smask,2));
for n=1:S.number-1
    region = (S.number * 2) - (n-1)*2;
    Rdesc(region).type = 'arc';
    if n/2 == round(n/2)
        %evens, bottom of serpentine
        %serpentine mask
        arc_center = [origin(2)+S.vertical_length, origin(1) + S.vertical_spacing * (n-0.5)];
        R = sqrt((X-arc_center(1)).^2 + (Y-arc_center(2)).^2);
        inner_r = (S.vertical_spacing - S.channel_width)/2;
        outer_r = (S.vertical_spacing + S.channel_width)/2;
        arc_mask = R >= inner_r & R <= outer_r & X >arc_center(1);
        Smask = Smask | arc_mask;
        
        %regions mask
        inner_r = (S.vertical_spacing - S.channel_width - region_padding)/2;
        outer_r = (S.vertical_spacing + S.channel_width + region_padding)/2;
        arc_mask = R >= inner_r & R <= outer_r & X >arc_center(1);
        Rmask(arc_mask) = region;
        Rdesc(region).orientation = 'cw';
    else
        %odds, top of serpentine
        arc_center = [origin(2), origin(1) + S.vertical_spacing * (n-0.5)];
        R = sqrt((X-arc_center(1)).^2 + (Y-arc_center(2)).^2);
        inner_r = (S.vertical_spacing - S.channel_width)/2;
        outer_r = (S.vertical_spacing + S.channel_width)/2;
        arc_mask = R > inner_r & R < outer_r & X <arc_center(1);
        Smask = Smask | arc_mask;
        
        %regions mask
        inner_r = (S.vertical_spacing - S.channel_width - region_padding)/2;
        outer_r = (S.vertical_spacing + S.channel_width + region_padding)/2;
        arc_mask = R >= inner_r & R <= outer_r & X <arc_center(1);
        Rmask(arc_mask) = region;
        Rdesc(region).orientation = 'ccw';
    end
    Rdesc(region).center = [arc_center(2), arc_center(1)];
end
