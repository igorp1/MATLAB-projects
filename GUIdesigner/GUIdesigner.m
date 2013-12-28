%{

    GUI designer v 1.0.0

    by Igor dePaula

    EK 127 - Spring 14'

%}


function GUIdesigner()

global file;     %tells you to which file everything is been saved
global callbacks;
callbacks =0;


%%Promp user for project name

if ispc()
    file = 'myGUI.m';
else
    [fileName,path] = uiputfile('myGUI.m','Choose where you want to save your GUI');
    
    file = fileName;
    
end









%% open file:
if ispc()
    [~,user] = system('echo %username%');
else
    [~,user] = system('echo $USER');
end



fid = fopen([path file],'w');

fprintf(fid,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n%%                   \n');
fprintf(fid,'%%    %s         \n',file);
fprintf(fid,'%%                   \n');
fprintf(fid,'%% Created by %s%%\n', user);
fprintf(fid,'%% on %s         \n%%\n',date);
fprintf(fid,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n');

fprintf(fid,'function %s()\n\n',file(1:end-2));

fprintf(fid,'f_main = figure(''color'',''w'',...\n');
fprintf(fid,'                ''units'',''normalized'',...\n');
fprintf(fid,'                ''position'',[0 0 1 1]);\n\n\n');



fclose(fid);
%% object properties:
global object %tells you what kind of object is been placed on the panel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       THE PROPERTIES OF A BASIC OBJECTS      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   STYLE                      % STYLE t= string
%                 -<                           %
%                /  \  COLOR                   % COLOR t= 3x3 double vec(for some: foreground and background)
%               /    -<                        %
%              /       STRING                  %
%             /                                %
%            /                                 %
%           /                   X              % X t= double
% OBJECT  -<           ORIGIN -<               %
%           \         /         Y              % Y t= double
%             FRAME -<                         %
%                     \                        %
%                      \       HEIGHT          % HEIGHT t= double
%                       SIZE -<                %
%                              WIDTH           % WIDTH t= double
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define Colors:

axes_color =   [220 220 220]/255;  %LIGHT GREY
push_color =   [150 250   0]/255;    %GREEN
slider_color = [255 230   0]/255;    %YELLOW
edit_color =   [120  70 200]/255;    %PURPLE
text_color =   [250  80   0]/255;     %ORANGE
panel_color =  [ 50  40 255]/255;     %BLUE
menu_color =   [200   0   0]/255;      %RED


%% GUI setup:

f_main = figure('color', 'white',...
    'units','normalized',...
    'position',[0.025 0.05 0.95 0.9],...
    'CloseRequestFcn',@closeMe);

%% Drawing area:
DrawPanel = uipanel('background',[0.98 0.98 0.98],...
    'units','normalized',...
    'position',[0 0 .85 1]);

DrawAxes = axes('parent',DrawPanel,...
    'units','normalized',...
    'position',[0 0 1 1],...
    'xlim',[0 100],...
    'ylim',[0 100]);

%% Functionality:

y = 0.05
axes_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Axes',...
    'callback',@generate,...
    'fontsize',15,...
    'fontweight','bold',...
    'backgroundcolor',[axes_color]);
y = y + .1;
push_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Button',...
    'callback',@generate,...
    'fontsize',15,...
    'fontweight','bold',...
    'backgroundcolor',[push_color]);
y = y + .1;
slider_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Slider',...
    'callback',@generate,...
    'fontsize',15,...
    'fontweight','bold',...
    'backgroundcolor',[slider_color]);
y = y + .1;
edit_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Editable Textbox',...
    'callback',@generate,...
    'fontsize',13,...
    'fontweight','bold',...
    'backgroundcolor',[edit_color]);
y = y + .1;
text_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Textbox',...
    'callback',@generate,...
    'fontsize',15,...
    'fontweight','bold',...
    'backgroundcolor',[text_color]);
y = y + .1;
panel_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Panel',...
    'callback',@generate,...
    'fontsize',15,...
    'fontweight','bold',...
    'backgroundcolor',[panel_color]);
y = y + .1;
menu_new = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[.875 y .1 0.1],...
    'string','New Menu',...
    'callback',@generate,...
    'fontsize',15,...
    'fontweight','bold',...
    'backgroundcolor',[menu_color]);




