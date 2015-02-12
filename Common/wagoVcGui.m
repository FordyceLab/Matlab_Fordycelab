function vcObj = wagoVcGui(configFile, slave, masterName, virtual)
% usbVcGui M-file for usbVcGui.fig
% GUI closure for Wago valve controllers.
%
% vcObj = wagoVcGui(configFile, [slave], [masterName], [virtual])
%
% configFile = Full path to the configuration file
% Configuration file is a text file with the IP address of the Wago
% controller and the valve polarities.
% The polarity is separated from the IP address by a TAB
% The polarity of each valve is specified by one letter:
% o = Normally open, c = Normally closed
% i.e.
% 128.3.129.237 <TAB> ccccoooooooo
%
% slave = Optional boolean that specifies if this GUI is a slave to another
%         GUI, so that it cannot be quitted by itself.
%         If omitted, it defaults to false.
% masterName = Optional string with the name of the master window that
%              called this one, and that controls the Quit.
%              If omitted, defaults to 'master'.
% virtual = Optional boolean parameter that when true makes the valve
%           controller not connect to the Wago, but it still accepts all
%           commands.  Defaults to false when absent.
%
% vcObj = Closure object giving access to the methods/functions that interface
%         with the Wago valve controller
%
% Methods:
% --------
%
% All methods below share the following arguments/variables:
%
% number(s) = Valve number(s) (numbers start at 0)
% value(s) = Valve value (0/1)
%
%
% values = vcObj.getValves(numbers)
% Set the state of one or more valves
%
% vcObj.setValves(valveName, value)
% Set the state of one or more valves, regardless of which controller they
% are on.
%
% state = vcObj.getState()
% Returns all the information about the current state of the controller(s):
% state.ip = Number of controllers to use
% state.polarity = Array with valve polarities
%                  polarity(j) = 0 --> jth valve is normally open
%                  polarity(j) = 1 --> jth valve is normally closed
% state.error = Last error code
% state.errorDescr = Description of last error code
%
% vcObj.setMemory(addressOffset, values)
% Write vector values to non-volatile memory, with an address offset.
% addressOffset must be >=0 and <= 12288
%
% values = vcObj.getMemory(addressOffset, totalWords)
% Read vector of values from non-volatile memory, with an address offset.
% addressOffset must be >=0 and <= 12288
%
% vcObj.reset()
% Close communication with controller, re-read config. file, and
% re-open communication with controller.
%
% vcObj.quit([unload])
% Close communication with the Wago controller and close the GUI.
% unload = Optional boolean parameter.
%          true = Unload DLL library used to communicate with controller
%          If omitted, defaults to true.
%
% vcObj.guiUpdate()
% Updates the GUI.
%
% nv = vcObj.getNumValves()
% Returns total number of valves in use in the controller
%
% R. Gomez-Sjoberg, 10/16/11

myName = 'WAGO Valve Controller';
myTag = 'wagoVcGui';

if ~exist('slave', 'var')
    slave = false;
end
if slave && ~exist('masterName', 'var')
    masterName = 'master';
elseif ~slave
    masterName = myName;
end

vc = [];
ipAddress = [];
polarity = [];
numValves = [];

% Where am I?
myFolder = fileparts(which([mfilename '.m']));

% Create logfile in case of errors
pathParts = strsplit(myFolder, filesep);
%we are in INSTALL_DIR/Common; want to write to INSTALL_DIR/Logs
fName = fullfile(pathParts{1:end-1}, 'Logs' ,[date,'_wagoLog.txt']);
wLog = fopen(fName,'a+');

