function [tipPosT2, goalPosT2] = alignEigCoord(tipPosT, goalPosT)

    %step1. offset init phase angle
    th0 = atan2(goalPosT(1,2), goalPosT(1,1));
    T2 = eye(3);
    T2(1:2,1:2) = [cos(-th0) -sin(-th0);sin(-th0) cos(-th0)];

    goalPosT2 = goalPosT * T2';
    tipPosT2 = tipPosT * T2';

    
    %step2. swap x &y vectors..due to ambiguity of two eig vectors..
    
    idx = floor((length(tipPosT)/4)/2);

    %thetaTest = atan2(goalPosT2(2,2), goalPosT2(2,1));
    thetaTest = atan2(goalPosT2(idx,2), goalPosT2(idx,1));
    
    if(thetaTest <0) 
%     theta = atan2(goalPosT2(1:10,2), goalPosT2(1:10,1));
%     p = polyfit(1:length(theta),theta',1);
%if(p(1) <0) %swap x &y vectors..


        goalPosT2 = goalPosT2(:,[2 1 3]);
        tipPosT2 = tipPosT2(:,[2 1 3]);

        th0 = atan2(goalPosT2(1,2), goalPosT2(1,1));
        T2 = eye(3);
        T2(1:2,1:2) = [cos(-th0) -sin(-th0);sin(-th0) cos(-th0)];

        goalPosT2 = goalPosT2 * T2';
        tipPosT2 = tipPosT2 * T2';

    end
    
    
end
