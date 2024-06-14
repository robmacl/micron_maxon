%Create Trace circle has been verified ...06/11/2013...

clear all
micron_Fs = 2016.1/2;

%Construct a questdlg with three options
type={'circle' 'helix' 'lissajous'};

choice = questdlg('Please choose a trajectory:', ...
 'Select Target Trajectory', ...
 'Circle','Helix','Lissajous','Circle');


%iOffset = 100;
% Handle response
iChoice = 1;

cType = {'Const. Vel. (mm/s)', 'Const. Time (s)'};

cTypeVal = 0;
switch choice
    case 'Circle'
        disp([choice ' has been selected'])
        iChoice = 1;
        
        cchoice = questdlg('Please choose the type of a trajectory:', ...
         'Select Trajectory Type', ...
         cType{1}, cType{2}, cType{1});
        switch cchoice
            case cType{1}
                disp('Const. Vel. selected!');
                cTypeVal = 1;
            case cType{2}
                disp('Const. Time. selected!');
                cTypeVal = 2;
        end
        
        

        prompt = {'Radius of workspace (mm)', cchoice, 'Index Offset (n)'};
        dlg_title = 'Input for workspace diameter';
        num_lines = 1;
        def = {'1','2', '500'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        ans_d = str2double(answer);
        
        
        radius = ans_d(1)*1000;
        if(cTypeVal==1)
            totalTravel = 2*pi*ans_d(1); %mm
            totalTime = totalTravel/ans_d(2); %v=d/t
            length = floor(micron_Fs*totalTime); %for 1 seconde
        else
            length = floor(micron_Fs*ans_d(2)); %for 1 seconde
        end
       
        
        res = circle_tr(radius,length);



        %break   
    case 'Helix'
        disp([choice ' has been selected'])
        iChoice = 2;
        
        prompt = {'Diameter of workspace(+/-)', 'Trace Time','Num Rotation'};
        dlg_title = 'Input for workspace diameter';
        num_lines = 1;
        def = {'1','5','10'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        ans_d = str2double(answer);
        
        
        radius = ans_d(1)*1000;
        height = ans_d(1)*1000*2;
        length = floor(micron_Fs*ans_d(2)); %for 1 seconde
        n_rot = ans_d(3);
        
        res = helix_tr(radius,height,length,n_rot);
        

        %break
    case 'Lissajous'
        disp([choice ' has been selected'])
        iChoice = 3;
        
        prompt = {'Width of workspace', 'Trace Time','Num. of Order'};
        dlg_title = 'Input for workspace diameter';
        num_lines = 1;
        def = {'1','5','3'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        ans_d = str2double(answer);
        
        
        radius = ans_d(1)*1000;
        length = floor(micron_Fs*ans_d(2)); %for 1 seconde
        order = ans_d(3);
        
        res = lissajous_tr(radius,length,order);

end       

iOffset = ans_d(3);
if( iOffset > 0)
    pt = 0:iOffset-1;
    profile = radius*sin(pi/2/iOffset*pt);
    addPt = zeros(iOffset,3);
    addPt(:,1) = profile';
    res = vertcat(addPt, res);
end


plot3(res(:,1), res(:,2), res(:,3));
daspect([1 1 1])
grid on

if(iChoice ~=2)
    view(2);
end

if(cTypeVal==1)
    strSel = 'v';
elseif (cTypeVal ==2)
    strSel = 's';
else
    strSel = 's';
end


r = strrep(num2str(ans_d(1)), '.', 'p');

v = strrep(num2str(ans_d(2)), '.', 'p');

if(iOffset > 0)
    filename=sprintf('%s_r%s_%s%s_off%d.dat',type{iChoice},r,strSel,v,iOffset);
else
    filename=sprintf('%s_r%s_%s%s.dat',type{iChoice},r,strSel,v);
end


filename=['trace\\' filename];
dlmwrite(filename,[res res],' ');