% Display the GUI
% Open GUI figure
figH = openfig([myFolder '\' myTag]);
set(figH, 'Name', myName, 'Tag', myTag);
% Get UI object handles
uiH = getHandles(figH);

% Set UI object callbacks
set(uiH.VcReset, 'Callback', @VcReset_Callback);
set(uiH.VcUpdate, 'Callback', @VcUpdate_Callback);
if ~slave
    set(uiH.VcQuit, 'CallBack', @Quit_Callback);
    set(figH, 'CloseRequestFcn', @Quit_Callback);
else
    set(uiH.VcQuit, 'CallBack', @SlaveQuit_Callback);
    set(uiH.VcQuit, 'Enable', 'off', 'Visible', 'off');
    set(figH, 'CloseRequestFcn', @SlaveQuit_Callback);
    set(uiH.VcReset, 'Enable', 'off');
end
defaultBackgroundColor = get(0, 'defaultUicontrolBackgroundColor');

if virtual
    set(uiH.BitDisplay, 'Enable', 'on', 'Visible', 'on');
else
    set(uiH.BitDisplay, 'Enable', 'off', 'Visible', 'off');
end

% Initialize the communication
objectInit;

% Update and display figure
VcUpdate_Callback;
set(figH, 'Visible', 'on');

% Create Analog Valves Gui
% This has been commented out at Stanford 1/2015 by PMF to reflect
% the fact that we don't use the analog valves Gui
% aVcObj = analogValvesGui(vc, @objectClose);

vcObj = [];
% Assign public methods
vcObj.getNumValves = @getNumValves;
vcObj.getValves = @getValves;
vcObj.setValves = @setValves;
vcObj.getMemory = vc.getMemory;
vcObj.setMemory = vc.setMemory;
vcObj.getState = @getState;
vcObj.quit = @objectClose;
vcObj.guiUpdate = @VcUpdate_Callback;
vcObj.reset = @objectReset;
% I commented out these lines because we are not using the analog valve
% controls PMF 1/2015 Stanford
% vcObj.setOutputPressures = aVcObj.setOutputPressures;
% vcObj.getOutputPressures = aVcObj.getOutputPressures;
% vcObj.calibrate = aVcObj.calibrate;
% vcObj.setLabels = aVcObj.setLabels;
% vcObj.help = aVcObj.help;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quit callback
    function Quit_Callback(~, ~)
        
        opt = YesNoQuestion('Title', 'Wago Valve Controller', 'String', ...
            'Are you sure you want to quit?');
        switch lower(opt)
            case 'yes'
                objectClose(true);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on menu select in Quit or close request when running as slave.
    function SlaveQuit_Callback(~, ~)
        
        infodlg('Title', 'Wago Valve COntroller', 'String', ...
            ['To close this interface use the Quit button on the ' ...
            masterName ' window']);
%         objectClose(true);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes when Reset button is pressed, or when the reset method is
% invoked, iff the GUI is displayed
    function VcReset_Callback(~, ~)
        
        set(uiH.VcReset, 'BackgroundColor', 'red');
        objectReset;
        set(uiH.VcReset, 'BackgroundColor', defaultBackgroundColor);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes when Reset button is pressed, or when the reset method is
% invoked, iff the GUI is displayed
    function VcUpdate_Callback(~, ~)
        
        set(uiH.VcUpdate, 'BackgroundColor', 'red');
        [err, descr] = vc.error();
        statusStr = [num2str(err) ' - ' descr];
        set(uiH.VcStatus, 'String', statusStr);
        if err
            set(uiH.VcStatus, 'BackgroundColor', 'red');
        else
            set(uiH.VcStatus, 'BackgroundColor', 'white');
        end
        if virtual
            displayBits;
        end
        set(uiH.VcUpdate, 'BackgroundColor', defaultBackgroundColor);
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns total number of active valves
    function n = getNumValves
        
        n = numValves;
    end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display state of bits on the GUI
    function displayBits
        
            values = vc.getValves(0:(numValves-1));
            valStr = num2str(values);
            set(uiH.BitDisplay, 'String', valStr(valStr ~= ' '));
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Connection to controller's getValves function
    function v = getValves(numbers)
        v = vc.getValves(numbers);
        if virtual
            displayBits;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Connection to controller's setValves function
% PMF amended this to include a check to see if the actual valve
% setting matches the desired valve setting and an attempt to retry if it
% doesn't
    function setValves(numbers, values)
        vc.setValves(numbers, values);
        % disp(['Desired config is: ',num2str(numbers)])
        % check if Wago set the valves correctly
        vs = vc.getValves(numbers);
        if ~isequal(values,vs)
            disp('Wago did not get the setValve commands correctly!')
            fprintf(wLog,[datestr(now),' Wago did not get the setValve commands correctly!\r\n'])
            % and try again to set valves
            vc.setValves(numbers, values);
        end
        if virtual
            displayBits;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns internal state of the controller
    function state = getState

        [err, descr] = vc.error();
        state.ip = ipAddress;
        state.polarity = polarity;
        state.error = err;
        state.errorDescr = descr;
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resets the controller
    function objectReset

        % Close valve system
        vc.close();
        vc = [];
        clear('wago');
        % delete(aVcObj.figure);
        % Initialize the valves
        objectInit;
        % aVcObj = analogValvesGui(vc, @objectClose);

    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads configuration file and initializes connection with valve controllers
    function objectInit
        
        % Read valve configuration file
        [ipAddress, polarity] = wago_read_config(configFile);
        if virtual
            ipAddress = 'Virtual';
        end
        numValves = length(polarity);
        % Open valve controllers
        vc = wagoNModbus(ipAddress, polarity, virtual);
        % Update GUI
        set(uiH.VcIp, 'String', ipAddress);
        polStr = 99*ones(1, numValves).*polarity + 111*ones(1, numValves).*(~polarity);
        set(uiH.VcPolarity, 'String', [' ' char(polStr)]);
        VcUpdate_Callback;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close communication with the controllers and close the GUI if displayed.
    function objectClose(unload)
        
        if nargin == 0
            unload = true;
        end
        
        % delete(aVcObj.figure);
        vc.close(unload);
        % fclose(wLog);
        
        delete(figH);
    end

end