%%                                                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% CALLBACKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Function to generate object:

    function generate(s,~)
        
        source = get(s);
        
        switch source.String(5:end);
            
            case 'Axes'
                disp('Axes')
                %ask for labels, title, x and y ranges
                getPropertyAxes();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',axes_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],axes_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
                
            case 'Button'
                disp('Button')
                %ask for backgorundcolor, foregroundcolor, string,
                %callback name, fontsize, fontweight
                getPropertypush();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',push_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],push_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
                
            case 'Slider'
                disp('Slider')
                %ask for range and origin
                getPropertyslider();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',slider_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],slider_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
                
            case 'Editable Textbox'
                disp('Editable Textbox')
                %ask for backgorundcolor, foregroundcolor, string,
                %callback name, fontsize, fontweight
                getPropertyEdit();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',edit_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],edit_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
                
                
            case 'Textbox'
                disp('Textbox')
                %ask for backgorundcolor, foregroundcolor, string,
                %fontsize, fontweight
                getPropertyText();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',text_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],text_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
                
                
            case 'Panel'
                disp('Panel')
                %ask for backgorundcolor, foregroundcolor
                getPropertyPanel();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',panel_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],panel_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
                
            case 'Menu'
                disp('Menu')
                %strings (options on menu)
                getPropertyMenu();
                uiwait;
                [X_origin, Y_origin] = ginput(1);
                hold on;
                plot(DrawAxes,X_origin, Y_origin,'marker','s','MarkerFaceColor',menu_color,'MarkerEdgeColor','k');
                set(DrawAxes,'xlim',[0 100],'ylim',[0 100]);
                
                [X_end, Y_end] = ginput(1);
                patch([X_origin X_end X_end X_origin],[Y_origin Y_origin Y_end Y_end],menu_color);
                
                if X_end < X_origin 
                    object.frame.origin.X = X_end/100;
                else
                    object.frame.origin.X = X_origin/100;
                end
                if Y_end < Y_origin
                    object.frame.origin.Y = Y_end/100;
                else
                   object.frame.origin.Y = Y_origin/100;
                end
                    
                    
                object.frame.size.width = abs(X_end - X_origin)/100;
                object.frame.size.height = abs(Y_end - Y_origin)/100;
                write2file(object);
        end
        
        
    end


%% Function to create objects:
    function getPropertyAxes(~,~)
        
        object.style = 'axes';
        
        f_sub = figure('units','normalized',...
            'position',[0.4 0.4 0.2 .3],...
            'color','w');
        
        handle_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.85 0.995 0.1]);
        handle_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.95 0.995 0.05],...
            'string','Handle Name:');
        
        title_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.70 0.995 0.1]);
        title_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.80 0.995 0.05],...
            'string','Title:');
        
        labelX_edit =  uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.55 0.995 0.1]);
        labelX_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.65 0.995 0.05],...
            'string','X label:');
        
        labelY_edit =  uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.4 0.995 0.1]);
        labelY_text = uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.5 0.995 0.05],...
            'string','Y label:');
        
        rangeX_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.35 0.995 0.05],...
            'string','X range:');
        rangeX_min = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.25 0.495 0.1]);
        rangeX_max = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.5 0.25 0.495 0.1]);
        
        rangeY_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.2 0.995 0.05],...
            'string','Y range:');
        rangeY_min = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.10 0.495 0.1]);
        rangeY_max = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.5 0.10 0.495 0.1]);
        
        pushIt = uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[0.25 0.0 0.5 0.1],...
            'string','Enter properties',...
            'callback',@saveProperties);
        
        
        function saveProperties(~,~)
            
            object.handle = get(handle_edit,'string');
            object.title = get(title_edit,'string');
            object.YLabel = get(labelY_edit,'string');
            object.XLabel = get(labelX_edit,'string');
            Ymin = str2num(get(rangeY_min,'string'));
            Ymax = str2num(get(rangeY_max,'string'));
            object.YLim=[Ymin Ymax];
            Xmin = str2num(get(rangeX_min,'string'));
            Xmax = str2num(get(rangeX_max,'string'));
            object.XLim=[Xmin Xmax];
            delete(f_sub);
        end
        
        
    end    %DONE
