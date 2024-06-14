% Return nominal scale factor to convert normalized PSD readings into microns
% at the sensor.  This is approximately 1/6 of the object space distance due
% to optical demagnification.

function [scale] = nominal_scale () 
  
% sensor is 1cm, so +/- 5000 microns at full scale
scale = 5000;
