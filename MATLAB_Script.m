clc
clear
close all

[filename] = uigetfile('*mat');
addpath(filename)
load(filename)

%load("VVA Template 2022 Labchart 8 V2 VVA001 VR Data");

channel_select = [1 2 3 5 6 7];

data = data_block1(channel_select,:);
[n, w] = size(data);

tickblock = comtick_block1; % identifies experiment names
times = ticktimes_block1; % identifies experiment data ranges
m = 1; % data ranges in ticktimes
p = 1; % experiment plotting loop variable
namevar = 2; % loop var
name = comtext_block1(namevar,1:14); % Experiment name in window

titles = titles_block1(channel_select,:); % MCA, MP, ECG, etc.
titlevar = 1;

% 1000 ticks = 1 second

%correcting for DC bias in channel 6
cchairpos = (data(6,:) - 2.49895)*(20/15 * 2.08229 - 2.49895) * 100;
data(6,:) = cchairpos;

%correctedplate = (data(5,:) - 2.49895);
%data(5,:) = correctedplate;

%% Graphs Each Experiment

%p = n; % activate this line to only display the graph from experiment #p. testing only. 
extraplots = 2;

while p <= n % plots each test
    a = tickblock(m,1); % lower experiment data range
    b = tickblock(m+2,1); % upper experiment data range
    m = m + 3;
    figure("Name",name);
    for i = 1:n % plots each graph in test
        subplot(n+extraplots,1,i);
        plot(data(i,a:b))
        title(titles(titlevar,:),'interpreter', 'none');
        titlevar = titlevar + 1;
    end
    titlevar = 1;
    p = p + 1;
    namevar = namevar + 3; %Updates each title
    name = comtext_block1(namevar,1:14); 

%add extra subplots here

    %Tilt Plate Chair Difference
    %relativeoffset = (data(5,a:b) + data(6,a:b));
    %subplot(n+extraplots,1,i);
    %plot(relativeoffset)
    %title("Relative Offset Between Tilt Plate and Chair")

    %Heart Rate Plot
    ekg = data(3,a:b);
    heartrateplot(ekg,n,extraplots)

    %MCA Adj. BP
    va = data(1,a:b);

    


end


%% Function / Subplot Declaration

function heartrateplot(ekg,n,extraplots)

[~, xp] = findpeaks(ekg,"MinPeakProminence",150);
o1 = size(xp,2);

for o = 1:(o1-1) % makes a set v that contains bpm calculated between peak distances
    v(1,o) = xp(o+1)-xp(o);
    v(1,o) = (v(1,o))^-1 * 1000 * 60; % turns peak distances into bpm 
end

xpp = xp(:,1:(size(xp,2)-1)); % makes sure the sets are the same length
subplot(n+extraplots,1,n+extraplots);
plot(xpp,v)
title("Heart Rate")
end



function heartmcabp(va)

%Pa = %arterial flow
p = .997538; % g/mL
g = 9.81; % m/s^2
ha = 14 * 0.0254; % m (from in)

%mcabp = Pa + p*g*ha + .5 * p * va^2
subplot(n+extraplots,1,n+extraplots);
plot(mcabp)
title("MCA BP")
end