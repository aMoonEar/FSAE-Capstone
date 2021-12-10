% =========================================================================
% =========================================================================
%                       FSAE2 - Capstone Project     
% =========================================================================
% =========================================================================

% GROUP: FSAE2
% University of Ottawa
% Mechanical Engineering
% Latest Revision: 9/12/2021

% =========================================================================
% FSAE2 - Parametrization Code
% =========================================================================


function varargout = MAIN(varargin)
    % MAIN MATLAB code for MAIN.fig
    %      MAIN, by itself, creates a new MAIN or raises the existing
    %      singleton*.
    %
    %      H = MAIN returns the handle to a new MAIN or the handle to
    %      the existing singleton*.
    %
    %      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in MAIN.M with the given input arguments.
    %
    %      MAIN('Property','Value',...) creates a new MAIN or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before MAIN_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to MAIN_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help MAIN
    
    % Begin initialization code - DO NOT EDIT
    warning('off','all')
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @MAIN_OpeningFcn, ...
                       'gui_OutputFcn',  @MAIN_OutputFcn, ...
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
    
% --- Outputs from this function are returned to the command line.
function varargout = MAIN_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% End initialization code

% =========================================================================\
% =========================================================================
% --- Executes just before MAIN is made visible.
% =========================================================================
% =========================================================================

function MAIN_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN (see VARARGIN)

% Choose default command line output for MAIN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set the default values on the GUI. It is recommended to choose a valid set 
%of default values as a starting point when the program launches.
clc
Default_driver_weight=75;
set(handles.Sliderdriver_weight,'Value',Default_driver_weight);
set(handles.TXTdriver_weight,'String',num2str(Default_driver_weight));

Default_cornering=3.5;
set(handles.Slidercornering,'Value',Default_cornering);
set(handles.TXTcornering,'String',num2str(Default_cornering));

%Set the window title with the group identification:
set(handles.figure1,'Name','Group FSAE2 // CADCAM 2021');

% Display uOttawa logo on the GUI
axis image
axes(handles.fsae);
fsaeLogo = imread('H:\groupFSAE2\MATLAB\GUI Images\SAE_logo.png');
imshow(fsaeLogo);

%Add the 'subfunctions' folder to the path so that subfunctions can be
%accessed
addpath('Subfunctions');

% =========================================================================

% --- Executes on button press in BTN_Generate.
function BTN_Generate_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BTN_Generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isempty(handles))
    Wrong_File();
