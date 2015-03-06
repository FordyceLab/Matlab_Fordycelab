function chip = DummyChip(vcType, valveNumFile, virtual, slave, masterName)
% Dummy microfluidic chip for simple hardware testing. Just exposes 8
% valves for manual control
%
% chip = DummyChip(vcType, valveNumFile, virtual, slave, masterName)
%
% vcType = Specifies type of valve controller to use: 'wago' or 'usb' slave
% valveNumFile = Full name of the file where the list of valve numbers is
%                stored. This file must be in the same folder as the
%                chip closure.
% slave = Boolean that specifies if this GUI is a slave to another
%         GUI, so that it cannot be quitted by itself.
% masterName = String with the name of the master window that
%              called this one, and that controls the Quit.
% virtual = Boolean parameter that when true makes the valve
%           controller be virtualized, but it still accepts all
%           commands.  Defaults to false when absent.
%
% R. Gomez-Sjoberg, Camilo Diaz-Botia, 10/14/11

fileSeparator = filesep();

myName = 'Dummy Chip';

%determine myTag automatically
myTag = mfilename;

if slave && isempty(masterName)
    masterName = 'master';
elseif ~slave
    masterName = myName;
end

% Where am I?
myFolder = fileparts(which([myTag '.m']));

% Space-less name for error logging
pathParts = strsplit(myFolder, filesep);
%we are in INSTALL_DIR/Common; want to write to INSTALL_DIR/Logs
errorLogFileName = fullfile(pathParts{1:end-1}, 'Logs' ,[myTag,'_ERRORS.txt']);
% Initialize error logging
errorLog = eventLog(['Error log file for ' myName], errorLogFileName, true);

% Open figure and get all handles to GUI objects
myFigH = openfig([myFolder fileSeparator myTag]);
myUiH = getHandles(myFigH);
set(myFigH, 'Name', myName, 'Tag', myTag);
defaultBackgroundColor = get(0,'defaultUicontrolBackgroundColor');

% Draw chip
myXy = [];
drawChip;

% Initialize valves
myValves = [];

chipInit;

% Set Callbacks for new GUI
set(myUiH.OpenAll, 'Callback', @OpenAll_Callback);
set(myUiH.CloseAll, 'Callback', @CloseAll_Callback);
set(myUiH.ChipReset, 'Callback', @ChipReset_Callback);
set(myUiH.About, 'Callback', @About_Callback);
if ~slave
    set(myUiH.Quit, 'Callback', @Quit_Callback);
    set(myFigH, 'CloseRequestFcn', @Quit_Callback);
else
    set(myUiH.Quit, 'Callback', @SlaveQuit_Callback);
    set(myUiH.Quit, 'Enable', 'off', 'Visible', 'off');
    set(myFigH, 'CloseRequestFcn', @SlaveQuit_Callback);
end

% Make figure visible
set(myFigH, 'Visible', 'on');

% Initialize output data structure
chip = [];

% Methods
chip.getTag = @getTag;
chip.getFolder = @getFolder;
chip.errorLog = errorLog;
chip.closeAll = @closeAllValves;
chip.openAll = @openAllValves;
chip.openValve = myValves.openValve;
chip.closeValve = myValves.closeValve;
chip.openValves = myValves.openValves;
chip.closeValves = myValves.closeValves;
chip.setValve = myValves.setValve;
chip.getValve = myValves.getValve;

chip.reset = @chipReset;
chip.message = @message;
chip.doSomething = @doSomething;
chip.quit = @chipClose;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do anything we want by editing this function
    function a = doSomething
        
        a = myUiH;
