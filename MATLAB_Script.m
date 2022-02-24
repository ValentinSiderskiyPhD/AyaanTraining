clc
clear
close all

[filename] = uigetfile('*mat');
load(filename)

%load("VVA Template 2022 Labchart 8 V2 VVA001 VR Data")

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

numberofextraplots = 1;

v = [0,0];

%% Graphs Each Experiment

while p <= n % plots each test
    a = tickblock(m,1); % lower experiment data range
    b = tickblock(m+2,1); % upper experiment data range
    m = m + 3;
    figure("Name",name);

    for i = 1:n % plots each graph in test
        
        subplot(n+numberofextraplots,1,i);
        plot(data(i,a:b))
        title(titles(titlevar,:),'interpreter', 'none');
        titlevar = titlevar + 1;

        %ekg = data(3,a:b);
        %subplot(n+1,1,n+1);
        %plot(ekg)
        %title("Heart Rate")
        
        xp = data(3,a:b);
        heartrateplot(xp,n,numberofextraplots)

    end    

    titlevar = 1;
    p = p + 1;
    namevar = namevar + 3; %Updates each title
    name = comtext_block1(namevar,1:14); 
    


end



%% Function / Subplot Declaration

function heartrateplot(xp,n,numberofextraplots)

o1 = size(xp,2);
v = [0,0]; % set containing every bpm calculated between peak distances

for o = 1:o1;

    if o + 1 > o1;
        break
    else
        v(1,o) = xp(o+1)-xp(o);
        v(1,o) = (v(1,o))^-1 * 1001 * 60; % turns peak distances into bpm
    end
    
end

xpp = xp(:,1:(size(xp,2)-1));
subplot(n+numberofextraplots,1,n+numberofextraplots);
plot(xpp,v)
%scatter(xpp,v,36,"blue","filled")
title("Heart Rate")
end