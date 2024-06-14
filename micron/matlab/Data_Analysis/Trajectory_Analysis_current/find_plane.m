function [normal, v,  T] = find_plane(data)

    [u s v] = svd(data'*data);
    normal = v(:,end);
    T = inv(v);
    
end