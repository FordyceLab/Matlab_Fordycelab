function pump = pumpGuiControlWagoAuto(getVc, setValve, uiH, uiPrefix, initialDir, errorLog)
% GUI pump control system closure. To be use only with a Wago controller
% that is programmed to do automatic pumping
%
% pump = pumpGuiControlWagoAuto(getVc, setValve, uiH, uiPrefix, errorLog)
%
% getVc = Handle to function that returns the handles to the valve control
%         closure (for example Wago or USB)
% setValve = Handle to function that sets a valve state based on the valve
%            name
% uiH = Structure with handles to all objects in the GUI figure.
%       If this structure has field uiH.ChamberPlot.h(..), those handles
%       are used to update the chamber plot.
% uiPrefix = String with the prefix used by all GUI controls that belong to
%            this MUX. Use different prefixes if the chip has more than one
%            MUX.
% initialDir = Boolean indicating initial pumping direction
%              true = forward, false = backward
% errorLog = Object/closure that handles error logging. Pass [] if no
%            logging is needed.
%
% R. Gomez-Sjoberg, L. Ardila-Perez, 01/09/12

myName = 'Pump Controller - Wago Auto';
myTag = 'pumpGuiControlWagoAuto';
defaultBackgroundColor = get(0,'defaultUicontrolBackgroundColor');

% Where am I?
myFolder = fileparts(which([myTag '.m']));

% Initialize internal data structures
iPump = [];

% Array with handles to this Mux's UI objects
pumpUiH = [];

% Generate pumping function handles
pumpingFcnH = @PumpingFcn;
pumpStopFcnH = @PumpStopFcn;
pumpStopCallbackH = @PumpStop_Callback;
pumpRunCallbackH = @PumpRun_Callback;

% Initialize mux control
pumpInit;

% Set callbacks
set(pumpUiH.PumpClose, 'Callback', @PumpClose_Callback);
set(pumpUiH.PumpOpen, 'Callback', @PumpOpen_Callback);
set(pumpUiH.PumpDir, 'Callback', @PumpDir_Callback);
set(pumpUiH.PumpCycles, 'Callback', @PumpCycles_Callback);
set(pumpUiH.PumpPeriod, 'Callback', @PumpPeriod_Callback);
set(pumpUiH.PumpRun, 'Callback', pumpRunCallbackH);

