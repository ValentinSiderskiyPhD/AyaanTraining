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

% 1000 ticks = 1 second

extraplots = 2;

%% Graphs Each Experiment
%p = n; % activate this line to only display the graph from experiment #p. testing only. 
while p <= n % plots each test
    a = tickblock(m,1); % lower experiment data range
    b = tickblock(m+2,1); % upper experiment data range
    m = m + 3;
    figure("Name",name);
    
    for i = 1:n % plots each graph in test
        %correcting for DC bias in channel 5 and 6
        cchairpos1 = 40*(max(data(6,a:b)) - min(data(6,a:b)))^-1;
        cchairposdata = (data(6,a:b) - data(6,a))*cchairpos1;
        data(6,a:b) = cchairposdata;

        correctedplate = (data(5,a:b) - data(5,a)) * cchairpos1;
        data(5,a:b) = correctedplate;

        %plots all data
        subplot(n+extraplots,1,i);
        plot(data(i,a:b))
        title(titles(titlevar,:),'interpreter', 'none');
        titlevar = titlevar + 1;
    end    

    %add extra subplots here

    %Tilt Plate Chair Difference
    relativeoffset = (data(5,a:b) + data(6,a:b));
    subplot(n+extraplots,1,i+1);
    plot(relativeoffset)
    title("Relative Offset Between Tilt Plate and Chair")

    %Heart Rate Plot
    ekg = data(3,a:b);
    heartrateplot(ekg,n,extraplots)

    titlevar = 1;
    p = p + 1;
    namevar = namevar + 3; %Updates each title
    name = comtext_block1(namevar,1:14); 

end


%% Function / Subplot Declaration

function heartrateplot(ekg,n,extraplots)

[~, xp] = findpeaks(ekg,"MinPeakProminence",150);
o1 = size(xp,2);
v = [0,0]; % set containing every bpm calculated between peak distances

for o = 1:(o1-1)
    v(1,o) = xp(o+1)-xp(o);
    v(1,o) = (v(1,o))^-1 * 1000 * 60; % turns peak distances into bpm 
end

xpp = xp(:,1:(size(xp,2)-1));
subplot(n+extraplots,1,n+extraplots);
plot(xpp,v)
%scatter(xpp,v,36,"blue","filled")
title("Heart Rate")
end