display(comtick_block1)
display(comtext_block1)

lower = 0;
upper = 0;
k0 = 1;
k1 = 2;
n = 7;
n0=1

    for i = 1:n
        subplot(n,1,i);
        plot(shortdata(i,lower:upper))
    end

for i0 = k0:k1
    lower = comtick_block1(n0);
    upper = comtick_block1(n0+2);

    lower = lower + 3;
    upper = upper + 3;
end