%%%%%%%%%%%%%
    function getPropertyMenu(~,~)
        
        object.style = 'popupmenu';
        
        f_sub = figure('units','normalized',...
            'position',[0.4 0.3 0.2 .5]);
        
        handle_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.9 0.995 0.05]);
        handle_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.95 0.995 0.05],...
            'string','Handle Name:');
        
        options_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.85 0.995 0.05],...
            'string','Options:');
        
        
        y = .8;
        for i = 1:3
            options_edit(i) = uicontrol('style','edit',...
                'units','normalized',...
                'position',[0 y 1 0.05]);
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
        
        function addOptions(~,~)
            
            if length(options_edit) < 14
                options_edit(length(options_edit)+1) = uicontrol('style','edit',...
                    'units','normalized',...
                    'position',[0 y 1 0.05]);
                y = y - 0.05;
                set(moreoptions,'position',[.45 y .1 0.05]);
            elseif length(options_edit)+1 == 15
                options_edit(length(options_edit)+1) = uicontrol('style','edit',...
                    'units','normalized',...
                    'position',[0 y 1 0.05]);
                y = y - 0.05;
                set(moreoptions,'visible','off');
            end
            
            
            
        end
        
        function saveProperties(~,~)
            
            object.handle = get(handle_edit,'string');
            
            options = cell(1,length(options_edit));
            for i = 1:length(options_edit)
                
                options{i} = get(options_edit(i),'string');
                
            end
            
            object.string = options;
            
            delete(f_sub);
        end
         
        
    end    %DONE
%%%%%%%%%%%%%
    function getPropertyPanel(~,~)
        object.style = 'uipanel';

f_sub = figure('units','normalized',...
    'position',[0.4 0.3 0.2 .5]);

handle_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.005 0.9 0.995 0.05]);
handle_text =  uicontrol('style','text',...
    'units','normalized',...
    'position',[0.005 0.95 0.995 0.05],...
    'string','Handle Name:');

Color_text =  uicontrol('style','text',...
    'units','normalized',...
    'position',[0.005 0.85 0.995 0.05],...
    'string','Color:');

r_text = uicontrol('style','text',...
    'units','normalized',...
    'position',[0.00 0.75 .33 .05],...
    'string','R');

g_text = uicontrol('style','text',...
    'units','normalized',...
    'position',[0.33 0.75 .33 .05],...
    'string','G');

b_text = uicontrol('style','text',...
    'units','normalized',...
    'position',[0.66 0.75 .33 .05],...
    'string','B');

r_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.00 0.7 .33 .05],...
    'callback',@chooseColor);

g_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.33 0.7 .33 .05],...
    'callback',@chooseColor);

b_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.66 0.7 .33 .05],...
    'callback',@chooseColor);

p_COLOR = uipanel('units','normalized',...
                    'position',[0.05 0.1 0.905 .5]);
                
pushIt = uicontrol('style','pushbutton',...
                    'units','normalized',...
                    'position',[0.25 0.0 0.5 0.1],...
                    'string','Enter properties',...
                    'callback',@saveProperties);

    function saveProperties(~,~)
        
        object.handle = get(handle_edit,'string');
        
        R = str2num(get(r_edit,'string'))/255;
        G = str2num(get(g_edit,'string'))/255;
        B = str2num(get(b_edit,'string'))/255;
        
        if isempty(R) || R>255
            R=0;
        end
        
        if isempty(G) || G>255
            G=0;
        end
        
        if isempty(B) || B>255
            B=0;
        end
        
        
        object.color = [R G B];
        
        delete(f_sub);
    end

    function chooseColor(~,~)
        
        R = str2num(get(r_edit,'string'))/255;
        G = str2num(get(g_edit,'string'))/255;
        B = str2num(get(b_edit,'string'))/255;
        
        if isempty(R) || R>1
            set(r_edit,'string','0');
            R=0;
        end
        
        if isempty(G) || G>1
            set(g_edit,'string','0');
            G=0;
        end
        
        if isempty(B) || B>1
            set(b_edit,'string','0');
            B=0;
        end
        
        set(p_COLOR,'backgroundcolor',[R G B]);
        
        
    end



    end   %DONE
%%%%%%%%%%%%%
    function getPropertypush(~,~)

object.style = 'pushbutton';

f_sub = figure('units','normalized',...
    'position',[0.4 0.4 0.2 .3],...
    'color','w');

handle_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.005 0.85 0.995 0.1]);
handle_text =  uicontrol('style','text',...
    'units','normalized',...
    'position',[0.005 0.95 0.995 0.05],...
    'string','Handle Name:');

string_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.005 0.70 0.995 0.1]);
string_text =  uicontrol('style','text',...
    'units','normalized',...
    'position',[0.005 0.80 0.995 0.05],...
    'string','String:');

call_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.005 0.55 0.995 0.1]);
call_text =  uicontrol('style','text',...
    'units','normalized',...
    'position',[0.005 0.65 0.995 0.05],...
    'string','CallBack Function:');


