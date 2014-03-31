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

f_main = figure('color',[1 1 1],...
                'Units','Normalized',...
                'position',[0.03 0.05 0.95 0.86]);






%% GUI setup:
kjhgfh_ = uicontrol('Style','Push',...
                    'BackgroundColor', [1.00 1.00 1.00],...
                     'ForegroundColor', [0.00 0.00 0.00],...
                     'Callback', @defaultCall_2,...
                     'String', '',...
                     'FontName', 'Courier',...
                     'FontSize', 10,...
                     'FontWeight', 'normal',...
                     'Units', 'Normalized',...
                     'Position', [0.107 0.236 0.143 0.151]);

 		function defaultCall_2(Source,EventData)

			% WRITE YOUR FUNCTION DEFINITION HERE
			% To get a property use:
			%	foo = get(handle,'property');
			% To set a property use:
			%	set(handle,'property',foo);

		end


% hgfghcn = uicontrol('Style','Slider',...
%                     'Min',0.00,...                    
%                     'Max',0.00,...                   
%                     'Value',0.00,...    
%                     'Callback',@defaultCall_1'Callback', 
%                     'Units','Normalized',...         
%                     'Position', [0.379 0.781 0.567 0.058]);
%  		function defaultCall_1(Source,EventData)
% 
% 			% WRITE YOUR FUNCTION DEFINITION HERE
% 			% To get a property use:
% 			%	foo = get(handle,'property');
% 			% To set a property use:
% 			%	set(handle,'property',foo);
% 
% 		end


hello = axes('XLim',[0.00 10.00],...
             'YLim',[0.00 10.00],...
             'Units', 'Normalized',...
              'Position', [0.357 0.019 0.604 0.565]);
 title(hello,'')
xlabel('hello')
xlabel('')
ylabel('hello')
ylabel('')



logo = axes('Units', 'Normalized',...
             'Position', [0.045 0.611 0.296 0.289]);
IM = imread(['/Users/igorp/Pictures/background/1412769_1423357491226051_256539281_o.png']);
imshow(IM,'Parent',logo);



end