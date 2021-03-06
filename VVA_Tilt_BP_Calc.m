clc
clear
close all

%%{
[filename, filepath] = uigetfile('.mat',"Please open the VVA Script .mat data.");

if filepath == 0 error("No data selected."); end

load(fullfile(filepath,filename));
%}

%load("VVA Template 2022 Labchart 8 V2 VVA001 VR Data");
channel_select = [1 2 3 5 6 7]; % Skips the empty channel 4. 
data = data_block1(channel_select,:);
[Number_Of_Measurements, w] = size(data);

%% Pressure at the Heart and MCA. Type the distances below in meters OR centimeters. 

fm = 20; % Distance from finger to the midline
hm = 16; % Heart to where the finger is on the midline
mm = 42; % MCA to where the finger is on the midline
[FM, HM, MM] = MeterAssurity(fm,hm,mm);

rho = .997538; % Blood Density in g/mL
g = 9.81; % Gravity in m/s^2

ticknames = comtick_block1; % identifies experiment names
ticktimes = ticktimes_block1; % x axis var
titles = ["MCA (cm/s)";"BP (mmHg) ";"ECG       "; "CO2 (mmHg)"; "Plate Deg"; "Chair Deg "]; % fixing titles

chairpos = (data(6,:) - 2.49895)*(20/15 * 2.08229 - 2.49895) * 100; % Correcting for DC bias in channel 6. 
thetaR = chairpos; % see writeup for context on what thetaR is
bp = data(2,:);
[P_Heart, P_MCA] = heartmcabp(bp,thetaR,FM,HM,MM,rho,g);


%% Graphs Each Experiment
%1 = Number_Of_Experiments; % activate this line to only display the graph from experiment #1. testing only.

Context = comtext_block1;
[Number_Of_Experiments] = size(Context)/3; % Assumes experiment end and beginnings were properly recorded. 
Experiment_Plotting(Number_Of_Measurements,Number_Of_Experiments,ticknames,ticktimes,titles,Context,data)

%% Heart Rate Plot

ekg = data(3,:);
[Heart_Rate] = heartrate(ekg);


%% 
















%% Heart Rate Generator

function [Heart_Rate] = heartrate(ekg)

[~, Prominent_Peaks] = findpeaks(ekg,"MinPeakProminence",140);
o1 = size(Prominent_Peaks,2);

for o = 1:(o1-1) % makes a set v that contains heart bpm calculated between peak distances. 
    v(1,o) = Prominent_Peaks(o+1)-Prominent_Peaks(o);
    v(1,o) = (v(1,o))^-1 * 1000 * 60; % turns peak distances into bpm 
end

%[Heart_Rate] = Prominent_Peaks(:,1:(size(Prominent_Peaks,2)-1)); % line is needed for plotting against time bc it makes sure the sets are the same length
[Heart_Rate] = v;
end

%% Pressure at MCA and Heart Given Finger BP, Chair Angle, and Relevant Distances

function [P_Heart, P_MCA] = heartmcabp(bp,thetaR,FM,HM,MM,rho,g)

HF = hypot(HM,FM);
MF = hypot(MM,FM);

% Heart BP
thetaDH = acosd(HM/HF);
h = HF*sind(90 - thetaDH - thetaR); 
[P_Heart] = bp - rho * g * h * 10^3 * 1/133.322; % Pressure at the Heart

% MCA BP
thetaDM = acosd(MM/MF);
h = MF*sind(90 - thetaDM - thetaR);
[P_MCA] = bp - rho * g * h * 10^3 * 1/133.322; % Pressure at the MCA
end

%% Experiment Plotting Function

function Experiment_Plotting(Number_Of_Measurements,Number_Of_Experiments,ticknames,ticktimes,titles,Context,data)

m = 1; % data ranges in ticktimes
namevar = 2; % name loop var
[~, ContextSize] = size(Context);

for p = 1:Number_Of_Experiments % plots each experiment
    name = Context(namevar,1:ContextSize);
    figure("Name",name); % Experiment name in window
    titlevar = 1; % title naming var
    a = ticknames(m,1); % lower experiment data range
    b = ticknames(m+2,1); % upper experiment data range
    for i = 1:Number_Of_Measurements % plots each graph in test, setting beginning of experiment as 0 seconds. 
        subplot(Number_Of_Measurements,1,i);
        adjticktimes(1,a:b) = ticktimes(1,a:b) - ticktimes(1,a);
        plot(adjticktimes(1,a:b),data(i,a:b))
        xlim([adjticktimes(a) adjticktimes(b)]);
        title(titles(titlevar,:),'interpreter', 'none');
        titlevar = titlevar + 1;
    end
    m = m + 3;
    p = p + 1;
    namevar = namevar + 3; %Updates each title
end
end

%% Meter Assurity Function. Assures distances are in meters, just in case they're typed in CM. 

function [FM, HM, MM] = MeterAssurity(fm,hm,mm)

if fm > 2
    FM = fm/100;
else
    FM = fm;
end

if hm > 2
    HM = hm/100;
else
    HM = fm;
end

if mm > 2
    MM = mm/100;
else
    MM = mm;
end

end