function EKMMGUI

global txtname % this is the name of the file where the conversation is happening 
global id      % this is the id of the user
global t       %this is the variable allocation for the refresh timer


FileRequestNew %brings up the initial window for "login"

uiwait         %waits for the user to request a session before opening the main window


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%_MAIN WINDOW INTERFACE_%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fMain = figure('units','normalized',...
    'color','w',...
    'position',[.3 .1 .4 .8],...
    'keypressfcn',@press,...
    'name',txtname,...
    'numbertitle','off',...
    'resize','off',...
    'keyreleasefcn',@release,...
    'closerequestfcn',@exit);% in pixels: [433 91 576 720]

convoPanel = uicontrol('style','text',...
    'units','normalized',...
    'position',[.05 .075 .90 .9],...
    'background','k',...
    'foreground',[0 .7 0],...
    'fontweight','bold',...
    'fontname','Courier New',...
    'fontsize',13.5,...
    'horizontalalignment','left');

inputLine = uicontrol('style','edit',...
    'units','normalized',...
    'position',[.05 .02 .9 .05],...
    'background','k',...
    'foreground',[0 .7 0],...
    'fontweight','bold',...
    'fontname','Courier New',...
    'fontsize',13.5,...
    'horizontalalignment','left',...
    'callback',@enterText);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


