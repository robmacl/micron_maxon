% Evaluate all types of trajectories..06132013...by Sungwook Yang
% ex) line, circle, helix, and etc...
% current...
%clc;
close all;
clear all;
%clearvars -except 'pathname'
LINE = 1; CIRCLE =2; HELIX = 3; NONE = 4;
global h; 


% multi-files handler..
%clear all; 
[filename, pathname, nFiles] = getMultiBinFiles();


% if(~exist('pathname','var')), pathname = 0; end
% [filename, pathname, nFiles] = getMultiBinFiles(pathname);
% if(~nFiles), return; end

% ui handler...
options =  myGUICtrl;
guiH =findobj('Type','figure');
%selTraj: 1. Line, 2. Circle, 3. Helix, 4. None.

%%
if(options.selTrace == HELIX)
   [X Y Z r] = initHelix(options);
end
 
options = h.options;
% options.holdstill = false;
options.comp = '';

%close previous plots...
openedFigIDs = findobj('Type','figure');
openedFigIDs(openedFigIDs==guiH) =[] ;
close(openedFigIDs);

run_eval_sub;
%%