Color_text =  uicontrol('style','text',...
    'units','normalized',...
    'position',[0.005 0.48 0.995 0.05],...
    'string','Color:');

r_text = uicontrol('style','text',...
    'units','normalized',...
    'position',[0.00 0.43 .33 .05],...
    'string','R');

g_text = uicontrol('style','text',...
    'units','normalized',...
    'position',[0.33 0.43 .33 .05],...
    'string','G');

b_text = uicontrol('style','text',...
    'units','normalized',...
    'position',[0.66 0.43 .33 .05],...
    'string','B');

r_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.00 0.33 .33 .1],...
    'callback',@chooseColor);

g_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.33 0.33 .33 .1],...
    'callback',@chooseColor);

b_edit = uicontrol('style','edit',...
    'units','normalized',...
    'position',[0.66 0.33 .33 .1],...
    'callback',@chooseColor);

p_COLOR = uipanel('units','normalized',...
    'position',[0.05 0.13 0.905 .2]);




pushIt = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.25 0.0 0.5 0.1],...
    'string','Enter properties',...
    'callback',@saveProperties);


    function chooseColor(~,~)
        
        R = str2num(get(r_edit,'string'))/255;
        G = str2num(get(g_edit,'string'))/255;
        B = str2num(get(b_edit,'string'))/255;
        
        if isempty(R) || R>255
            set(r_edit,'string','0');
            R=0;
        end
        
        if isempty(G) || G>255
            set(g_edit,'string','0');
            G=0;
        end
        
        if isempty(B) || B>255
            set(b_edit,'string','0');
            B=0;
        end
        
        set(p_COLOR,'backgroundcolor',[R G B]);
        
        
    end


    function saveProperties(~,~)
        
        object.handle = get(handle_edit,'string');
        object.string = get(string_edit,'string');
        object.fnc = get(call_edit,'string');
        R = str2num(get(r_edit,'string'))/255;
        G = str2num(get(g_edit,'string'))/255;
        B = str2num(get(b_edit,'string'))/255;
        
        if isempty(R) || R>255
            R=0;
        end
        
        if isempty(G) || G>255
            G=0;
        end
        
        if isempty(B) || B>255
            B=0;
        end
        
        
        object.color = [R G B];
        delete(f_sub);
        
    end


    end    %DONE
%%%%%%%%%%%%%
    function getPropertyslider(~,~)
        
        object.style = 'slider';
        
        f_sub = figure('units','normalized',...
            'position',[0.4 0.4 0.2 .3],...
            'color','w');
        
        handle_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.85 0.995 0.1]);
        handle_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.95 0.995 0.05],...
            'string','Handle Name:');
        
        max_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.70 0.995 0.1]);
        max_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.80 0.995 0.05],...
            'string','Maximum Value:');
        
        min_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.55 0.995 0.1]);
        min_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.65 0.995 0.05],...
            'string','Minimum Value:');
        
        val_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.40 0.995 0.1]);
        val_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.50 0.995 0.05],...
            'string','Initial Value:');
        
        pushIt = uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[0.25 0.0 0.5 0.1],...
            'string','Enter properties',...
            'callback',@saveProperties);
        
        
        
        function saveProperties(~,~)
            
            object.handle = get(handle_edit,'string');
            M = str2num(get(max_edit,'string'));
            m = str2num(get(min_edit,'string'));
            val = str2num(get(val_edit,'string'));
            
            if ~isempty(M) && ~isempty(m)
                if M < m
                    object.min = M;
                    object.max = m;
                        if val <= m && val >= M
                            object.value = val;
                        else
                            object.value = M;
                        end
                else
                    object.min = m;
                    object.max = M;
                        if val <= M && val >= m
                            object.value = val;
                        else
                            object.value = m;
                        end
                            
                end
                
            else
                
                object.min = -100;
                object.max = 100;
                object.value = 0;
                
                
            end
                
            
            
            delete(f_sub);
            
        end
        
        
    end  %DONE
%%%%%%%%%%%%%
    function getPropertyText(~,~)
        
        object.style = 'text';
        
        f_sub = figure('units','normalized',...
            'position',[0.4 0.4 0.2 .3],...
            'color','w');
        
        handle_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.85 0.995 0.1]);
        handle_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.95 0.995 0.05],...
            'string','Handle Name:');
        
        string_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.70 0.995 0.1]);
        string_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.80 0.995 0.05],...
            'string','String:');
        pushIt = uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[0.25 0.0 0.5 0.1],...
            'string','Enter properties',...
            'callback',@saveProperties);
        
        
        
        function saveProperties(~,~)
            
            object.handle = get(handle_edit,'string');
            object.string = get(string_edit,'string');
            delete(f_sub);
        end
        
        
    end    %DONE
