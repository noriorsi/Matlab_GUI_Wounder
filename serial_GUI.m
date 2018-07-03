function varargout = serial_GUI(varargin)

% Edit the above text to modify the response to help serial_GUI

% Last Modified by GUIDE v2.5 18-Jul-2017 13:29:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @serial_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @serial_GUI_OutputFcn, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This function is for opening serial communication , all of the connected
%port are enable, for using RFDuino you have to choose the right COM port
%where youre device is connected. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before serial_GUI is made visible.
function serial_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

serialPorts = instrhwinfo('serial');
nPorts = length(serialPorts.SerialPorts);
set(handles.portList, 'String', ...
    [{'Select a port'} ; serialPorts.SerialPorts ]);
set(handles.portList, 'Value', 2);   
set(handles.history_box, 'String', cell(1));

handles.output = hObject;
axes(handles.axes1);
imshow('logo.png');
axes(handles.axes2);
imshow('body.png');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes serial_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% not specified function, automatically created with GUI.fig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = serial_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% clear all; 
% global a;
% a = arduino('COM8','rfduino');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is the function for selecting the right port
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in portList.
function portList_Callback(hObject, eventdata, handles)
% hObject    handle to portList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns portList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from portList


% --- Executes during object creation, after setting all properties.
function portList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function history_box_Callback(hObject, eventdata, handles)
% hObject    handle to history_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of history_box as text
%        str2double(get(hObject,'String')) returns contents of history_box as a double


% --- Executes during object creation, after setting all properties.
function history_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to history_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% As the happy gecko and rfduin were set uo, the right baudrate now is
% 38400, but it is changeble if the programmer wants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function baudRateText_Callback(hObject, eventdata, handles)
% hObject    handle to baudRateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baudRateText as text
%        str2double(get(hObject,'String')) returns contents of baudRateText as a double


% --- Executes during object creation, after setting all properties.
function baudRateText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudRateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% You can connect your selected device. If you are not connected ,
%% you cant start the program.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in connectButton.
function connectButton_Callback(hObject, eventdata, handles)    

if strcmp(get(hObject,'String'),'Connect') % currently disconnected
    serPortn = get(handles.portList, 'Value');
    if serPortn == 1
        errordlg('Select valid COM port');
    else
        serList = get(handles.portList,'String');
        serPort = serList{serPortn};
        serConn = serial(serPort, 'TimeOut', 1, ...
            'BaudRate', str2num(get(handles.baudRateText, 'String')));
        
        try
            fopen(serConn);
            handles.serConn = serConn;               
            % enable Tx text field and Rx button
            set(handles.start_button, 'Enable', 'On');
           % set(handles.rxButton, 'Enable', 'On');
            
            set(hObject, 'String','Disconnect')
        catch e
            errordlg(e.message);
        end
        
    end
else
    set(handles.start_button, 'Enable', 'Off');
    %set(handles.stop_button, 'Enable', 'Off');
    %set(handles.rxButton, 'Enable', 'Off');
    
    set(hObject, 'String','Connect')
    fclose(handles.serConn);
end
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START function. when you  push the start button 
% it writes to serial port "$START$" which starts the rfduino.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
           
   % get(hObject,'String');             
    s= serial(handles.serConn);  
    fprintf(s,'%s','$START$')
    fileID=fopen('datas.txt','w');
   
             while get (hObject, 'String')
                 out = fscanf(s) 
             %   out = fgets(s)           
                 list = get(handles.history_box, 'String');
                 set(handles.start_button,'Enable','Off');
                 set(handles.stop_button,'Enable','On');
                 set(handles.history_box,'String',...           
                  [list ;  out]);
                 
                 fprintf(fileID, '%s',out) ; 
                 pause(0.1);
              end
       
%fclose(s);
handles = guidata(hObject);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STOP function. when you  push the start button 
% it writes to serial port "$START$" which stops the rfduino.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)

%s=serial(handles.serConn);
if strcmp(get(hObject,'String'),'STOP & SAVE')
fprintf(handles.serConn,'%s','$STOP$')
fclose(handles.serConn);
set(handles.start_button,'Enable','On');
set(handles.stop_button,'Enable','Off');
handles.stop_button = 1;

handles = guidata(hObject);
guidata(hObject, handles);
end
%end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'serConn')
    fclose(handles.serConn);
end
% Hint: delete(hObject) closes the figure
delete(hObject);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here starts the PLOTTING 

