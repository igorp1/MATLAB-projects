%{
    Yakhot Simulator
    Version 3.0

    Follow along the options

    The simulation can be executed from a file or you can choose to create
    a new Truss.

    The Truss will be plot for you along with the X and Y coordinates and
    the loads.

    In order to create a new Truss, you will be asked to enter:
        1. The number of members
        2. The number of joints
        3. The X and Y positions of every joint
        4. The joint in which the load is applied

    Notes: This simulator is for Trusses that are pined down on one side
    and are supported by a roller on the right side. Additinally, you have
    to make sure that you label the first joint as the one on the left
    side, pined to the ground and the last one, as the one on the right
    side supported by the roller.
    
    Developed by:

    ~Igor dePaula
    Boston University,
    ECE Department
    Fall 2013


%}


function YakhotSimulator()

%% Declare all the global variables that will be used:
clear -global

global jointsNum;
global jointsName;
global membersNum;
global membersName;
global C;
global Sx;
global Sy;
global X;
global Y;
global L;
global isNew;
global oldFile;
global done;
global A;
global lengthStraw;
global cost;


%% Ask the user if he has a file or if he will create a new one
fromFile();
uiwait();


if isNew
    %% Setup Interface to create a new Truss:
    
    setup();
    
    uiwait();
    defineConections(jointsNum,membersNum);
    Set_Sx_Sy();
    
    uiwait();
else
    %% Setup Interface based on existing file:
    
    
    
    [filename,filepath] = getInputFile();
    
    oldFile = [filepath filename];
    
    %loading the file gives you: C,Sx,Sy,X,Y,L
    %additionally it will also plot the Truss
    helloOldTruss();
    
    [rows,cols] = size(C);
    
    jointsNum = rows;
    membersNum = cols;
    
    for i = 1:jointsNum
        jointsName{i} = sprintf('joint #%d',i);
    end
    
    for i = 1:membersNum
        membersName{i} = sprintf('joint #%c',i+64);
    end
    
    
end



%% Setup the Main interface

f_M = figure('units','normalized',...
    'position',[.1 .1 .8 .8],...
    'color',[0.5+rand(1,3)/2]...
    );

TrussPanel = uipanel('units','normalized',...
    'position',[0.02 0.441 0.75 0.513],...
    'BackgroundColor','w',...
    'bordertype','etchedout'...
    );


TrussIM = axes('units','normalized',...
    'position',[0 0 1 1],...
    'parent',TrussPanel...
    );

%prealocating x and y positions:
XnY_Data = zeros(2, jointsNum);

%x and Y reference:
XnY = uitable('units','normalized',...
    'position',[0.040 0.1 0.631 0.1],...
    'data',XnY_Data,...
    'rowName',{'X:','Y:'},...
    'ColumnEditable',true(1,jointsNum)...
    );


Loads_Data = zeros(jointsNum,2);

Loads = uitable('units','normalized',...
    'position',[0.78 0.441 0.205 0.513],...
    'data',Loads_Data,...
    'rowName',jointsName,...
    'ColumnEditable',true(1,2),...
    'ColumnName',{'X:','Y:'}...
    );


if ~isNew
    plotTruss();
    
    set(XnY,'data',[X;Y]);
    set(Loads,'data',reshape(L,numel(L)/2,2));
    
    
end


%Simulate button:

Calc_button = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.817 0.1 0.09 0.05],...
    'callback',@loadTruss,...
    'string','Save Truss'...
    );

Load_button = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.817 0.04 0.09 0.05],...
    'callback',@simulate,...
    'string','Start Simulation'...
    );

