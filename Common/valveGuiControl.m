function valves = valveGuiControl(vcType, virtual, uiH, valveNumFile, masterName, errorLog)
% Generic GUI valve control system closure
% To be used in conjuction with a GUI for a specific chip design
%
% valves = chipGuiControl(vcType, virtual, uiH, inputFolder, masterName, errorLog)
%
% vcType = Specifies type of valve controller to use: 'wago' or 'usb' slave
% virtual = Boolean parameter that when true makes the valve
%           controller be virtualized, but it still accepts all
%           commands.
% uiH = Structure with handles to all objects in the GUI figure.
%       Valve buttons and number boxes that belong to an input manifold
%       must have Tags that begin with 'i' followed by a number
%       (i.e. i12 & i12num).
% inputFolder = Full path to folder where the ValveNumbers.txt file is
%               located
% masterName = String with the name of the master window that
%              called this one, and that controls the Quit.
%              If empty, defaults to 'master'.
% errorLog = Object/closure that handles error logging. Pass [] if no
%            logging is needed.
%
% R. Gomez-Sjoberg, 11/28/11

fileSeparator = filesep();

myName = 'Valve Controller';
myTag = 'valveGuiControl';

% Where am I?
myFolder = fileparts(which([myTag '.m']));

% Initialize internal data structure
iValves = [];
iValves.vc = [];

% Start valve controller
switch lower(vcType)
    case 'wago'
        iValves.vcConfigFileName = [fileparts(which('wagoVcGui.m')) fileSeparator 'WagoController.txt'];
        % Start Wago controller
        iValves.vc = wagoVcGui(iValves.vcConfigFileName, true, masterName, virtual);
        disp('Starting wagoVcGui')
    case 'usb'
        iValves.vcConfigFileName = [fileparts(which('usbVcGui.m')) fileSeparator 'USBControllers.txt'];
        % Start USB valve controllers
        iValves.vc = usbVcGui(iValves.vcConfigFileName, true, masterName, virtual);
    otherwise
        beep;
        infodlg('Title', 'Valve Control', 'String', ...
            ['Invalid valve controller type: ' vcType]);
        valvesClose;
end

% Create sub-function handles
valveCallbackH = @valve_Callback;
valveNumCallbackH = @valveNum_Callback;

% Initialize valve control
valvesInit;

