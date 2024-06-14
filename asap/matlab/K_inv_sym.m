% What K_inv (projection transform) actually does, FYI.  This
% isn't used at runtime.

syms f sx dpxy1 dpxy2 Cxy1 Cxy2 x y z real;

K_inv = [
    f*sx/dpxy1	0	Cxy1	0
     0		f/dpxy2	Cxy2	0
     0		0	1	0];

K_inv * [x y z 1]'
