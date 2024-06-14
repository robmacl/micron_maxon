function options =  myGUICtrl

global h; 
myGUILoad;
%waitfor(h.f);
uiwait(h.f)

options = h.options;


if(~options.selTrace), return; end


end

function myGUILoad
global h;
% Create figure
h.f = figure('units','pixels','position',[500,500,320,200],...
             'toolbar','none','menu','none',...
             'name','Evaluate Traces', 'NumberTitle','off');
   
       
uipanel('Title','Trace','units','pixels','BackgroundColor', [.8 .8 .8] ,...
    'Position',[10 140 320-10*2 50]);

uipanel('Title','Options','units','pixels','BackgroundColor', [.8 .8 .8] ,...
    'Position',[10 55 320-10*2 75]);



% Create yes/no checkboxes
vOffset = 140 + 50/2-15;
hOffset = 5;
h.c1(1) = uicontrol('style','radiobutton','units','pixels',...
                'position',[hOffset+10,vOffset,65,20],'string','Hold-still','callback',@chk_call1);
h.c1(2) = uicontrol('style','radiobutton','units','pixels',...
                'position',[hOffset+90,vOffset,50,20],'string','Circle','callback',@chk_call1);
h.c1(3) = uicontrol('style','radiobutton','units','pixels',...
                'position',[hOffset+170,vOffset,50,20],'string','Helix', 'callback',@chk_call1);
h.c1(4) = uicontrol('style','radiobutton','units','pixels',...
                'position',[hOffset+250,vOffset,50,20],'string','None', 'callback',@chk_call1, 'Value',1);   

vOffset = 80 + 50/2-15;
h.c2(1) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+10,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','scale','callback',@chk_call2, 'Value',0);
h.c2(2) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+70,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','decimate','callback',@chk_call2, 'Value',1);
h.c2(3) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+130,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','plot', 'callback',@chk_call2, 'Value',1);
h.c2(4) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+190,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','simulation', 'callback',@chk_call2, 'Value',0);   
h.c2(5) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+250,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','save', 'callback',@chk_call2, 'Value',1); 
            
vOffset = vOffset - 25;            
h.c2(6) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+10,vOffset,60,20],'BackgroundColor', [.8 .8 .8],...
                'string','tipTransfrom','callback',@chk_call2, 'Value',1);
            
h.c2(7) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+70,vOffset,60,20],'BackgroundColor', [.8 .8 .8],...
                'string','eigTransform','callback',@chk_call2, 'Value',0);
h.c2(8) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+130,vOffset,60,20],'BackgroundColor', [.8 .8 .8],...
                'string','accTransform', 'callback',@chk_call2, 'Value',0);
            
h.c2(9) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+190,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','relT', 'callback',@chk_call2, 'Value',1);   
h.c2(10) = uicontrol('style','checkbox','units','pixels',...
                'position',[hOffset+250,vOffset,50,20],'BackgroundColor', [.8 .8 .8],...
                'string','errPlot', 'callback',@chk_call2, 'Value',0); 

vOffset = vOffset - 40;   
uicontrol('style','text','units','pixels',...
                'position',[hOffset+10,vOffset-15,30,40],...
                'string','Deci. Num.', 'BackgroundColor', [.8 .8 .8]);
h.c2(11) = uicontrol('style','edit','units','pixels',...
                'position',[hOffset+40,vOffset,20,20],...
                 'string','0','callback',@chk_call2);
set(h.c2(11), 'String', num2str(get(h.c2(2),'Value')*10));                            
            
uicontrol('style','text','units','pixels',...
    'position',[hOffset+60,vOffset-15,50,40],...
    'string','Index Offset', 'BackgroundColor', [.8 .8 .8]);
            
h.c2(12) = uicontrol('style','edit','units','pixels',...
                'position',[hOffset+110,vOffset,40,20],...
                 'string','0','callback',@chk_call2);
    

% Create OK pushbutton  
h.p(1) = uicontrol('style','pushbutton','units','pixels',...
                'position',[180,15,60,30],'string','OK',...
                'callback',@p_OK);
h.p(2) = uicontrol('style','pushbutton','units','pixels',...
    'position',[180 + 70,15,60,30],'string','Cancel',...
    'callback',@p_CANCEL);
            
            
    %Checkbox callback
    function chk_call1(varargin)
        hc = varargin{1};
        pVal = get(hc,'Value');
        set(h.c1(:),'Value',0);
        set(varargin{1},'Value',pVal);
        %Line, Circle, Helixe, None..
        if(hc == h.c1(2))
            set(h.c2(12), 'String', num2str(500));
        else
            set(h.c2(12), 'String', num2str(0));
        end
        
    end
    function chk_call2(varargin)
         hc = varargin{1};
         pVal = get(hc,'Value');
         if(hc == h.c2(6) || hc == h.c2(7) || hc == h.c2(8))
             set(h.c2(6:8),'Value',0);
             set(varargin{1},'Value',pVal);
         end
         
         if(hc == h.c2(2))
             set(h.c2(11), 'String', num2str(pVal*10));
         end
            

    end

    % Pushbutton callback
    function p_OK(varargin)
        val1 = get(h.c1,'Value');
        checked = find([val1{:}],1);
        h.selTrace = checked;
        
        h.options  = mapCtrl2Opts(h.c2);
        %h.selTrace = checked;
        h.options.selTrace = checked;
        
%         val2 = get(h.c2,'Value');
%         checked = find([val2{:}],1);
%         h.options = checked;
%         
%         val3 = str2double(get(h.c2(11),'String'));
        h.options.holdstill = false;
        switch h.selTrace
            case 1
                disp('Hold-Still');
                h.options.holdstill = true;
            case 2
                disp('Circle');
            case 3
                disp('Helix');
            case 4
                disp('None');
            
        end
      
        %close();
        uiresume(h.f)
    end

    function p_CANCEL(varargin)
        h.selTrace = 0;
        %h.options  = mapCtrl2Opts(h.c2);
        disp('Cancel Selection!');
        close(h.f);
    end


end



