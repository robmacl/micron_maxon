function [TR TRs accZn, accZn0] = getSurfTransform(file, options, TransOpts)

    
    if(nargin < 3)
        selType = 4; %side + pi/2 rotation..
        gNormal = true;
        center = [0 0 0];
        bLoadCenter = true;

    else
        selType = TransOpts.selType;
        gNormal = TransOpts.gNormal;
        center = TransOpts.center;
        bLoadCenter = false;
        
    end
    
    if(exist('acc_calib.mat', 'file'))
        load('acc_calib.mat');
    else
        accZero = [2.5 2.5 2.5];
        accMag = 1.0;
    end

%%
    if(bLoadCenter)
        chan = 1; %micron_position_tip
        [~, ~, center] = loadTraceData(file, chan, options);
    end
   
%%    
    %load ACC data of ASAP
    [~, ~, acc_avg] = loadAccData(file, options);
    %calcuate vector..
    vAcc = (acc_avg - accZero)/accMag; 
    accZ(1,:) = vAcc;
    
    
    %load ACC data of Surface
    if(gNormal)
        vAcc = [0 0 -1];
    else
        file = 'data\surface2.bin';
        if(~exist(file,2))
            [filename, pathname]=uigetfile({'*.bin';'*.dat';'*.*'},'Surface BIN files(*.bin)', 'MultiSelect','off' );
            file = [pathname filename];
        end

        [~, ~, acc_avg] = loadAccData(file, options);
        vAcc = (acc_avg - accZero)/accMag;
    end
    
    accZ(2,:) = vAcc;

    
    accZn = bsxfun(@rdivide, accZ,sqrt(sum(accZ.^2,2)));
    accZn0 = accZn;
  

    %%
    if(selType == 1)
         % R*w (world) = accZn (asap) R = Raw, R' = Rwa (output)
        Rx = AxisAngle2Rot([1 0 0 pi]); %accelerometer xy matching..
        accZn(1,:) = accZn(1,:)*Rx';
        accZn(2,:) = accZn(2,:)*Rx';
        
        % R*w (world) = accZn (asap) R = Raw, R' = Rwa (output)
        Rwa = calcTransform(accZn(1,:)); %Coord. Transform from asap to world, Rwa
        
        %Rt*R*w = Rt*accZn2(surface) R->Rt*R, R' = R'*Rt'
        Rws = calcTransform(accZn(2,:)); %Coord. Transform from surface to world, Rws
       

        
    elseif(selType == 2)
        % R*w (world) = accZn (asap) R = Raw, R' = Rwa (output)
        Rx = AxisAngle2Rot([1 0 0 pi]); %accelerometer xy matching..
        accZn(1,:) = accZn(1,:)*Rx';
        accZn(2,:) = accZn(2,:)*Rx';
        
        % R*w (world) = accZn (asap) R = Raw, R' = Rwa (output)
        Rwa = calcTransform(accZn(1,:)); %Coord. Transform from asap to world, Rwa
        
        Rz = eye(3);
        Rz = AxisAngle2Rot([0 0 1 -pi/2]); %accelerometer xy matching..
        
        %Rt*R*w = Rt*accZn2(surface) R->Rt*R, R' = R'*Rt'
        Rws = calcTransform(accZn(2,:)); %Coord. Transform from surface to world, Rws
        Rws = Rws*Rz';
        

    elseif(selType == 3)     %for side attachmet..
 
%       accelerometer matching..
%         accZn(1,1) = accZn0(1,3);
%         accZn(1,2) = -accZn0(1,1);
%         accZn(1,3) = -accZn0(1,2);
        
        Rx = AxisAngle2Rot([1 0 0 pi/2]); 
        accZn(1,:) = accZn0(1,:)*(Rx); %side to ASAP coordinate transform..z-axis matching..
        
        Rz = AxisAngle2Rot([0 0 1 pi/2]); %side to ASAP coordinate transform..xy-axis matching..
        accZn(1,:) = accZn(1,:)*(Rz);
        

        Rwa = calcTransform(accZn(1,:)); %Coord. Transform from asap to world, Rwa

        
        Rz = eye(3);
        Rx = AxisAngle2Rot([1 0 0 pi]); %accelerometer xy matching..
        
        %Rt*R*w = Rt*accZn2(surface) R->Rt*R, R' = R'*Rt'
        accZn(2,:) = accZn0(2,:)*Rx';
        Rws = calcTransform(accZn(2,:)); %Coord. Transform from surface to world, Rws
     

        
    elseif(selType == 4)
        
        
        Rx = AxisAngle2Rot([1 0 0 pi/2]); 
        accZn(1,:) = accZn0(1,:)*(Rx); %side to ASAP coordinate transform..z-axis matching..
        
        Rz = AxisAngle2Rot([0 0 1 pi/2]); %side to ASAP coordinate transform..xy-axis matching..
        accZn(1,:) = accZn(1,:)*(Rz);
        
         
        
        Rwa = calcTransform(accZn(1,:)); %Coord. Transform from asap to world, Rwa
        
        %Rwa = Rwa*Rx';
        Raw = Rwa'; %Coord. Transform from asap to world, Rwa
        
        Rz = eye(3);
        Rx = AxisAngle2Rot([1 0 0 pi]); %accelerometer xy matching..
        
        %Rt*R*w = Rt*accZn2(surface) R->Rt*R, R' = R'*Rt'
        accZn(2,:) = accZn0(2,:)*Rx';
        Rws = calcTransform(accZn(2,:)); %Coord. Transform from surface to world, Rws

        %%
        R = AxisAngle2Rot([0 0 1 -pi/2]); %accelerometer xy matching..
        %R = AxisAngle2Rot([0 0 1 -th0]); %accelerometer xy matching..
        Rws = Rws*R';
        

    else
        error('Please select transform type!');

    end
    
    Raw = Rwa'; %Coord. Transform from asap to world, Rwa
    Rsw = Rws';
    Rsa = Rsw*Rwa;
    
    %% method1
    %use only when loading cetner from tip position data file..
%     center = avg;
%     Tsw = eye(4);
%     Tsw(1:3, 1:3) = Rsw;
% 
%     Twa = eye(4);
%     Twa(1:3, 1:3) = Rwa;
%     Twa(1:3,4) = -Rwa*center';
%     Taw = inv(Twa);
% 
%     Tsa = Tsw*Twa; %Rsa = Rsw*Rwa & Rwa = Raw';
    %% method2
    TR = eye(4);
    TR(1:3, 1:3) = Rsa;
    TR(1:3,4) = -Rsa*center';
    
    %%
    TRs.Raw = Raw;
    TRs.Rwa = Rwa;
    TRs.Rsw = Rsw;
    TRs.Rws = Rws;

    

    
end