%IMPORTANT:
% TO DO : now the program works from a specified place. 
%    C:\Users\Nóra\Desktop\SmartWound\datas.txt
% I have make it works generally , automatically ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in figure_button.
function figure_button_Callback(hObject, eventdata, handles)


%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\Nóra\Desktop\SmartWound\datas.txt
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/07/18 09:47:39

%% Initialize variables.
%filename = 'C:\Users\Nóra\Desktop\SmartWound\datas.txt';
% FOR APP: 
filename = 'C:\Users\Nóra\Desktop\SmartWound\SmartWoundApp\for_testing\datas.txt';
delimiter = '\t';
startRow = 4;
%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
state0 = dataArray{:, 1};
force = dataArray{:, 2};
force_hgmm = dataArray{:, 3};
temp = dataArray{:, 4};
hum = dataArray{:, 5};
time = dataArray{:, 6};


%% Set up the figure window
%time = now; % it's a trial for real time plot 

%xlim(axesHandle,[min(time) max(time+0.001)]);
%% Set the time span and interval for data collection
%stopTime = '10/07 21:53';
%timeInterval = 0.005;

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in the first figure I want to plot all the 3 types of measurement ( 3
% because the force just in Newton now ) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
subplot(3,1,1)
x = time;
y1 = force; 
level = 5;
plot(x, y1, 'k-', 'Linewidth',1.3,'MarkerSize',8);
hold on
area(x, max(y1, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
ylim([0 10]); %mettol meddig terjedjen az y 
title('Erõ','fontsize',16);
xlabel('Time [s]')
ylabel('Force [N]')
legend ('measurement','over limit');
grid on
grid minor

subplot(3,1,2)
level = 37;
y2 = temp;
plot(x,y2, 'k-', 'Linewidth',1.3,'MarkerSize',8);
hold on
area(x, max(y2, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
ylim([0 100]);
title('Hõmérséklet','fontsize',16)
xlabel('Time [s]')
ylabel('Temperature [°C]')
legend ('measurement','over limit');
grid minor


subplot(3,1,3)
level = 70;
y3 = hum;
plot(x,y3, 'k-', 'Linewidth',1.3,'MarkerSize',8);
hold on
area(x, max(y3, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
xlabel('Time [s]')
ylabel('Humidity [%]')
title('Páratartalom','fontsize',16)
ylim([0 100])
legend ('measurement','over limit');
grid on
grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure 2 is for force, in Newton and also in Hgmm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
 subplot (2,1,1)
x = time;
y1 = force; 
level = 5;
plot(x, y1, 'k-', 'Linewidth',1.4,'MarkerSize',8);
hold on
area(x, max(y1, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
title('Erõ','fontsize',16)
xlabel('Time [s]')
ylabel('Force [N]')    
ylim([0 10]) %mettol meddig terjedjen az y
legend ('measurement','over limit');
grid minor


%%%% fullscale in hgmm is 133.3 * 10 / 38 = 35 hgmm


subplot (2,1,2)
x = time;
yy1 = force_hgmm;
plot(x, yy1, 'k-', 'Linewidth',1.4,'MarkerSize',8);
hold on
%harea = area(x,y1,limit);
%set( harea, 'FaceColor', 'y');
%alpha(.5);
level = 15;
area(x, max(yy1, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
title('Erõ Hgmm-ben','fontsize',16)
xlabel('Time [s]')
ylabel('Force [Hgmm]')    
ylim([0 100]) %mettol meddig terjedjen az y
legend ('measurement','over limit');
grid minor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 3 is for temperature-time plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(3)
level = 37;
y2 = temp;
plot(x,y2, 'k-', 'Linewidth',1.4,'MarkerSize',8);
hold on
area(x, max(y2, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
title('Hõmérséklet','fontsize',16)
xlabel('Time [s]')
ylabel('Temperature [°C]')
ylim([0 100])
legend ('measurement','over limit');
grid on
grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 4 is for humidity-ime plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(4)
level = 70;
y3 = hum;
plot(x,hum, 'k-', 'Linewidth',1.4,'MarkerSize',8);
hold on
area(x, max(y3, level), level, 'EdgeColor', 'none', 'FaceColor', [.8 0 0])
title('Páratartalom','fontsize',16)
xlabel('Time [s]')
ylabel('Humidity [%]')
ylim([0 100])
legend ('measurement','over limit');
grid on
grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% axes for pictures in the app
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function figure_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hasn't written yet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function datetime_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datetime_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
