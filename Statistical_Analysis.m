clear variables
close all
clc

%% Loading results from .mat tables

% footGSR_2 = importdata('Results_footGSR_2.mat');
footGSR_4 = importdata('Results_footGSR_4.mat');
footGSR_5 = importdata('Results_footGSR_5.mat');
footGSR_6 = importdata('Results_footGSR_6.mat');
footGSR_7 = importdata('Results_footGSR_7.mat');
footGSR_8 = importdata('Results_footGSR_8.mat');
footGSR_10 = importdata('Results_footGSR_10.mat');
footGSR_11 = importdata('Results_footGSR_11.mat');
footGSR_12 = importdata('Results_footGSR_12.mat');
footGSR_13 = importdata('Results_footGSR_13.mat');
footGSR_15 = importdata('Results_footGSR_15.mat');

% footGSR_smooth_2 = importdata('Results_footGSR_Smooth_2.mat');
footGSR_smooth_4 = importdata('Results_footGSR_Smooth_4.mat');
footGSR_smooth_5 = importdata('Results_footGSR_Smooth_5.mat');
footGSR_smooth_6 = importdata('Results_footGSR_Smooth_6.mat');
footGSR_smooth_7 = importdata('Results_footGSR_Smooth_7.mat');
footGSR_smooth_8 = importdata('Results_footGSR_Smooth_8.mat');
footGSR_smooth_10 = importdata('Results_footGSR_Smooth_10.mat');
footGSR_smooth_11 = importdata('Results_footGSR_Smooth_11.mat');
footGSR_smooth_12 = importdata('Results_footGSR_Smooth_12.mat');
footGSR_smooth_13 = importdata('Results_footGSR_Smooth_13.mat');
footGSR_smooth_15 = importdata('Results_footGSR_Smooth_15.mat');

% Respiration_2 = importdata('Results_Respiration_2.mat');
Respiration_4 = importdata('Results_Respiration_4.mat');
Respiration_5 = importdata('Results_Respiration_5.mat');
Respiration_6 = importdata('Results_Respiration_6.mat');
Respiration_7 = importdata('Results_Respiration_7.mat');
Respiration_8 = importdata('Results_Respiration_8.mat');
Respiration_10 = importdata('Results_Respiration_10.mat');
Respiration_11 = importdata('Results_Respiration_11.mat');
Respiration_12 = importdata('Results_Respiration_12.mat');
Respiration_13 = importdata('Results_Respiration_13.mat');
Respiration_15 = importdata('Results_Respiration_15.mat');

% RR_2 = importdata('Results_RR_2.mat');
RR_4 = importdata('Results_RR_4.mat');
RR_5 = importdata('Results_RR_5.mat');
RR_6 = importdata('Results_RR_6.mat');
RR_7 = importdata('Results_RR_7.mat');
RR_8 = importdata('Results_RR_8.mat');
RR_10 = importdata('Results_RR_10.mat');
RR_11 = importdata('Results_RR_11.mat');
RR_12 = importdata('Results_RR_12.mat');
RR_13 = importdata('Results_RR_13.mat');
RR_15 = importdata('Results_RR_15.mat');

labels = [zeros(30,1);zeros(30,1)+1;zeros(30,1)+1];

%% Mean RR

mean_RR4 = [RR_4{1,1} RR_4{1,3} RR_4{1,5};RR_4{1,2} RR_4{1,4} RR_4{1,6};NaN NaN RR_4{1,7}];
mean_RR5 = [RR_5{1,1} NaN RR_5{1,4};RR_5{1,2} RR_5{1,3} RR_5{1,5};NaN NaN RR_5{1,6}];
mean_RR6 = [RR_6{1,1} RR_6{1,3} RR_6{1,5};RR_6{1,2} RR_6{1,4} RR_6{1,6};NaN NaN RR_6{1,7}];
mean_RR7 = [RR_7{1,1} RR_7{1,3} RR_7{1,5};RR_7{1,2} RR_7{1,4} RR_7{1,6};NaN NaN RR_7{1,7}];
mean_RR8 = [RR_8{1,1} RR_8{1,3} RR_8{1,5};RR_8{1,2} RR_8{1,4} RR_8{1,6};NaN NaN RR_8{1,7}];
mean_RR10 = [RR_10{1,1} RR_10{1,3} RR_10{1,5};RR_10{1,2} RR_10{1,4} RR_10{1,6};NaN NaN RR_10{1,7}];
mean_RR11 = [RR_11{1,1} RR_11{1,3} RR_11{1,5};RR_11{1,2} RR_11{1,4} RR_11{1,6};NaN NaN RR_11{1,7}];
mean_RR12 = [RR_12{1,1} RR_12{1,3} RR_12{1,5};RR_12{1,2} RR_12{1,4} RR_12{1,6};NaN NaN RR_12{1,7}];
mean_RR13 = [RR_13{1,1} RR_13{1,3} RR_13{1,5};RR_13{1,2} RR_13{1,4} RR_13{1,6};NaN NaN RR_13{1,7}];
mean_RR15 = [RR_15{1,1} RR_15{1,3} RR_15{1,5};RR_15{1,2} RR_15{1,4} RR_15{1,6};NaN NaN RR_15{1,7}];

mean_RR = [mean_RR4;mean_RR5;mean_RR6;mean_RR7;mean_RR8;mean_RR10;mean_RR11;mean_RR12;mean_RR13;mean_RR15];

[p_mean_RR,~,stats] = anova1(mean_RR);
figure()
R_mean_RR = multcompare(stats);

