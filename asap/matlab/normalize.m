% normalize a linear homogenous vector or plain 3D vector,
% depending on length 3 or 4.
function [res] = normalize(v)
  res = v/norm(v(1:3));
  if (length(v) == 4)
    res(4) = 1;
  end
