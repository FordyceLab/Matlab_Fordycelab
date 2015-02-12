function [scr, chip, scope, camera, mfcs] = chipAutomation(chipName, vcType, valveNumFile, virtual, useScope, useCamera, camerasFile, useMfcs)
% Microfluidic chip automation and scripting system
%
% [scr, chip, scope, camera, mfcs] = chipAutomation(chipName, vcType, valveNumFile, virtual, useScope, useCamera, camerasFile, useMfcs)
%
% chipName = Full name of the chip closure to use
% vcType = Specifies type of valve controller to use: 'wago' or 'usb'
% valveNumFile = Full name of the file where the list of valve numbers is
%                stored. This file must be in the same folder as the
%                chip closure.
% virtual = Boolean parameter that when true makes the object
%           not connect to the real hardware, but it still accepts all
%           commands.  Defaults to false when absent.
% useScope = Boolean that specifies if the Leica microscope interface should be
%            activated
% useCamera = Boolean that specifies if the camera interface should be
%             activated
% camerasFile = Full name of the file where the list of cameras is
%               stored. This file must be in the same folder as the
%               cameraGui closure.
% useMfcs = Boolean that specifies if the camera MFCS should be
%             activated
%
% scr = Closure object giving access to the methods used to automate a chip
%       experiment
%
% R. Gomez-Sjoberg 10/18/11

fileSeparator = filesep;

myName = 'Chip Automation And Scripting';
myTag = 'chipAutomation';

% Where am I?
myFolder = fileparts(which([myTag '.m']));

% Open GUI figure
myFigH = openfig([myFolder fileSeparator myTag]);
myUiH = getHandles(myFigH);
set(myFigH, 'Name', myName, 'Tag', myTag);
defaultBackgroundColor = get(0,'defaultUicontrolBackgroundColor');

% Set Callbacks for new GUI
set(myUiH.ScriptFolderButton, 'Callback', @ScriptFolderButton_Callback);
set(myUiH.ScriptFolder, 'Callback', @ScriptFolder_Callback);
set(myUiH.ScriptFName, 'Callback', @ScriptFName_Callback);
set(myUiH.ScriptUpdate, 'Callback', @ScriptUpdate_Callback);
set(myUiH.ScriptEdit, 'Callback', @ScriptEdit_Callback);
set(myUiH.ScriptRun, 'Callback', @ScriptRun_Callback);
set(myUiH.ScriptStop, 'Callback', @ScriptStop_Callback);
set(myUiH.ScriptSafeStop, 'Callback', @ScriptSafeStop_Callback);
% set(myUiH.About, 'Callback', @About_Callback);
set(myUiH.Quit, 'Callback', @Quit_Callback);
set(myFigH, 'CloseRequestFcn', @Quit_Callback);

% Make figure visible
set(myFigH, 'Visible', 'on');

myData = [];
% Initialize script execution
scriptInit;

% Methods
scr.wait = @scrWait;
scr.waitAndLogPressures = @scrWaitAndLogPressures;
scr.message = @message;
scr.timer = @scrTimer;
scr.pause = @scriptPause;
scr.stop = @ScriptStop_Callback;
scr.run = @ScriptRun_Callback;
scr.safeStop = @ScriptSafeStop_Callback;
scr.runningSignal = @runningSignal;
scr.pauseSignal = @pauseSignal;
scr.stopSignal = @stopSignal;
scr.safeStopSignal = @safeStopSignal;
scr.getScriptName = @getScriptName;
scr.getScriptFolder = @getScriptFolder;
scr.setScriptFolder = @setScriptFolder;
scr.getScriptTimer = @getScriptTimer;
scr.setTimedScriptName = @setTimedScriptName;
scr.setTimedScriptPeriod = @setTimedScriptPeriod;
scr.startTimedScript = []; %@startTimer;
scr.stopTimedScript = []; %@stopTimer;
scr.isTimerRunning = [];
scr.quit = @objectClose;