Restart_button = uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.817 0.2 0.09 0.05],...
    'callback',@restart,...
    'string','Restart'...
    );

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% SIMULATION FCNS %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load variables from file:

    function setA()
        
        [r,c] = size(C);
        
        
        X = repmat(X,1,c)';
        
        
        Y = repmat(Y,1,c)';
        
        
        %preallocate M
        Mx = zeros(r,c);
        My = zeros(r,c);
        
        
        for i = 1:c%ineration through each member
            
            indx = find(C(:,i));
            
            %X-position
            Mx(indx(1),i) = X(indx(2),1) - X(indx(1),1);
            Mx(indx(2),i) = X(indx(1),1) - X(indx(2),1);
            
            
            
            %Y-position
            My(indx(1),i) = Y(indx(2),1) - Y(indx(1),1);
            My(indx(2),i) = Y(indx(1),1) - Y(indx(2),1);
            
            
        end
        
        
        M = [Mx;My];
        
        Stemp = [Sx;Sy];
        
        lengthStraw = sqrt(Mx.^2 + My.^2);
        
        cost = sum(sum(lengthStraw)/2) + r*10;
        
        distances = repmat(lengthStraw,2,1);
        
        M = M./distances;
        
        M(isnan(M)) = 0;
        
        A = [M Stemp];
        
    end

    function Set_Sx_Sy()
        
        %       Next we construct a connection matrix for the support forces along
        %       each axis, where Sx and Sy are matrices with j rows and 3 columns.
        %       Note that for our statically-determinate truss, supported by one
        %       pin and one roller joint, we will have a total of three unknown
        %       reactions. In each matrix, for each unknown reaction force, put a
        %       1 in the column that corresponds to the joint j (there should be
        %       only a single entry of ?1?; note that this is true in both matrices
        %       even though we know that for the loading conditions in this
        %       project, there are no support forces in the x direction) (and,
        %       another parenthetical note: be sure you understand and agree
        %       with the previous parenthetical remark!).
        
        %          Sx1 Sy1 Sy2
        %Joint 1: [ 0   0   0 ]
        %Joint 2: [ 0   0   0 ]
        %Joint 3: [ 0   0   0 ]
        %Joint 4: [ 0   0   0 ]
        %Joint 5: [ 0   0   0 ]
        %  ...    [... ... ...]
        
        Sx = zeros(jointsNum,3);
        
        Sx(1) = true;
        
        Sy = zeros(jointsNum,3);
        
        Sy(1,2) = true;
        Sy(end, 3) = true;
        
    end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% CALLBACK FCNS %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Restarts the simulator
    function restart(~,~)
        
        delete(f_M);
        YakhotSimulator;
        
    end

