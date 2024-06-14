%average linear velocity

syms t;
input =@(a, t0, t)(a*sin(2*pi/t0*t));

vel = diff(input,t');

intVal = int(vel^2,t);
sqIntVal = subs(intVal, 't','t0')-subs(intVal, 't',0);
v = sqrt(sqIntVal/'t0');
t0 = solve('v0' - v,'t0');
t0 = t0(1);

getTime = matlabFunction(t0);
%getTime = @(a,v0)(sqrt(2.0).*pi.*a)./v0

t1 = getTime(2, 1);
t2 = getTime(2, 2);
t4 = getTime(2, 5);

syms tx;
vx = solve(tx-t0,v0);
getVel = matlabFunction(vx);
%getVel = @(a,tx)(sqrt(2.0).*pi.*a)./tx
v1 = getVel(2, 8);
v2 = getVel(2, 4);
v5 = getVel(2, 1.6);


