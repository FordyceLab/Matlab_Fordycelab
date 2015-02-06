function [num, names, pos, dims, calib, xLim, yLim] = readChipLocations(fname)
% Reads location names and positions from a file
% File has a list of location names, positions, and dimensions
% LocationName <TAB> Xpos <TAB> Ypos <TAB> width <TAB> height
% i.e. 5 <TAB> 3.4 <TAB> 7.9 <TAB> 300 <TAB> 100
%      ChipCenter <TAB> 2.9 <TAB> 24 <TAB> 0 <TAB> 0
% A special location name is calib, which specifies two positions
% for calibration.
%    calib <TAB> Loc#1 <TAB> Loc#2 <TAB> 0 <TAB> 0
% Loc#1 and Loc#2 refer to the numbers of the locations to use for
% calibration. Locations are numbered from 1, starting with the first one
% on the list.
% Other special locations are xlim, ylim, which specify the
% coordinates of the chip corners:
%    xlim <TAB> xmin <TAB> xmax <TAB> 0 <TAB> 0
%    ylim <TAB> ymin <TAB> ymax <TAB> 0 <TAB> 0

% try
    names = {};
    pos = [];
    dims = [];
    calib = [];
    xLim = [];
    yLim = [];
    num = 0;
    if ~exist(fname, 'file')
        infodlg('Title', 'Chip locations file', 'String', ['Chip locations file ' 10 13 '"' fname '"' 10 13 'does not exist!']);
    else
        [names, pos(:, 1), pos(:, 2), dims(:, 1), dims(:, 2)] = textread(fname, '%s\t%f\t%f\t%f\t%f\n', ...
            'whitespace', '\r\n\t', 'commentstyle', 'matlab');
        num = length(names);
        if ~num
            infodlg('Title', 'Chip locations file', 'String', 'Chip locations file is empty!');
        else
            % Extract special points
            % Calibration locations
            [sPos, sDim, names, pos, dims, num] = extractSpecialPoint('calib', names, pos, dims);
            if ~isempty(sPos)
                calib = sPos;
            else
                infodlg('Title', 'Chip locations file', 'String', 'Calibration points are absent or incorrectly defined');
            end
            % X and Y limits
            [sPos, sDim, names, pos, dims, num] = extractSpecialPoint('xlim', names, pos, dims);
            if ~isempty(sPos)
                xLim = sPos;
            else
                infodlg('Title', 'Chip locations file', 'String', 'X limits (min, max) are absent or incorrectly defined');
            end
            [sPos, sDim, names, pos, dims, num] = extractSpecialPoint('ylim', names, pos, dims);
            if ~isempty(sPos)
                yLim = sPos;
            else
                infodlg('Title', 'Chip locations file', 'String', 'Y limits (min, max) are absent or incorrectly defined');
            end
        end
    end
% catch
%     beep;
%     infodlg('Title', 'Chip locations file', 'String', ['Error loading chip locations' 10 13 lasterr]);
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract special positions from the list of chip locations
    function [sPos, sDim, newNames, newPos, newDims, newNum] = extractSpecialPoint(PtName, names, pos, dims)
        % Extract special positions from the list of chip locations
        % Returns the "position" and "dimension" info from the row whose name
        % is equal to PtName
        % Returns a new list of positions, with the extracted position removed.
        
        sPos = [];
        sDim = [];
        numN = length(names);
        idx = strfind(lower(names), PtName);
        newNames = names;
        newPos = pos;
        newDims = dims;
        newNum = numN;
        if ~isempty(idx)
            for ii = 1:numN
                if ~isempty(idx{ii})
                    sPos = pos(ii, :);
                    sDim = dims(ii, :);
                    idxRemove = [1:(ii - 1), (ii + 1):numN];
                    newNames = names(idxRemove);
                    newPos = pos(idxRemove, :);
                    newDims = dims(idxRemove, :);
                    newNum = numN - 1;
                    break
                end
            end %for ii
        end
    end
end