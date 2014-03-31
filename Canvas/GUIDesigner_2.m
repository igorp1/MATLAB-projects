%%%%%%%%%%%%%%%%%%%%%
%
%    Canvas.m
%
% Created by Igor dePaula
%
% Version under development 
%
%%%%%%%%%%%%%%%%%%%%%

function GUIDesigner_2

global handTemp;

global toCheck;

global callbackCounter
callbackCounter = 0;

global f_keyPress;
clear f_keyPress;
f_keyPress = [];

global objects;
clear objects

objects.push = [];            
objects.slider = [];
objects.radio = [];
objects.bgroup = [];
objects.edit = [];
objects.text = [];
objects.axes = [];
objects.menu = [];
objects.panel = [];
objects.image = [];
objects.timer = [];
objects.keyfnc = [];
objects.tabmenu = [];
objects.keyshortcut = [];
objects.figure.closeReq.exist = 0;
objects.figure.position = [0.025 0.054396 0.95 0.864382];


global DrawAxes;



Canvas();



    function Canvas()
        
        f_main = figure('color','w',...
            'units','normalized',...
            'position',[0 0 1 1]);
        
        x = 0.025;
        canvas = uipanel('Units','Normalized',...
            'Position',[x 0.054396 0.95 0.864382],...
            'backgroundcolor',[0.0000 0.0000 0.0000]);
        
        DrawAxes = axes('parent',canvas,...
            'units','normalized',...
            'position',[0 0 1 1],...
            'xlim',[0 100],...
            'ylim',[0 100]);
        
        
        %% setup uimenu
        m = uimenu('label','Designer',...
            'parent',f_main,...
            'position',1);
        %------------------------------------
        uimenu('label','Save',...
            'parent',m,...
            'callback',@saveWork);
        function saveWork(~,~)
            
            if ispc()
                [~,user] = system('echo %username%');
            else
                [~,user] = system('echo $USER');
            end
            
            defaultString = sprintf('DesignerFile_%s_%s',date,user(1:end-1));
            
            [file, path] = uiputfile([defaultString '.mat'],'Save as');
            
            if file == 0
                return
            end
            
            save([path file],'objects');
            
            warndlg('Your current work has been saved','Save');
        end
        %------------------------------------
        uimenu('label','Open',...
            'parent',m,...
            'callback',@openWork);
        function openWork(~,~)
            
            [file, path] = uigetfile(['.mat'],'Load');
            
            if file == 0
                return
            end
            
            clear objects
            
            tempLoad = load([path file]);
            
            objects = tempLoad.objects;
            
            for i = 1:length(objects.push)
                drawObject_auto(objects.push(i))
            end
            for i = 1:length(objects.slider)
                drawObject_auto(objects.slider(i))
            end
            for i = 1:length(objects.radio)
                drawObject_auto(objects.radio(i))
            end
            for i = 1:length(objects.bgroup)
                drawObject_auto(objects.bgroup(i))
            end
            for i = 1:length(objects.edit)
                drawObject_auto(objects.edit(i))
            end
            for i = 1:length(objects.text)
                drawObject_auto(objects.text(i))
            end
            for i = 1:length(objects.axes)
                drawObject_auto(objects.axes(i))
            end
            for i = 1:length(objects.menu)
                drawObject_auto(objects.menu(i))
            end
            for i = 1:length(objects.panel)
                drawObject_auto(objects.panel(i))
            end
            for i = 1:length(objects.image)
                drawObject_auto(objects.image(i))
            end
            
            if ~isempty(objects.timer)
                if objects.timer.exist
                    addTimer();
                end
            end
            if ~isempty(objects.keyfnc)
                if objects.keyfnc.exist
                    addKeyPressFnc();
                end
            end
            if ~isempty(objects.tabmenu)
                if objects.tabmenu.exist
                    addUiMenu();
                end
            end
            if ~isempty(objects.keyshortcut)
                if objects.keyshortcut.exist
                    addAccelerator();
                end
            end
            if ~isempty(objects.figure.closeReq)
                if objects.figure.closeReq.exist
                    addcloseReq();
                end
            end
                
            set(canvas,'position',objects.figure.position);
            
        end
        %------------------------------------
        uimenu('label','Generate Code',...
            'parent',m,...
            'callback',@genCode);
        function genCode(~,~)
            disp('Generate Code')
            codeGenerator(objects);
            warndlg('Code has been generated','Generate Code');
        end
        %------------------------------------
        uimenu('label','New Project',...
            'parent',m,...
            'callback',@createNew);
        function createNew(~,~)
            disp('New Project')
        end
        %------------------------------------
        f_tab_menu = uimenu('label','Figure',...
            'parent',m);
        uimenu('label','Portrait',...
            'parent',f_tab_menu,...
            'callback',@figurePortrait);
        function figurePortrait(~,~)
            set(canvas,'position',[0.3 0.01 0.35 0.905])
            objects.figure.position = [0.3 0.01 0.35 0.905];
        end
        uimenu('label','Landscape',...
            'parent',f_tab_menu,...
            'callback',@figureLandscape);
        function figureLandscape(~,~)
            set(canvas,'position',[0.025 0.054396 0.95 0.864382])
            objects.figure.position = [0.025 0.054396 0.95 0.864382];
        end
        tabmenu_closereq = uimenu('label','CloseReq [  ]',...
            'parent',f_tab_menu,...
            'callback',@addcloseReq);
        function addcloseReq(~,~)
            
            persistent toggle
            if isempty(toggle)
                toggle = false;
            end
            
            if toggle == false
                set(tabmenu_closereq,'Label','CloseReq [X]')
                objects.figure.closeReq.exist = 1;
                toggle = true;
                
                warndlg('CloseReq function has been setup','CloseReq');
            else
                set(tabmenu_closereq,'Label','CloseReq [  ]')
                objects.figure.closeReq.exist = 0;
                toggle = false;
                
                warndlg('CloseReq function has been deleted','CloseReq');
            end
            
            
        end
        %------------------------------------
        tabmenu_timer = uimenu('label','Timer [  ]',...
            'parent',m,...
            'callback',@addTimer);
        function addTimer(Source,EventData)
            
            
            if ~isempty(objects.timer)
                
                
                warndlg('Timer has been deleted','Timer');
                set(tabmenu_timer,'label','Timer [  ]');
                objects.timer = [];
                
            else
                warndlg('Timer has been setup','Timer');
                
                set(tabmenu_timer,'label','Timer [X]');
                objects.timer.handle = 't';
                objects.timer.type = 'timer';
                objects.timer.period = 1;
                objects.timer.ExecutionMode = 'fixedRate';
                objects.timer.BusyMode = 'queue';
                objects.timer.TasksToExecute = 10;
            end
            
        end
        %------------------------------------
        tabmenu_uimenu = uimenu('label','UI Menu [  ]',...
            'parent',m,...
            'callback',@addUiMenu);
        function addUiMenu(~,~)
            
            persistent toggle
            if isempty(toggle)
                toggle = false;
            end
            
            if toggle == false
                set(tabmenu_uimenu,'Label','UI Menu [X]')
                objects.figure.closeReq.exist = 1;
                toggle = true;
                
                objects.tabmenu.exist = true;
                
                warndlg('The UI Menu has been setup','Timer');
            else
                set(tabmenu_uimenu,'Label','UI Menu [  ]')
                objects.figure.closeReq.exist = 0;
                toggle = false;
                
                objects.tabmenu.exist = false;
                
                warndlg('The UI Menu has been deleted','Timer');
            end
            
        end
        %------------------------------------
        tabmenu_acc = uimenu('label','Accelerator [  ]',...
            'parent',m,...
            'callback',@addAccelerator);
        function addAccelerator(~,~)
            
            persistent toggle
            if isempty(toggle)
                toggle = false;
            end
            
            if toggle == false
                set(tabmenu_acc,'Label','Accelerator [X]')
                objects.figure.closeReq.exist = 1;
                toggle = true;
                
                objects.tabmenu.exist = true;
                
                warndlg('The Accelerator has been setup','Timer');
            else
                set(tabmenu_acc,'Label','Accelerator [  ]')
                objects.figure.closeReq.exist = 0;
                toggle = false;
                
                objects.tabmenu.exist = false;
                
                warndlg('The Accelerator has been deleted','Timer');
            end
        end
        %------------------------------------
        uimenu('label','Key Press Function',...
            'parent',m,...
            'callback',@addKeyPressFnc);
        %------------------------------------
        uimenu('label','Quit',...
            'parent',m,...
            'callback',@quit);
        function quit(~,~)
            
            choice = questdlg('Do you want to save before you exit?',...
                            'SAVE',...
                            'Yes','No','Cancel','Yes');
        if ~strcmp(choice,'Cancel')                 
            if strcmp(choice,'Yes')  
                saveWork();
                uiwait();
            end
            
            
            delete(f_main);
        end
            
        end
        %------------------------------------
        uimenu('label','About...',...
            'parent',m,...
            'callback',@about);
        function about(~,~)
            
            
        end
        %------------------------------------
        
        
        %% Setup buttons
        
        
        p_push = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Push',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        
        x = x + 0.06;
        p_slider = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Slider',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        
        
        x = x + 0.06;
        p_buttonGroup = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Radio',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        
        
        x = x + 0.06;
        p_buttonGroup = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Button Group',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        
        x = x + 0.06;
        p_edit = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Edit',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        
        
        x = x + 0.06;
        p_text = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Text',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        x = x + 0.06;
        p_axes = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Axes',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        x = x + 0.06;
        p_menu = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Menu',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        x = x + 0.06;
        p_panel = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Panel',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        x = x + 0.06;
        p_image = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[x 0.918778 0.06 0.041729],...
            'string','Image',...
            'backgroundcolor',[0.0000 0.0000 0.0000]+1,...
            'CallBack',@newOrEdit);
        
        
        
        
        
    end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function drawObject_auto(object)
        
        X_origin = object.position(1);
        Y_origin = object.position(2);
        hold on;
        
        plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',[.9 .9 .9],'MarkerEdgeColor','k');
        
        set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
        
         X_end = object.position(1) + object.position(3);
         Y_end = object.position(2) + object.position(4);
         
        patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],[.9 .9 .9],'parent',DrawAxes);
        
        if X_end < X_origin
            positionVec(1) = X_end/100;
        else
            positionVec(1) = X_origin/100;
        end
        
        if Y_end < Y_origin
            positionVec(2) = Y_end/100;
        else
            positionVec(2) = Y_origin/100;
        end
        
        
        positionVec(3) = abs(X_end - X_origin)/100;
        positionVec(4) = abs(Y_end - Y_origin)/100;
        
        if strcmp(object.type,'IMAGE')
            t = text([(positionVec(1)*100)+(positionVec(3)*100/2) - 4.25],[(positionVec(2)*100)+(positionVec(4)*100/2) - 1],{upper(object.type), object.handle,object.fileName},'parent',DrawAxes);
        else
            t = text([(positionVec(1)*100)+(positionVec(3)*100/2) - 2.25],[(positionVec(2)*100)+(positionVec(4)*100/2) - 1],{upper(object.type),object.handle},'parent',DrawAxes);
        end

        set(t,'fontsize',14,'fontweight','bold','fontname','Monaco');
        
    end

    function positionVec = drawObject(object)
        
        [X_origin, Y_origin] = ginput(1);
        hold on;
        
        plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',[.9 .9 .9],'MarkerEdgeColor','k');
        
        set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
        
        [X_end, Y_end] = ginput(1);
        patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],[.9 .9 .9],'parent',DrawAxes);
        
        if X_end < X_origin
            positionVec(1) = X_end/100;
        else
            positionVec(1) = X_origin/100;
        end
        
        if Y_end < Y_origin
            positionVec(2) = Y_end/100;
        else
            positionVec(2) = Y_origin/100;
        end
        
        
        positionVec(3) = abs(X_end - X_origin)/100;
        positionVec(4) = abs(Y_end - Y_origin)/100;
        
        if strcmp(object.type,'IMAGE')
            t = text([(positionVec(1)*100)+(positionVec(3)*100/2) - 4.25],[(positionVec(2)*100)+(positionVec(4)*100/2) - 1],{upper(object.type), object.handle,object.fileName},'parent',DrawAxes);
        else
            t = text([(positionVec(1)*100)+(positionVec(3)*100/2) - 2.25],[(positionVec(2)*100)+(positionVec(4)*100/2) - 1],{upper(object.type),object.handle},'parent',DrawAxes);
        end

        set(t,'fontsize',14,'fontweight','bold','fontname','Monaco');
        
    end

    function newOrEdit(Source,~)
        
        objType = upper(get(Source,'string'));
        
        f_newOrEdit = figure('color','w',...
            'units','normalized',...
            'position',[0 .7 .3 .2],...
            'numbertitle','off',...
            'name',objType);
        
        
        p = uicontrol('Style','PushButton',...
            'Units','Normalized',...
            'Position',[0.05 0.05 0.425 0.807487],...
            'string','',...
            'backgroundcolor',[1.0000 1.0000 1.0000],...
            'string',['NEW ' objType],...
            'fontname','monaco',...
            'fontsize',12,...
            'CallBack',@addNewObject);
        
        
        uicontrol('Style','Text',...
            'Units','Normalized',...
            'Position',[0.005342 0.87 0.993590 0.1],...
            'backgroundcolor','w',...
            'string',objType,...
            'fontname','monaco',...
            'fontsize',12);
        
        
        %%get objects from selected type:
        
        switch lower(objType)
            
            case 'push'
                toCheck = objects.push;
            case 'slider'
                toCheck = objects.slider;
            case 'radio'
                toCheck = objects.radio;
            case 'button group'
                toCheck = objects.bgroup;
            case 'edit'
                toCheck = objects.edit;
            case 'text'
                toCheck = objects.text;
            case 'axes'
                toCheck = objects.axes;
            case 'menu'
                toCheck = objects.menu;
            case 'panel'
                toCheck = objects.panel;
            case 'image'
                toCheck = objects.image;
        end
        
        handles = {};
        if isempty(toCheck)
            
            set(p,'position',[0.30 0.05 0.425 0.807487])
            
        else
            
            t = uicontrol('Style','Text',...
            'Units','Normalized',...
            'Position',[0.525 0.58128 0.43 0.15],...
            'string',{'Edit Properties','from:'},...
            'fontname','monaco',...
            'backgroundcolor', [1 1 1]);
            
            for i = 1:length(toCheck)
                handles{end+1} = toCheck(i).handle;
            end
            
            m = uicontrol('Style','PopupMenu',...
            'Units','Normalized',...
            'Position',[0.525 0.261925 0.43 0.176471],...
            'string',handles);
        
            uicontrol('style','push',...
            'units','normalized',...
            'string','EDIT',...
            'position',[0.63 0.1 0.2 0.15],...
            'callback',@editPropeties);
            
        end
        
        
        
        
        
        function editPropeties(Source,~)
            
            indx = get(m,'value');
            
            
            switch lower(objType)
            
                case 'push'
                    toCheck = objects.push(indx);
                case 'slider'
                    toCheck = objects.slider(indx);
                case 'radio'
                    toCheck = objects.radio(indx);
                case 'button group'
                    toCheck = objects.bgroup(indx);
                case 'edit'
                    toCheck = objects.edit(indx);
                case 'text'
                    toCheck = objects.text(indx);
                case 'axes'
                    toCheck = objects.axes(indx);
                case 'menu'
                    toCheck = objects.menu(indx);
                case 'panel'
                    toCheck = objects.panel(indx);
                case 'image'
                    toCheck = objects.image(indx);
                    editIM();
                    objects.image(indx) = toCheck;
            end
            
        end
        
        function addNewObject(Source,~)
            
            %% prompt for handle
            
            delete(f_newOrEdit);
            
            getHandle();
            
            uiwait();
            
            
            switch lower(objType)
                case 'push'
                    
                    callbackCounter = callbackCounter + 1;
                    objects.push(end+1).type = objType;
                    
                    objects.push(end).handle = handTemp;
                    objects.push(end).backgroundcolor = [1 1 1];
                    objects.push(end).foregroundcolor = [0 0 0];
                    objects.push(end).callback = ['defaultCall_' num2str(callbackCounter)];
                    objects.push(end).string = '';
                    objects.push(end).fontname = 'Courier';
                    objects.push(end).fontsize = 10;
                    objects.push(end).fontweight = 'normal';
                    objects.push(end).enable = 'on';
                    
                    posVec = drawObject(objects.push(end));
                    objects.push(end).position = posVec;
                    
                    
                %----------------------------------------------------------    
                case 'slider'
                    
                    callbackCounter = callbackCounter + 1;
                    objects.slider(end+1).type = objType;
                    
                    objects.slider(end).handle = handTemp;
                    objects.slider(end).min = 0;
                    objects.slider(end).max = 0;
                    objects.slider(end).value = 0;
                    objects.slider(end).callback = ['defaultCall_' num2str(callbackCounter)];
                    
                    posVec = drawObject(objects.slider(end));
                    objects.slider(end).position = posVec;
                %----------------------------------------------------------    
                case 'radio'
                    objects.radio(end+1).handle = handTemp;
                    objects.radio(end).type = objType;
                    callbackCounter = callbackCounter + 1;
                    
                    objects.radio(end).BackgroundColor = [1 1 1];
                    objects.radio(end).ForegroundColor = [0 0 0];
                    objects.radio(end).Callback = ['defaultCall_' num2str(callbackCounter)];
                    objects.radio(end).Value = 0;
                    objects.radio(end).String = '' ;
                    objects.radio(end).FontName = 'Courier';
                    objects.radio(end).FontSize = 10;
                    objects.radio(end).FontWeight = 'normal';
                    
                    posVec = drawObject(objects.radio(end));
                    objects.radio(end).position = posVec;
                    
                %----------------------------------------------------------
                case 'button group'
                    objects.bgroup(end+1).handle = handTemp;
                %----------------------------------------------------------
                case 'edit'
                    objects.edit(end+1).handle = handTemp;
                    objects.edit(end).type = objType;
                    callbackCounter = callbackCounter + 1;
                    
                    objects.edit(end).BackgroundColor = [1 1 1];
                    objects.edit(end).ForegroundColor = [0 0 0];
                    objects.edit(end).Callback = ['defaultCall_' num2str(callbackCounter)];
                    objects.edit(end).String = '';
                    objects.edit(end).FontName = 'Courier';
                    objects.edit(end).FontSize = 10;
                    objects.edit(end).FontWeight = 'normal';
                    
                    posVec = drawObject(objects.edit(end));
                    objects.edit(end).position = posVec;
                %----------------------------------------------------------
                case 'text'
                    
                    objects.text(end+1).handle = handTemp;
                    objects.text(end).type = objType;
                    callbackCounter = callbackCounter + 1;
                    
                    objects.text(end).BackgroundColor = [1 1 1];
                    objects.text(end).ForegroundColor = [0 0 0];
                    objects.text(end).String = '';
                    objects.text(end).FontName = 'Courier';
                    objects.text(end).FontSize = 10;
                    objects.text(end).FontWeight = 'normal';
                    
                    posVec = drawObject(objects.text(end));
                    objects.text(end).position = posVec;
                    
                %----------------------------------------------------------
                case 'axes'
                    objects.axes(end+1).handle = handTemp;
                    objects.axes(end).type = objType;
                    
                    objects.axes(end).xlim = [0 100];
                    objects.axes(end).ylim = [0 100];
                    objects.axes(end).xtick = [0:10:100];
                    objects.axes(end).ytick = [0:10:100];
                    objects.axes(end).title = '';
                    objects.axes(end).xlabel = '';
                    objects.axes(end).ylabel = '';
                    
                    posVec = drawObject(objects.axes(end));
                    objects.axes(end).position = posVec;
                    
                %----------------------------------------------------------
                case 'menu'
                    objects.menu(end+1).handle = handTemp;
                    objects.menu(end).type = objType;
                    
                    objects.menu(end).Callback = ['defaultCall_' num2str(callbackCounter)];
                    objects.menu(end).Value = 1;
                    objects.menu(end).String = {'a','b','c'};
                    
                    posVec = drawObject(objects.menu(end));
                    objects.menu(end).position = posVec;
                    
                %----------------------------------------------------------
                case 'panel'
                    objects.panel(end+1).handle = handTemp;
                    objects.panel(end).type = objType;
                    
                    objects.panel(end).BorderType = 'etchedin';
                    objects.panel(end).BorderWidth = 1;
                    objects.panel(end).BackgroundColor = [1 1 1];
                    
                    posVec = drawObject(objects.panel(end));
                    objects.panel(end).position = posVec;
                %----------------------------------------------------------
                case 'image'
                    objects.image(end+1).handle = handTemp;
                    objects.image(end).type = objType;
                    
                    [fileName,path] = uigetfile({'*.png';'*.jpg';'*.jpeg'},'Choose the image you want to open');
                    
                    if fileName~=0
                    objects.image(end).fileName = fileName;
                    objects.image(end).path = path;
                    
                    posVec = drawObject(objects.image(end));
                    objects.image(end).position = posVec;
                    end
                
            end
            
        end
        
    end

    function getHandle()
        
        f = figure('color','w',...
            'units','normalized',...
            'position',[0 .7 .3 .2],...
            'numbertitle','off',...
            'name','Handle',...
            'closerequest',@sethandle);
        
        uicontrol('Style','Text',...
            'Units','Normalized',...
            'Position',[0.005342 0.87 1 0.1],...
            'backgroundcolor','w',...
            'string','PICK A NAME FOR YOR OBJECT HANDLE',...
            'fontname','monaco',...
            'fontsize',12);
        
        in = uicontrol('Style','EDIT',...
            'Units','Normalized',...
            'Position',[0.005342 0.5 1 0.2],...
            'backgroundcolor','w',...
            'string','',...
            'fontname','monaco',...
            'fontsize',13.5);
        
        uicontrol('Style','push',...
            'Units','Normalized',...
            'Position',[0.25 0.25 0.5 0.2],...
            'backgroundcolor','w',...
            'string','Set',...
            'fontname','monaco',...
            'fontsize',12,...
            'callback',@sethandle);
        
        function sethandle(~,~)
            
            hand_string = get(in,'string');
            
            if isempty(hand_string)
                
                warndlg('The handle name cannot be empty','HANDLE');
                
            else
                
                if ~isempty(str2num(hand_string(1)))
                    hand_string = ['handle_' hand_string];
                end
                
                hand_string = strrep(hand_string,' ','_');
                hand_string = strrep(hand_string,'+','_');
                hand_string = strrep(hand_string,'-','_');
                hand_string = strrep(hand_string,'*','_');
                hand_string = strrep(hand_string,'!','_');
                hand_string = strrep(hand_string,'@','_');
                hand_string = strrep(hand_string,'#','_');
                hand_string = strrep(hand_string,'&','_');
                hand_string = strrep(hand_string,'%','_');
                hand_string = strrep(hand_string,'^','_');
                hand_string = strrep(hand_string,'$','_');
                
                handTemp = hand_string;
                
                delete(f)
                
            end
            
        end
        
    end

    function addKeyPressFnc(~,~)
        
        if ~isempty(f_keyPress)
            set(f_keyPress,'visible','on');
        else
            f_keyPress = figure('units','normalized',...
                'NumberTitle','off',...
                'Name','Key Press Function',...
                'position',[0 0.5 0.2 .5],...
                'color',[1 1 1],...
                'CloseRequestFcn',@saveProperties);
            
            handle_edit = uicontrol('style','edit',...
                'units','normalized',...
                'position',[0.005 0.9 0.995 0.05],...
                'backgroundcolor',[1 1 1]);
            handle_text =  uicontrol('style','text',...
                'units','normalized',...
                'position',[0.005 0.95 0.995 0.05],...
                'string','Function Name:',...
                'backgroundcolor',[1 1 1]);
            
            options_text =  uicontrol('style','text',...
                'units','normalized',...
                'position',[0.005 0.85 0.995 0.05],...
                'string','Keys:',...
                'backgroundcolor',[1 1 1]);
            
            moreoptions = uicontrol('style','pushbutton',...
                'units','normalized',...
                'position',[.05 0.86 .05 0.035],...
                'string','?',...
                'callback',@help);
            
            
            
            y = .8;
            for i = 1
                options_edit(i) = uicontrol('style','edit',...
                    'units','normalized',...
                    'position',[0 y 1 0.05],...
                    'backgroundcolor',[1 1 1]);
                y = y - 0.05;
            end
            
            moreoptions = uicontrol('style','pushbutton',...
                'units','normalized',...
                'position',[.45 y .1 0.05],...
                'string','+',...
                    'callback',@addOptions);
                
                
                pushIt = uicontrol('style','pushbutton',...
                    'units','normalized',...
                    'position',[0.25 0.0 0.5 0.1],...
                    'string','Enter properties',...
                    'callback',@saveProperties);
        end

        function help(~,~)
            
            msgbox({'All the keys you add will have their own space on the KeyPressFunction.',...
                '  ',...
                'All nubers and letters you pick must be one character long.',...
                'Other than numbers and letters you can pick the following items: ',...
                ' ',...
                'rightarrow',...
                'leftarrow',...
                'uparrow',...
                'downarrow',...
                'return',...
                'escape',...
                'space',...
                'backspace',...
                'shift'},...
                'HELP');
            
        end

        function addOptions(~,~)
            
            if isempty(get(options_edit(end),'string'))
                warndlg('You have empty fields','Keys');
                return
            end
            
            
            if length(options_edit) < 14
                options_edit(length(options_edit)+1) = uicontrol('style','edit',...
                    'units','normalized',...
                    'position',[0 y 1 0.05],...
                    'backgroundcolor',[1 1 1]);
                y = y - 0.05;
                set(moreoptions,'position',[.45 y .1 0.05]);
            elseif length(options_edit)+1 == 15
                options_edit(length(options_edit)+1) = uicontrol('style','edit',...
                    'units','normalized',...
                    'position',[0 y 1 0.05],...
                    'backgroundcolor',[1 1 1]);
                y = y - 0.05;
                set(moreoptions,'visible','off');
            end
            
            
            
        end
        
        function saveProperties(~,~)
            
            function_handle = get(handle_edit,'string');
            
            if isempty(function_handle)
                warndlg('You cannot leave the function name empty','Function Name');
                return
            end
            
            allKeys = {};
            
            %% check key options:
            for i = 1:length(options_edit)
                
                currenKey = get(options_edit(i),'string');
                
                if ismember(currenKey,{'rightarrow', 'leftarrow', 'uparrow', 'downarrow', 'return', 'escape', 'space', 'backspace', 'shift'})
                    
                    allKeys{end+1} = currenKey;
                    
                else
                    if length(currenKey) == 1
                        allKeys{end+1} = currenKey;
                    else
                        warndlg('One or more of your key options are not valid','Keys');
                        return
                    end
                end
                
            end
            
            objects.keyfnc.fncName = function_handle;
            objects.keyfnc.exist = true;
            objects.keyfnc.keys = allKeys;
            
            set(f_keyPress,'visible','off')
        end
        
        
    end

    function write2file(fid,obj)
        
        switch lower(obj.type)
        
            case 'push'


                        fprintf(fid,'%s = uicontrol(''Style'',''Push'',...\n',obj.handle);
                        fprintf(fid,'%s''BackgroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.backgroundcolor(1),...
                                                                                                                                            obj.backgroundcolor(2),...
                                                                                                                                            obj.backgroundcolor(3));
                        fprintf(fid,'%s''ForegroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.foregroundcolor(1),...
                                                                                                                                            obj.foregroundcolor(2),...
                                                                                                                                            obj.foregroundcolor(3));
                        fprintf(fid,'%s''Callback'', @%s,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.callback); 
                        fprintf(fid,'%s''String'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.string);
                        fprintf(fid,'%s''FontName'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontname);
                        fprintf(fid,'%s''FontSize'', %d,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontsize);
                        fprintf(fid,'%s''FontWeight'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontweight);
                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = uicontrol('])));
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n\n ',blanks(length([obj.handle ' = uicontrol('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                                                                                                                        
                        fprintf(fid,'\t\tfunction %s(Source,EventData)\n\n',obj.callback);
                        fprintf(fid,'\t\t\t%% WRITE YOUR FUNCTION DEFINITION HERE\n');
                        fprintf(fid,'\t\t\t%% To get a property use:\n');
                        fprintf(fid,'\t\t\t%%\tfoo = get(handle,''property'');\n');
                        fprintf(fid,'\t\t\t%% To set a property use:\n');
                        fprintf(fid,'\t\t\t%%\tset(handle,''property'',foo);\n\n');
                        fprintf(fid,'\t\tend');
                        
                        fprintf(fid,'\n\n\n')
                    %----------------------------------------------------------    
                    case 'slider'

                        fprintf(fid,'%s = uicontrol(''Style'',''Slider'',...\n',obj.handle);
                        fprintf(fid,'%s''Min'',%.2f,...',blanks(length([obj.handle ' = uicontrol('])),obj.min);
                        fprintf(fid,'%s''Max'',%.2f,...',blanks(length([obj.handle ' = uicontrol('])),obj.max);
                        fprintf(fid,'%s''Value'',%.2f,...',blanks(length([obj.handle ' = uicontrol('])),obj.value);
                        fprintf(fid,'%s''Callback'',%.2f,...',blanks(length([obj.handle ' = uicontrol('])),obj.callback);
                        fprintf(fid,'%s''Units'',''Normalized'',...',blanks(length([obj.handle ' = uicontrol('])));
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = uicontrol('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                        fprintf(fid,'\t\tfunction %s(Source,EventData)\n\n',obj.callback);
                        fprintf(fid,'\t\t\t%% WRITE YOUR FUNCTION DEFINITION HERE\n');
                        fprintf(fid,'\t\t\t%% To get a property use:\n');
                        fprintf(fid,'\t\t\t%%\tfoo = get(handle,''property'');\n');
                        fprintf(fid,'\t\t\t%% To set a property use:\n');
                        fprintf(fid,'\t\t\t%%\tset(handle,''property'',foo);\n\n');
                        fprintf(fid,'\t\tend');
                        
                        fprintf(fid,'\n\n\n')
                        
                    %----------------------------------------------------------    
                    case 'radio'
                        
                        
                        fprintf(fid,'%s = uicontrol(''Style'',''Radio'',...\n',obj.handle);
                        fprintf(fid,'%s''BackgroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.BackgroundColor(1),...
                                                                                                                                            obj.BackgroundColor(2),...
                                                                                                                                            obj.BackgroundColor(3));
                        fprintf(fid,'%s''ForegroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.ForegroundColor(1),...
                                                                                                                                            obj.ForegroundColor(2),...
                                                                                                                                            obj.ForegroundColor(3));
                        fprintf(fid,'%s''Callback'', @%s,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.Callback); 
                        fprintf(fid,'%s''String'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.String);
                        fprintf(fid,'%s''FontName'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.FontName);
                        fprintf(fid,'%s''FontSize'', %d,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.FontSize);
                        fprintf(fid,'%s''FontWeight'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.FontWeight);
                        fprintf(fid,'%s''Value'', %d,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.Value);
                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = uicontrol('])));
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = uicontrol('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                        
                        fprintf(fid,'\t\tfunction %s(Source,EventData)\n\n',obj.Callback);
                        fprintf(fid,'\t\t\t%% WRITE YOUR FUNCTION DEFINITION HERE\n');
                        fprintf(fid,'\t\t\t%% To get a property use:\n');
                        fprintf(fid,'\t\t\t%%\tfoo = get(handle,''property'');\n');
                        fprintf(fid,'\t\t\t%% To set a property use:\n');
                        fprintf(fid,'\t\t\t%%\tset(handle,''property'',foo);\n\n');
                        fprintf(fid,'\t\tend');
                        
                        fprintf(fid,'\n\n\n');


                    %----------------------------------------------------------
                    case 'button group'
                        objects.bgroup(end+1).handle = handTemp;
                    %----------------------------------------------------------
                    case 'edit'
                        
                        
                        
                        fprintf(fid,'%s = uicontrol(''Style'',''Radio'',...\n',obj.handle);
                        fprintf(fid,'%s''BackgroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.backgroundcolor(1),...
                                                                                                                                            obj.backgroundcolor(2),...
                                                                                                                                            obj.backgroundcolor(3));
                        fprintf(fid,'%s''ForegroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.foregroundcolor(1),...
                                                                                                                                            obj.foregroundcolor(2),...
                                                                                                                                            obj.foregroundcolor(3));
                        fprintf(fid,'%s''Callback'', @%s,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.callback); 
                        fprintf(fid,'%s''String'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.string);
                        fprintf(fid,'%s''FontName'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontname);
                        fprintf(fid,'%s''FontSize'', %d,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontsize);
                        fprintf(fid,'%s''FontWeight'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontweight);
                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = uicontrol('])));
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = uicontrol('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                        fprintf(fid,'\t\tfunction %s(Source,EventData)\n\n',obj.callback);
                        fprintf(fid,'\t\t\t%% WRITE YOUR FUNCTION DEFINITION HERE\n');
                        fprintf(fid,'\t\t\t%% To get a property use:\n');
                        fprintf(fid,'\t\t\t%%\tfoo = get(handle,''property'');\n');
                        fprintf(fid,'\t\t\t%% To set a property use:\n');
                        fprintf(fid,'\t\t\t%%\tset(handle,''property'',foo);\n\n');
                        fprintf(fid,'\t\tend');
                        
                        fprintf(fid,'\n\n\n');
                    %----------------------------------------------------------
                    case 'text'

                        fprintf(fid,'%s = uicontrol(''Style'',''Radio'',...\n',obj.handle);
                        fprintf(fid,'%s''BackgroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.backgroundcolor(1),...
                                                                                                                                            obj.backgroundcolor(2),...
                                                                                                                                            obj.backgroundcolor(3));
                        fprintf(fid,'%s''ForegroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.foregroundcolor(1),...
                                                                                                                                            obj.foregroundcolor(2),...
                                                                                                                                            obj.foregroundcolor(3));
                        
                        fprintf(fid,'%s''String'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.string);
                        fprintf(fid,'%s''FontName'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontname);
                        fprintf(fid,'%s''FontSize'', %d,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontsize);
                        fprintf(fid,'%s''FontWeight'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.fontweight);
                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = uicontrol('])));
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = uicontrol('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                        
                        
                        fprintf(fid,'\n\n\n');


                    %----------------------------------------------------------
                    case 'axes'
                        fprintf(fid,'%s = axes(',obj.handle);

                        fprintf(fid,'%s''XLim'',[%.2f %.2f],...\n',blanks(length([obj.handle ' = axes('])),obj.xlim(1),obj.xlim(1));
                        fprintf(fid,'%s''YLim'',[%.2f %.2f],...\n',blanks(length([obj.handle ' = axes('])),obj.ylim(1),obj.ylim(1));    


                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = axes('])));  
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = axes('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                        fprintf(fid,'title(%s,''%s'')\n',obj.handle,obj.title);
                        fprintf(fid,'xlabel(''%s'')\n',obj.handle,obj.xlabel);
                        fprintf(fid,'ylabel(''%s'')\n',obj.handle,obj.ylabel);                                                                                                   obj.position(3),...
                                           
                    
                        fprintf(fid,'\n\n\n');
                    %----------------------------------------------------------
                    case 'menu'

                        fprintf(fid,'%s = uicontrol(''Style'',''PopupMenu'',...\n',obj.handle);
                        fprintf(fid,'%s''Callback'', @%s,...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.callback); 
                        fprintf(fid,'%s''String'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.string);
                        fprintf(fid,'%s''Value'', ''%s'',...\n ',blanks(length([obj.handle ' = uicontrol('])),obj.Value);
                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = axes('])));  
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = axes('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));


                        fprintf(fid,'\t\tfunction %s(Source,EventData)\n\n',obj.callback);
                        fprintf(fid,'\t\t\t%% WRITE YOUR FUNCTION DEFINITION HERE\n');
                        fprintf(fid,'\t\t\t%% To get a property use:\n');
                        fprintf(fid,'\t\t\t%%\tfoo = get(handle,''property'');\n');
                        fprintf(fid,'\t\t\t%% To set a property use:\n');
                        fprintf(fid,'\t\t\t%%\tset(handle,''property'',foo);\n\n');
                        fprintf(fid,'\t\tend');



                        fprintf(fid,'\n\n\n');
                    %----------------------------------------------------------
                    case 'panel'

                        fprintf(fid,'%s = uipanel(',obj.handle);
                        fprintf(fid,'%s''BorderType'',''%s'',...\n',blanks(length([obj.handle ' = uipanel('])),obj.BorderType);
                        fprintf(fid,'%s''BorderWidth'',%d,...\n',blanks(length([obj.handle ' = uipanel('])),obj.BorderType);

                        fprintf(fid,'%s''BackgroundColor'', [%.2f %.2f %.2f],...\n ',blanks(length([obj.handle ' = uipanel('])),obj.backgroundcolor(1),...
                                                                                                                                obj.backgroundcolor(2),...
                                                                                                                                obj.backgroundcolor(3));
                        

                        fprintf(fid,'%s''Units'', ''Normalized'',...\n ',blanks(length([obj.handle ' = uipanel('])));  
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n ',blanks(length([obj.handle ' = uipanel('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));
                        
                        fprintf(fid,'\n\n\n');
                    %----------------------------------------------------------
                    case 'image'

                        %position axes
                        fprintf(fid,'%s = axes(',obj.handle);


                        fprintf(fid,'''Units'', ''Normalized'',...\n ');  
                        fprintf(fid,'%s''Position'', [%.3f %.3f %.3f %.3f]);\n',blanks(length([obj.handle ' = axes('])),obj.position(1),...
                                                                                                                            obj.position(2),...
                                                                                                                            obj.position(3),...
                                                                                                                            obj.position(4));    
                        %load image
                        fprintf(fid,'IM = imread([''%s%s'']);\n',obj.path,obj.fileName);
                        %place on axes
                        fprintf(fid,'imshow(IM,''Parent'',%s);\n',obj.handle);
                        
                        fprintf(fid,'\n\n\n');
                        


        
        end
        
    end

    function codeGenerator(objects)
        
        %% open file
        if ispc()
            path = '';
            fileName = 'myGUI.m';
        else
            [fileName, path] = uiputfile('.m','Save generated Code','myGUI');
        end
        
        if fileName == 0
            return;
        end
        
        fid = fopen([path fileName],'w');
        
        %% print header
        if ispc()
            [~,user] = system('echo %username%');
        else
            [~,user] = system('echo $USER');
        end
         
        fprintf(fid,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n%%                   \n');
        fprintf(fid,'%%    %s         \n',fileName);
        fprintf(fid,'%%                   \n');
        fprintf(fid,'%% Created by %s%%\n', user);
        fprintf(fid,'%% on %s         \n%%\n',date);
        fprintf(fid,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n');

        fprintf(fid,'function %s()\n\n',fileName(1:end-2));

        fprintf(fid,'f_main = figure(''color'',[1 1 1],...\n');
        
        if ~isempty(objects.figure.closeReq)
            if objects.figure.closeReq.exist
                fprintf(fid,'                ''CloseRequestFcn'',@MyCloseReq,...\n');
            end
        end
        if ~isempty(objects.keyfnc)
            if objects.keyfnc.exist
                fprintf(fid,'                ''KeyPressFcn'',@%s,...\n',objects.keyfnc.fncName);
            end
        end
            
            
        fprintf(fid,'                ''Units'',''Normalized'',...\n');
        fprintf(fid,'                ''position'',[%.2f %.2f %.2f %.2f]);\n\n',objects.figure.position(1),...
                                                                                    objects.figure.position(2),...
                                                                                    objects.figure.position(3),...
                                                                                    objects.figure.position(4));
       fprintf(fid,'\n\n\n')
           
        
            %%
            
            if ~isempty(objects.figure.closeReq)
                if objects.figure.closeReq.exist
                    fprintf(fid,'%%%% CloseRequestFcn:\n\n');
                    fprintf(fid,'function MyCloseReq(Source, EventData)\n');
                    fprintf(fid,'\n');
                    fprintf(fid,'\t%% WRITE YOUR FUNCTION DEFINITION HERE\n');
                    if objects.timer.exist
                        fprintf(fid,'\tstop(%s);',objects.timer.handle);
                    end
                    fprintf('\tdelete(f_main)\n\n');
                    fprintf('end\n');
                    fprintf('\n\n')
                end
            end
            
            if ~isempty(objects.timer)
                if objects.timer.exist
                   %%print timer stuff
                   fprintf(fid,'%%%% CloseRequestFcn:\n\n');
                   fprintf(fid,'function SetupTimer()');
                       fprintf(fid,'\t%s = timer;',objects.timer.handle);

                       fprintf(fid,'\t%s.Period         = %d;',objects.timer.handle,objects.timer.period);
                       fprintf(fid,'\t%s.ExecutionMode  = ''%s'';',objects.timer.handle,objects.timer.ExecutionMode);
                       fprintf(fid,'\t%s.TimerFcn       = @autorefresh;',objects.timer.handle);
                       fprintf(fid,'\t%s.BusyMode       = ''%s'';',objects.timer.handle,objects.timer.BusyMode);
                       fprintf(fid,'\t%s.TasksToExecute = %d;',objects.timer.handle,objects.timer.TasksToExecute);

                       fprintf(fid,'start(%s)',objects.timer.handle);

                           fprintf(fid,'\t\tfunction autorefresh(h,~)\n\n');
                           fprintf(fid,'\t\t\tWRITE YOUR FUNCTION DEFINITION HERE\n\n');
                           fprintf(fid,'\t\tend\n');
                   fprintf(fid,'end\n');
                   
                   
                   
                   
                   
                end
            end
                    
                
            if ~isempty(objects.keyfnc)
                if objects.keyfnc.exist
                    
                    fprintf(fid,'%%%% KeyPressFcn:\n\n');
                     fprintf(fid,'function %s(~,e)\n\n',objects.keyfnc.fncName);
                     fprintf(fid,'\tk = e.Key;\n\n');
                     fprintf(fid,'\tswitch k\n\n'); 
                     
                     keys = objects.keyfnc.keys;
                     
                     for i = 1:length(keys)
                         fprintf(fid,'\t\t case ''%s''\n',keys{i});
                         fprintf(fid,'\t\t\t%% CASE DEFINITION GOES HERE\n');
                     end 
                     
                     fprintf(fid,'\n\tend\n');
                     fprintf(fid,'end\n');
                     
                     fprintf(fid,'\n\n\n');
                     
                end
            end
            if ~isempty(objects.tabmenu)
                if objects.tabmenu.exist
                    fprintf(fid,'%%%% UIMenu setup:\n\n');
                    fprintf(fid,'m = uimenu(''Label'',''My Menu'',...\n');
                    fprintf(fid,'           ''Parent'',f_main,...\n');
                    fprintf(fid,'           ''Position'',1);\n');
                    fprintf(fid,'%%------------------------------------\n')
                    for i = 1:3
                        fprintf(fid,'uimenu(''Label'',''Position %d'',...\n',i);
                        fprintf(fid,'       ''Parent'',m,...\n');
                        fprintf(fid,'       ''Callback'',@MenuAction_%d);\n',i);
                        fprintf(fid,'function MenuAction_%d(~,~)\n',i)
                        fprintf(fid,'\t%%DEFINE ACTION HERE\n');
                        fprintf(fid,'end\n');
                        fprintf(fid,'%%------------------------------------\n')
                    end
                end
            end
            if ~isempty(objects.keyshortcut)
                if objects.keyshortcut.exist
                    addAccelerator();
                end
            end
            
        
        
        %% print objects
        
            fprintf(fid,'\n\n%%%% GUI setup:\n');
        
            for i = 1:length(objects.push)
                write2file(fid,objects.push(i))
            end
            for i = 1:length(objects.slider)
                write2file(fid,objects.slider(i))
            end
            for i = 1:length(objects.radio)
                write2file(fid,objects.radio(i))
            end
            for i = 1:length(objects.bgroup)
                write2file(fid,objects.bgroup(i))
            end
            for i = 1:length(objects.edit)
                write2file(fid,objects.edit(i))
            end
            for i = 1:length(objects.text)
                write2file(fid,objects.text(i))
            end
            for i = 1:length(objects.axes)
                write2file(fid,objects.axes(i))
            end
            for i = 1:length(objects.menu)
                write2file(fid,objects.menu(i))
            end
            for i = 1:length(objects.panel)
                write2file(fid,objects.panel(i))
            end
            for i = 1:length(objects.image)
                write2file(fid,objects.image(i))
            end
        %% print end
        
        fprintf(fid,'end');
        
        fclose(fid);
    end

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% EDIT PROPERTIES GUIS %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function editIM()

    F_prop_IM = figure('color','w',...
                    'units','normalized',...
                    'NumberTitle','off',...
                    'name',toCheck.handle,...
                    'position',[0 0.8 .4 .2],...
                    'CloseRequestFcn',@closeIt);


    fileName = toCheck.fileName;
    path = toCheck.path;

    master_save = uicontrol('Style','PushButton',...
                   'Units','Normalized',...
                   'Position',[0.754988 0.052158 0.220698 0.176259],...
                   'string','SAVE',...
                   'fontname','monaco',...
                   'fontsize',13,...
                   'backgroundcolor',[1.0000 1.0000 1.0000],...
                   'CallBack',@saveIt);

               uicontrol('Style','PushButton',...
                   'Units','Normalized',...
                   'Position',[0.3 0.4 0.220698 0.176259],...
                   'string','Change image',...
                   'fontname','monaco',...
                   'fontsize',13,...
                   'backgroundcolor',[1.0000 1.0000 1.0000],...
                   'CallBack',@getSource);  
    name_text = uicontrol('Style','text',...
                   'Units','Normalized',...
                   'Position',[0.1 0.57 0.7 0.176259],...
                   'string',[path fileName],...
                   'fontname','monaco',...
                   'fontsize',12,...
                   'backgroundcolor',[1.0000 1.0000 1.0000],...
                   'CallBack',@getSource);  
                uicontrol('Style','text',...
                   'Units','Normalized',...
                   'Position',[0.3 0.74 0.24 0.176259],...
                   'string','Current image is:',...
                   'fontname','monaco',...
                   'fontsize',13,...
                   'backgroundcolor',[1.0000 1.0000 1.0000],...
                   'CallBack',@getSource);  

        function getSource(~,~)

            [fileName_temp, path_temp] = uigetfile({'*.png';'*.jpg';'*.jpeg'},'Choose the image you want to open');
            if fileName_temp == 0
                return
            else
                fileName = fileName_temp;
                path = path_temp;
                set(name_text,'string',[path fileName]);
            end
        end

        function saveIt(Source,EventData)

            toCheck.fileName = fileName;
            toCheck.path = path;

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


                delete(F_prop_IM);
            end



        end


    end

end






%% OBS:
%{

Figure:

[ ] Name
[ ] NumberTitle(on/off)
[X] KeyPressFcn
[ ] CloseRequestFcn
[ ] Color
[ ] Units
[X] Position
[ ] Resize (on/off)
[ ] WindowButtonDownFcn
[ ]	WindowButtonMotionFcn
[ ]	WindowButtonUpFcn
[ ]	WindowKeyPressFcn
[ ]	WindowKeyReleaseFcn
[ ]	WindowScrollWheelFcn

Push:

[ ] BackgroundColor
[ ] ForegroundColor
[ ] Callback
[ ] String
[ ] FontName
[ ] FontSize
[ ] FontWeight
[ ] Units
[ ] Position
[ ] Enable (on/off)

Slider:

[ ] Units
[ ] Position
[ ] Min
[ ] Max
[ ] Value
[ ] Callback


Radio:

[ ] BackgroundColor
[ ] ForegroundColor
[ ] Callback
[ ] Value
[ ] String
[ ] FontName
[ ] FontSize
[ ] FontWeight
[ ] Units
[ ] Position
[ ] Enable (on/off)

Button Group(uibuttongroup):

[ ]
[ ]
[ ]

Edit:

[ ] BackgroundColor
[ ] ForegroundColor
[ ] Callback
[ ] String
[ ] FontName
[ ] FontSize
[ ] FontWeight
[ ] Units
[ ] Position
[ ] Enable (on/off)

Text:

[ ] BackgroundColor
[ ] ForegroundColor
[ ] String
[ ] FontName
[ ] FontSize
[ ] FontWeight
[ ] Units
[ ] Position

Axes:

[ ] Units
[ ] Position
[ ] XLim
[ ] XTick
[ ] YLim
[ ] YTick
----------
[ ] title
[ ] xlabel
[ ] ylabel


PopupMenu:

[ ] Units
[ ] Position
[ ] Callback
[ ] Value
[ ] String(the options)

Panel:

[ ] BorderType
[ ] BorderWidth
[ ] BackgroundColor

Timer:

[X] Period
[X] ExecutionMode ('fixedRate')
[X] TimerFcn
[X] BusyMode ('queue')
[X] TasksToExecute

Tab Menu:

[ ] Label
[ ] Position

Accelerator:

[ ]


%}


%	This GUI was powered by the GUIDesigner v 1.3