% Initialize chip control
chip = [];
errorLog = [];
if ~isempty(chipName)
    try
        message('Starting chip controller');
        success = true;
        switch lower(chipName)
            case 'lblccc'
                chip = lblCCC(vcType, valveNumFile, virtual, true, myName);
            case 'cellulose1chip'
                chip = cellulose1Chip(vcType, valveNumFile, virtual, true, myName);
            case 'beadsynthesizerv2p4'
                chip = beadSynthesizerV2p4(vcType, valveNumFile, virtual, true, myName);
            case 'beadsynthesizerv0p5'
                chip = beadSynthesizerV0p5(vcType, valveNumFile, virtual, true, myName);
            case 'beadsynthesizerv2p5'
                chip = beadSynthesizerV2p5(vcType, valveNumFile, virtual, true, myName);
            case 'beadsynthesizerv3p0'
                chip = beadSynthesizerV3p0(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinev0p2'
                chip = serpentineV0p2(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinev0p2withsausages'
                chip = serpentineV0p2WithSausages(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinetestdevicev0p4a'
                chip = serpentineTestDeviceV0p4A(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinetestdevicev0p4b'
                chip = serpentineTestDeviceV0p4B(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinetestdevicev1p0a'
                chip = serpentineTestDeviceV1p0A(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinetestdevicev1p0b'
                chip = serpentineTestDeviceV1p0B(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinetestdevicev1p0c'
                chip = serpentineTestDeviceV1p0C(vcType, valveNumFile, virtual, true, myName);
            case 'serpentinetestdevicev1p1'
                chip = serpentineTestDeviceV1p1(vcType, valveNumFile, virtual, true, myName);
            case 'peptoidsynthesis'
                chip = peptoidSynthesis(vcType, valveNumFile, virtual, true, myName);
            case 'radiationccc'
                chip = radiationCCC(vcType, valveNumFile, virtual, true, myName);
            case 'beadrinserv0p5'
                chip = beadRinserV0p5(vcType, valveNumFile, virtual, true, myName);
            case 'rbcsorterv0p1'
                chip = RBCSorterV0p1(vcType, valveNumFile, virtual, true, myName);
            case 'beadreactorv0p2'
                chip = beadReactorV0p2(vcType, valveNumFile, virtual, true, myName);
            case 'pc1kv1p0'
                chip = PC1kV1p0(vcType, valveNumFile, virtual, true, myName);
            otherwise
                success = false;
                error(['Unsupported chip ' chipName]);
        end
        if success
            errorLog = chip.errorLog;
        end
    catch ME
        success = false;
        errorHandler('', ME, 'ERROR! Cannot activate the chip control interface! ', [], @message, true);
%         rethrow(ME);
    end
end

if isempty(errorLog)
    % Create our own error log
    pathParts = strsplit(myFolder, filesep);
    %we are in INSTALL_DIR/Common; want to write to INSTALL_DIR/Logs
    errorLogFileName = fullfile(pathParts{1:end-1}, 'Logs' ,[myTag,'_ERRORS.txt']);
    % Initialize error logging
    errorLog = eventLog(['Error log file for ' myName], errorLogFileName, true);
end

% Start scope, camera, and MFCS interfaces
scope = [];
camera = [];
mfcs = [];
if useScope
    try
        message('Starting microscope controller');
        scope = Scope;
    catch ME
        errorHandler('', ME, 'ERROR! Cannot activate the microscope control interface! ', [], @message, true);
        useScope = false;
        scope = [];
    end
else
    scope.openShutters = [];
    scope.closeShutters = [];
    scope.setViewPort = [];
end
if useCamera
    try
        message('Starting camera controller');
        camera = cameraGui(camerasFile, scope.openShutters, scope.closeShutters, scope.setViewPort, true, myName, errorLog);
        if useScope
            scope.setCameraFcnHandles(camera.getCurrent, camera.getNames, camera.select);
        end
    catch ME
        errorHandler('', ME, 'ERROR! Cannot activate the camera control interface! ', [], @message, true);
        useCamera = false;
        camera = [];
    end
end
if useMfcs
    try
        message('Starting MFCS controller');
        mfcs = mfcsGui(0079, true, myName, errorLog);
    catch ME
        errorHandler('', ME, 'ERROR! Cannot activate the MFCS control interface! ', [], @message, true);
        useMfcs = false;
        mfcs = [];
    end
end
message('Ready!');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on menu select in About.
    function About_Callback(hObject, ~)
        
        str = {'Chip Automation And Scripting System'; 'October 2011'; ' '; ...
            'Rafael Gómez-Sjöberg'; 'Engineering Division'; 'Lawrence Berkeley National Laboratory'};
        aboutdlg('Title', 'Chip Automation And Scripting System', 'String', str);
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on menu select in Quit or close request.
    function Quit_Callback(hObject, eventdata)
        
        opt = YesNoQuestion('Title', 'Chip Automation And Scripting System', 'String', ...
            ['This will quit all open interfaces!' 10 13 ...
            'Are you sure you want to quit?']);
        switch lower(opt)
            case 'yes'
                objectClose();
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Closes the object and deletes the GUI
    function objectClose
        
        % Close scripting system
        scriptClose;
        
        try
            if useScope
                scope.quit();
                clear scope;
                clear('leicaGui');
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! Cannot close microscope interface! ', errorLog, @message, false);
        end
        try
            if useCamera
                camera.quit();
                clear camera;
                clear('cameraGui');
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! Cannot close camera interface! ', errorLog, @message, false);
        end
        try
            if useMfcs
                mfcs.quit();
                clear mfcs;
                clear('mfcsGui');
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! Cannot close MFCS interface! ', errorLog, @message, false);
        end
        try
            if ~isempty(chip)
                chipTag = chip.getTag();
                chip.quit();
                clear chip;
                clear(chipTag);
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! Cannot close chip interface! ', errorLog, @message, false);
        end
        
        % Close GUI
        delete(myFigH);
        % cd(myFolder);
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get new scripts folder
    function ScriptFolderButton_Callback(hObject, ~)
        
        folder = uigetdir(myData.Folder, 'Please the select a folder where scripts are stored');
        if folder
            if folder(end) ~= fileSeparator
                folder = [folder fileSeparator];
            end
            myData.Folder = folder;
            set(myUiH.ScriptFolder, 'String', folder);
            set(myUiH.ScriptFolder, 'UserData', folder);
            ScriptUpdate_Callback(myUiH.ScriptUpdate, []);
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return current Script name without the .m extension
    function scrName = getScriptName
        
        scrName = [myData.FName];

    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return Script Folder box
    function folder = getScriptFolder
        
        folder = get(myUiH.ScriptFolder, 'String');

    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Script Folder box
    function setScriptFolder(folder)

        set(myUiH.ScriptFolder, 'String', folder);
        ScriptFolder_Callback(myUiH.ScriptFolder, []);
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Script Folder box
    function ScriptFolder_Callback(hObject, ~)
        
        if myData.Running
            str = ['Cannot change the script folder' 10 13 'while a script is running!'];
            infodlg('Title', 'Script Folder', 'String', str);
            % Restore previous value
            str = get(hObject, 'UserData');
            set(hObject, 'String', str);
        else
            str = get(hObject, 'String');
            if exist(str, 'dir')
                if ~isempty(str) &&  (str(end) ~= fileSeparator)
                    str = [str fileSeparator];
                    set(hObject, 'String', str);
                end
                myData.Folder = str;
                set(hObject, 'UserData', str);
                ScriptUpdate_Callback(myUiH.ScriptUpdate, []);
            else
                msg = ['The folder' 10 13 str 10 13 'does not exist!'];
                infodlg('Title', 'Script Folder Does Not Exist', 'String', msg);
                % Restore previous value
                str = get(hObject, 'UserData');
                set(hObject, 'String', str);
            end
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Script Name box
    function ScriptFName_Callback(hObject, ~)
        
        if myData.Running
            str = ['Cannot change the script' 10 13 'while a script is running!'];
            infodlg('Title', 'Script', 'String', str);
            % Restore previous value
            v = get(hObject, 'UserData');
            set(hObject, 'Value', v);
        else
            v = get(hObject, 'Value');
            str = get(hObject, 'String');
            set(hObject, 'UserData', v);
            myData.FName = str{v};
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Script Update button
    function ScriptUpdate_Callback(hObject, ~)
        
        list = dir(myData.Folder);
        scripts = {};
        nn = length(list);
        cc = 1;
        cv = 1;
        for ii = 1:nn
            if ~list(ii).isdir
                if strcmp(list(ii).name(end-1:end), '.m')
                    scripts{cc} = list(ii).name(1:end-2);
                    if strcmp(list(ii).name(1:end-2), myData.FName)
                        cv = cc;
                    end
                    cc = cc + 1;
                end
            end
        end
        if isempty(scripts)
            scripts = {' '};
        end
        set(myUiH.ScriptFName, 'String', scripts);
        set(myUiH.ScriptFName, 'Value', cv);
        myData.FName = scripts{cv};
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close Script running system
    function scriptClose
        
        try
            set(myUiH.Msg, 'String', 'Closing scripting system');
            stop(myData.Timer1);
            stop(myData.Timer2);
            stop(myData.Timer3);
            stop(myData.Timer4);
            stop(myData.Timer5);
            pause(3);
            delete(myData.Timer1);
            delete(myData.Timer2);
            delete(myData.Timer3);
            delete(myData.Timer4);
            delete(myData.Timer5);
        catch
            beep;
            msg = lasterr;
            set(myUiH.Msg, 'String', ['ERROR!  scriptClose' 10 13 msg]);
            log_error('scriptClose', msg);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Script running system
    function scriptInit
        
        % Init flags and display
        myData.Folder = get(myUiH.ScriptFolder, 'String');
        set(myUiH.ScriptFolder, 'UserData', myData.Folder);
        myData.FName = '';
        set(myUiH.ScriptFName, 'String', ' ');
        set(myUiH.ScriptFName, 'Value', 1);
        set(myUiH.ScriptFName, 'UserData', 1);
        myData.Running = false;
        myData.Stop = false;
        myData.Pause = false;
        myData.SafeStop = false;
        set(myUiH.ScriptStop, 'UserData', 0);
        set(myUiH.ScriptRun, 'BackgroundColor', defaultBackgroundColor);
        set(myUiH.ScriptRun, 'String', 'RUN');
        myData.PauseLength = 0.5; %hrs
        
        % Setup timers
        % These timers are for running scripts
        myData.Timer1 = timer('TimerFcn', @ScriptTimerFcn1, 'BusyMode', 'drop', 'ExecutionMode', 'fixedSpacing', 'Name', 'ScriptTimer1');
        myData.Timer2 = timer('TimerFcn', @ScriptTimerFcn2, 'BusyMode', 'drop', 'ExecutionMode', 'fixedSpacing', 'Name', 'ScriptTimer2');
        myData.Timer3 = timer('TimerFcn', @ScriptTimerFcn3, 'BusyMode', 'drop', 'ExecutionMode', 'fixedSpacing', 'Name', 'ScriptTimer3');
        myData.Timer4 = timer('TimerFcn', @ScriptTimerFcn4, 'BusyMode', 'drop', 'ExecutionMode', 'fixedSpacing', 'Name', 'ScriptTimer4');
        myData.Timer5 = timer('TimerFcn', @ScriptTimerFcn5, 'BusyMode', 'drop', 'ExecutionMode', 'fixedSpacing', 'Name', 'ScriptTimer5');
        myData.TimedScript{1} = '';
        myData.TimedScript{2} = '';
        myData.TimedScript{3} = '';
        myData.TimedScript{4} = '';
        myData.TimedScript{5} = '';
        
        % Update list of scripts
        ScriptUpdate_Callback(myUiH.ScriptUpdate, [])
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for script timer 1
    function ScriptTimerFcn1(hObject, ~)
        
        scr_fname = myData.TimedScript{1};
        if ~exist(scr_fname, 'file')
            scr_str = ['Error!' 10 13 'Cannot find the script ' scr_fname ' !'];
            infodlg('Title', 'Script Timer Function 1', 'String', scr_str);
        else
            try
                clear(scr_fname);
                scriptRun(scr_fname, scr, chip, camera, scope, mfcs);
            catch
                beep;
                msg = [myData.TimedScript{1} 10 13 lasterr];
                set(myUiH.Msg, 'String', ['ERROR!  ScriptTimerFcn1' 10 13 msg]);
                log_error('ScriptTimerFcn1', msg);
            end
            clear(scr_fname);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for script timer 2
    function ScriptTimerFcn2(hObject, ~)
        
        scr_fname = myData.TimedScript{2};
        if ~exist(scr_fname, 'file')
            scr_str = ['Error!' 10 13 'Cannot find the script ' scr_fname ' !'];
            infodlg('Title', 'Script Timer Function 2', 'String', scr_str);
        else
            try
                clear(scr_fname);
                scriptRun(scr_fname, scr, chip, camera, scope, mfcs);
            catch
                beep;
                msg = [myData.TimedScript{2} 10 13 lasterr];
                set(myUiH.Msg, 'String', ['ERROR!  ScriptTimerFcn2' 10 13 msg]);
                log_error('ScriptTimerFcn2', msg);
            end
            clear(scr_fname);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for script timer 3
    function ScriptTimerFcn3(hObject, ~)
        
        scr_fname = myData.TimedScript{3};
        if ~exist(scr_fname, 'file')
            scr_str = ['Error!' 10 13 'Cannot find the script ' scr_fname ' !'];
            infodlg('Title', 'Script Timer Function 3', 'String', scr_str);
        else
            try
                clear(scr_fname);
                scriptRun(scr_fname, scr, chip, camera, scope, mfcs);
            catch
                beep;
                msg = [myData.TimedScript{3} 10 13 lasterr];
                set(myUiH.Msg, 'String', ['ERROR!  ScriptTimerFcn3' 10 13 msg]);
                log_error('ScriptTimerFcn3', msg);
            end
            clear(scr_fname);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for script timer 4
    function ScriptTimerFcn4(hObject, ~)
        
        scr_fname = myData.TimedScript{4};
        if ~exist(scr_fname, 'file')
            scr_str = ['Error!' 10 13 'Cannot find the script ' scr_fname ' !'];
            infodlg('Title', 'Script Timer Function 4', 'String', scr_str);
        else
            try
                clear(scr_fname);
                scriptRun(scr_fname, scr, chip, camera, scope, mfcs);
            catch
                beep;
                msg = [myData.TimedScript{4} 10 13 lasterr];
                set(myUiH.Msg, 'String', ['ERROR!  ScriptTimerFcn4' 10 13 msg]);
                log_error('ScriptTimerFcn4', msg);
            end
            clear(scr_fname);
        end
        
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for script timer 5
    function ScriptTimerFcn5(hObject, ~)
        
        scr_fname = myData.TimedScript{5};
        if ~exist(scr_fname, 'file')
            scr_str = ['Error!' 10 13 'Cannot find the script ' scr_fname ' !'];
            infodlg('Title', 'Script Timer Function 5', 'String', scr_str);
        else
            try
                clear(scr_fname);
                scriptRun(scr_fname, scr, chip, camera, scope, mfcs);
            catch
                beep;
                msg = [myData.TimedScript{5} 10 13 lasterr];
                set(myUiH.Msg, 'String', ['ERROR!  ScriptTimerFcn5' 10 13 msg]);
                log_error('ScriptTimerFcn5', msg);
            end
            clear(scr_fname);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get timer object from one of the 5 timed script functions
    function timerObj = getScriptTimer(timerNum)
        
        timerObj = [];
        if (timerNum < 1) || (timerNum > 5)
            scr_str = ['Error!' 10 13 'Invalid timer number (' num2str(timerNum) ')!' 10 13 ...
                'Valid numbers are from 1 to 5'];
            infodlg('Title', 'Get Script Timer', 'String', scr_str);
        else
            timerObj = myData.(['Timer' num2str(timerNum)]);
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set script name for one of the 5 timed script functions
    function setTimedScriptName(timerNum, scriptName)
        
        if ~isempty(scriptName) && ~isequal(scriptName(end-1:end), '.m')
            scriptName = [scriptName '.m'];
        end
        if (timerNum < 1) || (timerNum > 5)
            scr_str = ['Error!' 10 13 'Invalid timer number (' num2str(timerNum) ')!' 10 13 ...
                'Valid numbers are from 1 to 5'];
            infodlg('Title', 'Set Timed Script', 'String', scr_str);
        elseif ~isempty(scriptName)
            scr_str = ['Error!' 10 13 'Timer script name is empty!'];
            infodlg('Title', 'Set Timed Script', 'String', scr_str);
        elseif ~exist(scriptName, 'file')
            scr_str = ['Error!' 10 13 'Timer script ' scriptName ' does not exist!'];
            infodlg('Title', 'Set Timed Script', 'String', scr_str);
        else
            myData.TimedScript{timerNum} = scriptName;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set script name for one of the 5 timed script functions
    function setTimedScriptPeriod(timerNum, period)
        
        if (timerNum < 1) || (timerNum > 5)
            scr_str = ['Error!' 10 13 'Invalid timer number (' num2str(timerNum) ')!' 10 13 ...
                'Valid numbers are from 1 to 5'];
            infodlg('Title', 'Set Timed Script Period', 'String', scr_str);
        elseif (period <= 0)
            scr_str = ['Error!' 10 13 'Period must be larger than zero!'];
            infodlg('Title', 'Set Timed Script Period', 'String', scr_str);
        else
            myData.TimedScript{timerNum} = scriptName;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Edit Script button
    function ScriptEdit_Callback(hObject, ~)
        
        fname = [myData.Folder myData.FName '.m'];
        if ~isempty(myData.FName) &&  ~isempty(myData.Folder) ...
                && exist(fname, 'file')
            edit(fname);
        else
            edit('');
            %infodlg('Title', 'Script', 'String', 'Cannot find the script!');
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Stop Script button
    function ScriptStop_Callback(hObject, ~)
        
        if myData.Running
            myData.Stop = 1;
        else
            infodlg('Title', 'Script', 'String', 'No script running!');
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Stop Script button
    function ScriptSafeStop_Callback(hObject, ~)
        
        if myData.Running
            myData.SafeStop = 1;
            set(myUiH.ScriptSafeStop, 'BackgroundColor', 'yellow');
            message('Script will only stop if it includes a safe stop evaluation');
        else
            infodlg('Title', 'Script', 'String', 'No script running!');
        end
        
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Run Script button
    function ScriptRun_Callback(hObject, ~)
        
        path(myData.Folder, path);
        scr_fname = [myData.FName '.m'];
        if myData.Running
            if myData.Pause
                myData.Pause = 0;
                myData.PauseStart = 0;
                set(myUiH.ScriptRun, 'BackgroundColor', 'green');
                set(myUiH.ScriptRun, 'String', 'Pause');
            else
                myData.Pause = 1;
                myData.PauseStart = now;
                set(myUiH.ScriptRun, 'BackgroundColor', 'yellow');
                set(myUiH.ScriptRun, 'String', 'Resume');
            end
        elseif ~exist(scr_fname, 'file')
            infodlg('Title', 'Script', 'String', 'Cannot find the script!');
        else
            try
                myData.Running = 1;
                myData.Stop = 0;
                myData.SafeStop = 0;
                myData.Pause = 0;
                myData.PauseStart = 0;
                set(myUiH.ScriptRun, 'BackgroundColor', 'green');
                set(myUiH.ScriptRun, 'String', 'Pause');
                set(myUiH.ScriptStop, 'BackgroundColor', 'red');
                set(myUiH.ScriptSafeStop, 'BackgroundColor', 'red');
                set(myUiH.Msg, 'String', ['Script ' myData.FName ' started']);
                drawnow;
                scriptRun(myData.FName, scr, chip, camera, scope, mfcs);
                if myData.Stop
                    scr_str = ['Script ' myData.FName ' stopped'];
                else
                    scr_str = ['Script ' myData.FName ' ended'];
                end
                set(myUiH.Msg, 'String', scr_str);
            catch ME
                thisTag = [myTag ':ScriptRun'];
                errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
            end
            % rmpath(myData.Folder);
            myData.Running = 0;
            myData.Stop = 0;
            myData.Pause = 0;
            myData.PauseStart = 0;
            clear(myData.FName);
            set(myUiH.ScriptRun, 'BackgroundColor', defaultBackgroundColor);
            set(myUiH.ScriptRun, 'String', 'RUN');
            set(myUiH.ScriptStop, 'BackgroundColor', defaultBackgroundColor);
            set(myUiH.ScriptSafeStop, 'BackgroundColor', defaultBackgroundColor);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [done, tremain] = scrTimer(tstart, tlength)
        % [done, tremain] = scrTimer(tstart, tlength)
        % Determines time between now and tstart, and
        % whether the elapsed time is longer than tlength
        %
        % tstart = Date number for when the timer started
        % tlength = Length of the period being timed, in hours
        %
        % done = 1 if time is up (elapsed time > tlength), 0 otherwise
        % tremain = Time remaining [hrs, min, sec]
        %
        % R. Gomez-Sjoberg 5/31/06
        
        time = 24*(now - tstart); %hrs
        dt = tlength - time; %hrs
        hrs = fix(dt);
        min = fix(dt * 60);
        sec = fix((dt*60 - min)*60);
        if (time >= tlength)
            done = 1;
        else
            done = 0;
        end
        tremain = [hrs, min, sec];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function that times the pause when a script is paused
% After the defined time length the pause is released
    function scriptPause(msg)
        
        done = 0;
        while ~myData.Stop && myData.Pause  && ~done
            pause(0.98);
            % pause might have been released during the 0.98sec wait
            if myData.Pause
                [done, tremain] = scrTimer(myData.PauseStart, myData.PauseLength);
                str = [msg 10 13 'Paused - ' num2str_pad(tremain(2), 2) ':' num2str_pad(tremain(3), 2)];
                set(myUiH.Msg, 'String', str);
                if ~done && ((tremain*[3600; 60; 1]) <= 10)
                    % Beep on the last 10 seconds of the pause
                    beep;
                end
                if myData.Pause && done
                    % Release pause
                    ScriptRun_Callback(myUiH.ScriptRun, []);
                end
            end
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the script run signal is active
    function sig = runningSignal
        
        sig = myData.Running;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the script stop signal is active
    function sig = pauseSignal
        
        sig = myData.Pause;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the script stop signal is active
    function sig = stopSignal
        
        sig = myData.Stop;
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the script safe stop signal is active
    function sig = safeStopSignal
        
        sig = myData.SafeStop;
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wait for the specified number of minutes & seconds
% chipEcho = true/false Optional parameter that specifies if the
% message should be echoed into the chip message area.
% Defaults to false if absent
    function scrWait(min, sec, msg, chipEcho)
        
        if nargin == 2
            msg = '';
            chipEcho = false;
        end
        if nargin == 3 || isempty(chip)
            chipEcho = false;
        end
        tstart = now;
        wait_t = min/60 + sec/3600; %converted to hrs
        done = 0;
        while ~myData.Stop  && ~done
            if myData.Pause
                scriptPause(msg);
            else
                pause(0.98);
                [done, tremain] = scrTimer(tstart, wait_t);
                str = [msg 10 13 'Waiting - ' num2str_pad(tremain(2), 2) ':' num2str_pad(tremain(3), 2)];
                set(myUiH.Msg, 'String', str);
                if chipEcho
                    chip.message(str);
                end
            end
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wait for the specified number of minutes & seconds
% chipEcho = true/false Optional parameter that specifies if the
% message should be echoed into the chip message area.
% Defaults to false if absent
    function scrWaitAndLogPressures(min, sec, msg, chipEcho, mfcsLogFid)
        
        if nargin == 2
            msg = '';
            chipEcho = false;
        end
        if nargin == 3 || isempty(chip)
            chipEcho = false;
        end
        tstart = now;
        wait_t = min/60 + sec/3600; %converted to hrs
        
        waitTime = min*60 + sec
        sumTime = 0
        done = 0;
        while sumTime < waitTime
            if myData.Pause
                scriptPause(msg);
            else
                tic
                [done,tremain] = scrTimer(tstart,wait_t);
                str = [msg 10 13 'Waiting - ' num2str_pad(tremain(2), 2) ':' num2str_pad(tremain(3), 2)];
                outPressures = mfcs.readChannelPressure([1,2,3,4,5,6,7,8]);
                fprintf(mfcsLogFid,[num2str(outPressures(2,:)),'\n\r'],'%4.2f');
                set(myUiH.Msg, 'String', str);
                if chipEcho
                    chip.message(str)
                end
                sumTime = sumTime + toc;
            end
        end
        
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display message on message window
    function message(msg)
        
        set(myUiH.Msg, 'String', msg);
        drawnow;
        
    end

end
