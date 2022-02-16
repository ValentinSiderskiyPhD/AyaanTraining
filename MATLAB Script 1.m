upperbound = 20000;
shortdata = data_block1(1:7,1:upperbound);
n = 7;
for i = 1:n 
    subplot(n,1,i);
    plot(shortdata(i,1:upperbound))
end
