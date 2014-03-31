%%%%%%%%%%%%%%%%%%%%% 
%                   
%    DanGUI.m         
%                   
% Created by igorp
%
% on 22-Feb-2014         
%
%%%%%%%%%%%%%%%%%%%%%


function DanGUI()

f_main = figure('color','w',...
                'units','normalized',...
                'position',[0 0 1 1]);


text_1 = uicontrol('Style','Text',...
               'Units','Normalized',...
               'Position',[0.109533 0.582729 0.256645 0.148041],...
               'string','jasydzfcjlhsa');


slide1 = uicontrol('Style','Slider',...
               'Units','Normalized',...
               'Position',[0.520165 0.634978 0.197984 0.023222],...
               'max',[10.00],...
               'min',[0.00],...
               'value',[5.00]);


bes = uicontrol('Style','Text',...
               'Units','Normalized',...
               'Position',[0.523831 0.668360 0.193401 0.037736],...
               'string','How much does Bessie stink? (0-10)');





end









%	This GUI was powered by the GUIDesigner v 1.3