%% Saves and plots a newly created truss
    function loadTruss(~,~)
        
        %         if done
        %             warndlg({'The Truss has already been saved';'You may restart if you wish'});
        %             return
        %         end
        
        
        
        
        fid = fopen('YakhotSimulator_input.txt','w');
        fprintf(fid,'%%EK301, Section A1, Group 1, %s\n', date);
        fprintf(fid,'\\%% Puneet Jhaveri.....ID U-%d\n', 22333827);
        fprintf(fid,'\\%% Mike Lipschitz.....ID U-%d\n', 73582249);
        fprintf(fid,'\\%% Igor dePaula.......ID U-%d\n', 42055545);
        fprintf(fid,'\\%% Luke Sakakeeny.....ID U-%d\n', 58113705);
        fprintf(fid,'\\%% DATE: %s\n\n',date);
        %print C
        [r c]  = size(C);
        fprintf(fid,'C = [');
        for i = 1:r
            if i~=1
                fprintf(fid,'%s',blanks(5));
            end
            for j = 1:c
                fprintf(fid,' %d ',C(i,j));
            end
            if i == r
                fprintf(fid,'];\n');
            else
                fprintf(fid,';\n');
            end
        end
        
        
        %print Sx
        [r c]  = size(Sx);
        fprintf(fid,'Sx = [');
        for i = 1:r
            if i ~= 1
                fprintf(fid,'%s',blanks(5));
            end
            for j = 1:c
                fprintf(fid,' %d ',Sx(i,j));
            end
            if i == r
                fprintf(fid,'];\n');
            else
                fprintf(fid,';\n');
            end
        end
        
        
        %print Sy
        [r c]  = size(Sy);
        fprintf(fid,'Sy = [');
        for i = 1:r
            if i ~= 1
                fprintf(fid,'%s',blanks(5));
            end
            for j = 1:c
                fprintf(fid,' %d ',Sy(i,j));
            end
            if i == r
                fprintf(fid,'];\n');
            else
                fprintf(fid,';\n');
            end
        end
        
        %print X
        XnY_set = get(XnY,'data');
        X = XnY_set(1,:);
        fprintf(fid,'X = [');
        for i = 1:length(X)
            fprintf(fid,' %d ',X(i));
        end
        fprintf(fid, ' ];\n');
        
        %print Y
        Y = XnY_set(2,:);
        fprintf(fid,'Y = [');
        for i = 1:length(Y)
            fprintf(fid,' %d ',Y(i));
        end
        fprintf(fid, ' ];\n');
        
        %print L
        L = get(Loads,'data');
        L = reshape(L,numel(L),1);
        fprintf(fid,'L = [');
        for i = 1:length(L)
            fprintf(fid,' %d ',L(i));
        end
        fprintf(fid, ' ];\n');
        
        fclose all;
        
        
        
        %% Plot Truss:
        hold(TrussIM,'off');
        for i = 1:membersNum
            
            x = X(logical(C(:,i)));
            y = Y(logical(C(:,i)));
            
            plot(TrussIM,x,y,'--gs',...
                'LineWidth',2,...
                'MarkerSize',10,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor',[0.5,0.5,0.5]);
            hold(TrussIM,'on');
        end
        
        axis(TrussIM,[-3 max(X)+3 0 max(Y)+3]);
        
        %open input file just created
        if ~ispc()
            !open YakhotSimulator_input.txt
        else
            open('YakhotSimulator_input.txt');
        end
        
        saveas(TrussIM,'YakhotSimulator_TrussDiagram.png');
        
        %done = true;
        
    end

%% Starts the simulation
    function simulate(~,~)
        
        %% Check if the simulation has yet happened or not:
        if done
            warndlg({'The simulation already happende, you will find the' ...
                'output file in your directory.','You may restart the simulation if you want'});
            return
        end
        
        
        %% Setup A
        
        if isempty(done) || done==false
        setA();
        end
        
        %% Start the simulation:
        
        inc = 1; %set the inicial increment to 5 N. 
        
        figure %open a new figure for the simulation plot
        
        willbreak = 0; %kick it right into the for loop
        
        while max(willbreak)<1% it breaks when the curren load exceeds Fb
           
            %get the forces again:
            %loadfile
            L(L~=0) = 5*inc;
            
            try
            T = inv(A)*(-L');
            catch
                warndlg('Your Truss design is not valid for this simulator')
                return
            end
            T = -T;
            
            %%%%%%%%%%%%%%%%Simulation%%%%%%%%%%%%%%%%%
            
            T4loads = T(1:end-3);
            
            iten  = T4loads >=0;
            
            T4loads(iten) = 0;
            
            T4loads = abs(T4loads);
            
%             lengthStraw = sum(lengthStraw)/2;
            
            Fb = 402.043./(sum(lengthStraw)/2).^1.435;
            
            willbreak = T4loads./Fb';
           
            
            indx = find(max(willbreak)==willbreak);
            
            U = 282.78./lengthStraw.^2.43;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %plot the current scenario
            hold on
            plot(max(L),max(willbreak),'r*')
            ylabel('buckling ratio')
            xlabel('load')
            
            
            pause(0.01);
            inc = inc + 0.01;
            
        end
        
        
        
        
        
        %% Save your results:
        
        %% Print the first half of the file:
        
        % savefile
        
        fid = fopen('YakhotSimulator_output.txt','w');
        
        
        cmpindx = T < 0;
        tenindx = T > 0;
        
        
        state = zeros(1,length(T)-3);
        
        state(cmpindx) = 'C';
        state(tenindx) = 'T';
        state(state == 0) = '-';
        state = char(state);
        
        
        %%print all the names:
        
        fprintf(fid,'%%EK301, Section A1, Group 1, %s\n', date);
        fprintf(fid,'\\%% Puneet Jhaveri.....ID U-%d\n', 22333827);
        fprintf(fid,'\\%% Mike Lipschitz.....ID U-%d\n', 73582249);
        fprintf(fid,'\\%% Igor dePaula.......ID U-%d\n', 42055545);
        fprintf(fid,'\\%% Luke Sakakeeny.....ID U-%d\n', 58113705);
        fprintf(fid,'\\%% DATE: %s\n\n',date);
        
        
        
        %print all the members
        for i = 1:length(T)
            fprintf(fid,'m%d: %.3f (%c)\n',i ,abs(T(i)), state(i));
        end
        
        
        
        fprintf(fid,'Reaction forces in Newtons: \n');
        
        fprintf(fid,'Sx1: %.2f\n', T(end-2));
        
        fprintf(fid,'Sy1: %.2f\n',T(end-1));
        
        fprintf(fid,'Sy2: %.2f\n',T(end));
        
        fprintf(fid,'Cost of Truss: $%.2f\n',cost);
        
        %%
        
        fprintf(fid,'Theoretical load/cost ratio in N/$: %.4f\n', max(L)/cost);
        
        fprintf(fid,'Member %d will be the first one to break\n',indx);
        
        fprintf(fid,'Length of member is: %.2f\n',lengthStraw(indx));
        
        fprintf(fid,'The predicted buckling strength is %.2f\n',Fb(indx));
        
        fprintf(fid,'The buckling strength uncertainty is %.2f\n',U(indx));
        
        fprintf(fid,'The maximum load of the truss is %.2f\n',max(L));
        
        fprintf(fid,'The maximum load uncertainty is %.2f\n',(max(L).*U(indx)./Fb(indx)));
        
        
        fclose all;
        
        done = true;
        
        if ~ispc()
            !open YakhotSimulator_output.txt
        else
            open('YakhotSimulator_output.txt');
        end
        
    end

%% Load an exiting file into the main interface
    function helloOldTruss(~,~)
        
        %% Load all variables:
        fid = fopen(oldFile,'r');
        if fid==-1
            error('file could not be loaded')
        end
        
        mycell = textscan(fid,'%s','delimiter','\n');
        
        fclose all;
        
        mat = char(mycell{1});
        
        refo = mat == '[';
        refc = mat == ']';
        
        refo = sum(refo')';
        refc = sum(refc')';
        
        refo = find(refo);
        refc = find(refc);
        
        if length(refo)~=length(refc)
            error('Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.');
        end
        
        tempstr = [];
        
        for i = 1:length(refo)
            
            for j = refo(i):refc(i)
                tempstr = [tempstr mat(j,:)];
                
            end
            eval(tempstr)
        end
        
    end


    function plotTruss(~,~)
        %% Plot Truss:
        hold(TrussIM,'off');
        for i = 1:membersNum
            
            x = X(logical(C(:,i)));
            y = Y(logical(C(:,i)));
            
            plot(TrussIM,x,y,'--gs',...
                'LineWidth',2,...
                'MarkerSize',10,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor',[0.5,0.5,0.5]);
            hold(TrussIM,'on');
        end
        
        axis(TrussIM,[-3 max(X)+3 0 max(Y)+3]);
    end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% SETUP FCNS %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Lets you pick whether you want so simulate from a file or create a trus

    function fromFile()
        
        f = figure('color','w',...
            'units','normalized',...
            'position',[.3 .4 .35 .25],...
            'CloseRequestFcn',@donotexit...
            );
        
        uicontrol('units','normalized',...
            'position',[0 0 1 .5],...
            'style','pushbutton',...
            'string','I already have a Truss I want to load',...
            'callback',@getFromFile);
        
        
        uicontrol('units','normalized',...
            'position',[0 .5 1 .5],...
            'style','pushbutton',...
            'string','I want to create a new Truss',...
            'callback',@MakeNewFile);
        
        function donotexit(~,~)
            if isempty(isNew)
                warndlg('You must pick an option before moving on')
            else
                delete(f)
            end
        end
        
        function getFromFile(~,~)
            isNew = false;
            close(f);
        end
        
        function MakeNewFile(~,~)
            isNew = true;
            close(f);
        end
        
    end

%% Asks for the number of members and joints:
    function setup()
        
        fS = figure('units','normalized',...
            'position',[.3 .4 .35 .25],...
            'color','w',...
            'CloseRequestFcn',@donotexit...
            );
        
        %variables for relative positioning:
        x = 0.15;
        y = 0.4;
        w = 0.3;
        h = 0.1;
        
        uicontrol('style','text',...
            'units','normalized',...
            'position',[x y w h],...
            'string','Enter # of joints:');
        
        J_input = uicontrol('style','edit',...
            'units','normalized',...
            'position',[x+w+.05 y w h]...
            );
        
        uicontrol('style','text',...
            'units','normalized',...
            'position',[x y+h+0.2 w h],...
            'string','Enter # of members:'...
            );
        
        M_input = uicontrol('style','edit',...
            'units','normalized',...
            'position',[x+w+.05 y+h+0.2 w h]...
            );
        
        uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[x+w/2+0.025 y-h-0.15 w h],...
            'string','Save Values',...
            'callback',@save...
            );
        
        
        function donotexit(~,~)
            
            warndlg('You must input all values and save before moving on');
            
        end
        
        
        
        
        function save(~,~)
            
            numJ = get(J_input,'string');
            numM = get(M_input,'string');
            
            numJ = str2num(numJ);
            numM = str2num(numM);
            
            if isempty(numJ) || isempty(numM) || numJ<=0 || numM<=0
                warndlg('One or more of the values entered are not valid.')
                return
            end
            
            %Define the number of joints and members
            jointsNum = round(numJ);
            membersNum = round(numM);
            
            %Define the cellarray with names of joints and members
            for i = 1:jointsNum
                jointsName{i} = sprintf('joint #%d',i);
            end
            
            for i = 1:membersNum
                membersName{i} = sprintf('member #%c',i+64);
            end
            
            delete(fS)
            
            
        end
    end

%% Gets the input file from the user's computer
    function [fileName,path] = getInputFile()
        
        [fileName,path] = uigetfile('.txt','Choose Input file');
        
    end

%% Gets all the connections between joints and members
    function defineConections(numJoints, numMembers)
        %You want to be able to create a matrix(C) that holds information of to which
        %joints members are connected. You want this matrix to have as many rows as
        %the truss has joints and as many columns as the truss has members. So, if
        %the truss has member 4 connected to joint 2, you want to show it by
        %putting a 1 in your C matrix:
        %
        %        M1 M2 M3 M4 M5
        %Joint 1[0  0  0  0  0]
        %Joint 2[0  0  0  1  0]
        %Joint 3[0  0  0  0  0]
        %Joint 4[0  0  0  0  0]
        
        f_C = figure('units','normalized',...
            'position',[.3 .4 .35 .25],...
            'color','w',...
            'CloseRequestFcn',@savedata);
        
        Cgui = false(numJoints,numMembers);
        
        C_mat = uitable('data',Cgui,...
            'units','normalized',...
            'position',[0 0.1 1 0.9],...
            'ColumnName',membersName,...
            'ColumnEditable',true(1,numMembers),...
            'RowName', jointsName);
        
        Save_C = uicontrol('style','pushbutton',...
            'units','normalized',...
            'position',[0.375 0 0.25 0.1],...
            'string','Save',...
            'callback',@savedata);
        
        function savedata(~,~)
            
            %check to see if the input is acceptable:
            Cinput = get(C_mat,'data');
            
            C = Cinput;
            
            check = any(sum(Cinput) ~= 2);
            
            if check
                warndlg('One or more of the values entered are not valid.');
                return
            end
            
            
            delete(f_C)
        end
        
    end



end