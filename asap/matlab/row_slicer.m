% Helper function for slicing up datafile rows with variable length parts.
function [new_nvals, slice] = row_slicer(nvals, slice_size)
new_nvals = nvals + slice_size;
slice = nvals + 1 : nvals + slice_size;
