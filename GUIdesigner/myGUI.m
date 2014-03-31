%%%%%%%%%%%%%%%%%%%%% 
%                   
%    myGUI.m         
%                   
% Created by igorp
%
% on 15-Jan-2014         
%
%%%%%%%%%%%%%%%%%%%%%


function myGUI()

f_main = figure('color','w',...
                'units','normalized',...
                'position',[0 0 1 1]);


k = uicontrol('Style','Slider',...
               'Units','Normalized',...
               'Position',[0.348763 0.406766 0.138405 0.260726],...
               'max',[100.00],...
               'min',[-100.00],...
               'value',[0.00]);


m = uicontrol('Style','PopupMenu',...
                   'Units','Normalized',...
                   'Position',[0.642071 0.395215 0.049496 0.382838],...
                   'string',{'','',''});





end









%	This GUI was powered by the GUIDesigner v 1.3
