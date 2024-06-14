function TR = calcTransform(vecs)
    %Coordinate Transfrom,  %input : n x 3 vectors...
    %if size(vecs, 1) == 1, Transform from world [0 0 1] to accZn(1,:)
    %else,  Transfrom from accZn(1,:) to accZn(i,:)
 
    nVec = size(vecs, 1);
    if(nVec == 1)
        vecs = vertcat([0 0 1], vecs);
        nVec = nVec + 1;
    end
    
      
    vInit = vecs(1,:);
    if(norm(vInit))
        vInit = vInit/norm(vInit);
    else
        error('the length of vector is zero???');
    end
            
 
    for i= 2:nVec
        vec = vecs(i,:);

        rotAxis = cross(vInit,vec);  %|vInit|=1. |vAcc|=1...
        normAxis = norm(rotAxis);
        if(normAxis > 1e-6)
            rotAxis = rotAxis/normAxis;
        else
            rotAxis = vInit;  %No rotation
        end
        
        if(norm(vec))
            vec = vec/norm(vec);
        else
            error('the length of vector is zero???');
        end
        
        rotAngle = acos(vInit*vec'); 
        axis_angle=[rotAxis,rotAngle];
        
        %R*vInit = vec;, R: T01, R' = T10;
        TR{i-1} = AxisAngle2Rot(axis_angle)';
        
%          if(norm(rotAxis)>1e-10)
%              Q=getQuarternion(axis_angle');
%              RotMat = Quart2Rot(Q);
%              TR(1:3,1:3)=RotMat;
%          end
     
    end
    
    if(numel(TR)==1)
        TR = cell2mat(TR);
    end;
   %TR'*vec' = vInit

end