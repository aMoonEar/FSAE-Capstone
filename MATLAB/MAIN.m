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
    Default_axial_force=75;
    Default_cornering=3.5;
    set(handles.Slideraxial_force,'Value',Default_axial_force);
    set(handles.TXTaxial_force,'String',num2str(Default_axial_force));
    set(handles.Slidercornering,'Value',Default_cornering);
    set(handles.TXTcornering,'String',num2str(Default_cornering));
    %set(handles.NumWeights,'Value',1); %The 1st item of the list is selected. Change the list from the GUIDE.
    %set(handles.TXT_shaftlength,'String','21.25');
    
    %Set the window title with the group identification:
    set(handles.figure1,'Name','Group FSAE2 // CADCAM 2021');
    
    % Display uOttawa logo on the GUI
    %axis image
    %axes(handles.uOttawa);
    %uOttawaLogo = imread('C:\Users\16138\Documents\FSAE-Capstone\MATLAB\GUI Images\uOttawaLogo.JPG');
    %imshow(uOttawaLogo);
    
    % Display uOttawa logo on the GUI
    %axis image
    %axes(handles.fsae);
    %fsaeLogo = imread('C:\Users\16138\Documents\FSAE-Capstone\MATLAB\GUI Images\SAE_logo.png');
    %imshow(fsaeLogo);
    
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
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                           Range Checking
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Perform basic range checking (for those that can go out of range)
        %if isnan(shaft_length) || (shaft_length <=0) || (shaft_length > 50)
        %    msgbox('The shaft length specified is not an acceptable value. Please correct it.','Cannot generate!','warn');
        %    return;
        %end
    
        % Let the user know that the design is being generated
        %generateMessage = msgbox('Generating design! Please wait...');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                           Input Parameters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        driverWeight = 111.58;
        steeringStiffness = 1;
        corneringRadius = 1;
        
        % Calling the design code with all inputted parameters
        DesignCode(driverWeight, steeringStiffness, corneringRadius);
        
        % Once DesignCode has been successfully completed, close the message
        % box
        %delete(generateMessage);
        
        % Once the parts optimized, output message box to the user
        %msgbox('Successfully optimized! Please re-build the SolidWorks assembly');
        
    
        %Show the results on the GUI.
        %log_file = 'H:\groupABC\Log\groupABC_LOG.TXT';
        %fid = fopen(log_file,'r'); %Open the log file for reading
        %S=char(fread(fid)'); %Read the file into a string
        %fclose(fid);
    
        %set(handles.TXT_log,'String',S); %write the string into the textbox
        %set(handles.TXT_path,'String',log_file); %show the path of the log file
        %set(handles.TXT_path,'Visible','on');
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
    
    function TXTaxial_force_Callback(hObject, eventdata, handles) %#ok
    % hObject    handle to TXTaxial_force (see GCBO) 
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of TXTaxial_force as text
    %        str2double(get(hObject,'String')) returns contents of TXTaxial_force as a double
    
    if(isempty(handles))
        Wrong_File();
    else
        value = round(str2double(get(hObject,'String')));
    
        %Apply basic testing to see if the value does not exceed the range of the
        %slider (defined in the gui)
        if(value<get(handles.Slideraxial_force,'Min'))
            value = get(handles.Slideraxial_force,'Min');
        end
        if(value>get(handles.Slideraxial_force,'Max'))
            value = get(handles.Slideraxial_force,'Max');
        end
        set(hObject,'String',value);
        set(handles.Slideraxial_force,'Value',value);
    end
    
    % --- Executes during object creation, after setting all properties.
    function TXTaxial_force_CreateFcn(hObject, eventdata, handles) %#ok
        % hObject    handle to TXTaxial_force (see GCBO)
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
    function Slideraxial_force_Callback(hObject, eventdata, handles) %#ok
    % hObject    handle to Slideraxial_force (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    if(isempty(handles))
        Wrong_File();
    else
        value = round(get(hObject,'Value')); %Round the value to the nearest integer
        set(handles.TXTaxial_force,'String',num2str(value));
    end
    
    % --- Executes during object creation, after setting all properties.
    function Slideraxial_force_CreateFcn(hObject, eventdata, handles) %#ok
    % hObject    handle to Slideraxial_force (see GCBO)
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
    
    uOttawaLogo = imread('C:\Users\16138\Documents\FSAE-Capstone\MATLAB\GUI Images\uOttawaLogo.png');
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
    
