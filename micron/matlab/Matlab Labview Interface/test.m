addpath('../');

trace_defs

packetIn = [];
packetOut = zeros(16,1, 'single');

[packetIn, restult] = matlab_labview_sync();
null_pos = packetIn(:,micron_null_pos_tip);

ctr = 0;
tic 
for i = 1:10000
    [packetIn, restult] = matlab_labview_sync();
    
    tip_pos = packetIn(:,micron_position_tip);
    %fprintf('%0.1f %0.1f %0.1f\n', tip_pos(1), tip_pos(2), tip_pos(3));
    
    % Goal (XYZ)
    packetOut(1) = null_pos(1) + 250*sin(ctr);
    packetOut(2) = null_pos(2);
    packetOut(3) = null_pos(3);
    
    % Whether or not to use sent goal position on LabVIEW side of things
    packetOut(4) = 0;
    
    % FIRE THE LASERZZZ!!!!
    packetOut(5) = 0;
    
    % TODO: Make LabVIEW read these floats as the RCM goal (XYZ)
    packetOut(6) = 0;
    packetOut(7) = 0;
    packetOut(8) = 0;
    
    if ~mod(i,100)
        fprintf('%0.1f %0.1f %0.1f\n', packetOut(1), packetOut(2), packetOut(3));
    end
    
    [result] = matlab_labview_sync(packetOut);
    ctr = ctr + 0.00314;
    %pause(0.001);
    java.lang.Thread.sleep(1)
end
toc