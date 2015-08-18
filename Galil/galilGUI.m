function varargout = galilGUI(varargin)
% GALILGUI MATLAB code for galilGUI.fig
%      GALILGUI, by itself, creates a new GALILGUI or raises the existing
%      singleton*.
%
%      H = GALILGUI returns the handle to a new GALILGUI or the handle to
%      the existing singleton*.
%
%      GALILGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GALILGUI.M with the given input arguments.
%
%      GALILGUI('Property','Value',...) creates a new GALILGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before galilGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to galilGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help galilGUI

% Last Modified by GUIDE v2.5 20-Jul-2015 13:52:03
% Written by Dolly Yuan!!!!!!!
% Last Updated: 08/07/15 by Dolly Yuan!!!!!!!!!!


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @galilGUI_OpeningFcn, ...
    'gui_OutputFcn',  @galilGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before galilGUI is made visible.
function galilGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to galilGUI (see VARARGIN)

% Choose default command line output for galilGUI
handles.output = hObject

% Update handles structure
handles.galil = varargin{1}
guidata(hObject, handles);

handles.galil.sendCommand('EO 0'); %turn off command echo
handles.galil.sendCommand('CN 1,1'); %limit switches active high


% UIWAIT makes galilGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = galilGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.galil.sendCommand('SP 10060.36,2011.585'); % brings speed back to default of 5 mm/s



% --- Executes on button press in big_left_button.
function big_left_button_Callback(hObject, eventdata, handles)
str = handles.increment;    % specified distance to be moved with one click
distance = str2double(str) * handles.galil.longconversion;  % converts from mm to galil motor increments

command = strcat('PR ',' ,-',num2str(distance)) ;
handles.galil.sendCommand(command);
out = handles.galil.sendCommand('BG Y');

handles.galil.checkLimits(out); % is it at a limit?

% --- Executes on button press in big_up_button.
function big_up_button_Callback(hObject, eventdata, handles)
str = handles.increment;    % specified distance to be moved with one click
distance = str2double(str) * handles.galil.shortconversion; % converts from mm to galil motor increments

command = strcat('PR ',' ',num2str(distance));
handles.galil.sendCommand(command);
out = handles.galil.sendCommand('BG X');

handles.galil.checkLimits(out); % is it at a limit?

% --- Executes on button press in big_right_button.
function big_right_button_Callback(hObject, eventdata, handles)
str = handles.increment;    % specified distance to be moved with one click
distance = str2double(str) * handles.galil.longconversion;  % converts from mm to galil motor increments

command = strcat('PR ',' ,',num2str(distance));
handles.galil.sendCommand(command);
out = handles.galil.sendCommand('BG Y');

handles.galil.checkLimits(out ); % is it at a limit?

% --- Executes on button press in big_down_button.
function big_down_button_Callback(hObject, eventdata, handles)
str = handles.increment;    %specified distance to be moved with one click
distance = str2double(str) * handles.galil.shortconversion; %converts from mm to galil motor increments

command = strcat('PR ',' -',num2str(distance));
handles.galil.sendCommand(command);
out = handles.galil.sendCommand('BG X');

handles.galil.checkLimits(out); %is it at a limit?

% sets the distance moved per click of the arrow buttons
function amount_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of amount as text
%        str2double(get(hObject,'String')) returns contents of amount as a double

% returns content in the text box
handles.increment = get(hObject,'String');

% if the string is a number and the number is greater than 0, add it to
% handles. else an error dialog box will pop up
if isstrprop(handles.increment,'digit') & str2double(handles.increment)>0
    fprintf(handles.increment);
    guidata(hObject, handles);
else
    msgbox('Please enter a number greater than 0', 'Error', 'error');
end

% --- Executes during object creation, after setting all properties.
function amount_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% adds default increment value to handles
handles.increment = get(hObject, 'String')
guidata(hObject, handles);


% --- Executes on button press in position.
function position_Callback(hObject, eventdata, handles)
% galil returns current position of motors
xvalue = handles.galil.sendCommand('RP A')
yvalue = handles.galil.sendCommand('RP B')