% Methods
pump.getTag = @getTag;
pump.getFolder = @getFolder;
pump.set = @setPump;
pump.run = @runPump;
pump.open = @openPump;
pump.close = @closePump;
pump.setDirection = @setPumpDirection;
pump.getDirection = @getPumpDirection;
pump.switchDirection = @switchPumpDirection;
pump.setFrwdSequence = @setFrwdSequence;
pump.setBkwdSequence = @setBkwdSequence;
pump.quit = @pumpQuit;
pump.reset = @pumpReset;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns this closure's tag
    function tag = getTag
        tag = myTag;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the folder where this m file is stored
    function folder = getFolder
        folder = myFolder;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset pump control system
    function pumpReset
        
        pumpInit;
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close pump control system
    function pumpQuit
        
        try
            message(['Closing ' uiPrefix ' control system']);
            % Nothing to do here for now!
        catch ME
            thisTag = [myTag ':pumpQuit'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize pump
    function pumpInit
        
        try
            message(['Initializing ' uiPrefix ' control system']);
            iPump.vc = getVc();
            % Initialize GUI handles
            iPump.valveNames = cell(3, 1);
            for jj = 1:3
                uiName = [uiPrefix num2str(jj)];
                iPump.valveNames{jj} = uiName;
                pumpUiH.(['Pump' num2str(jj)]) = uiH.(uiName);
                pumpUiH.(['Pump' num2str(jj) 'Num']) = uiH.([uiName 'Num']);
            end
            pumpUiH.PumpClose = uiH.([uiPrefix 'Close']);
            pumpUiH.PumpOpen = uiH.([uiPrefix 'Open']);
            pumpUiH.PumpDir = uiH.([uiPrefix 'Dir']);
            pumpUiH.PumpPeriod = uiH.([uiPrefix 'Period']);
            pumpUiH.PumpCycles = uiH.([uiPrefix 'Cycles']);
            pumpUiH.PumpRun = uiH.([uiPrefix 'Run']);
            
            iPump.Running = 0;
            iPump.Cycles = 100;
            iPump.Period = 0.1;
            set(pumpUiH.PumpPeriod, 'String', num2str(iPump.Period), 'UserData', iPump.Period);
            set(pumpUiH.PumpCycles, 'String', num2str(iPump.Cycles), 'UserData', iPump.Cycles);
            iPump.Timer = timer('Period', iPump.Period, ...
                'TasksToExecute', 400, 'TimerFcn', pumpingFcnH, ...
                'StopFcn', pumpStopFcnH, ...
                'BusyMode', 'queue', 'ExecutionMode', 'fixedSpacing');
            set(iPump.Timer, 'Name', 'PumpTimer');
            iPump.FrwdSequence = {[0 0 1]; [1 0 1]; [1 0 0]; [1 1 0]; [1 1 1]};
            iPump.BkwdSequence = {[1 0 0]; [1 0 1]; [0 0 1]; [0 1 1]; [1 1 1]};
            iPump.SeqIndex = 1;
            iPump.ValveNumbers = [];
            iPump.Counter = 400;
            iPump.StopFlag = 0;
            if initialDir
                setPumpDirection('forward');
            else
                setPumpDirection('backward');
            end
            
        catch ME
            thisTag = [myTag ':pumpInit'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display message on message window
    function message(msg)
        try
            set(uiH.Msg, 'String', msg);
            drawnow;
        catch ME
            thisTag = [myTag ':message'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set forward pumping sequence
    function setFrwdSequence(seq)
        % seq = Cell array where each element is a 1x3 vector with the
        % valve values for each step in the sequence
        
        try
            iPump.FrwdSequence = seq;
            if iPump.Frwd
                setPumpDirection('forward');
            end
        catch ME
            thisTag = [myTag ':setFrwdSequence'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set backward pumping sequence
    function setBkwdSequence(seq)
        % seq = Cell array where each element is a 1x3 vector with the
        % valve values for each step in the sequence
        
        try
            iPump.BkwdSequence = seq;
            if ~iPump.Frwd
                setPumpDirection('backward');
            end
        catch ME
            thisTag = [myTag ':setBkwdSequence'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close all valves in the pump
    function closePump()
        
        try
            setValve(iPump.valveNames{1}, 1);
            setValve(iPump.valveNames{2}, 1);
            setValve(iPump.valveNames{3}, 1);
        catch ME
            thisTag = [myTag ':closePump'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open all valves in the pump
    function openPump()
        
        try
            setValve(iPump.valveNames{1}, 0);
            setValve(iPump.valveNames{2}, 0);
            setValve(iPump.valveNames{3}, 0);
        catch ME
            thisTag = [myTag ':openPump'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Switch pumping direction
    function switchPumpPirection
        
        PumpDir_Callback(uiH.PumpDir, []);
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the pump
    function runPump(cycles, period, wait)
        % if period and/or cycles are not specified, the values
        % set on the interface are used
        % if wait==1, the function waits until the pump ends running
        
        thisTag = [myTag ':runPump'];
        try
            if exist('cycles', 'var')
                set(pumpUiH.PumpCycles, 'String', cycles);
                PumpCycles_Callback(pumpUiH.PumpCycles, []);
            end
            if exist('period', 'var');
                set(pumpUiH.PumpPeriod, 'String', period);
                PumpPeriod_Callback(pumpUiH.PumpPeriod, []);
            end
            if ~exist('wait', 'var')
                wait = 0;
            end
            drawnow;
            PumpRun_Callback(pumpUiH.PumpRun, []);
            if iPump.TimerFlag
                % Wait for pump to start
                cnt = 0;
                while ~iPump.Running && (cnt < 60)
                    pause(1);
                    %disp(['Waiting for pump to start. iPump.Running = ' num2str(iPump.Running)]);
                    cnt = cnt + 1;
                end %while ~iPump.Running...
                if cnt >= 60
                    msg = 'Timed out waiting for pump to start!';
                    errorHandler(thisTag, [], msg, errorLog, @message, false);
                else
                    %Wait for pump to stop before returning
                    cnt = 0;
                    ptime = iPump.Period*(iPump.SeqLength + 1)*2.5;
                    while wait && iPump.Running && (cnt < (iPump.Cycles/2))
                        pause(ptime);
                        %disp(['Waiting for pump to stop. Pump.Running = ' num2str(Pump.Running)]);
                        cnt = cnt + 1;
                    end %while wait && ...
                    if cnt >= (iPump.Cycles/2)
                        msg = 'Timed out waiting for pump to finish!';
                        errorHandler(thisTag, [], msg, errorLog, @message, false);
                    end %if cnt >= (Pump.Cycles/2)
                end %if cnt >= 60
            end %if Pump.TimerFlag
        catch ME
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get pumping direction
    function dirStr = getPumpDirection
        % dirStr = 'forward' or 'backward'
        
        try
            if iPump.Frwd
                dirStr = 'forward';
            else
                dirStr = 'backward';
            end
        catch ME
            thisTag = [myTag ':getPumpDirection'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set pumping direction
    function setPumpDirection(dir_str)
        % dir_str = 'forward' or 'backward'
        
        try
            switch lower(dir_str)
                case 'forward'
                    iPump.Sequence = iPump.FrwdSequence;
                    iPump.Frwd = 1;
                    set(pumpUiH.PumpDir, 'String', 'Forw');
                    set(pumpUiH.PumpDir, 'BackgroundColor', defaultBackgroundColor);
                case 'backward'
                    iPump.Sequence = iPump.BkwdSequence;
                    iPump.Frwd = 0;
                    set(pumpUiH.PumpDir, 'String', 'Back');
                    set(pumpUiH.PumpDir, 'BackgroundColor', 'red');
                otherwise
                    infodlg('Title', 'pumpDirection', 'string', ['Error!' 10 13 ...
                        'Invalid direction string ' dir_str 10 13 ...
                        'Valid values are ''forward'' and ''backward''']);
            end
            iPump.SeqLength = length(iPump.Sequence);
            drawnow;
        catch ME
            thisTag = [myTag ':pumpDirection'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Pump Period text-box
    function PumpPeriod_Callback(hObject, ~)
        
        per = str2double(get(hObject, 'String'));
        if ~iPump.Running && (per > 0.002)
            iPump.Period = per;
            set(hObject, 'UserData', per);
        else
            per = get(hObject, 'UserData');
            set(hObject, 'String', num2str(per, '%4.2f'));
            set(hObject, 'UserData', per);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Pump cycles text-box
    function PumpCycles_Callback(hObject, ~)
        
        cycles = str2double(get(hObject, 'String'));
        if ~iPump.Running && (cycles > 0)
            iPump.Cycles = fix(cycles);
            set(hObject, 'UserData', fix(cycles));
        else
            cycles = get(hObject, 'UserData');
            set(hObject, 'String', num2str(cycles, '%6.0f'));
            set(hObject, 'UserData', cycles);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Pump direction button
    function PumpDir_Callback(hObject, ~)
        
        if iPump.Frwd
            setPumpDirection('backward');
        else
            setPumpDirection('forward');
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set value of all valves in the pump
    function setPump(values)
        
        try
            setValve(iPump.valveNames{1}, values(1));
            setValve(iPump.valveNames{2}, values(2));
            setValve(iPump.valveNames{3}, values(3));
        catch ME
            thisTag = [myTag ':setPump'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close all valves in the pump
    function PumpClose_Callback(hObject, ~)
        
        setPump([1 1 1]);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open all valves in the pump
    function PumpOpen_Callback(hObject, ~)
        
        setPump([0 0 0]);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Pump Stop button
    function PumpStop_Callback(hObject, ~)
        
        if iPump.Running
            if iPump.TimerFlag
                % We are using the pump timer, so stop it
                stop(iPump.Timer);
            else
                % We are not using the pump timer
                iPump.StopFlag = 1;
            end
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for Pump Run button
    function PumpRun_Callback(hObject, ~)
        
        try
            if ~iPump.Running
                % Get pump valve numbers
                vnum(1) = str2double(get(pumpUiH.Pump1Num, 'String'));
                vnum(2) = str2double(get(pumpUiH.Pump2Num, 'String'));
                vnum(3) = str2double(get(pumpUiH.Pump3Num, 'String'));
                iPump.ValveNumbers = vnum;
                % Get current pump valve states
                iPump.State(1) = get(pumpUiH.Pump1, 'Value');
                iPump.State(2) = get(pumpUiH.Pump2, 'Value');
                iPump.State(3) = get(pumpUiH.Pump3, 'Value');
                
                set(pumpUiH.Pump1, 'Enable', 'off');
                set(pumpUiH.Pump2, 'Enable', 'off');
                set(pumpUiH.Pump3, 'Enable', 'off');
                set(pumpUiH.Pump1Num, 'Enable', 'off');
                set(pumpUiH.Pump2Num, 'Enable', 'off');
                set(pumpUiH.Pump3Num, 'Enable', 'off');
                set(pumpUiH.PumpOpen, 'Enable', 'off');
                set(pumpUiH.PumpClose, 'Enable', 'off');
                set(pumpUiH.PumpRun, 'BackgroundColor', 'red');
                set(pumpUiH.PumpRun, 'String', 'Stop');
                
                set(pumpUiH.PumpRun, 'Callback', pumpStopCallbackH);
                iPump.Running = 1;
                if iPump.Period >= 0.1
                    % Pump using timer
                    iPump.TimerFlag = 1;
                    % Set timer period and number of cycles
                    set(iPump.Timer, 'Period', iPump.Period, ...
                        'TasksToExecute', iPump.Cycles * iPump.SeqLength);
                    % Set pump to start of sequence
                    iPump.SeqIndex = 1;
                    iPump.Counter = iPump.Cycles;
                    % Start the pump
                    start(iPump.Timer);
                else
                    % Pump with a loop
                    iPump.TimerFlag = 0;
                    iPump.StopFlag = 0;
                    per = abs(iPump.Period - 0.002);
                    for ii = iPump.Cycles:-1:1
                        set(pumpUiH.PumpCycles, 'String', ii);
                        for jj = 1:iPump.SeqLength
                            pattern = iPump.Sequence{jj};
                            iPump.vc.setValves(vnum, pattern);
                            pause(per);
                        end
                        if iPump.StopFlag
                            break;
                        end
                    end
                    PumpStopFcn([], []);
                end
            end
        catch ME
            thisTag = [myTag ':PumpRun_Callback'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup after the pump stops
    function PumpStopFcn(hObject, ~)
        
        try
            iPump.Running = 0;
            iPump.StopFlag = 0;
            % Restore original pump state
            iPump.vc.setValves(iPump.ValveNumbers, iPump.State);
            % Restore Run button and cycles display
            set(pumpUiH.PumpCycles, 'String', iPump.Cycles);
            set(pumpUiH.PumpRun, 'BackgroundColor', defaultBackgroundColor);
            set(pumpUiH.PumpRun, 'String', 'Run');
            set(pumpUiH.PumpRun, 'Callback', pumpRunCallbackH);
            % Enable pump valve control
            set(pumpUiH.Pump1, 'Enable', 'on');
            set(pumpUiH.Pump2, 'Enable', 'on');
            set(pumpUiH.Pump3, 'Enable', 'on');
            set(pumpUiH.Pump1Num, 'Enable', 'on');
            set(pumpUiH.Pump2Num, 'Enable', 'on');
            set(pumpUiH.Pump3Num, 'Enable', 'on');
            set(pumpUiH.PumpOpen, 'Enable', 'on');
            set(pumpUiH.PumpClose, 'Enable', 'on');
        catch ME
            thisTag = [myTag ':PumpStopFcn'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the pump with the timer
    function PumpingFcn(hObject, ~)
        
        try
            % Pump with repeated firings of the timer
            pattern = iPump.Sequence{iPump.SeqIndex};
            iPump.vc.setValves(iPump.ValveNumbers, pattern);
            if iPump.SeqIndex == iPump.SeqLength
                iPump.SeqIndex = 1;
                iPump.Counter = iPump.Counter - 1;
                set(pumpUiH.PumpCycles, 'String', iPump.Counter);
            else
                iPump.SeqIndex = iPump.SeqIndex + 1;
            end
        catch ME
            thisTag = [myTag ':PumpingFcn'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end

end