refreshtimer %this function kicks in the timer(t) to begin the auto refresh


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%_FUNCTIONS_%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    function enterText(~,e)%Main text entry function
        
        textInput = get(inputLine,'string');
        set(inputLine,'string','');
        if strcmp(textInput(1),'@')
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%_CODE FOR COMMANDS_%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            command = textInput(2:end);
            
            switch command
                
                case 'new'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DONE
                    exit
                    EKMMGUI
                    
                case 'file'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DONE
                    
                    FileRequestNew
                    
                case 'saveas'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DONE
                    
                    [file,path] = uiputfile(sprintf('Conversation_%d.txt',fMain),...
                        'Export Conversation Transcript');
                    
                    fid = fopen(txtname,'r');
                    if fid==-1
                        error('File not found')
                    end
                    convoCell = textscan(fid,'%s','delimiter','\n');
                    convo = convoCell{1};
                    fclose(fid);
                    fid = fopen(sprintf('%s%s.txt',path,file),'w');
                    [lines,~] = size(convo);
                    for i = 1:lines
                        fprintf(fid,'%s',convo{i})
                    end
                    fclose all;
                    
                    
                case 'clear'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DONE
                    set(convoPanel,'string','')
                    fid = fopen(txtname,'w+');
                    fclose all;
                    
                case 'help'
                    
                    helpcell = {    'The big textbox on the top is the field in which you will be able to see the conversation the little edit textbox on the bottom is the entry field. Write anything and hit enter to get the conversation going.';
                                    ' ';
                                   ['In order to control the interface you can enter commands. To enter a commend enter ''@'' followed by the command in the entry text field'];
                                    'This are the commands you may use in addition to mathematical operations(+,-,*,/...) and MATLAB functions:';
                                    ' ';
                                    ' ';
                                    'new     -> quits the current conversation and opens a new one';
                                    ' ';
                                    'file    -> allow you to change the current file and/or your personal id';
                                    ' ';
                                    'quit    -> closes the conversation';
                                    ' ';
                                    'help    -> opens the help panel';
                                    ' ';
                                    'clear   -> clears the current conversation record';
                                    ' ';
                                    'saveas  -> allows you to save a transcript of the conversation ina desired location'};

                    help = figure('units','normalized',...
                                'color','k',...
                                'name','HELP',...
                                'numbertitle','off',...
                                'position',[.7 .1 .2 .6]);
                            
                    helpPanel = uicontrol('style','text',...
                                            'units','normalized',...
                                            'position',[.0 .0 1 1],...
                                            'background','k',...
                                            'foreground',[0 .7 0],...
                                            'fontweight','bold',...
                                            'fontname','Courier New',...
                                            'fontsize',12.5,...
                                            'horizontalalignment','left',...
                                            'string',helpcell);
                    
                case 'quit'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DONE
                    
                    exit
                    
                otherwise%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DONE
                    
                    
                    out = eval(command);
                    
                    fid = fopen(txtname,'a');
                    fprintf(fid,sprintf('[%s>> %.4f ]\n',id,out));
                    fclose all;
                    
                    
                    
            end%switch
        else
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%% CODE FOR MESSENGER %%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            fid = fopen(txtname,'a');
            if fid==-1
                error('File not found')
            end
            fprintf(fid,'[%s]%s\n',id,textInput);
            
            fclose(fid);
            fid = fopen(txtname,'r');
            convoCell = textscan(fid,'%s','delimiter','\n');
            convo = convoCell{1};
            fclose all;
            
            [lines,~] = size(convo);
            if lines>37
                set(convoPanel,'string',{convo{lines-37:end}});
            else
                set(convoPanel,'string',convo)
            end
            
        end
        
    end%enterText 


    function  FileRequestNew(~,e)%the function to request the creation of a new file or continuing on a previous one
        
        
        FileRequestFigure = figure('units','normalized',...
            'color','w',...
            'position',[.2 .3 .5 .4],...
            'name','EK 127 MATLAB MESSENGER',...
            'numbertitle','off',...
            'resize','off');
        
        
        filename = uicontrol('style','edit',...
            'units','normalized',...
            'background','w',...
            'fontname','Courier New',...
            'fontsize',14,...
            'horizontalalignment','left',...
            'position',[.525 .35 .40 .1]);
        
        showbox_1 = uicontrol('style','text',...
            'units','normalized',...
            'position',[.525 .45 .40 .06],...
            'string','File Name:',...
            'background','w',...
            'fontname','Courier New',...
            'fontsize',14,...
            'horizontalalignment','left');
        
        
        identifier_Box = uicontrol('style','edit',...
            'units','normalized',...
            'background','w',...
            'fontname','Courier New',...
            'fontsize',14,...
            'horizontalalignment','left',...
            'position',[.525 .65 .40 .1]);
        
        showbox_2 = uicontrol('style','text',...
            'units','normalized',...
            'position',[.525 .75 .40 .06],...
            'string','Personal Identifier:',...
            'background','w',...
            'fontname','Courier New',...
            'fontsize',14,...
            'horizontalalignment','left');
        
        action = uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[.525 .2 .40 .06],...
            'string','Request',...
            'background','w',...
            'fontname','Courier New',...
            'fontsize',14,...
            'horizontalalignment','left',...
            'callback',@createFile);
        
        IMfile = axes('units','normalized',...
            'position',[0.05 0.05 .45 .9]);
        fileimage = imread('txtImage.jpg');
        imshow(fileimage,'parent',IMfile);
        
        
        
        function createFile(~,e)
            
            file = get(filename,'string');
            id = get(identifier_Box,'string');
            
            fid = fopen(sprintf('%s.txt',file),'a');
            fprintf(fid,sprintf('[%s connected]\n',id));
            
            fclose all;
            
            txtname = sprintf('%s.txt',file);
            
            
            
            delete(FileRequestFigure);
            
            
            
        end
        
        
    end%FileRequestNew


    function refreshtimer()%the timer to fresh the conversation panel
        t = timer;
        
        t.Period         = 1.5;
        t.ExecutionMode  = 'fixedRate';
        t.TimerFcn       = @autorefresh;
        t.BusyMode       = 'queue';
        t.TasksToExecute = inf;
        t.StopFcn        = @exit;
        
        start(t)
        
        function autorefresh(h,~)
            
            
            fid = fopen(txtname,'r');
            convoCell = textscan(fid,'%s','delimiter','\n');
            convo = convoCell{1};
            fclose all;
            [lines,~] = size(convo);
            if lines>37
                set(convoPanel,'string',{convo{lines-37:end}});
            else
                set(convoPanel,'string',convo)
            end
            
        end
        pause(2)
    end%refrehtimer


    function release(~,e)%key release to change the conversation panel foreground back to green
        
        k = e.Key;
        
        switch k
            
            case 'r'
                set(convoPanel,'foreground',[0 .7 0])
            case 'b'
                set(convoPanel,'foreground',[0 .7 0])
            case 'k'
                set(convoPanel,'foreground',[0 .7 0])
            case 'g'
                set(convoPanel,'foreground',[0 .7 0])
            case 'w'
                set(convoPanel,'foreground',[0 .7 0])
                
        end
        
        
    end%release 


    function press(~,e)%key release to change the conversation panel back to the desired color

        
        
        k = e.Key;
        
        switch k
            
            case 'r'
                set(convoPanel,'foreground','red')
            case 'b'
                set(convoPanel,'foreground','b')
            case 'k'
                set(convoPanel,'foreground','k')
            case 'g'
                set(convoPanel,'foreground',[.9 .8 0])
            case 'w'
                set(convoPanel,'foreground','w')
        end
    end%press


    function exit(~,e)%The function to exit
        stop(t)%stops the auto refresh
        delete(gcf)%closes the main window
    end%exit


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end