% Methods
valves.getVc = @getVc;
valves.getMuxData = @getMuxData;
valves.getInputsNumber = @getInputsNumber;
valves.getNumber = @getNumValves;
valves.getNames = @getValveNames;
valves.closeAll = @closeAll;
valves.openAll = @openAll;
valves.openValve = @openValve;
valves.openValves = @openValves;
valves.closeValve = @closeValve;
valves.closeValves = @closeValves;
valves.getValve = @getValve;
valves.setValve = @setValve;
valves.setValves = @setValves;
valves.getValveNumbers = @getValveNumbers;
valves.getFolder = @getFolder;
valves.quit = @valvesClose;
valves.reset = @valvesReset;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the handles to the valve controller
    function vc = getVc
        vc = iValves.vc;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the folder where this m file is stored
    function folder = getFolder
        folder = myFolder;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the number of valves
    function nv = getNumValves
        nv = iValves.num;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns a list of valve names
    function names = getValveNames
        names = iValves.names;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns MUX data
    function mux = getMuxData
        mux = iValves.mux;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns inputs data
    function ni = getInputsNumber
        ni = iValves.inputs.number;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close all the valves on the chip
    function closeAll()
        
        for ii = iValves.openAllCloseAllNames'
            setValve(ii{1}, 1);
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open all the valves on the chip
    function openAll()
        
        for ii = iValves.openAllCloseAllNames'
            setValve(ii{1}, 0);
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creation function for all valve buttons
    function valve_CreateFcn(hObject)
        
        set(hObject, 'BackgroundColor', [0 0.2 0]);
        set(hObject, 'Value', 0);
        set(hObject, 'UserData', 0);
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for all non-input manifold valve buttons
    function valve_Callback(hObject, ~)
        
        v = get(hObject, 'Value');
        tag = get(hObject, 'Tag');
        setValve(tag, v);
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creation function for all valve numbers
    function valveNum_CreateFcn(hObject)
        
        if ispc
            set(hObject,'BackgroundColor','white');
        else
            set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
        end
        set(hObject, 'String', 'x');
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback function for all valve numbers
    function valveNum_Callback(hObject, ~)
        
        tag = get(hObject, 'Tag');
        name = tag(1:end-3);
        v = str2double(get(hObject, 'String'));
        if (v >= 0) && ((v/24) < iValves.vc.num)
            set(uiH.(name), 'UserData', v);
        else
            v = get(uiH.(name), 'UserData');
            set(hObject, 'String', num2str(v));
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset valve control system
    function valvesReset

       iValves.vc.reset();
       valvesInit;
       
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close valve control system
    function valvesClose
        
        try
            message('Closing valve control system');
            % Close valve controllers and unload library
            if ~isempty(iValves) && ~isempty(iValves.vc)
                iValves.vc.quit(true);
                iValves.vc = [];
                switch vcType
                    case 'wago'
                        clear('wagoVcGui');
                    case 'usb'
                        clear('usbVcGui');
                end
            end
        catch ME
            thisTag = [myTag ':valvesClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize valve values and numbers as read from file
    function valvesInit
        
        message('Initializing Valves');
        iValves.number = 0;
        iValves.names = {};
        iValves.inputs.number = 0;
        iValves.openAllCloseAllNumber = 0;
        iValves.openAllCloseAllNames = {};
        try
            % Update VC display
            iValves.vc.guiUpdate;
            % Read valve numbers and startup values
            iValves.numFileName = valveNumFile;
            readValves(iValves.numFileName);
        catch ME
            thisTag = [myTag ':valvesInit'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read valve values and numbers from file
    function readValves(fname)
        
        if ~exist(fname, 'file')
            error(['Valve number file "' fname '" does not exist!']);
        else
            [names nums vals] = textread(fname, '%s\t%u\t%u\n', ...
                'whitespace', '\r\n\t', 'commentstyle', 'matlab');
            nn = length(names);
            if ~nn
                error('Valve number file is empty!');
            else
                for ii = 1:nn
                    value = vals(ii);
                    number = nums(ii);
                    name = names{ii};
                    switch lower(name)
                        case 'mux'
                            % Set MUX
                            iValves.mux.first = number;
                            iValves.mux.initialState = value;
                        case 'xxxx'
                            if (value == 1) || (value == 0)
                                iValves.vc.setValves(number, value);
                            end
                        otherwise
                            initValve(name, number, value);
                    end
                end
            end
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize number and value of one button-controlled valve
    function initValve(name, number, value)
        
        switch name
            case fieldnames(uiH)
                iValves.number = iValves.number + 1;
                iValves.names{iValves.number, 1} = name;
                % If valve is not part of an input manifold, add to list of
                % valves that are actuated by openAll and closeAll
                % functions
                if isempty(regexp(name, '^(i[0-9]+)$', 'once'))
                    iValves.openAllCloseAllNumber = iValves.openAllCloseAllNumber + 1;
                    iValves.openAllCloseAllNames{iValves.openAllCloseAllNumber, 1} = name;
                    set(uiH.(name), 'Callback', valveCallbackH);
                else
                    iValves.inputs.number = iValves.inputs.number + 1;
                end
                set(uiH.([name 'Num']), 'Callback', valveNumCallbackH);
                % Set valve number in GUI
                set(uiH.(name), 'UserData', number);
                set(uiH.([name 'Num']), 'String', num2str(number));
                if (value == 1) || (value == 0)
                    setValve(name, value);
                end
            otherwise
                str = ['Error!' 10 13 'Invalid valve name: ' name];
                infodlg('Title', 'Initialize Valve', 'String', str);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set value of one button-controlled valve Reads value back from controller
% and uses it to update button display
    function setValve(name, value)
        
        try
            switch name
                case iValves.names
                    number = get(uiH.(name), 'UserData');
                    iValves.vc.setValves(number, value);
                    rd_value = iValves.vc.getValves(number);
                    set(uiH.(name), 'Value', rd_value);
                    if rd_value
                        % Valve is closed
                        set(uiH.(name), 'BackgroundColor', [0 1 0]);
                    else
                        % Valve is open
                        set(uiH.(name), 'BackgroundColor', [0 0.2 0]);
                    end
                    drawnow;
                otherwise
                    str = ['Error!' 10 13 'Invalid valve name: ' name];
                    infodlg('Title', 'Set Valve', 'String', str);
            end
        catch ME
            thisTag = [myTag ':setValve'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get value of one button-controlled valve Reads actual value from the
% valve controller, not from the interface It also updates valve button on
% the interface
    function value = getValve(name)
        
        try
            switch name
                case iValves.names
                    number = get(uiH.(name), 'UserData');
                    value = iValves.vc.getValves(number);
                    set(uiH.(name), 'Value', value);
                    if value
                        % Valve is closed
                        set(uiH.(name), 'BackgroundColor', [0 1 0]);
                    else
                        % Valve is open
                        set(uiH.(name), 'BackgroundColor', [0 0.2 0]);
                    end
                    drawnow;
                otherwise
                    str = ['Error!' 10 13 'Invalid valve name: ' name];
                    infodlg('Title', 'Get Valve', 'String', str);
            end
        catch ME
            thisTag = [myTag ':getValve'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return array of numbers corresponding to the valve names provided as
% a cell array of strings
    function numbers = getValveNumbers(names)
        try
            nn = length(names);
            numbers = zeros(1, nn);
            for jj = 1:nn
                name = names{jj};
                switch name
                    case iValves.names
                        numbers(jj) = get(uiH.(name), 'UserData');
                otherwise
                    str = ['Error!' 10 13 'Invalid valve name: ' name];
                    infodlg('Title', 'Get Valve Numbers', 'String', str);
                end
            end
        catch ME
            thisTag = [myTag ':getValveNumbers'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
    end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simultaneously actuate a set of valves
% names = Cell array of strings with valve names
% values = Array of values for the valves (0 = open, 1 = closed)
    function setValves(names, values)
        try
            numbers = getValveNumbers(names);
            iValves.vc.setValves(numbers, values);
            rd_value = iValves.vc.getValves(numbers);
            for jj = 1:length(names)
                set(uiH.(names{jj}), 'Value', rd_value(jj));
                        if rd_value(jj)
                            % Valve is closed
                            set(uiH.(names{jj}), 'BackgroundColor', [0 1 0]);
                        else
                            % Valve is open
                            set(uiH.(names{jj}), 'BackgroundColor', [0 0.2 0]);
                        end
                        drawnow;
            end
        catch ME
            thisTag = [myTag ':setValves'];
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
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, true);
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open one valve specified by name
    function openValve(name)
        setValve(name, 0);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close one valve specified by name
    function closeValve(name)
        setValve(name, 1);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open multiple valves specified by name
    function openValves(names)
        nn = length(names);
        setValves(names, zeros(1, nn));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close multiple valves specified by name
    function closeValves(names)
        nn = length(names);
        setValves(names, ones(1, nn));
    end

end