% read only the numbers returned by the galil. ignore whitespace, letters,
% indents, etc.
new_xvalue = strread(lower(xvalue), '%f', 'whitespace',['a':'z' ' \t' ' \n' ':']);
new_yvalue = strread(lower(yvalue), '%f', 'whitespace',['a':'z' ' \t' ' \n' ':']);

% convert from machine returned units to millimeters
shortxvalue = new_xvalue/handles.galil.shortconversion;
longyvalue = new_yvalue/handles.galil.longconversion;

% sets the Tell Position button text to include coordinates
newstring = strcat('Tell Position: ',num2str(shortxvalue),',',num2str(longyvalue));
set(hObject,'String',newstring);


% --- Executes during object creation, after setting all properties.
function position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in reset.
% after homing to Tube 1, sets that as the home position (0,0)
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.galil.sendCommand( 'DP 0,0');


% adds the desired x coordinate to handles
function xco_Callback(hObject, eventdata, handles)
% hObject    handle to xco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xpo = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xco_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% adds the desired y coordinate to handles
function yco_Callback(hObject, eventdata, handles)
% hObject    handle to yco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ypo = get(hObject,'String');
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of yco as text
%        str2double(get(hObject,'String')) returns contents of yco as a double


% --- Executes during object creation, after setting all properties.
function yco_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xyco.
% moves the stage to desired x,y coordinate
function xyco_Callback(hObject, eventdata, handles)

% converts from millimeters to machine understood units
shortxpo = str2double(handles.xpo)*handles.galil.shortconversion;
longypo = str2double(handles.ypo)*handles.galil.longconversion;

% sends command to the x axis to move to desired x location
commandx = strcat('PA ',num2str(shortxpo));
handles.galil.sendCommand(commandx);
outx = handles.galil.sendCommand('BG X');
handles.galil.checkLimits(outx);

% sends command to the y axis to move to desired y location
commandy = strcat('PA ,',num2str(longypo));
handles.galil.sendCommand(commandy);
outy = handles.galil.sendCommand('BG Y');
handles.galil.checkLimits(outy);

% adds inputed speed to handles
function speed_Callback(hObject, eventdata, handles)
handles.speed = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%adds default speed to handles
handles.speed = get(hObject,'String');
guidata(hObject,handles);



% --- Executes on button press in setspeed.
% sets the speed of the stages. the speed for both stages is always the
% same.
function setspeed_Callback(hObject, eventdata, handles)
% converts from millimeters to galil understood units
shortspeed = str2double(handles.speed)*handles.galil.shortconversion;
longspeed = str2double(handles.speed)*handles.galil.longconversion;

% gives the set speed command
command = strcat('SP ',num2str(shortspeed),',',num2str(longspeed));
handles.galil.sendCommand(command);


% --- Executes on button press in stop.
% stops all movement. press this immediately after using the physical
% emergency stop button.
function stop_Callback(hObject, eventdata, handles)
% sends the stop command
handles.galil.sendCommand('ST XY');


% --- Executes on button press in findCSV.
% lets the user choose a CSV file controlling the fraction collector by
% calling the loadCSV function located in the galilController class
% displays the csv file uploaded, if any
function findCSV_Callback(hObject, eventdata, handles)
% dialog pops up, and user can choose a CSV file.
% make sure this file is in the appropriate folder opened in MatLab. if it
% is not, it will throw an error with the csvread function
handles.galil.loadCSV();
% displays the csv file uploaded or 'No File Selected' if no file has been
% opened.
if handles.galil.fileName == 0
    set(handles.csvDisplay,'String','No File Selected');
else
    set(handles.csvDisplay,'String',handles.galil.fileName);
end

% adds the desired tube number to handles
function numtube_Callback(hObject, eventdata, handles)
handles.whichtube = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
% adds default tube number of 1 to handles
function numtube_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.whichtube = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes on button press in gototube.
% moves the stage to the appropriate tube placement depending on the
% uploaded csv file
% calls the function goToTube located in the galilController class
function gototube_Callback(hObject, eventdata, handles)
handles.galil.goToTube(handles.whichtube);