%         set(myUiH.Quit, 'Callback', @Quit_Callback);
%         set(myFigH, 'CloseRequestFcn', @Quit_Callback);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the folder where this m file is stored
    function tag = getTag
        tag = myTag;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the folder where this m file is
    function folder = getFolder
        
        folder = myFolder;
    end

    function drawChip

        try
            % Read chip locations from file
            myXy.locFName = fullfile(myFolder, 'ChipLocations.txt');
            [myXy.NumLocations myXy.Names, myXy.Pos, ...
                myXy.Dims, myXy.Calib, myXy.Xlim, myXy.Ylim] = readChipLocations(myXy.locFName);
            % Number of chambers in this chip
            numChambers = myXy.NumLocations;
            img = imread('BeadSynthesizerv3p0.png', 'png');
            for jj = 1:3
                img(:, :, jj) = flipud(img(:, :, jj));
            end %for jj
            imgSz = size(img);
            if isempty(myXy.Xlim) || (myXy.Xlim(1) <= myXy.Xlim(2))
                myXy.Xlim = [0, imgSz(2)];
            end
            if isempty(myXy.Ylim) || (myXy.Ylim(1) <= myXy.Ylim(2))
                myXy.Ylim = [0, imgSz(1)];
            end
            xData = linspace(myXy.Xlim(1), myXy.Xlim(2), 4);
            yData = linspace(myXy.Ylim(1), myXy.Ylim(2), 4);
            image('CData', img, 'Parent', myUiH.ChipImage, 'Clipping', 'off', ...
                'XData', xData, 'YData', yData);
            set(myUiH.ChipImage, 'NextPlot', 'add', 'XTick', [], 'YTick', []);
            myUiH.ChamberPlot.MarkerSize = 5;
            for ii = 1:myXy.NumLocations
                x = myXy.Pos(ii, 1);
                y = myXy.Pos(ii, 2);
                str = 'k+';
                myUiH.ChamberPlot.h(ii) = plot(myUiH.ChipImage, x, y, str);
                set(myUiH.ChamberPlot.h(ii), 'MarkerSize', myUiH.ChamberPlot.MarkerSize);
                set(myUiH.ChamberPlot.h(ii), 'MarkerFaceColor', [1 1 1]);
            end;
            set(myUiH.ChipImage, 'XLim', myXy.Xlim, 'YLim', myXy.Ylim);
            % Lock the axes so that drawing is not damaged by external plotting
            % commands
            set(myUiH.ChipImage, 'HandleVisibility', 'off');
        catch ME
            thisTag = [myTag ':drawChip'];
            errorHandler(thisTag, ME, '', errorLog, @message, false);
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close all the valves on the chip
    function closeAllValves()
        
        myValves.closeAll();
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open all the valves on the chip
    function openAllValves()
        
        myValves.openAll();
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close all the valves on the chip
    function CloseAll_Callback(hObject, ~)
        
        closeAllValves();
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open all the chip
    function OpenAll_Callback(hObject, ~)
        
        opt = YesNoQuestion('Title', 'Open All Valves', 'String', ...
            'Are you sure you want to open all the valves?');
        switch lower(opt)
            case 'yes'
                openAllValves();
        end
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on menu select in About.
    function About_Callback(hObject, ~)
        
        str = {'Dummy Device'; 'March 2015'; ' '; ...
            'Kurt Thorn'; 'UCSF'};
        img = imread('about_pic3.bmp');
        aboutdlg('Title', 'Cell Culture Chip', 'String', str, 'Image', img);
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on menu select in Quit or close request when running as slave.
    function SlaveQuit_Callback(~, ~)
        
        infodlg('Title', myName, 'String', ...
            ['To close this interface use the Quit button on the ' ...
            masterName ' window']);
%         chipClose();
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on menu select in Quit or close request.
    function Quit_Callback(hObject, ~)
        
        opt = YesNoQuestion('Title', myName, 'String', ...
            'Are you sure you want to quit?');
        switch lower(opt)
            case 'yes'
                chipClose();
        end
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback for Chip Reset button
    function ChipReset_Callback(~, ~)
        
        chipReset;
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset chip control system
    function chipReset
        
        myValves.reset();
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close chip control system
    function chipClose
        
        try
            myValves.quit();
            clear myValves;
            clear('valveGuiControl');
        catch ME
            thisTag = [myTag ':chipClose'];
            errorHandler(thisTag, ME, '', errorLog, @message, false);
        end
        
        delete(myFigH);
        
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize valve control systems
    function chipInit
        
        try
            % Start valve controller and connect it to the GUI
            myValves = valveGuiControl(vcType, virtual, myUiH, [myFolder fileSeparator valveNumFile], masterName, errorLog);
            disp('Starting valve controller and connecting to GUI')
        catch ME
            thisTag = [myTag ':chipInit'];
            errorHandler(thisTag, ME, '', errorLog, @message, true);
        end
 
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display message on message window
    function message(msg)
        
        try
            set(myUiH.Msg, 'String', msg);
            drawnow;
        catch ME
            thisTag = [myTag ':message'];
            errorHandler(thisTag, ME, 'ERROR! ', errorLog, @message, false);
        end
        
    end

end
