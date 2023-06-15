function x = stepfit(spectrum, YU, YD, Xmin)

N = length(spectrum);

num = 0;
for n = Xmin:N
    num = num+1;
    spe(num) = sum(abs([YU*ones(n,1); YD*zeros(N-n,1)] - spectrum));
end

[~,x] = min(spe);
x = x+Xmin;
