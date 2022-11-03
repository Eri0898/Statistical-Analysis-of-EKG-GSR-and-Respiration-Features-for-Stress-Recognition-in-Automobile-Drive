clear all
close all
clc

%% Loading data

data = edfread('drive06.edf');
T = size(data);
T = (T(1)*10)-10; %seconds
T = T/60; %minutes

ecg = data.ECG;
ecg = cell2mat(ecg);
ecg = ecg-mean(ecg);
ecg = ecg(1:2403936);
fs_ecg = 1/(10/length(data.ECG{1,1}));
%fundamental frequency ecg = 0.9861Hz
%resampling at 200 Hz
fs1_ecg = 200;
ecg = resample(ecg,fs1_ecg,fs_ecg);
fs_ecg = fs1_ecg;

emg = data.EMG;
emg = cell2mat(emg);
emg = emg-mean(emg);
fs_emg = 1/(10/length(data.EMG{1,1}));

footGSR = data.footGSR;
footGSR = cell2mat(footGSR);
footGSR = footGSR(1:150246);
fs_foot = 1/(10/length(data.footGSR{1,1}));

handGSR = data.handGSR;
handGSR = cell2mat(handGSR);
handGSR=handGSR(1:149834);
fs_hand = 1/(10/length(data.handGSR{1,1}));

hr = data.HR;
hr = cell2mat(hr);
fs_hr = 1/(10/length(data.HR{1,1}));

marker = data.marker;
marker = cell2mat(marker);
marker = marker-mean(marker);
marker = marker(1:75123);
fs_m = 1/(10/length(data.marker{1,1}));

resp = data.RESP;
resp = cell2mat(resp);
resp = resp(1:150246);
fs_resp = 1/(10/length(data.RESP{1,1}));

%% Pan tompkin on ecg signal (find R peaks from the ecg signal using the function pan_tompkin)

[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,fs_ecg,0);
R = qrs_i_raw;
figure;
plot(ecg);
hold on;
plot(R,ecg(R),'*r'); %knowing the positions of R peaks, ecg(R) tells the positions of R peaks on the x axis

%% Pan tompkin correction (correct when a R peak is missed or when it is too close to the previous one, i.e., when something is recognized as a peak without being a peak)

i=1;
NR=length(R);
M=mean(diff(R))-std(diff(R))-50;
while i+1<NR
    if  R(i+1)-R(i)<M      
        R(i+1)=[];        %delete the sample less than 200 ms away from the previous one
        i=i-1;
    end
    i=i+1;
    NR=length(R);
end

P1=(mean(diff(R))+std(diff(R))+50);
NR=length(R);
i=2;
while i<NR
    if R(i)-R(i-1)>P1     %eliminate the outlires identified in the absence of beats
        R_trans=mean([R(i-1) R(i)]);
        R=[R(1:i-1) round(R_trans) R(i:end)];
    end 
    i=i+1;
    NR=length(R);
end

for i=1:length(R)
    bef=R(i)-3;
    aft=R(i)+3;
    ecg_Ri=bef:aft;
    [val,idx]=max(ecg(ecg_Ri));
    R(i)=bef+idx-1;
end

figure('Name','ECG signal and R Peaks')
plot((1:length(ecg))/fs_ecg,ecg)
hold on
plot(R/fs_ecg,ecg(R),'*r')
xlim([0 length(ecg)/fs_ecg])

%% HRV signal

RR = diff(R);           % in samples
RR = RR'./fs_ecg;       % in time [sec]

figure('Name','HRV signal')
plot(mean(RR)*(1:length(RR)),RR,'color',[0.3010, 0.7450, 0.9330])
title('Tachogram - HRV signal')
xlabel('Time [s]');
ylabel('RR interval [s]')
hold on
plot(mean(RR)+zeros(1,length(RR)),'-r','linewidth',1.2)
xlim([0 length(ecg)/fs_ecg])

%% HRV features

fs_RR = 1/mean(RR);

RR_low1 = RR(240*fs_RR:540*fs_RR); %min 4-9 rest
RR_low2 = RR(4200*fs_RR:4500*fs_RR); %min 70-75 rest
RR_high1 = RR(1260*fs_RR:1560*fs_RR); %min 21-26 city
RR_high2 = RR(2340*fs_RR:2640*fs_RR); %min 39-44 city
RR_high3 = RR(3300*fs_RR:3600*fs_RR); %min 55-60 city
RR_middle1 = RR(1920*fs_RR:2220*fs_RR); %min 32-37 city
RR_middle2 = RR(2760*fs_RR:3060*fs_RR); %min 46-51 city

df_RR = fs_RR/length(RR_low1);
%low stress
[pxx_low1,~] = plomb(RR_low1,fs_RR);
[pxx_low2,f] = plomb(RR_low2,fs_RR);

LF_low1 = trapz(f(1:0.08/df_RR),pxx_low1(1:0.08/df_RR));
HF_low1 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_low1(0.15/df_RR:0.5/df_RR));
MF_low1 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_low1(0.08/df_RR:0.15/df_RR));
HRV_low1 = LF_low1/HF_low1;
HRV2_low1 = (LF_low1+MF_low1)/HF_low1;
LF_low2 = trapz(f(1:0.08/df_RR),pxx_low2(1:0.08/df_RR));
HF_low2 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_low2(0.15/df_RR:0.5/df_RR));
MF_low2 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_low2(0.08/df_RR:0.15/df_RR));
HRV_low2 = LF_low2/HF_low2;
HRV2_low2 = (LF_low2+MF_low2)/HF_low2;

