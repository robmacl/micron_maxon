function R = AxisAngle2Rot(axis_angle)
   
    axis = axis_angle(1:3); %1x3
    angle = axis_angle(4);
  
    
    %http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToMatrix/index.htm
    c = cos(angle);
    s = sin(angle);
    t = 1 - c;
    
    %skew matrix skA = cross(A, [1 1 1]');
    R = c*eye(3) + t*(axis'*axis) ...
        + s*[0 -axis(3) axis(2);axis(3) 0 -axis(1);-axis(2) axis(1) 0];
end