function varargout = RPS_main_gui(varargin)
% RPS_MAIN_GUI MATLAB code for RPS_main_gui.fig
%      RPS_MAIN_GUI, by itself, creates a new RPS_MAIN_GUI or raises the existing
%      singleton*.
%
%      H = RPS_MAIN_GUI returns the handle to a new RPS_MAIN_GUI or the handle to
%      the existing singleton*.
%
%      RPS_MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RPS_MAIN_GUI.M with the given input arguments.
%
%      RPS_MAIN_GUI('Property','Value',...) creates a new RPS_MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RPS_main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RPS_main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RPS_main_gui

% Last Modified by GUIDE v2.5 23-Mar-2017 19:34:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RPS_main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @RPS_main_gui_OutputFcn, ...
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


% --- Executes just before RPS_main_gui is made visible.
function RPS_main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RPS_main_gui (see VARARGIN)

% Choose default command line output for RPS_main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RPS_main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear;
clear rps_ai_alg % clearing persistent variables
global win_arr
global player_sel
win_arr = [];
player_sel = 1;


% --- Outputs from this function are returned to the command line.
function varargout = RPS_main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in player_rock.
function player_rock_Callback(hObject, eventdata, handles)
% hObject    handle to player_rock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of player_rock

% Deselects the others
if get(hObject,'Value')
    set(handles.player_paper,'Value',0);
    set(handles.player_scissors,'Value',0);
end

% Prevent itself from deselecting
if get(hObject,'Value') == 0
    set(hObject,'Value',1);
end
global player_sel;
player_sel = 1;
% 1 -> rock
% 2 -> paper
% 3 -> scissors 

% --- Executes on button press in player_paper.
function player_paper_Callback(hObject, eventdata, handles)
% hObject    handle to player_paper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of player_paper

% Deselects the others
if get(hObject,'Value')
    set(handles.player_rock,'Value',0);
    set(handles.player_scissors,'Value',0);
end

% Prevent itself from deselecting
if get(hObject,'Value') == 0
    set(hObject,'Value',1);
end
global player_sel;
player_sel = 2;
% 1 -> rock
% 2 -> paper
% 3 -> scissors 

% --- Executes on button press in player_scissors.
function player_scissors_Callback(hObject, eventdata, handles)
% hObject    handle to player_scissors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of player_scissors

% Deselects the others
if get(hObject,'Value')
    set(handles.player_paper,'Value',0);
    set(handles.player_rock,'Value',0);
end

% Prevent itself from deselecting
if get(hObject,'Value') == 0
    set(hObject,'Value',1);
end

global player_sel;
player_sel = 3;
% 1 -> rock
% 2 -> paper
% 3 -> scissors 

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in ai_alg.
function ai_alg_Callback(hObject, eventdata, handles)
% hObject    handle to ai_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ai_alg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ai_alg


% --- Executes during object creation, after setting all properties.
function ai_alg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ai_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rock_sel.
function rock_sel_Callback(hObject, eventdata, handles)
% hObject    handle to rock_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player_sel;
player_sel = 1;
start_game(handles)

% --- Executes on button press in paper_sel.
function paper_sel_Callback(hObject, eventdata, handles)
% hObject    handle to paper_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player_sel;
player_sel = 2;
start_game(handles)

% --- Executes on button press in scissors_sel.
function scissors_sel_Callback(hObject, eventdata, handles)
% hObject    handle to scissors_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player_sel;
player_sel = 3;
start_game(handles)

function start_game(handles)
global player_sel;
alg = get(handles.ai_alg,'Value');

% 1 -> Random
% 2 -> Most likely
% 3 -> Last winner
% 4 -> Extra
global win_arr
ai_sel = rps_ai_alg(player_sel,alg,0);
wins = rps_winner(player_sel,ai_sel);
win_arr = [win_arr wins];
player_wins = sum(win_arr == 1);
ties = sum(win_arr == 0);
ai_wins = sum(win_arr == 2);
switch ai_sel
    case 1
        set(handles.ai_sel_txt,'String','Rock');
    case 2
        set(handles.ai_sel_txt,'String','Paper');
    case 3
        set(handles.ai_sel_txt,'String','Scissors');
end

set(handles.player_stat,'String',num2str(player_wins));
set(handles.ai_stat,'String',num2str(ai_wins));
set(handles.tie_stat,'String',num2str(ties));