%middle stress
[pxx_middle1,~] = plomb(RR_middle1,fs_RR);
[pxx_middle2,f] = plomb(RR_middle2,fs_RR);

LF_middle1 = trapz(f(1:0.08/df_RR),pxx_middle1(1:0.08/df_RR));
HF_middle1 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_middle1(0.15/df_RR:0.5/df_RR));
MF_middle1 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_middle1(0.08/df_RR:0.15/df_RR));
HRV_middle1= LF_middle1/HF_middle1;
HRV2_middle1 = (LF_middle1+MF_middle1)/HF_middle1;

LF_middle2 = trapz(f(1:0.08/df_RR),pxx_middle2(1:0.08/df_RR));
HF_middle2 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_middle2(0.15/df_RR:0.5/df_RR));
MF_middle2 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_middle2(0.08/df_RR:0.15/df_RR));
HRV_middle2= LF_middle2/HF_middle2;
HRV2_middle2 = (LF_middle2+MF_middle2)/HF_middle2;

%high stress
[pxx_high1,~] = plomb(RR_high1,fs_RR);
[pxx_high2,~] = plomb(RR_high2,fs_RR);
[pxx_high3,f] = plomb(RR_high3,fs_RR);

LF_high1 = trapz(f(1:0.08/df_RR),pxx_high1(1:0.08/df_RR));
HF_high1 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_high1(0.15/df_RR:0.5/df_RR));
MF_high1 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_high1(0.08/df_RR:0.15/df_RR));
HRV_high1= LF_high1/HF_high1;
HRV2_high1 = (LF_high1+MF_high1)/HF_high1;

LF_high2 = trapz(f(1:0.08/df_RR),pxx_high2(1:0.08/df_RR));
HF_high2 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_high2(0.15/df_RR:0.5/df_RR));
MF_high2 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_high2(0.08/df_RR:0.15/df_RR));
HRV_high2= LF_high2/HF_high2;
HRV2_high2 = (LF_high2+MF_high2)/HF_high2;

LF_high3 = trapz(f(1:0.08/df_RR),pxx_high3(1:0.08/df_RR));
HF_high3 = trapz(f(0.15/df_RR:0.5/df_RR),pxx_high3(0.15/df_RR:0.5/df_RR));
MF_high3 = trapz(f(0.08/df_RR:0.15/df_RR),pxx_high3(0.08/df_RR:0.15/df_RR));
HRV_high3= LF_high3/HF_high3;
HRV2_high3 = (LF_high3+MF_high3)/HF_high3;

%% Time features RR

%mean RR
mRR_low1 = mean(RR_low1);
mRR_low2 = mean(RR_low2);
mRR_middle1 = mean(RR_middle1);
mRR_middle2 = mean(RR_middle2);
mRR_high1 = mean(RR_high1);
mRR_high2 = mean(RR_high2);
mRR_high3 = mean(RR_high3);

%standard deviation RR
sRR_low1 = std(RR_low1);
sRR_low2 = std(RR_low2);
sRR_middle1 = std(RR_middle1);
sRR_middle2 = std(RR_middle2);
sRR_high1 = std(RR_high1);
sRR_high2 = std(RR_high2);
sRR_high3 = std(RR_high3);

%rMSSD feature
rMSSD_low1 = sqrt(mean(diff(RR_low1).^2)); %root mean square of successive differences between normal heartbeats
rMSSD_low2 = sqrt(mean(diff(RR_low2).^2));
rMSSD_middle1 = sqrt(mean(diff(RR_middle1).^2));
rMSSD_middle2 = sqrt(mean(diff(RR_middle2).^2));
rMSSD_high1 = sqrt(mean(diff(RR_high1).^2));
rMSSD_high2 = sqrt(mean(diff(RR_high2).^2));
rMSSD_high3 = sqrt(mean(diff(RR_high3).^2));

