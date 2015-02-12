function [mfcs] = mfcsEZGui(serialNums, slave, masterName, errorLog)
% GUI for controlling two MFCS-EZ devices, providing 8 programmable
% pressure channels. The serial numbers of the devices are passed as
% inputs. serialNum1 is channels 1-4; serialNum2 is channels 5-8
%
% This requires that the Fluigent Matlab toolbox is installed.
%
% mfcs = mfcsGui(serialNum1, serialNum2, slave, masterName, errorLog)
%
% serialNum1 = Serial number of device1 (double) - controls channels 1-4
% serialNum2 = Serial number of device2 (double) - controls channels 5-8
% slave = Boolean that specifies if this GUI is a slave to another
%         GUI, so that it cannot be quitted by itself.
%         If omitted, it defaults to false.
% masterName = String with the name of the master window that
%              called this one, and that controls the Quit.
% errorLog = Object/closure that handles error logging. Pass [] if no
%            external logging is setup.
%-------------------------------------------------------------------------
% Methods:
%--------
% mfcs.quit()
%     Close the interface when is not working as slave
%--------
% mfcs.getStatus()
%   Get MFCS status:
%       • -1= Trouble in the MFCS connections (USB or electric
%           aperture)
%       • 0= MFCS is reset. MFCS needs to be manually rearmed
%           (press green switch on the front panel)
%       • 1= Normal
%       • 2= Pressure Supply Overpressure
%       • 3= MFCS needs to be manually rearmed after overpressure
%           (press green switch on the front panel)
%--------
% mfcs.readChannelPressure(Channel)
%   Get the pressure value and the measure time (ms) of the
%   specified channel or channels (from 1 to 8).
%--------
% mfcs.readChannelInformation(Channel)
%   Get the characteristics of the specified channel or channels:
%       • Pressure Units (0= no captor, 1= inches of water, 2= PSI)
%       • Maximum Pressure range (in the specified units)
%       • Zero pressure value of the captor (unsigned 12 bits)
%       • Pressure value (unsigned 12 bits)
%       • Chrono value (unsigned 16 bits)
%--------
% mfcs.setChannelsPressure(Channel,Pressure)
%   Set the regulated pressure for the specified channel or channels (from
%   1 to 8).
%--------
% mfcs.setAlpha(Channel,Alpha)
%   Set the alpha value (default value =5) for the specified channel or
%   channels (from 1 to 8). Alpha is linked to the proportional value of the PID.
%--------
% mfcs.setPurge(on)
%       • on = tru: Connect the channel 1 directly to the pressure supply when. This
%                 function should be used with care, as it can cause damage to the
%                 microsystems connected.
%       • on = false: set purge off
%--------
% mfcs.getPurge()
%   Get purge status:
%       • TRUE = purge ON,
%       • FALSE = purge OFF
%--------
% mfcs.setElectroValveAperture(Channel,EV)
%   Set the electrovalve aperture (%) for the specified channel or channels
%   (from 1 to 8). The manual control of the electrovalve is not
%   recommended and the output pressure is no longer regulated.
%--------
% mfcs.setZero(Channel,Zero)
%   Save in the EEPROM the zero pressure value of the specified
%   channel.
%--------
% mfcs.psiOn(unit)
%     Tells wether parameters are given in PSI or mBar.
%     if unit == 1 then PSI on
%     if unit == 0 then PSI off
%--------
% mfcs.functions()
%     Use this method to see the functions contained in the .dll file.
%--------
% mfcs.updateGui()
%     Use this method to update the GUI interface.
% mfcs.updateLabels()
%     Reads a .txt file with the labels for each channel and updates them.
%-------------------------------------------------------------------------
%Changes vs previous versions
% Old method name           |      New method name
%   mfcs.readChannel        |       mfcs.readChannelPressure
%   mfcs.dataChannel        |       mfcs.readChannelInformation
%   mfcs.setAuto            |       mfcs.setChannelsPressure
%   mfcs.setManual          |       mfcs.setElectroValveAperture
%   mfcs.setPurgeOn         |       mfcs.setPurge(1)
%   mfcs.setPurgeOff        |       mfcs.setPurge(0)
%
%  Created by C. Diaz-Botia at LBNL on 02/03/11
%  Last modifed on 01/25/11 by Rafael Gómez-Sjöberg and Camilo Díaz-Botía
%  Modified on 06/06/12 by Camilo Díaz-Botía
%  Rewritten for MFCS-EZ units on 01/05/2015 by Kurt Thorn at UCSF


