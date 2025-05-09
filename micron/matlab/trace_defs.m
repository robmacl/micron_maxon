% This file contains parameters describing the Micron trace data
% format.  The data is a 3D float array: 
%   data(sample_num,xyz,probe_point)
%
% To get 2D (n x 3) array of tip positions use:
%   squeeze(data(:,:,micron_position_tip))
%
% Use tip_pose.m to reconstruct the tip pose and see:
%   ../../research/tools/micron/plot3_data.m
%
% for an example of transforming using pose.
%
% These definitions are generated from "Probe Point.ctl" by
% probe_point_names.vi.  Up through micron_drive the order is the same as the
% actual signal flow.  All positions are in microns.

% Micron sample rate in samples/sec.  Note that the default decimate for
% read_bin_trace is 10, and data files from trialrunner.vi are usually
% decimated by 10.  Network data is streamed at full rate.
micron_Fs = 2016.1;

% Probe point names, generated by probe_point_names.vi
probe_points


% data(:,1,micron_status_flags) = bit fiags, access example using bitget:
%   bitget(flags, micron_position_servo_saturation_flag)
micron_cancellation_on_flag = 1;
micron_scaling_on_flag = 2;
micron_manipulator_slew_limit_flag = 3;
micron_position_servo_saturation_flag = 4;
micron_ASAP_position_valid_flag = 5;
micron_hard_manipulator_saturation_flag = 6;
