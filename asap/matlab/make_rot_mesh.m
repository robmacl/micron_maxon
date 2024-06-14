% Mesh a rectangular volume of angular space.  Span is in degrees, while XYZ
% are the number of planes in that direction.  The volume is centered on the
% origin.
% 
% for example, rot_mesh('foo.dat', 1, 8, 20, 120)

function rot_mesh (out_file, x, y, z, span)

angles = make_mesh(x, y, z, span/(max([x, y, z]) - 1));

%plot the mesh grid
plot3(angles(:,1), angles(:,2), angles(:,3),'r-*')
grid on
xlabel('Rx');
ylabel('Ry');
zlabel('Rz');

res = angles;
tran_zeros=zeros(length(res),3);
res=horzcat(tran_zeros, res);
fprintf(1, '%d points\n', length(res));
save(out_file,'res','-ascii','-tabs');