%%%%%%%%%%%%%
    function getPropertyEdit(~,~)
        
        object.style = 'edit';
        
        f_sub = figure('units','normalized',...
            'position',[0.4 0.4 0.2 .3],...
            'color','w');
        
        handle_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.85 0.995 0.1]);
        handle_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.95 0.995 0.05],...
            'string','Handle Name:');
        
        string_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.70 0.995 0.1]);
        string_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.80 0.995 0.05],...
            'string','String:');
        
        call_edit = uicontrol('style','edit',...
            'units','normalized',...
            'position',[0.005 0.55 0.995 0.1]);
        call_text =  uicontrol('style','text',...
            'units','normalized',...
            'position',[0.005 0.65 0.995 0.05],...
            'string','CallBack Function:');
        
        pushIt = uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[0.25 0.0 0.5 0.1],...
            'string','Enter properties',...
            'callback',@saveProperties);
        
        
        
        function saveProperties(~,~)
            
            object.handle = get(handle_edit,'string');
            object.string = get(string_edit,'string');
            object.fnc = get(call_edit,'string');
            delete(f_sub);
            
        end
        
        
    end    %DONE


%% Function to save objects to file

    function write2file(obj)
        %%open file
        
        fid = fopen([path file],'A');
        
        %% check the object type:
        
        switch obj.style
            
            
            case 'axes' %OK
                if isempty(obj.handle)
                    fprintf(fid,'a = axes(''Units'',''Normalized'',...\n');
                else
                    fprintf(fid,'%s = axes(''Units'',''Normalized'',...\n',obj.handle);
                end
                fprintf(fid,'     ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                    obj.frame.origin.Y,...
                    obj.frame.size.width,...
                    obj.frame.size.height);
                if ~isempty(obj.XLim)
                    fprintf(fid,'     ''XLim'',[%.2f %.2f],...\n',obj.XLim(1), obj.XLim(2));
                else
                    fprintf(fid,'     ''XLim'',[%.2f %.2f],...\n',0,100);
                end
                if ~isempty(obj.YLim)
                    fprintf(fid,'     ''YLim'',[%.2f %.2f]);\n',obj.YLim(1), obj.YLim(2));
                else
                    fprintf(fid,'     ''YLim'',[%.2f %.2f]);\n',0,100);
                end
                
                fprintf(fid,'title(''%s'')\n',obj.title);
                fprintf(fid,'xlabel(''%s'')\n',obj.XLabel);
                fprintf(fid,'ylabel(''%s'')\n\n\n',obj.YLabel);
                
                
                
            case 'uipanel' %OK
                if isempty(obj.handle)
                    fprintf(fid,'p = uipanel(''Units'',''Normalized'',...\n');
                else
                    fprintf(fid,'%s = uipanel(''Units'',''Normalized'',...\n',obj.handle);
                end
                fprintf(fid,'     ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                    obj.frame.origin.Y,...
                    obj.frame.size.width,...
                    obj.frame.size.height);
                fprintf(fid,'         ''backgroundcolor'',[%.4f %.4f %.4f]);\n\n\n',obj.color(1),...
                                                                                obj.color(2),...
                                                                                obj.color(3));
                
                
                
                
            case 'pushbutton'%%OK
                if isempty(obj.handle)
                    fprintf(fid,'t = uicontrol(''Style'',''PushButton'',...\n');
                else
                    fprintf(fid,'%s = uicontrol(''Style'',''PushButton'',...\n',obj.handle);
                end
                fprintf(fid,'               ''Units'',''Normalized'',...\n');
                
                fprintf(fid,'               ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                                                                                obj.frame.origin.Y,...
                                                                                obj.frame.size.width,...
                                                                                obj.frame.size.height);
                fprintf(fid,'               ''string'',''%s'',...\n',obj.string);
                
                fprintf(fid,'               ''backgroundcolor'',[%.4f %.4f %.4f],...\n',obj.color(1),...
                                                                                obj.color(2),...
                                                                                obj.color(3));
                
                if isempty(obj.fnc)
                    callbacks = callbacks +1;
                    fprintf(fid,'               ''CallBack'',@MyCallback_%d);\n',callbacks);
                    fprintf(fid,'\tfunction MyCallback_%d(Source,EventData)\n\n',callbacks);  
                else
                    fprintf(fid,'               ''CallBack'',@%s);\n',obj.fnc);
                    fprintf(fid,'\tfunction %s(Source,EventData)\n\n',obj.fnc);
                end
                
                
                fprintf(fid,'\t\t%%WRITE YOUR FUNCTION DEFINITION HERE\n\n\tend\n\n\n');
                
                
            case 'slider' %OK
                if isempty(obj.handle)
                    fprintf(fid,'m = uicontrol(''Style'',''Slider'',...\n');
                else
                    fprintf(fid,'%s = uicontrol(''Style'',''Slider'',...\n',obj.handle);
                end
                
                fprintf(fid,'               ''Units'',''Normalized'',...\n');
                
                fprintf(fid,'               ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                                                                                obj.frame.origin.Y,...
                                                                                obj.frame.size.width,...
                                                                                obj.frame.size.height);
                
                fprintf(fid,'               ''max'',[%.2f],...\n',obj.max);
                fprintf(fid,'               ''min'',[%.2f],...\n',obj.min);
                fprintf(fid,'               ''value'',[%.2f]);\n\n\n',obj.value);
                    
                
            case 'text' %OK
                if isempty(obj.handle)
                    fprintf(fid,'t = uicontrol(''Style'',''Text'',...\n');
                else
                    fprintf(fid,'%s = uicontrol(''Style'',''Text'',...\n',obj.handle);
                end
                fprintf(fid,'               ''Units'',''Normalized'',...\n');
                
                fprintf(fid,'               ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                                                                                obj.frame.origin.Y,...
                                                                                obj.frame.size.width,...
                                                                                obj.frame.size.height);
                fprintf(fid,'               ''string'',''%s'');\n\n\n',obj.string);
                
            case 'edit'%OK
                if isempty(obj.handle)
                    fprintf(fid,'e = uicontrol(''Style'',''Edit'',...\n');
                else
                    fprintf(fid,'%s = uicontrol(''Style'',''Edit'',...\n',obj.handle);
                end
                fprintf(fid,'               ''Units'',''Normalized'',...\n');
                
                fprintf(fid,'               ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                                                                                obj.frame.origin.Y,...
                                                                                obj.frame.size.width,...
                                                                                obj.frame.size.height);
                fprintf(fid,'               ''string'',''%s'',...\n',obj.string);
                
                
                if isempty(obj.fnc)
                    callbacks = callbacks +1;
                    fprintf(fid,'               ''CallBack'',@MyCallback_%d);\n',callbacks);
                    fprintf(fid,'\tfunction MyCallback_%d(Source,EventData)\n\n',callbacks);  
                else
                    fprintf(fid,'               ''CallBack'',@%s);\n',obj.fnc);
                    fprintf(fid,'\tfunction %s(Source,EventData)\n\n',obj.fnc);
                end
                
                fprintf(fid,'\t\t%%WRITE YOUR FUNCTION DEFINITION HERE\n\n\tend\n\n\n');
                
                
            case 'popupmenu'%OK
                if isempty(obj.handle)
                    fprintf(fid,'m = uicontrol(''Style'',''PopupMenu'',...\n');
                else
                    fprintf(fid,'%s = uicontrol(''Style'',''PopupMenu'',...\n',obj.handle);
                end
                fprintf(fid,'                   ''Units'',''Normalized'',...\n');
                fprintf(fid,'                   ''Position'',[%f %f %f %f],...\n',obj.frame.origin.X,...
                                                                                obj.frame.origin.Y,...
                                                                                obj.frame.size.width,...
                                                                                obj.frame.size.height);
                
                fprintf(fid,'                   ''string'',{')
                for i = 1:length(obj.string)-1
                    
                    fprintf(fid,'''%s'',',obj.string{i});
                    
                end
                fprintf(fid,'''%s''});\n\n\n',obj.string{end});
                
                
                
                
        end
        
        fclose(fid)
                
        clear object;
        clear obj;
                
                
                
                
                
    end   %OK

    function closeMe(~,~)
        
        fid = fopen(file,'A');
        fprintf(fid,'\n\n\nend\n\n\n\n\n\n\n\n\n\n');
        fprintf(fid,'%%\tThis GUI was powered by the GUIDesigner v 1.0\n');
        fclose(fid);
        delete(f_main);
    end      %OK
        
   
end