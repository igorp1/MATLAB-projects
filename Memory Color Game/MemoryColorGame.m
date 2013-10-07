function MemoryColorGame



clear all
%the variable mNumbers is the selection of the player
global myNumbers
% the variable selection will have the random selections from the game
global selection
% the variable c sets the level in which th player is in
global c
if isempty(c)
    c = 0;
end

%NEW%%
global posarray

posarray = {[.125 .425 .15 .2 ],[.325 .425 .15 .2 ],[.525 .425 .15 .2 ],[.725 .425 .15 .2 ]};

%%%%%%


%the figure window
f = figure('visible','on',...
    'units','normalized',...
    'position',[.25 .25 .5 .5],...
    'color','w',...
    'numbertitle','off',...
    'name','memory',...
    'DockControls','off');
%the red button, it has the value of of 1
r = uicontrol('style','pushbutton',...
    'backgroundcolor',[0.7 0 0],...
    'units','normalized',...
    'position',[.125 .425 .15 .2 ],...
    'callback',@printnum_1);
%the green button, it has the value of of 2
g = uicontrol('style','pushbutton',...
    'backgroundcolor',[0 0.7 0],...
    'units','normalized',...
    'position',[.325 .425 .15 .2 ],...
    'callback',@printnum_2);
%the blue button, it has the value of of 3
b = uicontrol('style','pushbutton',...
    'backgroundcolor',[0 0 0.7],...
    'units','normalized',...
    'position',[.525 .425 .15 .2 ],...
    'callback',@printnum_3);
%the yellow button, it has the value of of 4
y = uicontrol('style','pushbutton',...
    'backgroundcolor',[0.9 0.8 0],...
    'units','normalized',...
    'position',[.725 .425 .15 .2 ],...
    'callback',@printnum_4);
%the start button starts the game
start = uicontrol('style','pushbutton',...
    'backgroundcolor','default',...
    'units','normalized',...
    'position',[.3955 .125 .2 .2 ],...
    'string','START',...
    'fontsize',20,...
    'callback',@startara);

levelbox = uicontrol('style','text',...
                        'units','normalized',...
                        'backgroundcolor','w',...
                        'foregroundcolor','k',...
                        'fontsize',20,...
                        'position',[.4 .75 .2 .1],...
                        'string','HIT START');

%%%%%%%%%%%%%%%%%%%%%%%%%%_FUNCTIONS_%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the printnum functions will write a number to the variable myNumbers

    function printnum_1(~,~)
        
        if isempty(myNumbers)
            myNumbers = 1;
        else
            myNumbers  = [myNumbers 1];
        end
        
        if length(myNumbers) == length(selection)
            if myNumbers == selection
                
                for i = 1:4
                    set(f,'color','g');
                    set(levelbox,'backgroundcolor','g')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                end
                pause(0.7)
                startara
                myNumbers = [];
            else
                for i = 1:4
                    set(f,'color','r');
                    set(levelbox,'backgroundcolor','r')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                    set(f,'visible','off')
                end
            end
        end
        posindx = randperm(4);

set(r,'position',posarray{posindx(1)});
set(g,'position',posarray{posindx(2)});
set(b,'position',posarray{posindx(3)});
set(y,'position',posarray{posindx(4)});
        
    end

    function printnum_2(~,~)
        
        
        if isempty(myNumbers)
            myNumbers = 2;
        else
            myNumbers  = [myNumbers 2];
        end
        
        if length(myNumbers) == length(selection)
            if myNumbers == selection
                
                for i = 1:4
                    set(f,'color','g');
                    set(levelbox,'backgroundcolor','g')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                end
                pause(0.7)
                startara
                myNumbers = [];
            else
                for i = 1:4
                    set(f,'color','r');
                    set(levelbox,'backgroundcolor','r')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                    set(f,'visible','off')
                end
            end
        end
        posindx = randperm(4);

set(r,'position',posarray{posindx(1)});
set(g,'position',posarray{posindx(2)});
set(b,'position',posarray{posindx(3)});
set(y,'position',posarray{posindx(4)});
    end

    function printnum_3(~,~)
        
        if isempty(myNumbers)
            myNumbers = 3;
        else
            myNumbers  = [myNumbers 3];
        end
        
        if length(myNumbers) == length(selection)
            if myNumbers == selection
                
                for i = 1:4
                    set(f,'color','g');
                    set(levelbox,'backgroundcolor','g')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                end
                pause(0.7)
                startara
                myNumbers = [];
            else
                for i = 1:4
                    set(f,'color','r');
                    set(levelbox,'backgroundcolor','r')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                    set(f,'visible','off')
                end
            end
        end
        posindx = randperm(4);

set(r,'position',posarray{posindx(1)});
set(g,'position',posarray{posindx(2)});
set(b,'position',posarray{posindx(3)});
set(y,'position',posarray{posindx(4)});
    end

    function printnum_4(~,~)
        
        if isempty(myNumbers)
            myNumbers = 4;
        else
            myNumbers  = [myNumbers 4];
            
        end
        if length(myNumbers) == length(selection)
            if myNumbers == selection
                
                for i = 1:4
                    set(f,'color','g');
                    set(levelbox,'backgroundcolor','g')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                end
                pause(0.7)
                startara
                myNumbers = [];
            else
                for i = 1:4
                    set(f,'color','r');
                    set(levelbox,'backgroundcolor','r')
                    pause(0.1)
                    set(f,'color','w');
                    set(levelbox,'backgroundcolor','w')
                    pause(0.1)
                    set(f,'visible','off')
                end
            end
        end
        
        posindx = randperm(4);

set(r,'position',posarray{posindx(1)});
set(g,'position',posarray{posindx(2)});
set(b,'position',posarray{posindx(3)});
set(y,'position',posarray{posindx(4)});
    end

    function startara(~,~)
        
        set(r,'enable','off')
        set(b,'enable','off')
        set(g,'enable','off')
        set(y,'enable','off')
        
        set(start,'visible','off')
        
        c = c+1;
        set(levelbox,'string',sprintf('Level: %d',c));
        if isempty(selection)
            selection = randi([1 4],1);
        else
            selection  = [selection randi([1 4],1)];
        end
        
        for i = 1:c
            
            switch selection(i)
                
                case 1
                    set(r,'backgroundcolor','w')
                    pause(0.5)
                    set(r,'backgroundcolor',[0.7 0 0])
                case 2
                    set(g,'backgroundcolor','w')
                    pause(0.5)
                    set(g,'backgroundcolor',[0 0.7 0])
                case 3
                    set(b,'backgroundcolor','w')
                    pause(0.5)
                    set(b,'backgroundcolor',[0 0 0.7])
                case 4
                    set(y,'backgroundcolor','w')
                    pause(0.5)
                    set(y,'backgroundcolor',[0.9 0.8 0])
            end
            pause(0.3)
        end
        set(r,'enable','on')
        set(b,'enable','on')
        set(g,'enable','on')
        set(y,'enable','on')
    end

end