%pNN50 - Probability of difference of consecutive intervals greater 50ms or smaller -50ms
N = 0;
for i=1:length(RR_low1)-1
    if abs(RR_low1(i)-RR_low1(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_low1 = (N/length(RR_low1))*100;

N = 0;
for i=1:length(RR_low2)-1
    if abs(RR_low2(i)-RR_low2(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_low2 = (N/length(RR_low2))*100;

N = 0;
for i=1:length(RR_middle1)-1
    if abs(RR_middle1(i)-RR_middle1(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_middle1 = (N/length(RR_middle1))*100;

N = 0;
for i=1:length(RR_middle2)-1
    if abs(RR_middle2(i)-RR_middle2(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_middle2 = (N/length(RR_middle2))*100;

N = 0;
for i=1:length(RR_high1)-1
    if abs(RR_high1(i)-RR_high1(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_high1 = (N/length(RR_high1))*100;

N = 0;
for i=1:length(RR_high2)-1
    if abs(RR_high2(i)-RR_high2(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_high2 = (N/length(RR_high2))*100;

N = 0;
for i=1:length(RR_high3)-1
    if abs(RR_high3(i)-RR_high3(i+1))>0.05
        N = N + 1;
    end 
end
pNN50_high3 = (N/length(RR_high3))*100;

RowNames = {'Mean','Standard deviation','rMSSD','pNN50','HRV=LF/HF','HRV=(LF+MF)/HF'};
VariableNames = {'Low stress 1','Low stress 2','Middle stress 1','Middle stress 2','High stress 1','High stress 2','High stress 3'};
Results_RR = table([mRR_low1;sRR_low1;rMSSD_low1;pNN50_low1;HRV_low1;HRV2_low1],[mRR_low2;sRR_low2;rMSSD_low2;pNN50_low2;HRV_low2;HRV2_low2],[mRR_middle1;sRR_middle1;rMSSD_middle1;pNN50_middle1;HRV_middle1;HRV2_middle1],[mRR_middle2;sRR_middle2;rMSSD_middle2;pNN50_middle2;HRV_middle2;HRV2_middle2],[mRR_high1;sRR_high1;rMSSD_high1;pNN50_high1;HRV_high1;HRV2_high1],[mRR_high2;sRR_high2;rMSSD_high2;pNN50_high2;HRV_high2;HRV2_high2],[mRR_high3;sRR_high3;rMSSD_high3;pNN50_high3;HRV_high3;HRV2_high3],'VariableNames',VariableNames,'RowNames',RowNames)

%% GSR signal
% Startle detection

% The latest startle detection program
% Programmer: Jennifer Healey, Dec 13, 1999
% Usage: this is a script so you dont' have to pass a vector. 
% You can easily make it into a function if you prefer.
% The signals is "s" the sampling frequency is "Fs"
% the results are s-freq, s.mags and s-dur
% Edit all here or comment out for use in a giant script 

han = hann(500);
footGSR=footGSR-min(footGSR);
footGSR_smooth = conv(footGSR,han);
footGSR_smooth=footGSR_smooth/max(footGSR_smooth);

Fs = fs_foot;
s=footGSR_smooth;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Filter out the high frequency noise%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lgsr=length(s); 
lgsr2=lgsr/2; 
t=(1:lgsr)/Fs;
[b,a]=ellip(4,0.1,40,4*2/Fs);
[H,w]=freqz(b,a,lgsr);
sf=filter(b,a,s);
sf_prime=diff(sf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Find Significant Startles%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%There is ringing in the signal so the first 35 points are excluded
l35 = length(sf_prime);
sf_prime35=sf_prime(35:l35);

%Set a threshhold to define significant startle
%thresh=0.005; 
thresh=0.00003;
vector=sf_prime35;
overthresh=find(vector>thresh);

%overthresh is the values at which the segment is over the threshold
overthresh35=overthresh+35;

%the true values of the segment
gaps=diff(overthresh35);
%big_gaps=find(gaps>31);
big_gaps=find(gaps>50);

% big.gaps returns the indices of gaps that exceed 31
% eg - big.gaps=[60 92 132 168....]
% gaps(60)=245; gaps(92)=205 ...
% overthresh35(58:62)= [346 347 348 593 594] 0/
% so overthresh(61) is where the startle starts (ish)
% is overthresh (60) where the startle ends?

%check the results
iend=[]; 
ibegin=[];

for i=1:length(big_gaps)
    iend=[iend overthresh35(big_gaps(i))];
    ibegin=[ibegin overthresh35(big_gaps(i)+1)];
end

%%Fine Tuning%%
% The idea being this is to find the zero crossing closet to where it goes 
% over threshold
% find all zero crossings

overzero=find(sf_prime>0);
zerogaps=diff(overzero);
z_gaps=find(zerogaps>1);
iup=[]; 
idown=[];

for i=1:length(z_gaps)
    idown=[idown overzero(z_gaps(i))];
    iup=[iup overzero(z_gaps(i)+1)];
end

% find up crossing closest to ibegin
new_begin=[];

for i=1:length(ibegin)
    temp=find(iup<ibegin(i)); 
    choice=temp(length(temp)); 
    new_begin(i)=iup(choice);
end

%to find the end of the startle, find the maximum between startle % beginnings

new_end=[];

for i=1:(length(new_begin)-1)
    startit=new_begin(i); 
    endit=new_begin(i+1);
    [val, loc]=max(s(startit:endit));
    new_end(i)=startit+loc; 
end

if (length(new_begin)>0)
    lastbegin=new_begin(length(new_begin)); 
    [lastval,lastloc]=max(s(lastbegin:length(s)-1));
    new_end(length(new_begin))=new_begin(length(new_begin))+lastloc; 
end

s_mag=[]; %initialize a vector of startle magnitudes 
s_dur=[]; %initialize a vector of startle durations

for i=1:length(new_end)
    s_dur(i)=new_end(i)-new_begin(i);
    s_mag(i)=s(new_end(i))-s(new_begin(i));
end

s_freq=length(ibegin);
ibegin = new_begin;
iend = new_end;

%% Correction

for i=1:length(iend)
    bef=iend(i)-15;
    aft=iend(i)+15;
    foot_Ri=bef:aft;
    [val,idx]=max(footGSR_smooth(foot_Ri));
    iend(i)=bef+idx-1;
end

for i=1:length(ibegin)
    bef=ibegin(i)-15;
    aft=ibegin(i)+15;
    foot_Ri=bef:aft;
    [val,idx]=min(footGSR_smooth(foot_Ri));
    ibegin(i)=bef+idx-1;
end

figure
plot(footGSR_smooth,'k')
hold on
plot(iend,footGSR_smooth(iend),'r*')
hold on
plot(ibegin,footGSR_smooth(ibegin),'bo')
plot(new_end,footGSR_smooth(new_end),'sg')
plot(new_begin,footGSR_smooth(new_begin),'.m')
title ('Foot GSR comparison between onset and peak computation') 
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 
xlim ([0, length(footGSR_smooth)]);

%% GSR features

%divide GSR in segments
foot_low1 = footGSR(240*fs_foot:540*fs_foot); %min 4-9 rest
foot_low2 = footGSR(4200*fs_foot:4500*fs_foot); %min 70-75 rest
foot_high1 = footGSR(1260*fs_foot:1560*fs_foot); %min 21-26 city
foot_high2 = footGSR(2340*fs_foot:2640*fs_foot); %min 39-44 city
foot_high3 = footGSR(3300*fs_foot:3600*fs_foot); %min 55-60 city
foot_middle1 = footGSR(1920*fs_foot:2220*fs_foot); %min 32-37 city
foot_middle2 = footGSR(2760*fs_foot:3060*fs_foot); %min 46-51 city

%normalization of the segments
foot_low1=foot_low1-min(foot_low1);
foot_low1=foot_low1/max(foot_low1);
foot_low2=foot_low2-min(foot_low2);
foot_low2=foot_low2/max(foot_low2);
foot_high1=foot_high1-min(foot_high1);
foot_high1=foot_high1/max(foot_high1);
foot_high2=foot_high2-min(foot_high2);
foot_high2=foot_high2/max(foot_high2);
foot_high3=foot_high3-min(foot_high3);
foot_high3=foot_high3/max(foot_high3);
foot_middle1=foot_middle1-min(foot_middle1);
foot_middle1=foot_middle1/max(foot_middle1);
foot_middle2=foot_middle2-min(foot_middle2);
foot_middle2=foot_middle2/max(foot_middle2);

%mean GSR
mfoot_low1 = mean(foot_low1);
mfoot_low2 = mean(foot_low2);
mfoot_high1 = mean(foot_high1);
mfoot_high2 = mean(foot_high2);
mfoot_high3 = mean(foot_high3);
mfoot_middle1 = mean(foot_middle1);
mfoot_middle2 = mean(foot_middle2);

%standard deviation GSR
sfoot_low1 = std(foot_low1);
sfoot_low2 = std(foot_low2);
sfoot_high1 = std(foot_high1);
sfoot_high2 = std(foot_high2);
sfoot_high3 = std(foot_high3);
sfoot_middle1 = std(foot_middle1);
sfoot_middle2 = std(foot_middle2);

%area under the curve
area_foot_low1 = trapz((240*fs_foot:540*fs_foot),foot_low1);
area_foot_low2 = trapz((4200*fs_foot:4500*fs_foot),foot_low2);
area_foot_high1 = trapz((1260*fs_foot:1560*fs_foot),foot_high1);
area_foot_high2 = trapz((2340*fs_foot:2640*fs_foot),foot_high2);
area_foot_high3 = trapz((3300*fs_foot:3600*fs_foot),foot_high3);
area_foot_middle1 = trapz((1920*fs_foot:2220*fs_foot),foot_middle1);
area_foot_middle2 = trapz((2760*fs_foot:3060*fs_foot),foot_middle2);

%% GSR smooth features
fs_smooth = 31*length(footGSR_smooth)/length(footGSR);

foot_low1_smooth=conv(foot_low1,han);
foot_low1_smooth=foot_low1_smooth/max(foot_low1_smooth);
foot_low1_smooth=foot_low1_smooth(250:end-250); %remove the first and last 250 samples to come back to the original length

foot_low2_smooth=conv(foot_low2,han);
foot_low2_smooth=foot_low2_smooth/max(foot_low2_smooth);
foot_low2_smooth=foot_low2_smooth(250:end-250);

foot_middle1_smooth=conv(foot_middle1,han);
foot_middle1_smooth=foot_middle1_smooth/max(foot_middle1_smooth);
foot_middle1_smooth=foot_middle1_smooth(250:end-250);

foot_middle2_smooth=conv(foot_middle2,han);
foot_middle2_smooth=foot_middle2_smooth/max(foot_middle2_smooth);
foot_middle2_smooth=foot_middle2_smooth(250:end-250);

foot_high1_smooth=conv(foot_high1,han);
foot_high1_smooth=foot_high1_smooth/max(foot_high1_smooth);
foot_high1_smooth=foot_high1_smooth(250:end-250);

foot_high2_smooth=conv(foot_high2,han);
foot_high2_smooth=foot_high2_smooth/max(foot_high2_smooth);
foot_high2_smooth=foot_high2_smooth(250:end-250);

foot_high3_smooth=conv(foot_high3,han);
foot_high3_smooth=foot_high3_smooth/max(foot_high3_smooth);
foot_high3_smooth=foot_high3_smooth(250:end-250);

%mean smooth GSR
mfoot_low1_smooth = mean(foot_low1_smooth);
mfoot_low2_smooth = mean(foot_low2_smooth);
mfoot_high1_smooth = mean(foot_high1_smooth);
mfoot_high2_smooth = mean(foot_high2_smooth);
mfoot_high3_smooth = mean(foot_high3_smooth);
mfoot_middle1_smooth = mean(foot_middle1_smooth);
mfoot_middle2_smooth = mean(foot_middle2_smooth);

%standard deviation smooth GSR
sfoot_low1_smooth = std(foot_low1_smooth);
sfoot_low2_smooth = std(foot_low2_smooth);
sfoot_high1_smooth = std(foot_high1_smooth);
sfoot_high2_smooth = std(foot_high2_smooth);
sfoot_high3_smooth = std(foot_high3_smooth);
sfoot_middle1_smooth = std(foot_middle1_smooth);
sfoot_middle2_smooth = std(foot_middle2_smooth);

%area under the curve
area_foot_low1_smooth = trapz((240*fs_foot:540*fs_foot),foot_low1_smooth);
area_foot_low2_smooth = trapz((4200*fs_foot:4500*fs_foot),foot_low2_smooth);
area_foot_high1_smooth = trapz((1260*fs_foot:1560*fs_foot),foot_high1_smooth);
area_foot_high2_smooth = trapz((2340*fs_foot:2640*fs_foot),foot_high2_smooth);
area_foot_high3_smooth = trapz((3300*fs_foot:3600*fs_foot),foot_high3_smooth);
area_foot_middle1_smooth = trapz((1920*fs_foot:2220*fs_foot),foot_middle1_smooth);
area_foot_middle2_smooth = trapz((2760*fs_foot:3060*fs_foot),foot_middle2_smooth);

%save the peaks in a vector
iend_low1=[];
iend_low2=[];
iend_high1=[];
iend_high2=[];
iend_high3=[];
iend_middle1=[];
iend_middle2=[];

for i=1:length(iend)
    if iend(i)>240*fs_foot && iend(i)<540*fs_foot
        iend_low1 = [iend_low1 iend(i)];
    end
    if iend(i)>4200*fs_foot && iend(i)<4500*fs_foot
        iend_low2 = [iend_low2 iend(i)];
    end
    if iend(i)>1260*fs_foot && iend(i)<1560*fs_foot
        iend_high1 = [iend_high1 iend(i)];
    end
    if iend(i)>2340*fs_foot && iend(i)<2640*fs_foot
        iend_high2 = [iend_high2 iend(i)];
    end
    if iend(i)>3300*fs_foot && iend(i)<3600*fs_foot
        iend_high3 = [iend_high3 iend(i)];
    end
    if iend(i)>1920*fs_foot && iend(i)<2220*fs_foot
        iend_middle1 = [iend_middle1 iend(i)];
    end
    if iend(i)>2760*fs_foot && iend(i)<3060*fs_foot
        iend_middle2 = [iend_middle2 iend(i)];
    end
end

%save the onsets in a vector
ibegin_low1=[];
ibegin_low2=[];
ibegin_high1=[];
ibegin_high2=[];
ibegin_high3=[];
ibegin_middle1=[];
ibegin_middle2=[];

for i=1:length(ibegin)
    if ibegin(i)>240*fs_foot && ibegin(i)<540*fs_foot
        ibegin_low1 = [ibegin_low1 ibegin(i)];
    end
    if ibegin(i)>4200*fs_foot && ibegin(i)<4500*fs_foot
        ibegin_low2 = [ibegin_low2 ibegin(i)];
    end
    if ibegin(i)>1260*fs_foot && ibegin(i)<1560*fs_foot
        ibegin_high1 = [ibegin_high1 ibegin(i)];
    end
    if ibegin(i)>2340*fs_foot && ibegin(i)<2640*fs_foot
        ibegin_high2 = [ibegin_high2 ibegin(i)];
    end
    if ibegin(i)>3300*fs_foot && ibegin(i)<3600*fs_foot
        ibegin_high3 = [ibegin_high3 ibegin(i)];
    end
    if ibegin(i)>1920*fs_foot && ibegin(i)<2220*fs_foot
        ibegin_middle1 = [ibegin_middle1 ibegin(i)];
    end
    if ibegin(i)>2760*fs_foot && ibegin(i)<3060*fs_foot
        ibegin_middle2 = [ibegin_middle2 ibegin(i)];
    end
end

%number of peaks in the segments
npeak_low1 = length(iend_low1);
npeak_low2 = length(iend_low2);
npeak_high1 = length(iend_high1);
npeak_high2 = length(iend_high2);
npeak_high3 = length(iend_high3);
npeak_middle1 = length(iend_middle1);
npeak_middle2 = length(iend_middle2);

%% Plot of the smoothed GSR segments with on-sets and peaks
 
figure('Name','GSR smooth low1')
plot(240:1/fs_foot:540,footGSR_smooth(240*fs_foot:540*fs_foot))
hold on
plot(ibegin_low1/fs_foot,footGSR_smooth(ibegin_low1),'bo')
plot(iend_low1/fs_foot,footGSR_smooth(iend_low1),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([240 540])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 

figure('Name','GSR smooth low2')
plot(4200:1/fs_foot:4500,footGSR_smooth(4200*fs_foot:4500*fs_foot))
hold on
plot(ibegin_low2/fs_foot,footGSR_smooth(ibegin_low2),'bo')
plot(iend_low2/fs_foot,footGSR_smooth(iend_low2),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([4200 4500])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 

figure('Name','GSR smooth high1')
plot(1260:1/fs_foot:1560,footGSR_smooth(1260*fs_foot:1560*fs_foot))
hold on
plot(ibegin_high1/fs_foot,footGSR_smooth(ibegin_high1),'bo')
plot(iend_high1/fs_foot,footGSR_smooth(iend_high1),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([1260 1560])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 
 
figure('Name','GSR smooth high2')
plot(2340:1/fs_foot:2640,footGSR_smooth(2340*fs_foot:2640*fs_foot))
hold on
plot(ibegin_high2/fs_foot,footGSR_smooth(ibegin_high2),'bo')
plot(iend_high2/fs_foot,footGSR_smooth(iend_high2),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([2340 2640])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 

figure('Name','GSR smooth high3')
plot(3300:1/fs_foot:3600,footGSR_smooth(3300*fs_foot:3600*fs_foot))
hold on
plot(ibegin_high3/fs_foot,footGSR_smooth(ibegin_high3),'bo')
plot(iend_high3/fs_foot,footGSR_smooth(iend_high3),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([3300 3600])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 

figure('Name','GSR smooth middle1')
plot(1920:1/fs_foot:2220,footGSR_smooth(1920*fs_foot:2220*fs_foot))
hold on
plot(ibegin_middle1/fs_foot,footGSR_smooth(ibegin_middle1),'bo')
plot(iend_middle1/fs_foot,footGSR_smooth(iend_middle1),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([1920 2220])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 
 
figure('Name','GSR smooth middle2')
plot(2760:1/fs_foot:3060,footGSR_smooth(2760*fs_foot:3060*fs_foot))
hold on
plot(ibegin_middle2/fs_foot,footGSR_smooth(ibegin_middle2),'bo')
plot(iend_middle2/fs_foot,footGSR_smooth(iend_middle2),'r*')
plot(new_end/fs_foot,footGSR_smooth(new_end),'sg')
plot(new_begin/fs_foot,footGSR_smooth(new_begin),'.m')
hold off
xlim([2760 3060])
legend('FootGSR', 'iend' , 'ibegin' , 'new End', 'new Begin'); 

%% remove the first peak without its onset

if iend_low1(1)<ibegin_low1(1)
    iend_low1(1)=[];
end
if iend_low2(1)<ibegin_low2(1)
    iend_low2(1)=[];
end
if iend_high1(1)<ibegin_high1(1)
    iend_high1(1)=[];
end
if iend_high2(1)<ibegin_high2(1)
    iend_high2(1)=[];
end
if iend_high3(1)<ibegin_high3(1)
    iend_high3(1)=[];
end
if iend_middle1(1)<ibegin_middle1(1)
    iend_middle1(1)=[];
end
if iend_middle2(1)<ibegin_middle2(1)
    iend_middle2(1)=[];
end

% remove the last onset without its peak
if iend_low1(end)<ibegin_low1(end)
    ibegin_low1(end)=[];
end
if iend_low2(end)<ibegin_low2(end)
    ibegin_low2(end)=[];
end
if iend_high1(end)<ibegin_high1(end)
    ibegin_high1(end)=[];
end
if iend_high2(end)<ibegin_high2(end)
    ibegin_high2(end)=[];
end
if iend_high3(end)<ibegin_high3(end)
    ibegin_high3(end)=[];
end
if iend_middle1(end)<ibegin_middle1(end)
    ibegin_middle1(end)=[];
end
if iend_middle2(end)<ibegin_middle2(end)
    ibegin_middle2(end)=[];
end

%rise time and amplitude
rise_time_low1=[];
rise_time_low2=[];
rise_time_high1=[];
rise_time_high2=[];
rise_time_high3=[];
rise_time_middle1=[];
rise_time_middle2=[];

amp_low_1=[];
amp_low_2=[];
amp_high_1=[];
amp_high_2=[];
amp_high_3=[];
amp_middle_1=[];
amp_middle_2=[];

for i=1:length(iend_low1)
    rise_time_low1 = [rise_time_low1 (iend_low1(i)-ibegin_low1(i))/fs_foot];
    amp_low_1 = [amp_low_1 footGSR_smooth(iend_low1(i))-footGSR_smooth(ibegin_low1(i))];
end
for i=1:length(iend_low2)
    rise_time_low2 = [rise_time_low2 (iend_low2(i)-ibegin_low2(i))/fs_foot];
    amp_low_2 = [amp_low_2 footGSR_smooth(iend_low2(i))-footGSR_smooth(ibegin_low2(i))];
end
for i=1:length(iend_high1)
    rise_time_high1 = [rise_time_high1 (iend_high1(i)-ibegin_high1(i))/fs_foot];
    amp_high_1 = [amp_high_1 footGSR_smooth(iend_high1(i))-footGSR_smooth(ibegin_high1(i))];
end
for i=1:length(iend_high2)
    rise_time_high2 = [rise_time_high2 (iend_high2(i)-ibegin_high2(i))/fs_foot];
    amp_high_2 = [amp_high_2 footGSR_smooth(iend_high2(i))-footGSR_smooth(ibegin_high2(i))];
end
for i=1:length(iend_high3)
    rise_time_high3 = [rise_time_high3 (iend_high3(i)-ibegin_high3(i))/fs_foot];
    amp_high_3 = [amp_high_3 footGSR_smooth(iend_high3(i))-footGSR_smooth(ibegin_high3(i))];
end
for i=1:length(iend_middle1)
    rise_time_middle1 = [rise_time_middle1 (iend_middle1(i)-ibegin_middle1(i))/fs_foot];
    amp_middle_1 = [amp_middle_1 footGSR_smooth(iend_middle1(i))-footGSR_smooth(ibegin_middle1(i))];
end
for i=1:length(iend_middle2)
    rise_time_middle2 = [rise_time_middle2 (iend_middle2(i)-ibegin_middle2(i))/fs_foot];
    amp_middle_2 = [amp_middle_2 footGSR_smooth(iend_middle2(i))-footGSR_smooth(ibegin_middle2(i))];
end

rise_time_low1=mean(rise_time_low1);
rise_time_low2=mean(rise_time_low2);
rise_time_high1=mean(rise_time_high1);
rise_time_high2=mean(rise_time_high2);
rise_time_high3=mean(rise_time_high3);
rise_time_middle1=mean(rise_time_middle1);
rise_time_middle2=mean(rise_time_middle2);

amp_low_1=mean(amp_low_1);
amp_low_2=mean(amp_low_2);
amp_high_1=mean(amp_high_1);
amp_high_2=mean(amp_high_2);
amp_high_3=mean(amp_high_3);
amp_middle_1=mean(amp_middle_1);
amp_middle_2=mean(amp_middle_2);

%% Save features in tables
% Table normalized signal
RowNames = {'Mean','Standard deviation','Integral'};
VariableNames = {'Low stress 1','Low stress 2','Middle stress 1','Middle stress 2','High stress 1','High stress 2','High stress 3'};
Results_footGSR = table([mfoot_low1;sfoot_low1;area_foot_low1],[mfoot_low2;sfoot_low2;area_foot_low2],[mfoot_middle1;sfoot_middle1;area_foot_middle1],[mfoot_middle2;sfoot_middle2;area_foot_middle2],[mfoot_high1;sfoot_high1;area_foot_high1],[mfoot_high2;sfoot_high2;area_foot_high2],[mfoot_high3;sfoot_high3;area_foot_high3],'VariableNames',VariableNames,'RowNames',RowNames)

% Table normalized and smooth signal
RowNames = {'Mean','Standard deviation','Integral','Number of peaks','Mean Rise time','Mean Amplitude'};
VariableNames = {'Low stress 1','Low stress 2','Middle stress 1','Middle stress 2','High stress 1','High stress 2','High stress 3'};
Results_footGSR_Smooth = table([mfoot_low1_smooth;sfoot_low1_smooth;area_foot_low1_smooth;npeak_low1;rise_time_low1;amp_low_1],[mfoot_low2_smooth;sfoot_low2_smooth;area_foot_low2_smooth;npeak_low2;rise_time_low2;amp_low_2],[mfoot_middle1_smooth;sfoot_middle1_smooth;area_foot_middle1_smooth;npeak_middle1;rise_time_middle1;amp_middle_1],[mfoot_middle2_smooth;sfoot_middle2_smooth;area_foot_middle2_smooth;npeak_middle2;rise_time_middle2;amp_middle_2],[mfoot_high1_smooth;sfoot_high1_smooth;area_foot_high1_smooth;npeak_high1;rise_time_high1;amp_high_1],[mfoot_high2_smooth;sfoot_high2_smooth;area_foot_high2_smooth;npeak_high2;rise_time_high2;amp_high_2],[mfoot_high3_smooth;sfoot_high3_smooth;area_foot_high3_smooth;npeak_high3;rise_time_high3;amp_high_3],'VariableNames',VariableNames,'RowNames',RowNames)

%% Respiration 

[b,a]=butter(3,0.16/(fs_resp/2),'high');
resp = filtfilt(b,a,resp);

[b,a]=butter(3,0.5/(fs_resp/2),'low');
resp = filtfilt(b,a,resp);

[pks,locs]=findpeaks(resp,'minpeakheight',0);
figure
plot(resp)
hold on 
plot(locs,pks,'*')

i=1;
NR=length(locs);
M=40;
while i+1<NR
    if  locs(i+1)-locs(i)<M      
        locs(i+1)=[];        %delete the sample less than 200 ms away from the previous one
        i=i-1;
    end
    i=i+1;
    NR=length(locs);
end


for i=1:length(locs)
    bef=locs(i)-3;
    aft=locs(i)+3;
    ecg_Ri=bef:aft;
    [val,idx]=max(resp(ecg_Ri));
    locs(i)=bef+idx-1;
end

figure('Name','Respiration signal and Peaks')
plot((1:length(resp))/fs_resp,resp,'color','#80B3FF')
hold on
plot(locs/fs_resp,resp(locs),'*m')
xlim([0 length(resp)/fs_resp])

%save the locs in a vector
locs_low1=[];
locs_low2=[];
locs_high1=[];
locs_high2=[];
locs_high3=[];
locs_middle1=[];
locs_middle2=[];

%save the peaks in a vector
pks_low1=[];
pks_low2=[];
pks_high1=[];
pks_high2=[];
pks_high3=[];
pks_middle1=[];
pks_middle2=[];

for i=1:length(locs)
    if locs(i)>240*fs_resp && locs(i)<540*fs_resp
        locs_low1 = [locs_low1 locs(i)];
        pks_low1 = [pks_low1 pks(i)];
    end
    if locs(i)>4200*fs_resp && locs(i)<4500*fs_resp
        locs_low2 = [locs_low2 locs(i)];
        pks_low2 = [pks_low2 pks(i)];
    end
    if locs(i)>1260*fs_resp && locs(i)<1560*fs_resp
        locs_high1 = [locs_high1 locs(i)];
        pks_high1 = [pks_high1 pks(i)];
    end
    if locs(i)>2340*fs_resp && locs(i)<2640*fs_resp
        locs_high2 = [locs_high2 locs(i)];
        pks_high2 = [pks_high2 pks(i)];
    end
    if locs(i)>3300*fs_resp && locs(i)<3600*fs_resp
        locs_high3 = [locs_high3 locs(i)];
        pks_high3 = [pks_high3 pks(i)];
    end
    if locs(i)>1920*fs_resp && locs(i)<2220*fs_resp
        locs_middle1 = [locs_middle1 locs(i)];
        pks_middle1 = [pks_middle1 pks(i)];
    end
    if locs(i)>2760*fs_resp && locs(i)<3060*fs_resp
        locs_middle2 = [locs_middle2 locs(i)];
        pks_middle2 = [pks_middle2 pks(i)];
    end
end

mlocs_low1 = mean(diff(locs_low1))/fs_resp;
mlocs_low2 = mean(diff(locs_low2))/fs_resp;
mlocs_high1 = mean(diff(locs_high1))/fs_resp;
mlocs_high2 = mean(diff(locs_high2))/fs_resp;
mlocs_high3 = mean(diff(locs_high3))/fs_resp;
mlocs_middle1 = mean(diff(locs_middle1))/fs_resp;
mlocs_middle2 = mean(diff(locs_middle2))/fs_resp;

mpks_low1 = mean(pks_low1);
mpks_low2 = mean(pks_low2);
mpks_high1 = mean(pks_high1);
mpks_high2 = mean(pks_high2);
mpks_high3 = mean(pks_high3);
mpks_middle1 = mean(pks_middle1);
mpks_middle2 = mean(pks_middle2);

spks_low1 = std(pks_low1);
spks_low2 = std(pks_low2);
spks_high1 = std(pks_high1);
spks_high2 = std(pks_high2);
spks_high3 = std(pks_high3);
spks_middle1 = std(pks_middle1);
spks_middle2 = std(pks_middle2);

Rrate_low1 = length(pks_low1)/5;
Rrate_low2 = length(pks_low2)/5;
Rrate_high1 = length(pks_high1)/5;
Rrate_high2 = length(pks_high2)/5;
Rrate_high3 = length(pks_high3)/5;
Rrate_middle1 = length(pks_middle1)/5;
Rrate_middle2 = length(pks_middle2)/5;

%%Save features in a table
% Table Respiration signal
RowNames = {'Mean Peaks Distance','Mean Peaks Amplitude','Standard deviation Peaks Amplitude','Respiration Rate'};
VariableNames = {'Low stress 1','Low stress 2','Middle stress 1','Middle stress 2','High stress 1','High stress 2','High stress 3'};
Results_Respiration_signal=table([mlocs_low1;mpks_low1;spks_low1;Rrate_low1],[mlocs_low2;mpks_low2;spks_low2;Rrate_low2],[mlocs_middle1;mpks_middle1;spks_middle1;Rrate_middle1],[mlocs_middle2;mpks_middle2;spks_middle2;Rrate_middle2],[mlocs_high1;mpks_high1;spks_high1;Rrate_high1],[mlocs_high2;mpks_high2;spks_high2;Rrate_high2],[mlocs_high3;mpks_high3;spks_high3;Rrate_high3],'VariableNames',VariableNames,'RowNames',RowNames)


%% Some plots...

labels = categorical({'RR signal'});

figure
hold all
set(gca,'YTick',[10]);
plot(mean(RR)*(1:length(RR)),RR)%,'color',[0.3010, 0.7450, 0.9330])
plot(t(1:150246),footGSR)%,'color',[0.3010, 0.7450, 0.9330]) %[259/264 150/264 260/264])
plot(t(1:150246),resp)%,'color',[0.3010, 0.7450, 0.9330])
xlim([97 4800])
xlabel('Time (s)','fontsize',20)
xline([97 1000 1870 2308 2700 3160 3897 4800])



figure
plot(2340:1/fs_foot:2640,footGSR_smooth(2340*fs_foot:2640*fs_foot),'linewidth',1.5)
hold on
plot(ibegin_high2/fs_foot,footGSR_smooth(ibegin_high2),'bo','markersize',15)
plot(iend_high2/fs_foot,footGSR_smooth(iend_high2),'r*','markersize',15)
title('Foot GSR signal with onsets and peaks','fontsize',20)
ylabel('mV','fontsize',17)
xlabel('Time (s)','fontsize',17)
xlim([2340 2640])
legend('', 'onsets' , 'peaks','fontsize',20); 



figure
subplot(4,1,1)
plot(mean(RR)*(1:length(RR)),RR)
title('RR signal','fontsize',17)
subplot(4,1,2)
plot(t,footGSR_smooth)
title('Foot GSR signal','fontsize',17)
subplot(4,1,3)
plot(t(1:150246),resp)
title('Respiration signal','fontsize',17)
subplot(4,1,4)
plot(2*t(1:75123),marker)
title('Marker signal','fontsize',17)


close all
