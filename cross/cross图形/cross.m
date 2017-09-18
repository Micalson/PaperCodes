function varargout = cross(varargin)
% CROSS MATLAB code for cross.fig
%      CROSS, by itself, creates a new CROSS or raises the existing
%      singleton*.
%
%      H = CROSS returns the handle to a new CROSS or the handle to
%      the existing singleton*.
%
%      CROSS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROSS.M with the given input arguments.
%
%      CROSS('Property','Value',...) creates a new CROSS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cross_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cross_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cross

% Last Modified by GUIDE v2.5 26-Feb-2017 22:06:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cross_OpeningFcn, ...
                   'gui_OutputFcn',  @cross_OutputFcn, ...
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


% --- Executes just before cross is made visible.
function cross_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cross (see VARARGIN)

% Choose default command line output for cross
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cross wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cross_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function column_Callback(hObject, eventdata, handles)
% hObject    handle to column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of column as text
%        str2double(get(hObject,'String')) returns contents of column as a double


% --- Executes during object creation, after setting all properties.
function column_CreateFcn(hObject, eventdata, handles)
% hObject    handle to column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function error4_Callback(hObject, eventdata, handles)
% hObject    handle to error4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of error4 as text
%        str2double(get(hObject,'String')) returns contents of error4 as a double


% --- Executes during object creation, after setting all properties.
function error4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to error4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_Callback(hObject, eventdata, handles)
% hObject    handle to num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num as text
%        str2double(get(hObject,'String')) returns contents of num as a double


% --- Executes during object creation, after setting all properties.
function num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function error2_Callback(hObject, eventdata, handles)
% hObject    handle to error2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of error2 as text
%        str2double(get(hObject,'String')) returns contents of error2 as a double


% --- Executes during object creation, after setting all properties.
function error2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to error2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in test20.
function test20_Callback(hObject, eventdata, handles)
% hObject    handle to test20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clearvars;
close all;
clear all;

L = imread('L.png');
R = imread('R.png');
dispL = double(imread('dispL.png'))/4;

% figure;imshow(L);
% imshow(R);
L1=L(:,:,1);
L2=L(:,:,2);
L3=L(:,:,3);
LL1 = medfilt2(L1, [3 3]);
LL2 = medfilt2(L2, [3 3]);
LL3 = medfilt2(L3, [3 3]);
L(:,:,1)=LL1;
L(:,:,2)=LL2;
L(:,:,3)=LL3;
R1=R(:,:,1);
R2=R(:,:,2);
R3=R(:,:,3);
RR1 = medfilt2(R1, [3 3]);
RR2 = medfilt2(R2, [3 3]);
RR3 = medfilt2(R3, [3 3]);
R(:,:,1)=RR1;
R(:,:,2)=RR2;
R(:,:,3)=RR3;
% figure;imshow(L);


height=375;
width=450;
WINDOW_THRESHOLD=20;
T=60;
L_max=17;
Edp_min=100000000;
d_max=59;
errorNum=0;
errorNum4=0;
ddisp=zeros(height,width,1);

for i=1:375      %212
    tic
%     disp([i-1,(i-1)*450,errorNum,errorNum4]);
    set(handles.column,'String',i-1);
    set(handles.num,'String',(i-1)*450);
    set(handles.error2,'String',errorNum2);
    set(handles.error4,'String',errorNum4);
    for j=1:450   %165
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
        for d=0:d_max
            if(j-d<1)
                continue;
            end;
            [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j-d,R);
            upper=min(upperL,upperR);
            down =min(downL, downR);
            
            Edp=0;
            sumUD=0;
            for ud=-upper:down 
                sumLR=0;
                [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
                [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j-d,R);
                left =min(leftL,leftR);
                right=min(rightL,rightR);
                sumLR=left+right+1;
                for lr=-left:right
                    dL = double(abs( L(i+ud,j+lr,1)-R(i+ud,j-d+lr,1)) );
                    da = double(abs( L(i+ud,j+lr,2)-R(i+ud,j-d+lr,2)) );
                    db = double(abs( L(i+ud,j+lr,3)-R(i+ud,j-d+lr,3)) );
                    eds=min(dL+da+db,T);
                    Edp=Edp+eds;
                end;
                sumUD=sumUD+sumLR;
            end;
            EEdp=Edp/sumUD;
%             disp([i,j,d,Edp,sumUD]);
%             disp([EEdp]);
            if(EEdp<Edp_min)
                Edp_min=EEdp;
                bestD=d;
            end;
        end;
        disp([i,j,bestD]);
        ddisp(i,j,1)=bestD;
        trueDisp=dispL(i,j,1);
        if(abs(bestD-trueDisp)>2)
            errorNum=errorNum+1;
        end;
       if(abs(bestD-trueDisp)>4)
            errorNum4=errorNum4+1;
        end;
%         disp([i,j,abs(bestD*4-trueDisp),errorNum]);
        
%         plot(1:d_max+1,lll);
	end;
    time=toc;
%     disp([i,errorNum/(i*450),time]);
end;




