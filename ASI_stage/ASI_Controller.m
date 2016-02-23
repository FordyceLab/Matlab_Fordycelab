% Based on Galil code by Dolly Yauan
% Edited by Scott Longwell for ASI controller
% Last Updated: 2016.02.21 by Scott Longwell
% 10000 = 1 mm

classdef ASI_Controller < handle
    properties
        port % serial port
        baud % baud rate, usually 115200
        pauseTime = 0.05 % allows appropriate time for a command to be sent to the ASI Controller and an output to be returned
        csvFile % the read csvfile that controls the fraction collector.
        fileName % the string name of the file that will control the fraction collector.
        conversion = 10000.0 % conversion factor between mm and ASI units; 1 mm = 10000 ASI units (0.1 um)
        serialObj % serial object
    end
    
    methods
        %constructor
        function obj = ASI_Controller(port, baud)
            % setup serial connection
            flowControl = 'none';
            parity = 'none';
            stopBits = 1;
            terminator = 'CR';

            obj.serialObj = serial(port, 'BaudRate', baud, 'FlowControl', flowControl, 'Parity', parity, 'StopBits', stopBits, 'Terminator', terminator);
            fopen(obj.serialObj);
            
            % initialize stage position
            obj.sendCommand('2H MC X+ Y+'); % enable/disable motor control for axis
            XmaxYmin(obj) % move stage to switch limits ("bottom right")
            pause(15)
            obj.sendCommand('2H R X=-5000 Y=5000'); % move axes from switch limits 0.5 mm
            uiwait(msgbox('Please position dropper above A1'))
            obj.sendCommand('2H HERE X Y') % establish current position as 0,0 (different than HOME)
        end
        
        %destructor
        function delete(obj)
            fclose(obj.serialObj);
        end
        
        %starts the GUI controlled by ASI_GUI.m
        function launchGUI(obj)
            ASI_GUI(obj);
        end
        
        % sends the command to the ASI controller
        function out = sendCommand(obj, command)
            fprintf(obj.serialObj, command);
            
            pause(obj.pauseTime);
            
            out='';
            % checks how many bytes of output are available. this prevents
            % timeouts in case an ending code is not found.
            % returns the output from the ASI controller
            while obj.serialObj.BytesAvailable > 0
                charsread = fscanf(obj.serialObj, '%c', obj.serialObj.BytesAvailable);
                out = [out, charsread];
                pause(obj.pauseTime);
            end
        end

        % sends the stage to max X, max Y
        function XmaxYmax(obj)
            sendCommand(obj, '2H MOVE X=2000000 Y=2000000')
        end

        % sends the stage to max X, min Y
        function XmaxYmin(obj)
            sendCommand(obj, '2H MOVE X=2000000 Y=-2000000')
        end

        % sends the stage to min X, max Y
        function XminYmax(obj)
            sendCommand(obj, '2H MOVE X=-2000000 Y=2000000')
        end

        % sends the stage to min X, min Y
        function XminYmin(obj)
            sendCommand(obj, '2H MOVE X=-2000000 Y=-2000000')
        end


        % checks to see if the limits have been tripped. a dialog box pops
        % up if something has been tripped
        % does not alert the user immediately after the limit has been
        % tripped. only alerts the user if a move is attempted after the
        % limit has already been tripped by a previous move
        function checkLimits(obj,scanned)
            % scans for a question mark. strfind returns a vector of type
            % double of the locations of the ?
            questionmark = strfind(scanned, '?');
            
            % if it is empty, there is no error.
            % if a question mark has been scanned,
            if (~isempty(questionmark))
                fprintf(obj.serialObj,'TC'); % TC asks the ASI what the error code is
                % fprintf(obj.serialObj,'DU Y'); % DU Y
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
                % converts from millimeters to ASI understood units
                xPos = obj.csvFile(tubeNumber,1)*obj.conversion;
                yPos = obj.csvFile(tubeNumber,2)*obj.conversion;
                
                comStr = strcat('2H M X=', num2str(xPos), ' Y=', num2str(yPos)); % absolute position
                
                obj.sendCommand(comStr);
                
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
        
        % function that helps the user create the csvfile that dictates the
        % coordinates of all the tubes
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
            %tube), the coordinates are generated by subtracting or adding
            %from the previous tube's coordinates.
            for i = 1:numRow
                for j = 1:numCol
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
