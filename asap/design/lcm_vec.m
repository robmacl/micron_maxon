function [res, factors, powers] = lcm_vec (v)
buf = zeros(1, max(v));
for x = v
  fn = factor(x);
  for f = unique(fn)
    f_pow = sum(fn == f);
    if (f_pow > buf(f))
      buf(f) = f_pow;
    end
  end
end

factors = find(buf ~= 0);
powers = buf(factors);

res = prod(factors.^powers);
