% This is some code stripped out of calibrate_sensor that used to work when
% it was a script.

if (exist('Zu_m', 'var'))
  Zu_save = Zu_m;
  Zv_save = Zv_m;
end

% Don't extrapolate when comparing surfaces.
muv_min = min(measured_uv);
muv_max = max(measured_uv);
[X_m,Y_m] = meshgrid(linspace(muv_min(1), muv_max(1), nbins), ...
		     linspace(muv_min(2), muv_max(2), nbins));

Zu_m = fit_u(X_m, Y_m);
Zv_m = fit_v(X_m, Y_m);

% If there's an axis-related effect in the sensor, then you'd expect some
% resemblance between the surfaces rotated 90 degrees.  Of all the various 90
% degree rotations and mirrorings, this seems to give the highest
% correlation.  The negation is a bit harder to explain, but could have to
% do with the sign flip between the two axes (anode vs. cathode.)
corr_uv = correlate_surfaces(-rot90(Zu), Zv)

if (exist('Zu_save', 'var'))
  corr_u = correlate_surfaces(Zu_m, Zu_save)
  corr_v = correlate_surfaces(Zv_m, Zv_save)

  figure
  surf(X_m, Y_m, Zu_m - Zu_save);
  daspect([1, 1, 0.01])
  title('u error change');
  xlabel('u (\mum)');
  ylabel('v (\mum)');
  zlabel('\Deltau (\mum)');
  
  figure
  surf(X_m, Y_m, Zv_m - Zv_save);
  daspect([1, 1, 0.01])
  title('v error change');
  xlabel('u (\mum)');
  ylabel('v (\mum)');
  zlabel('\Deltav (\mum)');
end
