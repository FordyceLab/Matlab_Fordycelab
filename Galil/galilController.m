% Written by Dolly Yuan!!!!!!!
% Last Updated: 08/07/15 by Dolly Yuan!!!!!!!!!!

classdef galilController < handle
    
    properties
        port %serial port
        baud %baud rate, usually 115200 (as of 08/05/2015)
        pauseTime = 0.05 %allows appropriate time for a command to be sent to the Galil Controller and an output to be returned
        csvFile %the read csvfile that controls the fraction collector.
        fileName %the string name of the file that will control the fraction collector.
        longconversion = 402.317 %conversion factor between millimeters and units on the long stage (y axis). 1 millimeter = 402.317 galil units
        shortconversion = 2012.072 %conversion factor between millimeters and units on the short stage (x axis). 1 millimeter = 2012.072 galil units
    end
    properties %(GetAccess = private, SetAccess = private)
        serialObj %serial object
    end
    
    methods
        %constructor
        function obj = galilController(port, baud)
            obj.serialObj = serial(port, 'BaudRate', baud, 'FlowControl', 'hardware', 'Parity', 'none', 'StopBits', 1, 'Terminator', 'CR');
            fopen(obj.serialObj);
            
            obj.sendCommand('EO 0'); %turn off command echo
            obj.sendCommand('CN 1,1'); %limit switches active high
        end
        
        %destructor
        function delete(obj)
            fclose(obj.serialObj);
        end
        
        %starts the GUI controlled by galilGUI.m
        function launchGUI(obj)
            galilGUI(obj);
        end
        
        % sends the command to the galil controller
        function out = sendCommand(obj, command)
            fprintf(obj.serialObj, command);
            
            pause(obj.pauseTime);
            
            out='';
            %checks how many bytes of output are available. this prevents
            %timeouts in case an ending code is not found.
            %returns the output from the galil controller
            while obj.serialObj.BytesAvailable > 0
                charsread = fscanf(obj.serialObj, '%c', obj.serialObj.BytesAvailable);
                out = [out, charsread];
                pause(obj.pauseTime);
            end
        end
        
        %checks to see if the limits have been tripped. a dialog box pops
        %up if something has been tripped
        %does not alert the user immediately after the limit has been
        %tripped. only alerts the user if a move is attempted after the
        %limit has already been tripped by a previous move
        function checkLimits(obj,scanned)
            %scans for a question mark. strfind returns a vector of type
            %double of the locations of the ?
            questionmark = strfind(scanned, '?');
            
            %if it is empty, there is no error.
            %if a question mark has been scanned,
            if (~isempty(questionmark))
                fprintf(obj.serialObj,'TC'); % TC asks the galil what the error code is
                pause(obj.pauseTime);
                bytes2=obj.serialObj.BytesAvailable; %scans the appropriate number of bytes
                tcreturn = fscanf(obj.serialObj,'%c',bytes2);
                
                % if the error code returned is 22, that means a limit
                % switch has been tripped. a dialog box is popped up.
                if (~isempty(strfind(tcreturn,'22')))
                    uiwait(msgbox('Limit Switch has been turned on. Move the other direction','Error','warn','modal'));
                end
            end
            
        end
        
        %moves the stage to the appropriate tube number according to the
        %uploaded csv file
        function goToTube(obj, tubeNumber)
            numRows = size(obj.csvFile,1); %total number of tube positions in the csvfile
            
            if tubeNumber > numRows %returns an error if the tubeNumber is invalid
                uiwait(msgbox(strcat('There are only ', num2str(numRows), ' possible tubes'),'Error','error','modal'));
            else
                % converts from millimeters to galil understood units
                shortx = obj.csvFile(tubeNumber,1)*obj.shortconversion;
                longy = obj.csvFile(tubeNumber,2)*obj.longconversion;
                
                comx = strcat('PA ',num2str(shortx));
                comy = strcat('PA ,',num2str(longy));
                
                obj.sendCommand(comx);
                obj.sendCommand(comy);
                
                obj.sendCommand('BG X');
                obj.sendCommand('BG Y');
            end
        end
        
        %allows the user to choose the csvfile that dictates coordinates of
        %all the tubes.
        function loadCSV(obj)
            obj.fileName = uigetfile('*.csv','Choose the appropriate CSV file');
            if obj.fileName ~= 0
                obj.csvFile = csvread(obj.fileName);
            end
        end
        
        %function that helps the user create the csvfile that dictates the
        %coordinates of all the tubes
        % inputName = name of the file
        % xDistance = distance between each row (along the short axis) in
        % millimeters
        % yDistance = distance between each column (along the long axis) in
        % millimeters
        % numRow = number of Rows
        % numCol = number of columns
        function createCsvFile(obj,inputName,xDistance,yDistance,numRow,numCol)
            matrix = []; %{numRow*numCol,2}
            
            col = 0;
            row = 0;
            
            numTubes = 1;
            %for each row in the file (each row is the coordinates of one
            %tube), the coordinates are genertaed by subtracting or adding
            %from the previous tube's coordinates.
            for i = 1:numCol
                for j = 1:numRow
                    matrix(numTubes,1) = row;
                    matrix(numTubes,2) = col;
                    
                    row = row - xDistance;
                    numTubes = numTubes+1;
                end
                row = 0;
                col = col +yDistance;
            end
            %writes the csv file
            csvwrite(inputName,matrix)
        end
        
    end
    
end