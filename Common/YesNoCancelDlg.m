function varargout = YesNoCancelDlg(varargin)
% YESNOCANCELDLG M-file for YesNoCancelDlg.fig
%      YESNOCANCELDLG by itself, creates a new YESNOCANCELDLG or raises the
%      existing singleton*.
%
%      H = YESNOCANCELDLG returns the handle to a new YESNOCANCELDLG or the handle to
%      the existing singleton*.
%
%      YESNOCANCELDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YESNOCANCELDLG.M with the given input arguments.
%
%      YESNOCANCELDLG('Property','Value',...) creates a new YESNOCANCELDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before YesNoCancelDlg_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to YesNoCancelDlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help YesNoCancelDlg

% Last Modified by GUIDE v2.5 08-Nov-2006 18:09:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @YesNoCancelDlg_OpeningFcn, ...
                   'gui_OutputFcn',  @YesNoCancelDlg_OutputFcn, ...
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

% --- Executes just before YesNoCancelDlg is made visible.
function YesNoCancelDlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to YesNoCancelDlg (see VARARGIN)

% Choose default command line output for YesNoCancelDlg
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.text1, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.YesNoCancelDlg, 'Color');
IconCMap=questIconMap;

Img=image(IconData, 'Parent', handles.axes1);
set(handles.YesNoCancelDlg, 'Colormap', IconCMap);

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

% Make the GUI modal
% set(handles.YesNoCancelDlg,'WindowStyle','modal')

% UIWAIT makes YesNoCancelDlg wait for user response (see UIRESUME)
uiwait(handles.YesNoCancelDlg);

% --- Outputs from this function are returned to the command line.
function varargout = YesNoCancelDlg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.YesNoCancelDlg);

% --- Executes on button press in pushbutton1.
function pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.YesNoCancelDlg);


% --- Executes when user attempts to close YesNoCancelDlg.
function YesNoCancelDlg_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to YesNoCancelDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(handles.YesNoCancelDlg, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.YesNoCancelDlg);
else
    % The GUI is no longer waiting, just close it
    delete(handles.YesNoCancelDlg);
end


% --- Executes on key press over YesNoCancelDlg with no controls selected.
function YesNoCancelDlg_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to YesNoCancelDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said cancel by hitting escape
    handles.output = 'Cancel';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.YesNoCancelDlg);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')

    handles.output = 'Return';

    uiresume(handles.YesNoCancelDlg);
end    

