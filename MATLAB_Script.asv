clc
clear
close all

%%{
[filename, filepath] = uigetfile('.mat',"Please open the VVA Script .mat data.");

if filepath == 0 error("No data selected."); end

load(fullfile(filepath,filename));
%}

%load("VVA Template 2022 Labchart 8 V2 VVA001 VR Data");


channel_select = [1 2 3 5 6 7];

data = data_block1(channel_select,:);
[n, w] = size(data);

ticknames = comtick_block1; % identifies experiment names
ticktimes = ticktimes_block1; % x axis var
m = 1; % data ranges in ticktimes
p = 1; % experiment plotting loop variable
namevar = 2; % loop var
name = comtext_block1(namevar,1:14); % Experiment name in window

%titles = titles_block1(channel_select,:); % MCA, MP, ECG, etc.
titlevar = 1;
titles = ["MCA (cm/s)";"BP (mmHg) ";"ECG       "; "CO2 (mmHg)"; "Plate Deg"; "Chair Deg "]; % Fixing Titles

% 1000 ticks = 1 second


%correcting for DC bias in channel 6
cchairpos = (data(6,:) - 2.49895)*(20/15 * 2.08229 - 2.49895) * 100;
data(6,:) = cchairpos;

%correctedplate = (data(5,:) - 2.49895); data(5,:) = correctedplate;

%% Graphs Each Experiment

%p = n; % activate this line to only display the graph from experiment #p. testing only.
extraplots = 3;

while p <= n % plots each test
    a = ticknames(m,1); % lower experiment data range
    b = ticknames(m+2,1); % upper experiment data range
    %aa = a/1000 bb = b/1000
    m = m + 3;
    figure("Name",name);
    for i = 1:n % plots each graph in test
        subplot(n+extraplots,1,i);
        adjticktimes(1,a:b) = ticktimes(1,a:b) - ticktimes(1,a);
        plot(adjticktimes(1,a:b),data(i,a:b))
        xlim([adjticktimes(a) adjticktimes(b)]);
        title(titles(titlevar,:),'interpreter', 'none');
        titlevar = titlevar + 1;
    end
    titlevar = 1;
    p = p + 1;
    namevar = namevar + 3; %Updates each title
    name = comtext_block1(namevar,1:14); 

%add extra subplots here

    %Tilt Plate Chair Difference relativeoffset = (data(5,a:b) +
    %data(6,a:b)); subplot(n+extraplots,1,i); plot(relativeoffset)
    %title("Relative Offset Between Tilt Plate and Chair")

    %Heart Rate Plot
    ekg = data(3,a:b);
    heartrateplot(ekg,n,extraplots)

    %Adj. BP
    adjtt = adjticktimes(1,a:b);
    bp = data(2,a:b);
    ccchairpos = cchairpos(1,a:b);
    heartmcabp(bp(1,:),adjtt(1,:),ccchairpos(1,:),n,extraplots)

    


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
subplot(n+extraplots,1,n+extraplots-2);
plot(xpp,v)
title("Heart Rate (BPM)")
end



function heartmcabp(bp,adjtt,ccchairpos,n,extraplots)
% Input variables
%pivotpt = ;
p = .997538; % g/mL
g = 9.81; % m/s^2

FM = 20;
HM = 16; % Heart to where the finger is on the midline
MM = 42; % MCA to where the finger is on the midline

HF = hypot(HM,FM); % necessary hypotenuse
MF = hypot(MM,FM);

thetaR = ccchairpos(1,:);
thetaDH = acosd(HM/HF);
thetaDM = acosd(MM/MF);

% Height Calculations
hheart = HF*sind(90 - thetaDH - thetaR)*10^-2; 
hMCA = MF*sind(90 - thetaDM - thetaR)*10^-2;

% Adjusted BP
adjHeart = bp(1,:) - p * g * hheart / (133.322 * 10^9);
adjMCA = bp(1,:) - p * g * hMCA / (133.322 * 10^9);

subplot(n+extraplots,1,n+extraplots-1);
plot(adjtt,adjHeart)
title("Heart BP")

subplot(n+extraplots,1,n+extraplots);
plot(adjtt,adjMCA)
title("MCA BP")
end