else

    %Get the design parameters from the interface (DO NOT PERFORM ANY DESIGN CALCULATIONS HERE)
    driverWeight = str2double(get(handles.TXTdriver_weight, 'String'));
    corneringRadius = str2double(get(handles.TXTcornering, 'String'));
    suspensionFeel = get(get(handles.suspensionButtonGroup, 'SelectedObject'),'String');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           Range Checking
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check driver mass inputted 
    if (driverWeight < get(handles.Sliderdriver_weight, 'Min') || driverWeight > get(handles.Sliderdriver_weight, 'Max') || isnan(driverWeight) )
        msgbox('The driver weight specified is not an acceptable value. Please correct it.','Cannot generate design!','warn');
        return;
    end

    % Check driver mass inputted 
    if (corneringRadius < get(handles.Slidercornering, 'Min') || corneringRadius > get(handles.Slidercornering, 'Max') || isnan(corneringRadius) )
        msgbox('The cornering radius specified is not an acceptable value. Please correct it.','Cannot generate design!','warn');
        return;
    end

    % Let the user know that the design is being generated
    generateMessage = msgbox('Generating design! Please wait...');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %                        Radio button values                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    % Checks which suspension feel type is selected and assigns its value to the corresponding variable
    if (strcmp(suspensionFeel,'0.25 (Soft)'))
        suspensionFeel = 0.25;
    elseif (strcmp(suspensionFeel,'0.75 (Stiff)'))
        suspensionFeel = 0.75;
    else 
        suspensionFeel = str2double(suspensionFeel);
    end
        
    % Calling the design code with all inputted parameters
    DesignCode(driverWeight, corneringRadius, suspensionFeel);

    % Once DesignCode has been successfully completed, close the message
    % box
    delete(generateMessage);

    % Once the parts optimized, output message box to the user
    msgbox('Successfully optimized! Please re-build the SolidWorks assembly');

    %Show the results on the GUI.
    log_file = 'H:\groupFSAE2\Log\groupFSAE2_LOG.TXT';
    fid = fopen(log_file,'r'); %Open the log file for reading
    S=char(fread(fid)'); %Read the file into a string
    fclose(fid);

    set(handles.TXT_log,'String',S); %write the string into the textbox
end

% =========================================================================

% --- Executes on button press in BTN_Finish.
function BTN_Finish_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BTN_Finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close gcf

% =========================================================================

% --- Gives out a message that the GUI should not be executed directly from
% the .fig file. The user should run the .m file instead.
function Wrong_File()
clc
h = msgbox('You cannot run the MAIN.fig file directly. Please run the program from the Main.m file directly.','Cannot run the figure...','error','modal');
uiwait(h);
disp('You must run the MAIN.m file. Not the MAIN.fig file.');
disp('To run the MAIN.m file, open it in the editor and press ');
disp('the green "PLAY" button, or press "F5" on the keyboard.');
close gcf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TXTdriver_weight_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to TXTdriver_weight (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXTdriver_weight as text
%        str2double(get(hObject,'String')) returns contents of TXTdriver_weight as a double

if(isempty(handles))
    Wrong_File();
else
    value = round(str2double(get(hObject,'String')));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.Sliderdriver_weight,'Min'))
        value = get(handles.Sliderdriver_weight,'Min');
    end
    if(value>get(handles.Sliderdriver_weight,'Max'))
        value = get(handles.Sliderdriver_weight,'Max');
    end
    set(hObject,'String',value);
    set(handles.Sliderdriver_weight,'Value',value);
end

% --- Executes during object creation, after setting all properties.
function TXTdriver_weight_CreateFcn(hObject, eventdata, handles) %#ok
    % hObject    handle to TXTdriver_weight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function TXTcornering_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to TXTcornering (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function TXTcornering_Callback(hObject, eventdata, handles)
% hObject    handle to TXTcornering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXTcornering as text
%        str2double(get(hObject,'String')) returns contents of TXTcornering as a double
if(isempty(handles))
    Wrong_File();
else
    value = str2double(get(hObject,'String'));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.Slidercornering,'Min'))
        value = get(handles.Slidercornering,'Min');
    end
    if(value>get(handles.Slidercornering,'Max'))
        value = get(handles.Slidercornering,'Max');
    end
    set(hObject,'String',value);
    set(handles.Slidercornering,'Value',value);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function Sliderdriver_weight_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to Sliderdriver_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if(isempty(handles))
    Wrong_File();
else
    value = round(get(hObject,'Value')); %Round the value to the nearest integer
    set(handles.TXTdriver_weight,'String',num2str(value));
end

% --- Executes during object creation, after setting all properties.
function Sliderdriver_weight_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to Sliderdriver_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function Slidercornering_Callback(hObject, eventdata, handles)
    % hObject    handle to Slidercornering (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    if(isempty(handles))
        Wrong_File();
    else
        value = round(get(hObject,'Value')*100)/100; %Round the value to two decimal places
        set(handles.TXTcornering,'String',num2str(value));
    end


    % --- Executes during object creation, after setting all properties.
    function Slidercornering_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Slidercornering (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TXT_log_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXT_log as text
%        str2double(get(hObject,'String')) returns contents of TXT_log as a double

% --- Executes during object creation, after setting all properties.
function uOttawa_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to uOttawa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

uOttawaLogo = imread('H:\groupFSAE2\MATLAB\GUI Images\uOttawaLogo.jpg');
imshow(uOttawaLogo);
% Hint: place code in OpeningFcn to populate uOttawa

% --- Executes during object creation, after setting all properties.
function TXT_log_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end