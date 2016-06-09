function [y] = my_check(x)

if isnan(x) || isinf(x)
    y = 0;
    x
else
    y = x;
end