% ROC curve
scores = [mean_RR(:,1);mean_RR(:,2);mean_RR(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_mean_RR]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_mean_RR = [specificity_1(idx) sensitivity(idx)];
treshold_mean_RR = t((specificity_1==opt_mean_RR(1)) & (sensitivity==opt_mean_RR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve mean RR')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_mean_RR(1),opt_mean_RR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Standard deviation RR

sd_RR4 = [RR_4{2,1} RR_4{2,3} RR_4{2,5};RR_4{2,2} RR_4{2,4} RR_4{2,6};NaN NaN RR_4{2,7}];
sd_RR5 = [RR_5{2,1} NaN RR_5{2,4};RR_5{2,2} RR_5{2,3} RR_5{2,5};NaN NaN RR_5{2,6}];
sd_RR6 = [RR_6{2,1} RR_6{2,3} RR_6{2,5};RR_6{2,2} RR_6{2,4} RR_6{2,6};NaN NaN RR_6{2,7}];
sd_RR7 = [RR_7{2,1} RR_7{2,3} RR_7{2,5};RR_7{2,2} RR_7{2,4} RR_7{2,6};NaN NaN RR_7{2,7}];
sd_RR8 = [RR_8{2,1} RR_8{2,3} RR_8{2,5};RR_8{2,2} RR_8{2,4} RR_8{2,6};NaN NaN RR_8{2,7}];
sd_RR10 = [RR_10{2,1} RR_10{2,3} RR_10{2,5};RR_10{2,2} RR_10{2,4} RR_10{2,6};NaN NaN RR_10{2,7}];
sd_RR11 = [RR_11{2,1} RR_11{2,3} RR_11{2,5};RR_11{2,2} RR_11{2,4} RR_11{2,6};NaN NaN RR_11{2,7}];
sd_RR12 = [RR_12{2,1} RR_12{2,3} RR_12{2,5};RR_12{2,2} RR_12{2,4} RR_12{2,6};NaN NaN RR_12{2,7}];
sd_RR13 = [RR_13{2,1} RR_13{2,3} RR_13{2,5};RR_13{2,2} RR_13{2,4} RR_13{2,6};NaN NaN RR_13{2,7}];
sd_RR15 = [RR_15{2,1} RR_15{2,3} RR_15{2,5};RR_15{2,2} RR_15{2,4} RR_15{2,6};NaN NaN RR_15{2,7}];

sd_RR = [sd_RR4;sd_RR5;sd_RR6;sd_RR7;sd_RR8;sd_RR10;sd_RR11;sd_RR12;sd_RR13;sd_RR15];

[p_sd_RR,~,stats] = anova1(sd_RR); 
figure()
R_sd_RR = multcompare(stats);

% ROC curve
scores = [sd_RR(:,1);sd_RR(:,2);sd_RR(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_sd_RR]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_sd_RR = [specificity_1(idx) sensitivity(idx)];
treshold_sd_RR = t((specificity_1==opt_sd_RR(1)) & (sensitivity==opt_sd_RR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve sd RR')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_sd_RR(1),opt_sd_RR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% rMMSD

rMMSD_RR4 = [RR_4{3,1} RR_4{3,3} RR_4{3,5};RR_4{3,2} RR_4{3,4} RR_4{3,6};NaN NaN RR_4{3,7}];
rMMSD_RR5 = [RR_5{3,1} NaN RR_5{3,4};RR_5{3,2} RR_5{3,3} RR_5{3,5};NaN NaN RR_5{3,6}];
rMMSD_RR6 = [RR_6{3,1} RR_6{3,3} RR_6{3,5};RR_6{3,2} RR_6{3,4} RR_6{3,6};NaN NaN RR_6{3,7}];
rMMSD_RR7 = [RR_7{3,1} RR_7{3,3} RR_7{3,5};RR_7{3,2} RR_7{3,4} RR_7{3,6};NaN NaN RR_7{3,7}];
rMMSD_RR8 = [RR_8{3,1} RR_8{3,3} RR_8{3,5};RR_8{3,2} RR_8{3,4} RR_8{3,6};NaN NaN RR_8{3,7}];
rMMSD_RR10 = [RR_10{3,1} RR_10{3,3} RR_10{3,5};RR_10{3,2} RR_10{3,4} RR_10{3,6};NaN NaN RR_10{3,7}];
rMMSD_RR11 = [RR_11{3,1} RR_11{3,3} RR_11{3,5};RR_11{3,2} RR_11{3,4} RR_11{3,6};NaN NaN RR_11{3,7}];
rMMSD_RR12 = [RR_12{3,1} RR_12{3,3} RR_12{3,5};RR_12{3,2} RR_12{3,4} RR_12{3,6};NaN NaN RR_12{3,7}];
rMMSD_RR13 = [RR_13{3,1} RR_13{3,3} RR_13{3,5};RR_13{3,2} RR_13{3,4} RR_13{3,6};NaN NaN RR_13{3,7}];
rMMSD_RR15 = [RR_15{3,1} RR_15{3,3} RR_15{3,5};RR_15{3,2} RR_15{3,4} RR_15{3,6};NaN NaN RR_15{3,7}];

rMMSD_RR = [rMMSD_RR4;rMMSD_RR5;rMMSD_RR6;rMMSD_RR7;rMMSD_RR8;rMMSD_RR10;rMMSD_RR11;rMMSD_RR12;rMMSD_RR13;rMMSD_RR15]; 

[p_rMMSD_RR,~,stats] = anova1(rMMSD_RR); 
figure()
R_rMMSD = multcompare(stats);

% ROC curve
scores = [rMMSD_RR(:,1);rMMSD_RR(:,2);rMMSD_RR(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_rMMSD]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_rMMSD_RR = [specificity_1(idx) sensitivity(idx)];
treshold_rMMSD_RR = t((specificity_1==opt_rMMSD_RR(1)) & (sensitivity==opt_rMMSD_RR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve rMMSD')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_rMMSD_RR(1),opt_rMMSD_RR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% pNN50

pNN50_RR4 = [RR_4{4,1} RR_4{4,3} RR_4{4,5};RR_4{4,2} RR_4{4,4} RR_4{3,6};NaN NaN RR_4{4,7}];
pNN50_RR5 = [RR_5{4,1} NaN RR_5{4,4};RR_5{4,2} RR_5{4,3} RR_5{4,5};NaN NaN RR_5{4,6}];
pNN50_RR6 = [RR_6{4,1} RR_6{4,3} RR_6{4,5};RR_6{4,2} RR_6{4,4} RR_6{4,6};NaN NaN RR_6{4,7}];
pNN50_RR7 = [RR_7{4,1} RR_7{4,3} RR_7{4,5};RR_7{4,2} RR_7{4,4} RR_7{4,6};NaN NaN RR_7{4,7}];
pNN50_RR8 = [RR_8{4,1} RR_8{4,3} RR_8{4,5};RR_8{4,2} RR_8{4,4} RR_8{4,6};NaN NaN RR_8{4,7}];
pNN50_RR10 = [RR_10{4,1} RR_10{4,3} RR_10{4,5};RR_10{4,2} RR_10{4,4} RR_10{4,6};NaN NaN RR_10{4,7}];
pNN50_RR11 = [RR_11{4,1} RR_11{4,3} RR_11{4,5};RR_11{4,2} RR_11{4,4} RR_11{4,6};NaN NaN RR_11{4,7}];
pNN50_RR12 = [RR_12{4,1} RR_12{4,3} RR_12{4,5};RR_12{4,2} RR_12{4,4} RR_12{4,6};NaN NaN RR_12{4,7}];
pNN50_RR13 = [RR_13{4,1} RR_13{4,3} RR_13{4,5};RR_13{4,2} RR_13{4,4} RR_13{4,6};NaN NaN RR_13{4,7}];
pNN50_RR15 = [RR_15{4,1} RR_15{4,3} RR_15{4,5};RR_15{4,2} RR_15{4,4} RR_15{4,6};NaN NaN RR_15{4,7}];

pNN50_RR = [pNN50_RR4;pNN50_RR5;pNN50_RR6;pNN50_RR7;pNN50_RR8;pNN50_RR10;pNN50_RR11;pNN50_RR12;pNN50_RR13;pNN50_RR15];

[p_pNN50_RR,~,stats] = anova1(pNN50_RR); 
figure()
R_pNN50 = multcompare(stats);

% ROC curve
scores = [pNN50_RR(:,1);pNN50_RR(:,2);pNN50_RR(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_pNN50_RR]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_pNN50_RR = [specificity_1(idx) sensitivity(idx)];
treshold_pNN50_RR = t((specificity_1==opt_pNN50_RR(1)) & (sensitivity==opt_pNN50_RR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve pNN50')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_pNN50_RR(1),opt_pNN50_RR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% HRV=LF/HF

HRV_RR4 = [RR_4{5,1} RR_4{5,3} RR_4{5,5};RR_4{5,2} RR_4{5,4} RR_4{5,6};NaN NaN RR_4{5,7}];
HRV_RR5 = [RR_5{5,1} NaN RR_5{5,4};RR_5{5,2} RR_5{5,3} RR_5{5,5};NaN NaN RR_5{5,6}];
HRV_RR6 = [RR_6{5,1} RR_6{5,3} RR_6{5,5};RR_6{5,2} RR_6{5,4} RR_6{5,6};NaN NaN RR_6{5,7}];
HRV_RR7 = [RR_7{5,1} RR_7{5,3} RR_7{5,5};RR_7{5,2} RR_7{5,4} RR_7{5,6};NaN NaN RR_7{5,7}];
HRV_RR8 = [RR_8{5,1} RR_8{5,3} RR_8{5,5};RR_8{5,2} RR_8{5,4} RR_8{5,6};NaN NaN RR_8{5,7}];
HRV_RR10 = [RR_10{5,1} RR_10{5,3} RR_10{5,5};RR_10{5,2} RR_10{5,4} RR_10{5,6};NaN NaN RR_10{5,7}];
HRV_RR11 = [RR_11{5,1} RR_11{5,3} RR_11{5,5};RR_11{5,2} RR_11{5,4} RR_11{5,6};NaN NaN RR_11{5,7}];
HRV_RR12 = [RR_12{5,1} RR_12{5,3} RR_12{5,5};RR_12{5,2} RR_12{5,4} RR_12{5,6};NaN NaN RR_12{5,7}];
HRV_RR13 = [RR_13{5,1} RR_13{5,3} RR_13{5,5};RR_13{5,2} RR_13{5,4} RR_13{5,6};NaN NaN RR_13{5,7}];
HRV_RR15 = [RR_15{5,1} RR_15{5,3} RR_15{5,5};RR_15{5,2} RR_15{5,4} RR_15{5,6};NaN NaN RR_15{5,7}];

HRV_RR = [HRV_RR4;HRV_RR5;HRV_RR6;HRV_RR7;HRV_RR8;HRV_RR10;HRV_RR11;HRV_RR12;HRV_RR13;HRV_RR15];

[p_HRV_RR,~,stats] = anova1(HRV_RR); 
figure()
R_HRV = multcompare(stats);

% ROC curve
scores = [HRV_RR(:,1);HRV_RR(:,2);HRV_RR(:,3)];
posclass = 1;

[specificity_1,sensitivity,t,auc_HRV_RR]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_HRV_RR = [specificity_1(idx) sensitivity(idx)];
treshold_HRV_RR = t((specificity_1==opt_HRV_RR(1)) & (sensitivity==opt_HRV_RR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve HRV')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_HRV_RR(1),opt_HRV_RR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% HRV= (LF+MF)/HF

HRV2_RR4 = [RR_4{6,1} RR_4{6,3} RR_4{6,5};RR_4{6,2} RR_4{6,4} RR_4{6,6};NaN NaN RR_4{6,7}];
HRV2_RR5 = [RR_5{6,1} NaN RR_5{6,4};RR_5{6,2} RR_5{6,3} RR_5{6,5};NaN NaN RR_5{6,6}];
HRV2_RR6 = [RR_6{6,1} RR_6{6,3} RR_6{6,5};RR_6{6,2} RR_6{6,4} RR_6{6,6};NaN NaN RR_6{6,7}];
HRV2_RR7 = [RR_7{6,1} RR_7{6,3} RR_7{6,5};RR_7{6,2} RR_7{6,4} RR_7{6,6};NaN NaN RR_7{6,7}];
HRV2_RR8 = [RR_8{6,1} RR_8{6,3} RR_8{6,5};RR_8{6,2} RR_8{6,4} RR_8{6,6};NaN NaN RR_8{6,7}];
HRV2_RR10 = [RR_10{6,1} RR_10{6,3} RR_10{6,5};RR_10{6,2} RR_10{6,4} RR_10{6,6};NaN NaN RR_10{6,7}];
HRV2_RR11 = [RR_11{6,1} RR_11{6,3} RR_11{6,5};RR_11{6,2} RR_11{6,4} RR_11{6,6};NaN NaN RR_11{6,7}];
HRV2_RR12 = [RR_12{6,1} RR_12{6,3} RR_12{6,5};RR_12{6,2} RR_12{6,4} RR_12{6,6};NaN NaN RR_12{6,7}];
HRV2_RR13 = [RR_13{6,1} RR_13{6,3} RR_13{6,5};RR_13{6,2} RR_13{6,4} RR_13{6,6};NaN NaN RR_13{6,7}];
HRV2_RR15 = [RR_15{6,1} RR_15{6,3} RR_15{6,5};RR_15{6,2} RR_15{6,4} RR_15{6,6};NaN NaN RR_15{6,7}];

HRV2_RR = [HRV2_RR4;HRV2_RR5;HRV2_RR6;HRV2_RR7;HRV2_RR8;HRV2_RR10;HRV2_RR11;HRV2_RR12;HRV2_RR13;HRV2_RR15];

[p_HRV2_RR,~,stats] = anova1(HRV2_RR); 
figure()
R_HRV2 = multcompare(stats); 

% ROC curve
scores = [HRV2_RR(:,1);HRV2_RR(:,2);HRV2_RR(:,3)];
posclass = 1;

[specificity_1,sensitivity,t,auc_HRV2_RR]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_HRV2_RR = [specificity_1(idx) sensitivity(idx)];
treshold_HRV2_RR = t((specificity_1==opt_HRV2_RR(1)) & (sensitivity==opt_HRV2_RR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve HRV2')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_HRV2_RR(1),opt_HRV2_RR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Mean footGSR

mean_footGSR_4 = [footGSR_4{1,1} footGSR_4{1,3} footGSR_4{1,5};footGSR_4{1,2} footGSR_4{1,4} footGSR_4{1,6};NaN NaN footGSR_4{1,7}];
mean_footGSR_5 = [footGSR_5{1,1} footGSR_5{1,3} footGSR_5{1,5};footGSR_5{1,2} footGSR_5{1,4} footGSR_5{1,6};NaN NaN footGSR_5{1,7}];
mean_footGSR_6 = [footGSR_6{1,1} footGSR_6{1,3} footGSR_6{1,5};footGSR_6{1,2} footGSR_6{1,4} footGSR_6{1,6};NaN NaN footGSR_6{1,7}];
mean_footGSR_7 = [footGSR_7{1,1} footGSR_7{1,3} footGSR_7{1,5};footGSR_7{1,2} footGSR_7{1,4} footGSR_7{1,6};NaN NaN footGSR_7{1,7}];
mean_footGSR_8 = [footGSR_8{1,1} footGSR_8{1,3} footGSR_8{1,5};footGSR_8{1,2} footGSR_8{1,4} footGSR_8{1,6};NaN NaN footGSR_8{1,7}];
mean_footGSR_10 = [footGSR_10{1,1} footGSR_10{1,3} footGSR_10{1,5};footGSR_10{1,2} footGSR_10{1,4} footGSR_10{1,6};NaN NaN footGSR_10{1,7}];
mean_footGSR_11 = [footGSR_11{1,1} footGSR_11{1,3} footGSR_11{1,5};footGSR_11{1,2} footGSR_11{1,4} footGSR_11{1,6};NaN NaN footGSR_11{1,7}];
mean_footGSR_12 = [footGSR_12{1,1} footGSR_12{1,3} footGSR_12{1,5};footGSR_12{1,2} footGSR_12{1,4} footGSR_12{1,6};NaN NaN footGSR_12{1,7}];
mean_footGSR_13 = [footGSR_13{1,1} footGSR_13{1,3} footGSR_13{1,5};footGSR_13{1,2} footGSR_13{1,4} footGSR_13{1,6};NaN NaN footGSR_13{1,7}];
mean_footGSR_15 = [footGSR_15{1,1} footGSR_15{1,3} footGSR_15{1,5};footGSR_15{1,2} footGSR_15{1,4} footGSR_15{1,6};NaN NaN footGSR_15{1,7}];

mean_footGSR = [mean_footGSR_4;mean_footGSR_5;mean_footGSR_6;mean_footGSR_7;mean_footGSR_8;mean_footGSR_10;mean_footGSR_11;mean_footGSR_12;mean_footGSR_13;mean_footGSR_15];

[p_mean_footGSR,~,stats] = anova1(mean_footGSR);
figure ()
R_mean_footGSR = multcompare(stats);

%% Standard deviation footGSR

sd_footGSR_4 = [footGSR_4{2,1} footGSR_4{2,3} footGSR_4{2,5};footGSR_4{2,2} footGSR_4{2,4} footGSR_4{2,6};NaN NaN footGSR_4{2,7}];
sd_footGSR_5 = [footGSR_5{2,1} footGSR_5{2,3} footGSR_5{2,5};footGSR_5{2,2} footGSR_5{2,4} footGSR_5{2,6};NaN NaN footGSR_5{2,7}];
sd_footGSR_6 = [footGSR_6{2,1} footGSR_6{2,3} footGSR_6{2,5};footGSR_6{2,2} footGSR_6{2,4} footGSR_6{2,6};NaN NaN footGSR_6{2,7}];
sd_footGSR_7 = [footGSR_7{2,1} footGSR_7{2,3} footGSR_7{2,5};footGSR_7{2,2} footGSR_7{2,4} footGSR_7{2,6};NaN NaN footGSR_7{2,7}];
sd_footGSR_8 = [footGSR_8{2,1} footGSR_8{2,3} footGSR_8{2,5};footGSR_8{2,2} footGSR_8{2,4} footGSR_8{2,6};NaN NaN footGSR_8{2,7}];
sd_footGSR_10 = [footGSR_10{2,1} footGSR_10{2,3} footGSR_10{2,5};footGSR_10{2,2} footGSR_10{2,4} footGSR_10{2,6};NaN NaN footGSR_10{2,7}];
sd_footGSR_11 = [footGSR_11{2,1} footGSR_11{2,3} footGSR_11{2,5};footGSR_11{2,2} footGSR_11{2,4} footGSR_11{2,6};NaN NaN footGSR_11{2,7}];
sd_footGSR_12 = [footGSR_12{2,1} footGSR_12{2,3} footGSR_12{2,5};footGSR_12{2,2} footGSR_12{2,4} footGSR_12{2,6};NaN NaN footGSR_12{2,7}];
sd_footGSR_13 = [footGSR_13{2,1} footGSR_13{2,3} footGSR_13{2,5};footGSR_13{2,2} footGSR_13{2,4} footGSR_13{2,6};NaN NaN footGSR_13{2,7}];
sd_footGSR_15 = [footGSR_15{2,1} footGSR_15{2,3} footGSR_15{2,5};footGSR_15{2,2} footGSR_15{2,4} footGSR_15{2,6};NaN NaN footGSR_15{2,7}];

sd_footGSR = [sd_footGSR_4;sd_footGSR_5;sd_footGSR_6;sd_footGSR_7;sd_footGSR_8;sd_footGSR_10;sd_footGSR_11;sd_footGSR_12;sd_footGSR_13;sd_footGSR_15];

[p_sd_footGSR,~,stats] = anova1(sd_footGSR);
figure ()
R_sd_footGSR = multcompare(stats);

% ROC curve
scores = [sd_footGSR(:,1);sd_footGSR(:,2);sd_footGSR(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_sd_footGSR]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_sd_footGSR = [specificity_1(idx) sensitivity(idx)];
treshold_sd_footGSR = t((specificity_1==opt_sd_footGSR(1)) & (sensitivity==opt_sd_footGSR(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve sd footGSR')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_sd_footGSR(1),opt_sd_footGSR(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Integral footGSR

integral_footGSR_4 = [footGSR_4{3,1} footGSR_4{3,3} footGSR_4{3,5};footGSR_4{3,2} footGSR_4{3,4} footGSR_4{3,6};NaN NaN footGSR_4{3,7}];
integral_footGSR_5 = [footGSR_5{3,1} footGSR_5{3,3} footGSR_5{3,5};footGSR_5{3,2} footGSR_5{3,4} footGSR_5{3,6};NaN NaN footGSR_5{3,7}];
integral_footGSR_6 = [footGSR_6{3,1} footGSR_6{3,3} footGSR_6{3,5};footGSR_6{3,2} footGSR_6{3,4} footGSR_6{3,6};NaN NaN footGSR_6{3,7}];
integral_footGSR_7 = [footGSR_7{3,1} footGSR_7{3,3} footGSR_7{3,5};footGSR_7{3,2} footGSR_7{3,4} footGSR_7{3,6};NaN NaN footGSR_7{3,7}];
integral_footGSR_8 = [footGSR_8{3,1} footGSR_8{3,3} footGSR_8{3,5};footGSR_8{3,2} footGSR_8{3,4} footGSR_8{3,6};NaN NaN footGSR_8{3,7}];
integral_footGSR_10 = [footGSR_10{3,1} footGSR_10{3,3} footGSR_10{3,5};footGSR_10{3,2} footGSR_10{3,4} footGSR_10{3,6};NaN NaN footGSR_10{3,7}];
integral_footGSR_11 = [footGSR_11{3,1} footGSR_11{3,3} footGSR_11{3,5};footGSR_11{3,2} footGSR_11{3,4} footGSR_11{3,6};NaN NaN footGSR_11{3,7}];
integral_footGSR_12 = [footGSR_12{3,1} footGSR_12{3,3} footGSR_12{3,5};footGSR_12{3,2} footGSR_12{3,4} footGSR_12{3,6};NaN NaN footGSR_12{3,7}];
integral_footGSR_13 = [footGSR_13{3,1} footGSR_13{3,3} footGSR_13{3,5};footGSR_13{3,2} footGSR_13{3,4} footGSR_13{3,6};NaN NaN footGSR_13{3,7}];
integral_footGSR_15 = [footGSR_15{3,1} footGSR_15{3,3} footGSR_15{3,5};footGSR_15{3,2} footGSR_15{3,4} footGSR_15{3,6};NaN NaN footGSR_15{3,7}];

integral_footGSR = [integral_footGSR_4;integral_footGSR_5;integral_footGSR_6;integral_footGSR_7;integral_footGSR_8;integral_footGSR_10;integral_footGSR_11;integral_footGSR_12;integral_footGSR_13;integral_footGSR_15];

[p_integral_footGSR,~,stats] = anova1(integral_footGSR);
figure ()
R_integral_footGSR = multcompare(stats);

%% Mean footGSR smooth 

mean_footGSR_smooth_4 = [footGSR_smooth_4{1,1} footGSR_smooth_4{1,3} footGSR_smooth_4{1,5};footGSR_smooth_4{1,2} footGSR_smooth_4{1,4} footGSR_smooth_4{1,6};NaN NaN footGSR_smooth_4{1,7}];
mean_footGSR_smooth_5 = [footGSR_smooth_5{1,1} footGSR_smooth_5{1,3} footGSR_smooth_5{1,5};footGSR_smooth_5{1,2} footGSR_smooth_5{1,4} footGSR_smooth_5{1,6};NaN NaN footGSR_smooth_5{1,7}];
mean_footGSR_smooth_6 = [footGSR_smooth_6{1,1} footGSR_smooth_6{1,3} footGSR_smooth_6{1,5};footGSR_smooth_6{1,2} footGSR_smooth_6{1,4} footGSR_smooth_6{1,6};NaN NaN footGSR_smooth_6{1,7}];
mean_footGSR_smooth_7 = [footGSR_smooth_7{1,1} footGSR_smooth_7{1,3} footGSR_smooth_7{1,5};footGSR_smooth_7{1,2} footGSR_smooth_7{1,4} footGSR_smooth_7{1,6};NaN NaN footGSR_smooth_7{1,7}];
mean_footGSR_smooth_8 = [footGSR_smooth_8{1,1} footGSR_smooth_8{1,3} footGSR_smooth_8{1,5};footGSR_smooth_8{1,2} footGSR_smooth_8{1,4} footGSR_smooth_8{1,6};NaN NaN footGSR_smooth_8{1,7}];
mean_footGSR_smooth_10= [footGSR_smooth_10{1,1} footGSR_smooth_10{1,3} footGSR_smooth_10{1,5};footGSR_smooth_10{1,2} footGSR_smooth_10{1,4} footGSR_smooth_10{1,6};NaN NaN footGSR_smooth_10{1,7}];
mean_footGSR_smooth_11 = [footGSR_smooth_11{1,1} footGSR_smooth_11{1,3} footGSR_smooth_11{1,5};footGSR_smooth_11{1,2} footGSR_smooth_11{1,4} footGSR_smooth_11{1,6};NaN NaN footGSR_smooth_11{1,7}];
mean_footGSR_smooth_12 = [footGSR_smooth_12{1,1} footGSR_smooth_12{1,3} footGSR_smooth_12{1,5};footGSR_smooth_12{1,2} footGSR_smooth_12{1,4} footGSR_smooth_12{1,6};NaN NaN footGSR_smooth_12{1,7}];
mean_footGSR_smooth_13 = [footGSR_smooth_13{1,1} footGSR_smooth_13{1,3} footGSR_smooth_13{1,5};footGSR_smooth_13{1,2} footGSR_smooth_13{1,4} footGSR_smooth_13{1,6};NaN NaN footGSR_smooth_13{1,7}];
mean_footGSR_smooth_15 = [footGSR_smooth_15{1,1} footGSR_smooth_15{1,3} footGSR_smooth_15{1,5};footGSR_smooth_15{1,2} footGSR_smooth_15{1,4} footGSR_smooth_15{1,6};NaN NaN footGSR_smooth_15{1,7}];

mean_footGSR_smooth= [mean_footGSR_smooth_4;mean_footGSR_smooth_5;mean_footGSR_smooth_6;mean_footGSR_smooth_7;mean_footGSR_smooth_8;mean_footGSR_smooth_10;mean_footGSR_smooth_11;mean_footGSR_smooth_12;mean_footGSR_smooth_13;mean_footGSR_smooth_15];

[p_mean_footGSR_smooth,~,stats] = anova1(mean_footGSR_smooth); 
figure()
R_mean_footGSR_smooth = multcompare(stats);   

%%  Standard Deviation footGSR smooth

std_footGSR_smooth_4 = [footGSR_smooth_4{2,1} footGSR_smooth_4{2,3} footGSR_smooth_4{2,5};footGSR_smooth_4{2,2} footGSR_smooth_4{2,4} footGSR_smooth_4{2,6};NaN NaN footGSR_smooth_4{2,7}];
std_footGSR_smooth_5 = [footGSR_smooth_5{2,1} footGSR_smooth_5{2,3} footGSR_smooth_5{2,5};footGSR_smooth_5{2,2} footGSR_smooth_5{2,4} footGSR_smooth_5{2,6};NaN NaN footGSR_smooth_5{2,7}];
std_footGSR_smooth_6 = [footGSR_smooth_6{2,1} footGSR_smooth_6{2,3} footGSR_smooth_6{2,5};footGSR_smooth_6{2,2} footGSR_smooth_6{2,4} footGSR_smooth_6{2,6};NaN NaN footGSR_smooth_6{2,7}];
std_footGSR_smooth_7 = [footGSR_smooth_7{2,1} footGSR_smooth_7{2,3} footGSR_smooth_7{2,5};footGSR_smooth_7{2,2} footGSR_smooth_7{2,4} footGSR_smooth_7{2,6};NaN NaN footGSR_smooth_7{2,7}];
std_footGSR_smooth_8 = [footGSR_smooth_8{2,1} footGSR_smooth_8{2,3} footGSR_smooth_8{2,5};footGSR_smooth_8{2,2} footGSR_smooth_8{2,4} footGSR_smooth_8{2,6};NaN NaN footGSR_smooth_8{2,7}];
std_footGSR_smooth_10= [footGSR_smooth_10{2,1} footGSR_smooth_10{2,3} footGSR_smooth_10{2,5};footGSR_smooth_10{2,2} footGSR_smooth_10{2,4} footGSR_smooth_10{2,6};NaN NaN footGSR_smooth_10{2,7}];
std_footGSR_smooth_11 = [footGSR_smooth_11{2,1} footGSR_smooth_11{2,3} footGSR_smooth_11{2,5};footGSR_smooth_11{2,2} footGSR_smooth_11{2,4} footGSR_smooth_11{2,6};NaN NaN footGSR_smooth_11{2,7}];
std_footGSR_smooth_12 = [footGSR_smooth_12{2,1} footGSR_smooth_12{2,3} footGSR_smooth_12{2,5};footGSR_smooth_12{2,2} footGSR_smooth_12{2,4} footGSR_smooth_12{2,6};NaN NaN footGSR_smooth_12{2,7}];
std_footGSR_smooth_13 = [footGSR_smooth_13{2,1} footGSR_smooth_13{2,3} footGSR_smooth_13{2,5};footGSR_smooth_13{2,2} footGSR_smooth_13{2,4} footGSR_smooth_13{2,6};NaN NaN footGSR_smooth_13{2,7}];
std_footGSR_smooth_15 = [footGSR_smooth_15{2,1} footGSR_smooth_15{2,3} footGSR_smooth_15{2,5};footGSR_smooth_15{2,2} footGSR_smooth_15{2,4} footGSR_smooth_15{2,6};NaN NaN footGSR_smooth_15{2,7}];

std_footGSR_smooth= [std_footGSR_smooth_4;std_footGSR_smooth_5;std_footGSR_smooth_6;std_footGSR_smooth_7;std_footGSR_smooth_8;std_footGSR_smooth_10;std_footGSR_smooth_11;std_footGSR_smooth_12;std_footGSR_smooth_13;std_footGSR_smooth_15];

[p_std_footGSR_smooth,~,stats] = anova1(std_footGSR_smooth);
figure()
R_std_footGSR_smooth = multcompare(stats); 

% ROC curve
scores = [std_footGSR_smooth(:,1);std_footGSR_smooth(:,2);std_footGSR_smooth(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_std_footGSR_smooth]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_std_footGSR_smooth = [specificity_1(idx) sensitivity(idx)];
treshold_std_footGSR_smooth = t((specificity_1==opt_std_footGSR_smooth(1)) & (sensitivity==opt_std_footGSR_smooth(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve sd footGSR smooth')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_std_footGSR_smooth(1),opt_std_footGSR_smooth(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Integral footGSR smooth

integral_footGSR_smooth_4 = [footGSR_smooth_4{3,1} footGSR_smooth_4{3,3} footGSR_smooth_4{3,5};footGSR_smooth_4{3,2} footGSR_smooth_4{3,4} footGSR_smooth_4{3,6};NaN NaN footGSR_smooth_4{3,7}];
integral_footGSR_smooth_5 = [footGSR_smooth_5{3,1} footGSR_smooth_5{3,3} footGSR_smooth_5{3,5};footGSR_smooth_5{3,2} footGSR_smooth_5{3,4} footGSR_smooth_5{3,6};NaN NaN footGSR_smooth_5{3,7}];
integral_footGSR_smooth_6 = [footGSR_smooth_6{3,1} footGSR_smooth_6{3,3} footGSR_smooth_6{3,5};footGSR_smooth_6{3,2} footGSR_smooth_6{3,4} footGSR_smooth_6{3,6};NaN NaN footGSR_smooth_6{3,7}];
integral_footGSR_smooth_7 = [footGSR_smooth_7{3,1} footGSR_smooth_7{3,3} footGSR_smooth_7{3,5};footGSR_smooth_7{3,2} footGSR_smooth_7{3,4} footGSR_smooth_7{3,6};NaN NaN footGSR_smooth_7{3,7}];
integral_footGSR_smooth_8 = [footGSR_smooth_8{3,1} footGSR_smooth_8{3,3} footGSR_smooth_8{3,5};footGSR_smooth_8{3,2} footGSR_smooth_8{3,4} footGSR_smooth_8{3,6};NaN NaN footGSR_smooth_8{3,7}];
integral_footGSR_smooth_10= [footGSR_smooth_10{3,1} footGSR_smooth_10{3,3} footGSR_smooth_10{3,5};footGSR_smooth_10{3,2} footGSR_smooth_10{3,4} footGSR_smooth_10{3,6};NaN NaN footGSR_smooth_10{3,7}];
integral_footGSR_smooth_11 = [footGSR_smooth_11{3,1} footGSR_smooth_11{3,3} footGSR_smooth_11{3,5};footGSR_smooth_11{3,2} footGSR_smooth_11{3,4} footGSR_smooth_11{3,6};NaN NaN footGSR_smooth_11{3,7}];
integral_footGSR_smooth_12 = [footGSR_smooth_12{3,1} footGSR_smooth_12{3,3} footGSR_smooth_12{3,5};footGSR_smooth_12{3,2} footGSR_smooth_12{3,4} footGSR_smooth_12{3,6};NaN NaN footGSR_smooth_12{3,7}];
integral_footGSR_smooth_13 = [footGSR_smooth_13{3,1} footGSR_smooth_13{3,3} footGSR_smooth_13{3,5};footGSR_smooth_13{3,2} footGSR_smooth_13{3,4} footGSR_smooth_13{3,6};NaN NaN footGSR_smooth_13{3,7}];
integral_footGSR_smooth_15 = [footGSR_smooth_15{3,1} footGSR_smooth_15{3,3} footGSR_smooth_15{3,5};footGSR_smooth_15{3,2} footGSR_smooth_15{3,4} footGSR_smooth_15{3,6};NaN NaN footGSR_smooth_15{3,7}];

integral_footGSR_smooth= [integral_footGSR_smooth_4;integral_footGSR_smooth_5;integral_footGSR_smooth_6;integral_footGSR_smooth_7;integral_footGSR_smooth_8;integral_footGSR_smooth_10;integral_footGSR_smooth_11;integral_footGSR_smooth_12;integral_footGSR_smooth_13;integral_footGSR_smooth_15];

[p_integral_footGSR_smooth,~,stats] = anova1(integral_footGSR_smooth);
figure()
R_integral_footGSR_smooth = multcompare(stats); 

%% Number of Peaks foorGSR smooth

npeaks_footGSR_smooth_4 = [footGSR_smooth_4{4,1} footGSR_smooth_4{4,3} footGSR_smooth_4{4,5};footGSR_smooth_4{4,2} footGSR_smooth_4{4,4} footGSR_smooth_4{4,6};NaN NaN footGSR_smooth_4{4,7}];
npeaks_footGSR_smooth_5 = [footGSR_smooth_5{4,1} footGSR_smooth_5{4,3} footGSR_smooth_5{4,5};footGSR_smooth_5{4,2} footGSR_smooth_5{4,4} footGSR_smooth_5{4,6};NaN NaN footGSR_smooth_5{4,7}];
npeaks_footGSR_smooth_6 = [footGSR_smooth_6{4,1} footGSR_smooth_6{4,3} footGSR_smooth_6{4,5};footGSR_smooth_6{4,2} footGSR_smooth_6{4,4} footGSR_smooth_6{4,6};NaN NaN footGSR_smooth_6{4,7}];
npeaks_footGSR_smooth_7 = [footGSR_smooth_7{4,1} footGSR_smooth_7{4,3} footGSR_smooth_7{4,5};footGSR_smooth_7{4,2} footGSR_smooth_7{4,4} footGSR_smooth_7{4,6};NaN NaN footGSR_smooth_7{4,7}];
npeaks_footGSR_smooth_8 = [footGSR_smooth_8{4,1} footGSR_smooth_8{4,3} footGSR_smooth_8{4,5};footGSR_smooth_8{4,2} footGSR_smooth_8{4,4} footGSR_smooth_8{4,6};NaN NaN footGSR_smooth_8{4,7}];
npeaks_footGSR_smooth_10= [footGSR_smooth_10{4,1} footGSR_smooth_10{4,3} footGSR_smooth_10{4,5};footGSR_smooth_10{4,2} footGSR_smooth_10{4,4} footGSR_smooth_10{4,6};NaN NaN footGSR_smooth_10{4,7}];
npeaks_footGSR_smooth_11 = [footGSR_smooth_11{4,1} footGSR_smooth_11{4,3} footGSR_smooth_11{4,5};footGSR_smooth_11{4,2} footGSR_smooth_11{4,4} footGSR_smooth_11{4,6};NaN NaN footGSR_smooth_11{4,7}];
npeaks_footGSR_smooth_12 = [footGSR_smooth_12{4,1} footGSR_smooth_12{4,3} footGSR_smooth_12{4,5};footGSR_smooth_12{4,2} footGSR_smooth_12{4,4} footGSR_smooth_12{4,6};NaN NaN footGSR_smooth_12{4,7}];
npeaks_footGSR_smooth_13 = [footGSR_smooth_13{4,1} footGSR_smooth_13{4,3} footGSR_smooth_13{4,5};footGSR_smooth_13{4,2} footGSR_smooth_13{4,4} footGSR_smooth_13{4,6};NaN NaN footGSR_smooth_13{4,7}];
npeaks_footGSR_smooth_15 = [footGSR_smooth_15{4,1} footGSR_smooth_15{4,3} footGSR_smooth_15{4,5};footGSR_smooth_15{4,2} footGSR_smooth_15{4,4} footGSR_smooth_15{4,6};NaN NaN footGSR_smooth_15{4,7}];

npeaks_footGSR_smooth= [npeaks_footGSR_smooth_4;npeaks_footGSR_smooth_5;npeaks_footGSR_smooth_6;npeaks_footGSR_smooth_7;npeaks_footGSR_smooth_8;npeaks_footGSR_smooth_10;npeaks_footGSR_smooth_11;npeaks_footGSR_smooth_12;npeaks_footGSR_smooth_13;npeaks_footGSR_smooth_15];

[p_npeaks_footGSR_smooth,~,stats] = anova1(npeaks_footGSR_smooth); 
figure()
R_npeaks_footGSR_smooth = multcompare(stats); 

% ROC curve
scores = [npeaks_footGSR_smooth(:,1);npeaks_footGSR_smooth(:,2);npeaks_footGSR_smooth(:,3)];
posclass = 1;

[specificity_1,sensitivity,t,auc_npeaks_footGSR_smooth]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_npeaks_footGSR_smooth = [specificity_1(idx) sensitivity(idx)];
treshold_npeaks_footGSR_smoot = t((specificity_1==opt_npeaks_footGSR_smooth(1)) & (sensitivity==opt_npeaks_footGSR_smooth(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve n° of peaks footGSR smooth')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_npeaks_footGSR_smooth(1),opt_npeaks_footGSR_smooth(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Mean Rise Time footGSR smooth

meanRiseTime_footGSR_smooth_4 = [footGSR_smooth_4{5,1} footGSR_smooth_4{5,3} footGSR_smooth_4{5,5};footGSR_smooth_4{5,2} footGSR_smooth_4{5,4} footGSR_smooth_4{5,6};NaN NaN footGSR_smooth_4{5,7}];
meanRiseTime_footGSR_smooth_5 = [footGSR_smooth_5{5,1} footGSR_smooth_5{5,3} footGSR_smooth_5{5,5};footGSR_smooth_5{5,2} footGSR_smooth_5{5,4} footGSR_smooth_5{5,6};NaN NaN footGSR_smooth_5{5,7}];
meanRiseTime_footGSR_smooth_6 = [footGSR_smooth_6{5,1} footGSR_smooth_6{5,3} footGSR_smooth_6{5,5};footGSR_smooth_6{5,2} footGSR_smooth_6{5,4} footGSR_smooth_6{5,6};NaN NaN footGSR_smooth_6{5,7}];
meanRiseTime_footGSR_smooth_7 = [footGSR_smooth_7{5,1} footGSR_smooth_7{5,3} footGSR_smooth_7{5,5};footGSR_smooth_7{5,2} footGSR_smooth_7{5,4} footGSR_smooth_7{5,6};NaN NaN footGSR_smooth_7{5,7}];
meanRiseTime_footGSR_smooth_8 = [footGSR_smooth_8{5,1} footGSR_smooth_8{5,3} footGSR_smooth_8{5,5};footGSR_smooth_8{5,2} footGSR_smooth_8{5,4} footGSR_smooth_8{5,6};NaN NaN footGSR_smooth_8{5,7}];
meanRiseTime_footGSR_smooth_10= [footGSR_smooth_10{5,1} footGSR_smooth_10{5,3} footGSR_smooth_10{5,5};footGSR_smooth_10{5,2} footGSR_smooth_10{5,4} footGSR_smooth_10{5,6};NaN NaN footGSR_smooth_10{5,7}];
meanRiseTime_footGSR_smooth_11 = [footGSR_smooth_11{5,1} footGSR_smooth_11{5,3} footGSR_smooth_11{5,5};footGSR_smooth_11{5,2} footGSR_smooth_11{5,4} footGSR_smooth_11{5,6};NaN NaN footGSR_smooth_11{5,7}];
meanRiseTime_footGSR_smooth_12 = [footGSR_smooth_12{5,1} footGSR_smooth_12{5,3} footGSR_smooth_12{5,5};footGSR_smooth_12{5,2} footGSR_smooth_12{5,4} footGSR_smooth_12{5,6};NaN NaN footGSR_smooth_12{5,7}];
meanRiseTime_footGSR_smooth_13 = [footGSR_smooth_13{5,1} footGSR_smooth_13{5,3} footGSR_smooth_13{5,5};footGSR_smooth_13{5,2} footGSR_smooth_13{5,4} footGSR_smooth_13{5,6};NaN NaN footGSR_smooth_13{5,7}];
meanRiseTime_footGSR_smooth_15 = [footGSR_smooth_15{5,1} footGSR_smooth_15{5,3} footGSR_smooth_15{5,5};footGSR_smooth_15{5,2} footGSR_smooth_15{5,4} footGSR_smooth_15{5,6};NaN NaN footGSR_smooth_15{5,7}];

meanRiseTime_footGSR_smooth=[meanRiseTime_footGSR_smooth_4; meanRiseTime_footGSR_smooth_5; meanRiseTime_footGSR_smooth_6; meanRiseTime_footGSR_smooth_7; meanRiseTime_footGSR_smooth_8; meanRiseTime_footGSR_smooth_10; meanRiseTime_footGSR_smooth_11;meanRiseTime_footGSR_smooth_12; meanRiseTime_footGSR_smooth_13; meanRiseTime_footGSR_smooth_15];

[p_meanRiseTime_footGSR_smooth,~,stats] = anova1(meanRiseTime_footGSR_smooth);
figure()
R_meanRiseTime_footGSR_smooth = multcompare(stats); 

% ROC curve
scores = [meanRiseTime_footGSR_smooth(:,1);meanRiseTime_footGSR_smooth(:,2);meanRiseTime_footGSR_smooth(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_meanRiseTime_footGSR_smooth]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_meanRiseTime_footGSR_smooth = [specificity_1(idx) sensitivity(idx)];
treshold_meanRiseTime_footGSR_smooth = t((specificity_1==opt_meanRiseTime_footGSR_smooth(1)) & (sensitivity==opt_meanRiseTime_footGSR_smooth(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve mean rise time footGSR smooth')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_meanRiseTime_footGSR_smooth(1),opt_meanRiseTime_footGSR_smooth(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Mean Amplitude footGSR_Smooth
 
Amp_footGSR_Smooth4 = [footGSR_smooth_4{6,1} footGSR_smooth_4{6,3} footGSR_smooth_4{6,5};footGSR_smooth_4{6,2} footGSR_smooth_4{6,4} footGSR_smooth_4{6,6};NaN NaN footGSR_smooth_4{6,7}];
Amp_footGSR_Smooth5 = [footGSR_smooth_5{6,1} footGSR_smooth_5{6,3} footGSR_smooth_5{6,5};footGSR_smooth_5{6,2} footGSR_smooth_5{6,4} footGSR_smooth_5{6,6};NaN NaN footGSR_smooth_5{6,7}];   
Amp_footGSR_Smooth6 = [footGSR_smooth_6{6,1} footGSR_smooth_6{6,3} footGSR_smooth_6{6,5};footGSR_smooth_6{6,2} footGSR_smooth_6{6,4} footGSR_smooth_6{6,6};NaN NaN footGSR_smooth_6{6,7}];
Amp_footGSR_Smooth7 = [footGSR_smooth_7{6,1} footGSR_smooth_7{6,3} footGSR_smooth_7{6,5};footGSR_smooth_7{6,2} footGSR_smooth_7{6,4} footGSR_smooth_7{6,6};NaN NaN footGSR_smooth_7{6,7}];
Amp_footGSR_Smooth8 = [footGSR_smooth_8{6,1} footGSR_smooth_8{6,3} footGSR_smooth_8{6,5};footGSR_smooth_8{6,2} footGSR_smooth_8{6,4} footGSR_smooth_8{6,6};NaN NaN footGSR_smooth_8{6,7}];
Amp_footGSR_Smooth10 = [footGSR_smooth_10{6,1} footGSR_smooth_10{6,3} footGSR_smooth_10{6,5};footGSR_smooth_10{6,2} footGSR_smooth_10{6,4} footGSR_smooth_10{6,6};NaN NaN footGSR_smooth_10{6,7}];
Amp_footGSR_Smooth11 = [footGSR_smooth_11{6,1} footGSR_smooth_11{6,3} footGSR_smooth_11{6,5};footGSR_smooth_11{6,2} footGSR_smooth_11{6,4} footGSR_smooth_11{6,6};NaN NaN footGSR_smooth_11{6,7}];
Amp_footGSR_Smooth12 = [footGSR_smooth_12{6,1} footGSR_smooth_12{6,3} footGSR_smooth_12{6,5};footGSR_smooth_12{6,2} footGSR_smooth_12{6,4} footGSR_smooth_12{6,6};NaN NaN footGSR_smooth_12{6,7}];
Amp_footGSR_Smooth13 = [footGSR_smooth_13{6,1} footGSR_smooth_13{6,3} footGSR_smooth_13{6,5};footGSR_smooth_13{6,2} footGSR_smooth_13{6,4} footGSR_smooth_13{6,6};NaN NaN footGSR_smooth_13{6,7}];
Amp_footGSR_Smooth15 = [footGSR_smooth_15{6,1} footGSR_smooth_15{6,3} footGSR_smooth_15{6,5};footGSR_smooth_15{6,2} footGSR_smooth_15{6,4} footGSR_smooth_15{6,6};NaN NaN footGSR_smooth_15{6,7}];
 
Amp_footGSR_Smooth = [Amp_footGSR_Smooth4;Amp_footGSR_Smooth5;Amp_footGSR_Smooth6;Amp_footGSR_Smooth7;Amp_footGSR_Smooth8;Amp_footGSR_Smooth10;Amp_footGSR_Smooth11;Amp_footGSR_Smooth12;Amp_footGSR_Smooth13;Amp_footGSR_Smooth15];
 
[p_Amp_footGSR_Smooth,~,stats] = anova1(Amp_footGSR_Smooth);
figure()
R_Amp_footGSR_Smooth = multcompare(stats); 

%% Mean pks distance Respiration

mean_pks_distance_Resp_4 = [Respiration_4{1,1} Respiration_4{1,3} Respiration_4{1,5};Respiration_4{1,2} Respiration_4{1,4} Respiration_4{1,6};NaN NaN Respiration_4{1,7}];
mean_pks_distance_Resp_5 = [Respiration_5{1,1} Respiration_5{1,3} Respiration_5{1,5};Respiration_5{1,2} Respiration_5{1,4} Respiration_5{1,6};NaN NaN Respiration_5{1,7}];
mean_pks_distance_Resp_6 = [Respiration_6{1,1} Respiration_6{1,3} Respiration_6{1,5};Respiration_6{1,2} Respiration_6{1,4} Respiration_6{1,6};NaN NaN Respiration_6{1,7}];
mean_pks_distance_Resp_7 = [Respiration_7{1,1} Respiration_7{1,3} Respiration_7{1,5};Respiration_7{1,2} Respiration_7{1,4} Respiration_7{1,6};NaN NaN Respiration_7{1,7}];
mean_pks_distance_Resp_8 = [Respiration_8{1,1} Respiration_8{1,3} Respiration_8{1,5};Respiration_8{1,2} Respiration_8{1,4} Respiration_8{1,6};NaN NaN Respiration_8{1,7}];
mean_pks_distance_Resp_10 = [Respiration_10{1,1} Respiration_10{1,3} Respiration_10{1,5};Respiration_10{1,2} Respiration_10{1,4} Respiration_10{1,6};NaN NaN Respiration_10{1,7}];
mean_pks_distance_Resp_11 = [Respiration_11{1,1} Respiration_11{1,3} Respiration_11{1,5};Respiration_11{1,2} Respiration_11{1,4} Respiration_11{1,6};NaN NaN Respiration_11{1,7}];
mean_pks_distance_Resp_12 = [Respiration_12{1,1} Respiration_12{1,3} Respiration_12{1,5};Respiration_12{1,2} Respiration_12{1,4} Respiration_12{1,6};NaN NaN Respiration_12{1,7}];
mean_pks_distance_Resp_13 = [Respiration_13{1,1} Respiration_13{1,3} Respiration_13{1,5};Respiration_13{1,2} Respiration_13{1,4} Respiration_13{1,6};NaN NaN Respiration_13{1,7}];
mean_pks_distance_Resp_15 = [Respiration_15{1,1} Respiration_15{1,3} Respiration_15{1,5};Respiration_15{1,2} Respiration_15{1,4} Respiration_15{1,6};NaN NaN Respiration_15{1,7}];

mean_pks_distance_Resp = [mean_pks_distance_Resp_4;mean_pks_distance_Resp_5;mean_pks_distance_Resp_6;mean_pks_distance_Resp_7;mean_pks_distance_Resp_8;mean_pks_distance_Resp_10;mean_pks_distance_Resp_11;mean_pks_distance_Resp_12;mean_pks_distance_Resp_13;mean_pks_distance_Resp_15];

[p_mean_pks_distance_Resp,~,stats] = anova1(mean_pks_distance_Resp);
figure ()
R_mean_pks_distance_Resp = multcompare(stats);

% ROC curve
scores = [mean_pks_distance_Resp(:,1);mean_pks_distance_Resp(:,2);mean_pks_distance_Resp(:,3)];
posclass = 0;

[specificity_1,sensitivity,t,auc_mean_pks_distance_Resp]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_mean_pks_distance_Resp = [specificity_1(idx) sensitivity(idx)];
treshold_mean_pks_distance_Resp = t((specificity_1==opt_mean_pks_distance_Resp(1)) & (sensitivity==opt_mean_pks_distance_Resp(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve mean peaks distance Respiration')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_mean_pks_distance_Resp(1),opt_mean_pks_distance_Resp(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Mean pks amplitude Respiration

mean_pks_amplitude_Resp_4 = [Respiration_4{2,1} Respiration_4{2,3} Respiration_4{2,5};Respiration_4{2,2} Respiration_4{2,4} Respiration_4{2,6};NaN NaN Respiration_4{2,7}];
mean_pks_amplitude_Resp_5 = [Respiration_5{2,1} Respiration_5{2,3} Respiration_5{2,5};Respiration_5{2,2} Respiration_5{2,4} Respiration_5{2,6};NaN NaN Respiration_5{2,7}];
mean_pks_amplitude_Resp_6 = [Respiration_6{2,1} Respiration_6{2,3} Respiration_6{2,5};Respiration_6{2,2} Respiration_6{2,4} Respiration_6{2,6};NaN NaN Respiration_6{2,7}];
mean_pks_amplitude_Resp_7 = [Respiration_7{2,1} Respiration_7{2,3} Respiration_7{2,5};Respiration_7{2,2} Respiration_7{2,4} Respiration_7{2,6};NaN NaN Respiration_7{2,7}];
mean_pks_amplitude_Resp_8 = [Respiration_8{2,1} Respiration_8{2,3} Respiration_8{2,5};Respiration_8{2,2} Respiration_8{2,4} Respiration_8{2,6};NaN NaN Respiration_8{2,7}];
mean_pks_amplitude_Resp_10 = [Respiration_10{2,1} Respiration_10{2,3} Respiration_10{2,5};Respiration_10{2,2} Respiration_10{2,4} Respiration_10{2,6};NaN NaN Respiration_10{2,7}];
mean_pks_amplitude_Resp_11 = [Respiration_11{2,1} Respiration_11{2,3} Respiration_11{2,5};Respiration_11{2,2} Respiration_11{2,4} Respiration_11{2,6};NaN NaN Respiration_11{2,7}];
mean_pks_amplitude_Resp_12 = [Respiration_12{2,1} Respiration_12{2,3} Respiration_12{2,5};Respiration_12{2,2} Respiration_12{2,4} Respiration_12{2,6};NaN NaN Respiration_12{2,7}];
mean_pks_amplitude_Resp_13 = [Respiration_13{2,1} Respiration_13{2,3} Respiration_13{2,5};Respiration_13{2,2} Respiration_13{2,4} Respiration_13{2,6};NaN NaN Respiration_13{2,7}];
mean_pks_amplitude_Resp_15 = [Respiration_15{2,1} Respiration_15{2,3} Respiration_15{2,5};Respiration_15{2,2} Respiration_15{2,4} Respiration_15{2,6};NaN NaN Respiration_15{2,7}];

mean_pks_amplitude_Resp = [mean_pks_amplitude_Resp_4;mean_pks_amplitude_Resp_5;mean_pks_amplitude_Resp_6;mean_pks_amplitude_Resp_7;mean_pks_amplitude_Resp_8;mean_pks_amplitude_Resp_10;mean_pks_amplitude_Resp_11;mean_pks_amplitude_Resp_12;mean_pks_amplitude_Resp_13;mean_pks_amplitude_Resp_15];

[p_mean_pks_amplitude_Resp,~,stats] = anova1(mean_pks_amplitude_Resp);
figure
R_mean_pks_amplitude_Resp = multcompare(stats);

%% Standard deviation pks amplitude Respiration

sd_pks_amplitude_Resp_4 = [Respiration_4{3,1} Respiration_4{3,3} Respiration_4{3,5};Respiration_4{3,2} Respiration_4{3,4} Respiration_4{3,6};NaN NaN Respiration_4{3,7}];
sd_pks_amplitude_Resp_5 = [Respiration_5{3,1} Respiration_5{3,3} Respiration_5{3,5};Respiration_5{3,2} Respiration_5{3,4} Respiration_5{3,6};NaN NaN Respiration_5{3,7}];
sd_pks_amplitude_Resp_6 = [Respiration_6{3,1} Respiration_6{3,3} Respiration_6{3,5};Respiration_6{3,2} Respiration_6{3,4} Respiration_6{3,6};NaN NaN Respiration_6{3,7}];
sd_pks_amplitude_Resp_7 = [Respiration_7{3,1} Respiration_7{3,3} Respiration_7{3,5};Respiration_7{3,2} Respiration_7{3,4} Respiration_7{3,6};NaN NaN Respiration_7{3,7}];
sd_pks_amplitude_Resp_8 = [Respiration_8{3,1} Respiration_8{3,3} Respiration_8{3,5};Respiration_8{3,2} Respiration_8{3,4} Respiration_8{3,6};NaN NaN Respiration_8{3,7}];
sd_pks_amplitude_Resp_10 = [Respiration_10{3,1} Respiration_10{3,3} Respiration_10{3,5};Respiration_10{3,2} Respiration_10{3,4} Respiration_10{3,6};NaN NaN Respiration_10{3,7}];
sd_pks_amplitude_Resp_11 = [Respiration_11{3,1} Respiration_11{3,3} Respiration_11{3,5};Respiration_11{3,2} Respiration_11{3,4} Respiration_11{3,6};NaN NaN Respiration_11{3,7}];
sd_pks_amplitude_Resp_12 = [Respiration_12{3,1} Respiration_12{3,3} Respiration_12{3,5};Respiration_12{3,2} Respiration_12{3,4} Respiration_12{3,6};NaN NaN Respiration_12{3,7}];
sd_pks_amplitude_Resp_13 = [Respiration_13{3,1} Respiration_13{3,3} Respiration_13{3,5};Respiration_13{3,2} Respiration_13{3,4} Respiration_13{3,6};NaN NaN Respiration_13{3,7}];
sd_pks_amplitude_Resp_15 = [Respiration_15{3,1} Respiration_15{3,3} Respiration_15{3,5};Respiration_15{3,2} Respiration_15{3,4} Respiration_15{3,6};NaN NaN Respiration_15{3,7}];

sd_pks_amplitude_Resp = [sd_pks_amplitude_Resp_4;sd_pks_amplitude_Resp_5;sd_pks_amplitude_Resp_6;sd_pks_amplitude_Resp_7;sd_pks_amplitude_Resp_8;sd_pks_amplitude_Resp_10;sd_pks_amplitude_Resp_11;sd_pks_amplitude_Resp_12;sd_pks_amplitude_Resp_13;sd_pks_amplitude_Resp_15];

[p_sd_pks_amplitude_Resp,~,stats] = anova1(sd_pks_amplitude_Resp);
figure ()
R_sd_pks_amplitude_Resp = multcompare(stats);

% ROC curve
scores = [sd_pks_amplitude_Resp(:,1);sd_pks_amplitude_Resp(:,2);sd_pks_amplitude_Resp(:,3)];
posclass = 1;

[specificity_1,sensitivity,t,auc_sd_pks_amplitude_Resp]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_sd_pks_amplitude_Resp = [specificity_1(idx) sensitivity(idx)];
treshold_sd_pks_amplitude_Resp = t((specificity_1==opt_sd_pks_amplitude_Resp(1)) & (sensitivity==opt_sd_pks_amplitude_Resp(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.5)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve sd peaks amplitude Respiration')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_sd_pks_amplitude_Resp(1),opt_sd_pks_amplitude_Resp(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on


%% Respiration rate

Respiration_Rate_4 = [Respiration_4{4,1} Respiration_4{4,3} Respiration_4{4,5};Respiration_4{4,2} Respiration_4{4,4} Respiration_4{4,6};NaN NaN Respiration_4{4,7}];
Respiration_Rate_5 = [Respiration_5{4,1} Respiration_5{4,3} Respiration_5{4,5};Respiration_5{4,2} Respiration_5{4,4} Respiration_5{4,6};NaN NaN Respiration_5{4,7}];
Respiration_Rate_6 = [Respiration_6{4,1} Respiration_6{4,3} Respiration_6{4,5};Respiration_6{4,2} Respiration_6{4,4} Respiration_6{4,6};NaN NaN Respiration_6{4,7}];
Respiration_Rate_7 = [Respiration_7{4,1} Respiration_7{4,3} Respiration_7{4,5};Respiration_7{4,2} Respiration_7{4,4} Respiration_7{4,6};NaN NaN Respiration_7{4,7}];
Respiration_Rate_8 = [Respiration_8{4,1} Respiration_8{4,3} Respiration_8{4,5};Respiration_8{4,2} Respiration_8{4,4} Respiration_8{4,6};NaN NaN Respiration_8{4,7}];
Respiration_Rate_10 = [Respiration_10{4,1} Respiration_10{4,3} Respiration_10{4,5};Respiration_10{4,2} Respiration_10{4,4} Respiration_10{4,6};NaN NaN Respiration_10{4,7}];
Respiration_Rate_11 = [Respiration_11{4,1} Respiration_11{4,3} Respiration_11{4,5};Respiration_11{4,2} Respiration_11{4,4} Respiration_11{4,6};NaN NaN Respiration_11{4,7}];
Respiration_Rate_12 = [Respiration_12{4,1} Respiration_12{4,3} Respiration_12{4,5};Respiration_12{4,2} Respiration_12{4,4} Respiration_12{4,6};NaN NaN Respiration_12{4,7}];
Respiration_Rate_13 = [Respiration_13{4,1} Respiration_13{4,3} Respiration_13{4,5};Respiration_13{4,2} Respiration_13{4,4} Respiration_13{4,6};NaN NaN Respiration_13{4,7}];
Respiration_Rate_15 = [Respiration_15{4,1} Respiration_15{4,3} Respiration_15{4,5};Respiration_15{4,2} Respiration_15{4,4} Respiration_15{4,6};NaN NaN Respiration_15{4,7}];

Respiration_Rate = [Respiration_Rate_4;Respiration_Rate_5;Respiration_Rate_6;Respiration_Rate_7;Respiration_Rate_8;Respiration_Rate_10;Respiration_Rate_11;Respiration_Rate_12;Respiration_Rate_13;Respiration_Rate_15];

[p_Respiration_Rate,~,stats] = anova1(Respiration_Rate);
figure()
R_Respiration_Rate = multcompare(stats);

% ROC curve
scores = [Respiration_Rate(:,1);Respiration_Rate(:,2);Respiration_Rate(:,3)];
posclass = 1;

[specificity_1,sensitivity,t,auc_Respiration_Rate]=perfcurve(labels,scores,posclass);
J = abs(sensitivity+specificity_1-1);
[~,idx] = min(J);
opt_Respiration_Rate = [specificity_1(idx) sensitivity(idx)];
treshold_Respiration_Rate = t((specificity_1==opt_Respiration_Rate(1)) & (sensitivity==opt_Respiration_Rate(2)));

figure()
plot(specificity_1,sensitivity,'b','linewidth',1.3)
xlabel('1-Specificity')
ylabel('Sensitivity')
title('ROC Curve Respiration Rate')
hold on
plot([0 1],[1 0],'--r','linewidth',0.8)
plot(opt_Respiration_Rate(1),opt_Respiration_Rate(2),'o','color','#80B3FF','linewidth',1.3,'MarkerSize',8)
legend('','','Optimal operating point (Sp=Se)','Location','best')
grid on

%% Plot multiple comparison
labels1 = categorical({'mRR','sdRR','rMMSD','pNN50','HRV','HRV2','mfoot','sfoot','area foot','mfoot smooth','sfoot smooth',...
    'area foot smooth','npeak','rise time','amp','mlocs','mpks','spks','Rrate'});
labels1 = reordercats(labels1,{'mRR','sdRR','rMMSD','pNN50','HRV','HRV2','mfoot','sfoot','area foot','mfoot smooth','sfoot smooth',...
    'area foot smooth','npeak','rise time','amp','mlocs','mpks','spks','Rrate'});

one_two = [R_mean_RR(1,6),R_sd_RR(1,6),R_rMMSD(1,6),R_pNN50(1,6),R_HRV(1,6),R_HRV2(1,6),R_mean_footGSR(1,6),...
    R_sd_footGSR(1,6),R_integral_footGSR(1,6),R_mean_footGSR_smooth(1,6),R_std_footGSR_smooth(1,6),...
    R_integral_footGSR_smooth(1,6),R_npeaks_footGSR_smooth(1,6),R_meanRiseTime_footGSR_smooth(1,6),...
    R_Amp_footGSR_Smooth(1,6),R_mean_pks_distance_Resp(1,6),R_mean_pks_amplitude_Resp(1,6),R_sd_pks_amplitude_Resp(1,6),...
    R_Respiration_Rate(1,6)];
one_three = [R_mean_RR(2,6),R_sd_RR(2,6),R_rMMSD(2,6),R_pNN50(2,6),R_HRV(2,6),R_HRV2(2,6),R_mean_footGSR(2,6),...
    R_sd_footGSR(2,6),R_integral_footGSR(2,6),R_mean_footGSR_smooth(2,6),R_std_footGSR_smooth(2,6),...
    R_integral_footGSR_smooth(2,6),R_npeaks_footGSR_smooth(2,6),R_meanRiseTime_footGSR_smooth(2,6),...
    R_Amp_footGSR_Smooth(2,6),R_mean_pks_distance_Resp(2,6),R_mean_pks_amplitude_Resp(2,6),R_sd_pks_amplitude_Resp(2,6),...
    R_Respiration_Rate(2,6)];
two_three = [R_mean_RR(3,6),R_sd_RR(3,6),R_rMMSD(3,6),R_pNN50(3,6),R_HRV(3,6),R_HRV2(3,6),R_mean_footGSR(3,6),...
    R_sd_footGSR(3,6),R_integral_footGSR(3,6),R_mean_footGSR_smooth(3,6),R_std_footGSR_smooth(3,6),...
    R_integral_footGSR_smooth(3,6),R_npeaks_footGSR_smooth(3,6),R_meanRiseTime_footGSR_smooth(3,6),...
    R_Amp_footGSR_Smooth(3,6),R_mean_pks_distance_Resp(3,6),R_mean_pks_amplitude_Resp(3,6),R_sd_pks_amplitude_Resp(3,6),...
    R_Respiration_Rate(3,6)];

figure()
plot(labels1,one_two,'ko','linewidth',1,'markersize',16,'MarkerFaceColor','k')
hold on
plot(labels1,one_three,'bs','linewidth',1,'MarkerSize',16,'MarkerFaceColor','b')
plot(labels1,two_three,'md','linewidth',1,'MarkerSize',16,'MarkerFaceColor','m')
set(gca,'fontsize',20)
yline(0.05,'--r','linewidth',1.5)
ylabel('p-values','fontweight','bold')
ylim([0 1.2])
legend('Low-Medium','Low-High','Medium-High')
grid on

%% 

close all