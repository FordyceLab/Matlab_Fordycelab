function S = get_serpentine_model(device)
%measured from image
% S.vertical_length = 177; %length of linear channels
% S.channel_width = 14;
% S.vertical_spacing = 24; %center - to -center
% S.number = 9; %number of linear channels

switch device
    
    case '70'
        %70 um device from Polly
        S.vertical_length = 1000; %length of linear channels
        S.channel_width = 70;
        S.vertical_spacing = 60+70; %center - to -center
        S.number = 9; %number of linear channels
        
    case '60'
        %60 um device from Polly
        S.vertical_length = 1000; %length of linear channels
        S.channel_width = 60;
        S.vertical_spacing = 50 + S.channel_width; %center - to -center
        S.number = 11; %number of linear channels
end