clc
clear
close all

[filename] = uigetfile('*mat');
load(filename)

m = 1; % data ranges in ticktimes
p = 1; % experiment plotting loop variable

channel_select = [1 2 3 5 6 7];

data = data_block1(channel_select,:);
[n, w] = size(data);

tickblock = comtick_block1;
times = ticktimes_block1;

namevar = 2; % loop var
name = comtext_block1(namevar,1:14); % Experiment name in window

titles = titles_block1(channel_select,:); % MCA, MP, ECG, etc.
titlevar = 1;

% 1001 ticks = 1 second

while p <= n % plots each test
    a = tickblock(m,1); % lower experiment data range
    b = tickblock(m+2,1); % upper experiment data range
    m = m + 3;
    figure("Name",name);

    for i = 1:n % plots each graph in test
        
        subplot(n+1,1,i);
        plot(data(i,a:b))
        title(titles(titlevar,:),'interpreter', 'none');
        titlevar = titlevar + 1;
        
    end
    
    %add any extra subplots here

    bpmca = data(2,a:b) - data(1,a:b);
    subplot(n+1,1,n+1);
    plot(bpmca)
    title("BP MCA Latency")
    
    titlevar = 1;
    p = p + 1;
    namevar = namevar + 3; %Updates each title
    name = comtext_block1(namevar,1:14); 
end