myName = 'MFCS-EZ Control';
myTag = 'mfcsGui';

if ~exist('slave', 'var')
    slave = false;
end
if slave && ~exist('masterName', 'var')
    masterName = 'master';
elseif ~slave
    masterName = myName;
end

myFolder = fileparts(which([myTag '.m']));

if isempty(errorLog)
    % Space-less name for error logging
    errorLogFileName = [myFolder '\' myTag '_ERRORS.txt'];
    % Initialize error logging
    errorLog = eventLog(['Error log file for ' myName], errorLogFileName, true);
end

% Display the GUI
% Open GUI figure
myfigH = openfig([myFolder '\' myTag]);
set(myfigH, 'Name', myName, 'Tag', myTag);
% Get UI object handles
myUiH = getHandles(myfigH);

mfcs.getStatus = @getStatus;
mfcs.readChannelPressure = @readChannelPressure;
mfcs.readChannelInformation = @readChannelInformation;
mfcs.setChannelsPressure = @setChannelsPressureScript;
mfcs.setElectroValveAperture = @setElectroValveApertureScript;
mfcs.setAlpha = @setAlphaScript;
mfcs.setZero = @setZero;
mfcs.setPurge = @setPurgeScript;
mfcs.getPurge = @getPurgeScript;
mfcs.psiOn = @psiOnScript;
mfcs.functions = @functions;
mfcs.updateGui = @updateGui;
mfcs.updateLabels = @updateLabels;
mfcs.quit = @quit;
mfcs.resest = @Reset_Callback;

%Define labels file
labelsFileName = [myFolder '\ChannelLabels.txt'];

numberOfChannels = 8;

% Set Callbacks for new GUI
set(myUiH.CheckStatusButton, 'Callback', @CheckStatusButton_Callback);
set(myUiH.PsiCheckbox, 'Callback', @PsiCheckbox_Callback);
set(myUiH.MbarCheckbox, 'Callback', @MbarCheckbox_Callback);
set(myUiH.PurgeCheckbox, 'Callback', @PurgeCheckbox_Callback);
set(myUiH.CheckPurgeButton, 'Callback', @CheckPurgeButton_Callback);
set(myUiH.About, 'Callback', @About_Callback);
set(myUiH.EmergencyStop, 'Callback', @EmergencyStop_Callback);
set(myUiH.Reset, 'Callback', @Reset_Callback);
if ~slave
    set(myUiH.Quit, 'Callback', @Quit_Callback);
    set(myfigH, 'CloseRequestFcn', @Quit_Callback);
else
    set(myUiH.Quit, 'Callback', @SlaveQuit_Callback);
    set(myUiH.Quit, 'Enable', 'off', 'Visible', 'off');
    set(myfigH, 'CloseRequestFcn', @SlaveQuit_Callback);
end

for jj=1:numberOfChannels
    slider = strcat('ChannelSlider',num2str(jj));
    set(myUiH.(slider),'Callback',@ChannelSlider_Callback);
    
    desiredPressure = strcat('DesiredPressure',num2str(jj));
    set(myUiH.(desiredPressure), 'Callback', @DesiredPressure_Callback);
    
    alphaChannel = strcat('AlphaChannel', num2str(jj));
    set(myUiH.(alphaChannel), 'Callback', @AlphaChannel_Callback);
    
    channelLabel = strcat('ChannelLabel',num2str(jj));
    set(myUiH.(channelLabel), 'Callback', @ChannelLabel_Callback);
    
    sliderStep = strcat('SliderStep',num2str(jj));
    set(myUiH.(sliderStep),'Callback',@SliderStep_Callback);
    
    clear slider desiredPressure alphaChannel channelLabel sliderStep;
end

%Common variable
psi = [];
psiPrevious = [];
channelInformation = [];
channelSlider = [];
realPressure = [];
maxPressure = [];
desiredPressure = [];
alphaChannel = [];
mfcsTimer = [];
mfcsHandle = [];

objectInit;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Object Initialization
    function objectInit()
        % Initialize MFCS USB connection        
        for ii=1:numel(serialNums)
            mfcsHandle(ii) = mfcs_init(serialNums(ii));
        end
        
        %Update labels
        updateLabels;
        % Read channel information and set default values
        psi = true;
        psiPrevious = true;
        set(myUiH.PsiCheckbox, 'value', 1);
        set(myUiH.MbarCheckbox, 'value', 0);
        channelInformation = mfcs.readChannelInformation(1:8);
        channelStatus = mfcs.readChannelPressure(1:8);
        
        for jj=1:numberOfChannels
            channelSlider = strcat('ChannelSlider',num2str(jj));
            realPressure = strcat('RealPressure', num2str(jj));
            maxPressure = strcat('MaxPressure',num2str(jj));
            desiredPressure = strcat('DesiredPressure', num2str(jj));
            alphaChannel = strcat('AlphaChannel', num2str(jj));
            sliderStep = strcat('SliderStep', num2str(jj));
            
            set(myUiH.(channelSlider),'max',channelInformation(3,jj));
            set(myUiH.(maxPressure),'string',num2str(channelInformation(3,jj)));
            set(myUiH.(realPressure),'string',num2str(channelStatus(2,jj)));
            set(myUiH.(desiredPressure), 'string', num2str(channelStatus(2,jj)));
            set(myUiH.(desiredPressure), 'Userdata', num2str(channelStatus(2,jj)));
            set(myUiH.(alphaChannel), 'Userdata', num2str(5));
            step = get(myUiH.(channelSlider),'SliderStep');
            set(myUiH.(sliderStep), 'string',step(1)*(get(myUiH.(channelSlider),'max')-...
                get(myUiH.(channelSlider),'min')));
            if channelStatus(2,jj)<0
                set(myUiH.(channelSlider), 'value', 0);
            else
                set(myUiH.(channelSlider), 'value', channelStatus(2,jj));
            end
            clear channelSlider realPressure maxPressure desiredPressure;
        end
        
        mfcsTimer = timer('Period', 4, 'Name', 'MFCStimer', ...
            'ExecutionMode', 'fixedRate', 'BusyMode', 'drop');
        mfcsTimer.TimerFcn = {@mfcsTimerFcn,'timer'};
        start(mfcsTimer);
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quit callback
    function Quit_Callback(~, ~)
        
        opt = YesNoQuestion('Title', myName, 'String', ...
            'Are you sure you want to quit?');
        switch lower(opt)
            case 'yes'
                quit();
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset callback
    function Reset_Callback(~, ~)
        %Stop object
        % Stop mfcsTimer
        stop(mfcsTimer);
        pause(1);
        delete(mfcsTimer);
        pause(0.5);
        % close MFCS communications
        for ii=1:numel(mfcsHandle)
            mfcs_close(mfcsHandle(ii));
        end
        %Restart object
        objectInit();
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on menu select in Quit or close request when running as slave.
    function SlaveQuit_Callback(~, ~)
        
        infodlg('Title', myName, 'String', ...
            ['To close this interface use the Quit button on the ' ...
            masterName ' window']);
        %         objectClose(true);
    end

% Close USB connection
    function quit
        % Stop mfcsTimer
        stop(mfcsTimer);
        pause(1);
        delete(mfcsTimer);
        pause(0.5);
        delete(myfigH);
        % close MFCS communications
        for ii=1:numel(mfcsHandle)
            mfcs_close(mfcsHandle(ii));
        end
    end

% Set purge on all MFCS controllers
    function setPurge(state)
        if state
            for ii = 1:numel(mfcsHandle)
                mfcs_set_purge_on(mfcsHandle(ii));
            end
        else
            for ii = 1:numel(mfcsHandle)
                mfcs_set_purge_off(mfcsHandle(ii));
            end
        end        
    end

% Get purge status
    function purgeState = getPurge
        %returns true if any MFCS is set to purge
        for ii = 1:numel(mfcsHandle)
            p = mfcs_get_purge(mfcsHandle(ii));
        end
        purgeState = any(p);
    end

% Get status
    function state = getStatus
        state = [];
        for ii = 1:numel(mfcsHandle)
            S = mfcs_get_status(mfcsHandle(ii));
            if S == 0
                state = [state 'MFCS' num2str(ii) ' is reset, needs to be manually rearmed'];
            else
                state = [state 'MFCS' num2str(ii) ' normal '];
            end
        end
    end

% Read channel
    function states = readChannelPressure(channels)
        channelsLength = length(channels);
        try
            for ii=1:channelsLength
                if channels(ii)<0 || channels(ii)>8
                    ME = MException('Input not valid',...
                        'Channel(s) out of range');
                    throw(ME)
                end
            end
            if channelsLength>0 && channelsLength<9
                pressures = zeros(1, channelsLength) -1;
                chronos = zeros(1, channelsLength) -1;
                
                for ii=1:channelsLength
                    [H, chan] = mapChannelToController(channels(ii));
                    [pressures(ii), chronos(ii)] = mfcs_read_chan(H, chan);
                    pause(0.1)
                end
                
                states=[double(channels);double(pressures);double(chronos)];
                
                if psi == 1
                    for ii=1:channelsLength
                        states(2,ii) = states(2,ii)/68.9475;
                    end
                end
            else
                ME = MException('Input not valid',...
                    'Number of channels out of range');
                throw(ME)
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end

% Data channel
    function states = readChannelInformation(channels)
        channelsLength = length(channels);
        try
            for ii=1:channelsLength
                if channels(ii)<=0 || channels(ii)>8
                    ME = MException('Input not valid',...
                        'Channel(s) out of range');
                    throw(ME)
                end
            end
            
            %initialize return values to -1
            if channelsLength>0 && channelsLength<9
                units = zeros(1, channelsLength) -1;
                maximum = zeros(1, channelsLength) -1;
                zero = zeros(1, channelsLength) -1;
                measure = zeros(1, channelsLength) -1;
                chrono = zeros(1, channelsLength) -1;
                
                %query controller
                for ii=1:channelsLength
                    [H, chan] = mapChannelToController(channels(ii));
                    [units(ii), maximum(ii), zero(ii), measure(ii), chrono(ii)] = mfcs_data_chan(H, chan);
                    pause(0.1)
                end
                
                states = [double(channels);...
                    double(units);...
                    double(maximum);...
                    double(zero);...
                    double(measure);...
                    double(chrono)];
                
                if psi == 0
                    for ii=1:8
                        if states(2,ii) == 2
                            states(3,ii) = 68.9475*states(3,ii);
                        end
                    end
                else
                    for ii=1:8
                        if states(2,ii) == 1
                            states(3,ii) = states(3,ii)/68.9475;
                        end
                    end
                end
            else
                ME = MException('Input not valid',...
                    'Number of channels out of range');
                throw(ME)
                
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end

% Set auto
    function setChannelsPressure(channels, pressures)
        try
            channelsLength = length(channels);
            pressuresLength = length(pressures);
            for ii=1:channelsLength
                if channels(ii)<=0 || channels(ii)>8
                    ME = MException('Input not valid',...
                        'Channel(s) out of range');
                    throw(ME)
                end
            end
            
            if psi == 1
                pressures(ii)=68.9475.*pressures(ii);
            end
            
            if channelsLength>0 && channelsLength<9
                if channelsLength == pressuresLength
                    for ii=1:channelsLength
                        [handle, outChannel] = mapChannelToController(channels(ii));
                        mfcs_set_auto(handle, pressures(ii), outChannel);
                    end                    
                else
                    ME = MException('Input not valid',...
                        'Pressure array length should match Channel array length');
                    throw(ME)
                end
            else
                ME = MException('Input not valid',...
                    'Number of channels out of range');
                throw(ME)
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end

% Set alpha
    function mfcsSetAlpha(channels, alphas)
        try
            channelsLength = length(channels);
            pressuresLength = length(alphas);
            for ii=1:channelsLength
                if channels(ii)<=0 || channels(ii)>8
                    ME = MException('Input not valid',...
                        'Channel(s) out of range');
                    throw(ME)
                end
            end
            if channelsLength>0 && channelsLength<9
                if channelsLength == pressuresLength
                    for ii=1:channelsLength
                        [handle, outChannel] = mapChannelToController(channels(ii));
                        mfcs_set_alpha(handle, outChannel, alphas(ii));
                        pause(0.1);
                    end
                else
                    ME = MException('Input not valid',...
                        'Alpha array length should match Channel array length');
                    throw(ME)
                end
            else
                ME = MException('Input not valid',...
                    'Number of channels out of range');
                throw(ME)
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end

% Set manual
    function setElectroValveApertureScript(channels, evs)
        try
            channelsLength = length(channels);
            pressuresLength = length(evs);
            for ii=1:channelsLength
                if channels(ii)<=0 || channels(ii)>8
                    ME = MException('Input not valid',...
                        'Channel(s) out of range');
                    throw(ME)
                end
            end
            if channelsLength>0 && channelsLength<9
                if channelsLength==pressuresLength
                    for ii=1:channelsLength
                        [handle, outChannel] = mapChannelToController(channels(ii));
                        mfcs_set_manual(handle, evs(ii), outChannel);
                        pause(0.1);
                    end
                else
                    ME = MException('Input not valid',...
                        'EV array length should match Channel array length');
                    throw(ME)
                end
            else
                ME = MException('Input not valid',...
                    'Number of channels out of range');
                throw(ME)
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end

% Set zero
    function setZero(channels, zeros)
        try
            channelsLength = length(channels);
            pressuresLength = length(zeros);
            for ii=1:channelsLength
                if channels(ii)<=0 || channels(ii)>8
                    ME = MException('Input not valid',...
                        'Channel(s) out of range');
                    throw(ME)
                end
            end
            if channelsLength>0 && channelsLength<9
                if channelsLength == pressuresLength
                    for ii=1:channelsLength
                        [handle, outChannel] = mapChannelToController(channels(ii));
                        mfcs_set_zero(handle, outChannel, zeros(ii));
                    end
                else
                    ME = MException('Input not valid',...
                        'Zero array length should match Channel array length');
                    throw(ME)
                end
            else
                ME = MException('Input not valid',...
                    'Number of channels out of range');
                throw(ME)
            end
        catch ME
            thisTag = [myTag ':objectClose'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
    end

    function psiOn(unit)
        if unit == 1
            psi = true;
        elseif unit ==0
            psi = false;
        else
            psi = true;
        end
    end

    function [handle, outChannel] = mapChannelToController(inChannel)
        %maps a channel number from 1 to 8 to a controller handle and the
        %channel number on that controller (from 1 to 4)
        channelsPerController = 4; %number of channels on each controller
        inChannel = inChannel - 1;
        outChannel = mod(inChannel, channelsPerController) + 1;
        controllerNum = floor(inChannel/channelsPerController) + 1;
        handle = mfcsHandle(controllerNum);
    end

% % Funtions for MFCS GUI interface

    function ChannelSlider_Callback(hObject,~)
        tag = get(hObject,'Tag');
        channel = str2num(tag(end));
        newPressure = get(hObject,'value');
        
        setChannelsPressure(channel,newPressure);
        mfcs.updateGui(tag(1:end-1), channel, newPressure);
    end

    function DesiredPressure_Callback(hObject,~)
        tag = get(hObject,'Tag');
        channel = str2num(tag(end));
        newPressure = str2num(char(get(hObject,'string')));
        oldPressure = get(hObject,'Userdata');
        sliderChannel = strcat('ChannelSlider', num2str(channel));
        if isempty(newPressure)
            set(hObject,'string',oldPressure);
        elseif (newPressure < 0) || (newPressure > get(myUiH.(sliderChannel),'max'))
            set(hObject,'string',oldPressure);
        else
            set(hObject,'Userdata',num2str(newPressure));
            setChannelsPressure(channel,newPressure);
            mfcs.updateGui(tag(1:end-1), channel, newPressure);
        end
    end

    function AlphaChannel_Callback(hObject,~)
        tag = get(hObject,'Tag');
        channel = str2num(tag(end));
        alphaChannel = strcat('AlphaChannel', num2str(channel));
        newAlpha = str2num(get(hObject,'string'));
        oldAlpha = get(hObject,'Userdata');
        
        if isempty(newAlpha)
            set(myUiH.(alphaChannel),'string',oldAlpha);
        elseif newAlpha<0 || newAlpha>255
            set(myUiH.(alphaChannel),'string',oldAlpha);
        else
            set(myUiH.(alphaChannel),'Userdata',num2str(newAlpha));
            mfcsSetAlpha(channel, newAlpha);
        end
    end

    function SliderStep_Callback(hObject,~)
        tag = get(hObject,'Tag');
        channel = str2num(tag(end));
        newStep = str2num(char(get(hObject,'string')));
        oldStep = get(hObject,'Userdata');
        sliderStep = strcat('SliderStep', num2str(channel));
        sliderChannel = strcat('ChannelSlider', num2str(channel));
        if isempty(newStep)
            set(hObject,'string',oldStep);
        elseif (newStep < 0) || (newStep > get(myUiH.(sliderChannel),'max'))
            set(hObject,'string',oldStep);
        else
            set(hObject,'Userdata',num2str(newStep));
            newSliderStep = get(myUiH.(sliderChannel),'SliderStep');
            newSliderStep(1) = newStep/(get(myUiH.(sliderChannel),'max')-get(myUiH.(sliderChannel),'min'));
            set(myUiH.(sliderChannel),'SliderStep',newSliderStep);
        end
    end

    function updateGui(caller, channels, pressures)
        switch lower(caller)
            case 'desiredpressure'
                desiredPressure = strcat(caller, num2str(channels));
                sliderChannel = strcat('ChannelSlider', num2str(channels));
                
                newPressure = str2num(char(get(myUiH.(desiredPressure),'string')));
                
                set(myUiH.(sliderChannel),'value',newPressure);
                
            case 'channelslider'
                desiredPressure = strcat('DesiredPressure',num2str(channels));
                channelSlider = strcat(caller,num2str(channels));
                
                newPressure = num2str(get(myUiH.(channelSlider),'value'));
                
                set(myUiH.(desiredPressure),'string', newPressure);
                
                set(myUiH.(desiredPressure),'Userdata', newPressure);
                
            case 'timer'
                state = mfcs.readChannelPressure([1 2 3 4 5 6 7 8]);
                for ii=1:numberOfChannels
                    realPressure = strcat('RealPressure', num2str(ii));
                    set(myUiH.(realPressure),'string',num2str(state(2,ii)));
                end
            case 'script'
                for ii=1:length(channels)
                    desiredPressure = strcat('DesiredPressure', num2str(channels(ii)));
                    sliderChannel = strcat('ChannelSlider', num2str(channels(ii)));
                    
                    set(myUiH.(desiredPressure),'string',num2str(pressures(ii)));
                    set(myUiH.(desiredPressure),'Userdata',num2str(pressures(ii)));
                    set(myUiH.(sliderChannel),'value',pressures(ii));
                end
            case 'units'
                set(myUiH.MbarCheckbox,'value',~psi);
                set(myUiH.PsiCheckbox,'value',psi);
                
                channelInformation = mfcs.readChannelInformation(1:8);
                
                for ii=1:numberOfChannels
                    slider = strcat('ChannelSlider',num2str(ii));
                    maxPressure = strcat('MaxPressure',num2str(ii));
                    desiredPressure = strcat('DesiredPressure', num2str(ii));
                    
                    set(myUiH.(slider),'max',channelInformation(3,ii));
                    set(myUiH.(maxPressure),'string',num2str(channelInformation(3,ii), '%6.2f'));
                    if psi==1 && psiPrevious ==0
                        set(myUiH.(desiredPressure), 'string', (str2num(get(myUiH.(desiredPressure),'string')))/68.9475);
                        set(myUiH.(desiredPressure), 'Userdata', get(myUiH.(desiredPressure),'string'));
                        if str2num(get(myUiH.(desiredPressure),'string'))<0
                            set(myUiH.(slider), 'value', 0);
                        else
                            set(myUiH.(slider), 'value', str2num(get(myUiH.(desiredPressure),'string')));
                        end
                    end
                    if psi==0 && psiPrevious ==1
                        set(myUiH.(desiredPressure), 'string', (str2num(get(myUiH.(desiredPressure),'string')))*68.9475);
                        set(myUiH.(desiredPressure), 'Userdata', get(myUiH.(desiredPressure),'string'));
                        if str2num(get(myUiH.(desiredPressure),'string'))<0
                            set(myUiH.(slider), 'value', 0);
                        else
                            set(myUiH.(slider), 'value', str2num(get(myUiH.(desiredPressure),'string')));
                        end
                    end
                    
                    clear slider realPressure maxPressure desiredPressure;
                end
                
                psiPrevious = psi;
            case 'alphascript'
                for ii=1:length(channels)
                    alphaChannel = strcat('AlphaChannel',num2str(channels(ii)));
                    set(myUiH.(alphaChannel),'string',num2str(pressures(ii)));
                end
        end
    end

    function mfcsTimerFcn(obj, event, string_arg)
        mfcs.updateGui('timer', 0, 0);
    end

    function CheckStatusButton_Callback(~,~)
        status = mfcs.getStatus();
        set(myUiH.StatusBox,'string',status);
        pause(3)
        set(myUiH.StatusBox,'string',' ');
    end

    function PsiCheckbox_Callback(~,~)
        psiTemp = get(myUiH.PsiCheckbox,'value');
        mfcs.psiOn(psiTemp);
        mfcs.updateGui('units',0,0);
    end

    function MbarCheckbox_Callback(~,~)
        psiTemp = ~(get(myUiH.MbarCheckbox,'value'));
        mfcs.psiOn(psiTemp);
        mfcs.updateGui('units',0,0);
    end

    function PurgeCheckbox_Callback(~,~)
        purgeStatus = get(myUiH.PurgeCheckbox,'value');
        if purgeStatus == 1
            mfcs.setPurge(1);
        elseif purgeStatus == 0
            mfcs.setPurge(0);
        end
    end

    function CheckPurgeButton_Callback(~,~)
        purgeState = mfcs.getPurge();
        if strcmp(purgeState,'Purge ON')
            set(myUiH.PurgeCheckbox,'value',1)
        elseif strcmp(purgeState,'Purge OFF')
            set(myUiH.PurgeCheckbox,'value',0)
        end
    end

    function updateLabels        
        if exist(labelsFileName, 'file')
            [channel, label] = textread(labelsFileName, '%u\t%s\n', ...
                'whitespace', '\r\n\t', 'commentstyle', 'matlab');
        else
            channel = 1:1:8;
            for ii = 1 : length(channel)
                label(ii) = {num2str(ii)};
            end
        end
        
        for ii = 1: length(channel)
            channelLabel = ['ChannelLabel' num2str(ii)];
            set(myUiH.(channelLabel), 'string', label{ii});
        end        
    end

    function ChannelLabel_Callback(~,~)
        channels = [1:1:8];
        labels = {};
        for ii = 1: length(channels)
            channelLabel = ['ChannelLabel' num2str(ii)];
            labels{ii} = get(myUiH.(channelLabel), 'string');
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

% % Functions for script automation
    function setPurgeScript(state)
        setPurge(logical(state));
        set(myUiH.PurgeCheckbox, 'value', logical(state));
    end

    function purgeState = getPurgeScript(~,~)
        purgeState = getPurge();
        if ~isempty(purgeState)
            set(myUiH.PurgeCheckbox, 'value', purgeState);
        end
    end

    function setChannelsPressureScript(channels, pressures)
        setChannelsPressure(channels, pressures);
        updateGui('script', channels, pressures);
    end

    function setAlphaScript(channels, alphas)
        setAlpha(channels, alphas);
        updateGui('alphaScript', channels, alphas);
    end

    function psiOnScript(unit)
        psiOn(unit);
        updateGui('units',0,0);
    end

    function About_Callback(hObject, eventdata)
        
        str = {'Micro-Fluidics Control System'; 'Ver. 2.0, January 2012'; ...
            'Camilo Díaz-Botía, Rafael Gomez-Sjoberg'; 'Engineering Division'; 'Lawrence Berkeley National Laboratory'; ...
            'Updated for MFCS-EZ by Kurt Thorn'; 'UCSF, 2015'};
        img = imread('about_pic3.bmp');
        aboutdlg('Title', myName, 'String', str, 'Image', img);
    end

    function EmergencyStop_Callback(~, ~)
        setChannelsPressure([1 2 3 4 5 6 7 8], [0 0 0 0 0 0 0 0]);
        updateGui('script', [1 2 3 4 5 6 7 8], [0 0 0 0 0 0 0 0]);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display message on message window
    function message(msg)        
        set(myUiH.Msg, 'String', msg);
        drawnow;        
    end
end %mfcs
