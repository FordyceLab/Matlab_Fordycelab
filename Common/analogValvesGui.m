function [aVcObj] = analogValvesGui(vc, wagoQuit)
% Creates object to control analog outputs of wago controller.
%
%
%  Created by C. Diaz-Botia at UCSF on 11/21/12

myName = ['Wago Analog Outputs'];
myTag = 'analogValvesGui';

if ~exist('slave', 'var')
    slave = false;
end
if slave && ~exist('masterName', 'var')
    masterName = 'master';
elseif ~slave
    masterName = myName;
end

myFolder = fileparts(which([myTag '.m']));

% if isempty(errorLog)
%     % Space-less name for error logging
%     errorLogFileName = [myFolder '\' myTag '_ERRORS.txt'];
%     % Initialize error logging
%     errorLog = eventLog(['Error log file for ' myName], errorLogFileName, true);
% end

% Display the GUI
% Open GUI figure
myfigH = openfig([myFolder '\' myTag]);
set(myfigH, 'Name', myName, 'Tag', myTag);
% Get UI object handles
myUiH = getHandles(myfigH);


aVcObj.setOutputPressures = @analogValvesSetOutputPressures;
aVcObj.getOutputPressures = @analogValvesGetOutputPressures;
aVcObj.calibrate = @analogValvesCalibrate;
aVcObj.setLabels = @analogValvesSetLabels;
aVcObj.help = @analogValvesHelp_Callback;
aVcObj.figure = myfigH;


%Define labels file
labelsFileName = fullfile(myFolder, 'AnalogValvesLabels.txt');

%Define Calibration file
calibrationFileName = fullfile(myFolder, 'AnalogValvesCalibration.mat');


numberOfAnalogValves = 4;

% Set Callbacks for new GUI
set(myUiH.Help, 'Callback', @analogValvesHelp_Callback);
set(myUiH.Calibrate, 'Callback', @analogValvesCalibrate_Callback);
set(myfigH, 'CloseRequestFcn', wagoQuit);

for jj=1:numberOfAnalogValves
    slider = strcat('ValveSlider',num2str(jj));
    set(myUiH.(slider),'Callback',@ValveSlider_Callback);
    
    desiredPressure = strcat('DesiredPressure',num2str(jj));
    set(myUiH.(desiredPressure), 'Callback', @DesiredPressure_Callback);
    
    valveLabel = strcat('ValveLabel',num2str(jj));
    set(myUiH.(valveLabel), 'Callback', @ValveLabel_Callback);
    
    clear slider desiredPressure valveLabel;
end

%Common variables
calibrationData = [];
tMatrix = [];


objectInit;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Object Initialization
    function objectInit()
        %Update labels
        updateLabels;
        
        % Load Calibration or calibrate
        goOn = 0;
        timeOut = 0;
        
        while ~goOn
            analogValvesCalibrate(0);
            if exist('tMatrix', 'var') && ~isempty(tMatrix)
                goOn = 1;
            else
                timeOut = timeOut + 1;
                if timeOut > 3
                    goOn = 1;
                    msgbox('Calibration not successful, interface will remain inactive');
                    set(myUiH.AnalogValvesGui, 'Visible', 'off');
                end
            end
        end
        
        % Read channel information and set default values
        if timeOut <= 3
            currentRegistersValues = vc.getRegisters(512,4);
            for ii = 1:numberOfAnalogValves
                currentValues(ii) = (hex2dec(currentRegistersValues{ii,2}) - tMatrix{ii}(2)) / tMatrix{ii}(1);
            end

            for jj=1:numberOfAnalogValves
                slider = strcat('ValveSlider',num2str(jj));
                desiredPressure = strcat('DesiredPressure', num2str(jj));
                
                if currentValues(jj) > get(myUiH.(slider), 'max')
                    set(myUiH.(slider),'value', get(myUiH.(slider), 'max'));
                elseif currentValues < get(myUiH.(slider), 'min')
                    set(myUiH.(slider),'value', get(myUiH.(slider), 'min'));
                else
                    set(myUiH.(slider),'value', currentValues(jj));
                end
                set(myUiH.(desiredPressure), 'string', num2str(currentValues(jj)));
                set(myUiH.(desiredPressure), 'Userdata', num2str(currentValues(jj)));

                clear valveSlider desiredPressure;
            end
        end

    end






% % Funtions for MFCS GUI interface

    function analogValvesCalibrate_Callback(~,~)
        if exist(calibrationFileName, 'file')
            opt = questdlg({'A calibration file already exists,'; ...
                'Do you want to calibrate anyway?'}, 'Calibration', 'Yes', 'Load', 'No', 'Yes');
        end
        
        switch lower(opt)
            case 'yes'
                delete(calibrationFileName);
                analogValvesCalibrate;
            case 'load'
                analogValvesCalibrate;
        end
    end

    function analogValvesCalibrate(confirmValues)
        if exist(calibrationFileName, 'file')
            calibrationData = load(calibrationFileName);
            calibrationData = calibrationData.calibrationData;
        else
            calibrationData.max = [];
            calibrationData.min = [];
            
            calibrationData.wMax = '7ff0';
            calibrationData.wMin = '000f';
                
            vc.setRegisters([512:515],[calibrationData.wMin; calibrationData.wMin; calibrationData.wMin; calibrationData.wMin]);
            for ii = 1:numberOfAnalogValves
                min = inputdlg(['What pressure does the wago controlled regulator NUMBER ' num2str(ii) ' read?'], ...
                    ['Calibrating valve ' num2str(ii)]);
                calibrationData.min(ii) = str2num(min{1});
            end
            vc.setRegisters([512:515], [calibrationData.wMax; calibrationData.wMax; calibrationData.wMax; calibrationData.wMax]);
            
            for ii = 1:numberOfAnalogValves
                max = inputdlg(['What pressure does the wago controlled regulator NUMBER ' num2str(ii) ' read?'], ...
                    ['Calibrating valve ' num2str(ii)]);
                calibrationData.max(ii) = str2num(max{1});
            end
            vc.setRegisters([512:515],[calibrationData.wMin; calibrationData.wMin; calibrationData.wMin; calibrationData.wMin]);
        end
        
        messageString{1,1} = 'Is this correct?';
        messageString{2,1} = '                  Min  Max';
        for ii = 1:numberOfAnalogValves
            messageString{ii+2,1} = ['Valve' num2str(ii) '    ' num2str(calibrationData.min(ii)) '    ' num2str(calibrationData.max(ii))];
        end
        
        if ~exist('confirmValues', 'var') || confirmValues 
            opt = questdlg(messageString, 'Calibration', 'Yes', 'No', 'Yes');
        else
            opt = 'yes';
        end
        
        switch lower(opt)
            case 'yes'
                tMatrix = {};
                for ii = 1:numberOfAnalogValves
                    tMatrix{ii} = [(hex2dec(calibrationData.wMax)-hex2dec(calibrationData.wMin))/(calibrationData.max(ii) - calibrationData.min(ii)); ...
                    hex2dec(calibrationData.wMin)-calibrationData.min(ii)*(hex2dec(calibrationData.wMax)-hex2dec(calibrationData.wMin))/(calibrationData.max(ii) - calibrationData.min(ii))];
                end
                save(calibrationFileName, 'calibrationData');
                
                for ii = 1:numberOfAnalogValves
                    valveSlider = ['ValveSlider' num2str(ii)];
                    set(myUiH.(valveSlider), 'enable', 'on');
                    set(myUiH.(valveSlider), 'Max', calibrationData.max(ii));
                    set(myUiH.(valveSlider), 'Value', calibrationData.min(ii));
                    set(myUiH.(valveSlider), 'Min', calibrationData.min(ii));
                end
                    
            case 'no'
                clear calibrationData
                if exist(calibrationFileName, 'file')
                    delete(calibrationFileName);
                end
                for ii = 1:numberOfAnalogValves
                    valveSlider = ['ValveSlider' num2str(ii)];
                    set(myUiH.(valveSlider), 'enable', 'off');
                end
                msgbox('Calibration was not performed, please try again', 'Calibration');
        end
        
        
    end
                
    
    function ValveSlider_Callback(hObject,~)
        tag = get(hObject,'Tag');
        valve = str2double(tag(end));
        newPressure = get(hObject,'value');
        
        updateGui(tag(1:end-1), valve, newPressure);
        
        newPressure = uint16(newPressure*tMatrix{valve}(1) + tMatrix{valve}(2));
        vc.setRegisters(511 + valve, dec2hex(newPressure));
    end

    function analogValvesSetOutputPressures(valves, pressures)
        for ii = 1:length(valves)
            newRegisterValues(ii) = uint16(pressures(ii)*tMatrix{valves(ii)}(1) + tMatrix{valves(ii)}(2));
        end
        
        vc.setRegisters(valves+511,dec2hex(newRegisterValues));
        
        updateGui('Script', valves, pressures);
    end

    function pressures = analogValvesGetOutputPressures
        currentRegisterValues = vc.getRegisters(512, 4);
        for ii = 1:numberOfAnalogValves
            pressures(ii) = (hex2dec(currentRegisterValues{ii,2})-tMatrix{ii}(2))/tMatrix{ii}(1);
        end
    end

    function DesiredPressure_Callback(hObject,~)
        tag = get(hObject,'Tag');
        valve = str2num(tag(end));
        newPressure = str2num(char(get(hObject,'string')));
        oldPressure = get(hObject,'Userdata');
        valveSlider = strcat('ValveSlider', num2str(valve));
        if isempty(newPressure)
            set(hObject,'string',oldPressure);
        elseif (newPressure < get(myUiH.(valveSlider),'Min')) || (newPressure > get(myUiH.(valveSlider),'max'))
            set(hObject,'string',oldPressure);
        else
            set(hObject,'Userdata',num2str(newPressure));
            updateGui(tag(1:end-1), valve, newPressure);
            newPressure = uint16(newPressure*tMatrix{valve}(1) + tMatrix{valve}(2));
            vc.setRegisters(511 + valve, dec2hex(newPressure));
        end
    end

    function updateGui(caller, valves, pressures)
        switch lower(caller)
            case 'desiredpressure'
                desiredPressure = strcat(caller, num2str(valves));
                valveSlider = strcat('ValveSlider', num2str(valves));
                
                newPressure = pressures;
                
                set(myUiH.(valveSlider),'value',newPressure);
                
            case 'valveslider'
                desiredPressure = strcat('DesiredPressure',num2str(valves));
                
                newPressure = pressures;
                
                set(myUiH.(desiredPressure),'string', newPressure);
                
                set(myUiH.(desiredPressure),'Userdata', newPressure);
                
            case 'script'
                for ii=1:length(valves)
                    desiredPressure = strcat('DesiredPressure', num2str(valves(ii)));
                    valveSlider = strcat('ValveSlider', num2str(valves(ii)));
                    
                    set(myUiH.(desiredPressure),'string',num2str(pressures(ii)));
                    set(myUiH.(desiredPressure),'Userdata',num2str(pressures(ii)));
                    set(myUiH.(valveSlider),'value',pressures(ii));
                end 
        end
    end

    function updateLabels
        
        if exist(labelsFileName, 'file')
            [valve label] = textscan(labelsFileName, '%u\t%s\n', ...
                    'whitespace', '\r\n\t', 'commentstyle', 'matlab');
        else
            valve = 1:1:numberOfAnalogValves;
            for ii = 1 : length(valve)
                label(ii) = {['V' num2str(ii)]};
            end
        end
        
        for ii = 1: length(valve)
            valveLabel = ['ValveLabel' num2str(ii)];
            set(myUiH.(valveLabel), 'string', label{ii});
        end
        
    end

    function ValveLabel_Callback(~,~)
        channels = [1:1:8];
        labels = {};
        for ii = 1: length(channels)
            valveLabel = ['ValveLabel' num2str(ii)];
            labels{ii} = get(myUiH.(valveLabel), 'string');
        end
        
        fId = fopen (labelsFileName, 'w');
        
        fprintf(fId,'%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n%s\r\n', ...
            '%Labels for mfcs interface when running the chip containing this file',...
            '%Write the number of the channel as label in case nothing special is needed',...
            '%as shown below',...
            '%',...
            '%1	Label1',...
            '%2	Label2',...
            '%3	Label3',...
            '%4	4',...
            '%5	5',...
            '%6	6',...
            '%7	7',...
            '%8	8',...
            '');
        
        for ii = 1: length(channels)
            fprintf(fId, '%u\t%s\r\n', channels(ii), labels{ii});
            ii;
        end
        fclose(fId);
        
        
    end
end %mfcs
