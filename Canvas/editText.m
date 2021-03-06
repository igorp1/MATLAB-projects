%%%%%%%%%%%%%%%%%%%%%
%
%    myGUI.m
%
% Created by igorp
%
% on 05-Jan-2014
%
%%%%%%%%%%%%%%%%%%%%%


function editText()

F_prop_text = figure('color','w',...
    'units','normalized',...
    'position',[0 0.8 .4 .24],...
    'CloseRequestFcn',@closeIt);


master_save = uicontrol('Style','PushButton',...
    'Units','Normalized',...
    'Position',[0.754988 0.052158 0.220698 0.176259],...
    'string','SAVE',...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000],...
    'CallBack',@saveIt);


% backgroundcolor = objects.push(end).backgroundcolor;
% foregroundcolor = objects.push(end).foregroundcolor;
% callback = objects.push(end).callback;
% string = objects.push(end).string;
% fontname = objects.push(end).fontname;
% fontsize = objects.push(end).fontsize;
% fontweight = objects.push(end).fontweight;
% enable = objects.push(end).enable;

y = 0.1;
master_save = uicontrol('Style','PopupMenu',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string',{'White','Black','Blue','Gold','Green','Red','Orange'},...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','Text',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string','Background ',...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','PopupMenu',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string',{'White','Black','Blue','Gold','Green','Red','Orange'},...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','Text',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string','Foreground ',...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','PopupMenu',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string',{'Courier','Helvetica','Arial','Times','Monaco'},...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','Text',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string','FontName',...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','PopupMenu',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string',{'light','normal','demi','bold'},...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);
y  = y+0.11;
master_save = uicontrol('Style','Text',...
    'Units','Normalized',...
    'Position',[0.05 y 0.220698 0.1],...
    'string','FontWeight',...
    'fontname','monaco',...
    'fontsize',13,...
    'backgroundcolor',[1.0000 1.0000 1.0000]);



    function saveIt(Source,EventData)
        
        %save new file name to object
        
        
        backgroundcolor;
        foregroundcolor;
        callback;
        string;
        fontname;
        fontsize;
        fontweight;
        enable;
        
        warndlg('The changes have been saved','SAVE');
        
        
    end

    function closeIt(~,~)
        
        choice = questdlg('Do you want to save before you exit?',...
            'SAVE',...
            'Yes','No','Cancel','Yes');
        if ~strcmp(choice,'Cancel')
            if strcmp(choice,'Yes')
                saveIt();
                uiwait();
            end
            delete(F_prop_text);
        end
        
        
        
    end


end









%	This GUI was powered by the GUIDesigner v 1.3
