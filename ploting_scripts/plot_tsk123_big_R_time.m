clear,clc,close all

purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
orange = [0.8500 0.3250 0.0980];

c1 = [0,0.8,0];
c2 = [1,0.5,0];
c3 = [0.3,0.7,1];

load('basic.mat','lat')

load('tsk2_data.mat','TS_original','PminusE_original')

TS_grwd_ref_tsk1 = zeros(1,360);
PminusE_grwd_ref_tsk1 = zeros(1,360);
TS_grwd_tsk1 = zeros(1,360);
PminusE_grwd_tsk1 = zeros(1,360);
load('tsk1_data.mat')
for i = 1:360
    [TS_grwd_ref_tsk1(i),PminusE_grwd_ref_tsk1(i)] = ...
        calc_global_mean(abs(TS_ref(i,:)-mean(TS_original,1))...
        ,abs(PminusE_ref(i,:)-mean(PminusE_original,1)),lat);
    [TS_grwd_tsk1(i),PminusE_grwd_tsk1(i)] = ...
        calc_global_mean(abs(TS_RL(i,:)-mean(TS_original,1))...
        ,abs(PminusE_RL(i,:)-mean(PminusE_original,1)),lat);
end

TS_grwd_ref = zeros(1,360);
PminusE_grwd_ref = zeros(1,360);
TS_grwd_tsk2 = zeros(1,360);
PminusE_grwd_tsk2 = zeros(1,360);
load('tsk2_data.mat')
for i = 1:360
    [TS_grwd_ref(i),PminusE_grwd_ref(i)] = ...
        calc_global_mean(abs(TS_ref(i,:)-mean(TS_original,1))...
        ,abs(PminusE_ref(i,:)-mean(PminusE_original,1)),lat);
    [TS_grwd_tsk2(i),PminusE_grwd_tsk2(i)] = ...
        calc_global_mean(abs(TS_RL(i,:)-mean(TS_original,1))...
        ,abs(PminusE_RL(i,:)-mean(PminusE_original,1)),lat);
end

TS_trwd_ref = zeros(1,360);
PminusE_trwd_ref = zeros(1,360);
TS_trwd_tsk3 = zeros(1,360);
PminusE_trwd_tsk3 = zeros(1,360);
load('tsk2_data3.mat')
for i = 1:360
    [TS_trwd_ref(i),PminusE_trwd_ref(i)] = ...
        calc_tropical_mean(abs(TS_ref(i,:)-mean(TS_original,1))...
        ,abs(PminusE_ref(i,:)-mean(PminusE_original,1)),lat);
    [TS_trwd_tsk3(i),PminusE_trwd_tsk3(i)] = ...
        calc_tropical_mean(abs(TS_RL(i,:)-mean(TS_original,1))...
        ,abs(PminusE_RL(i,:)-mean(PminusE_original,1)),lat);
end

load('tsk1_data.mat','MSUL_V_top');
MSUL_V_top1 = MSUL_V_top;
load('tsk2_data.mat','MSUL_V_top');
MSUL_V_top2 = MSUL_V_top;
load('tsk2_data3.mat','MSUL_V_top');
MSUL_V_top3 = MSUL_V_top;

MSUL_V_top_gmean1 = zeros(360,1);
MSUL_V_top_gmean2 = zeros(360,1);
MSUL_V_top_gmean3 = zeros(360,1);

for i = 1:360
    MSUL_V_top_gmean1(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top1(i,:)')/sum(cos(lat*pi/180));
    MSUL_V_top_gmean2(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top2(i,:)')/sum(cos(lat*pi/180));
    MSUL_V_top_gmean3(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top3(i,:)')/sum(cos(lat*pi/180));
end

load("tsk23_ctl_rwd.mat")
rwd_tsk2 = load('tsk2_rwd.mat');
rwd_tsk3 = load('tsk2_rwd3.mat');
rwd_tsk2.rwd_ref = cumsum(rwd_tsk2.rwd_ref);
rwd_tsk2.rwd_RL = cumsum(rwd_tsk2.rwd_RL);

load('RL_schematic_tsk1.mat')
rwd_tsk1.rwd_ref = StepReward_ref;
rwd_tsk1.rwd_RL = StepReward_trained;
rwd_tsk1.rwd_ref = cumsum(rwd_tsk1.rwd_ref);
rwd_tsk1.rwd_RL = cumsum(rwd_tsk1.rwd_RL);

load("tsk2_data3.mat","TS_2CO2","TS_original")
TS_2CO2 = transpose(mean(TS_2CO2,1));
TS_original = transpose(mean(TS_original,1));
dTS_2CO2 = abs(TS_2CO2 - TS_original);
[TS_trwd_2CO2,d] = calc_tropical_mean(dTS_2CO2,dTS_2CO2,lat);
rwd_tsk3.rwd_ref = -cumsum(TS_trwd_ref/TS_trwd_2CO2);
rwd_tsk3.rwd_RL = -cumsum(TS_trwd_tsk3/TS_trwd_2CO2);
combined_trwd_ctl = -cumsum(TS_rwd_ctl_tropics/TS_trwd_2CO2);

% tmp = sort(TS_rwd_ctl);
% TS_rwd_ctl = tmp(342);
% tmp = sort(TS_rwd_ctl_tropics);
% TS_rwd_ctl_tropics = tmp(342);
% tmp = sort(PminusE_rwd_ctl);
% PminusE_rwd_ctl = tmp(342);
% tmp = sort(combined_rwd_ctl);
% combined_rwd_ctl = tmp(18);
TS_rwd_ctl = mean(TS_rwd_ctl);
TS_rwd_ctl_tropics = mean(TS_rwd_ctl_tropics);
PminusE_rwd_ctl = mean(PminusE_rwd_ctl);
% combined_rwd_ctl = mean(combined_rwd_ctl);
combined_rwd_ctl = cumsum(combined_rwd_ctl);

figure(2)
set(gcf,'position',[0 0 1000 800])
tiledlayout(2,2,'TileSpacing', 'compact','Padding','compact');

%subplot(2,2,1)
nexttile
plot(1:360,ones(1,360)*3e-05,'--k','LineWidth',1)
hold on
plot(1:360,MSUL_V_top_gmean1,'Color',c1,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,MSUL_V_top_gmean2,'Color',c2,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,MSUL_V_top_gmean3,'Color',c3,'LineStyle','-','LineWidth',2)
%grid on
legend('constant SG','Stabilize CC, RL','Revert CC, RL',...
    'Revert tropical CC, RL')
ylabel('kg/m^2')
xlim([0,360])
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',18,'box','off')
title('(a) aerosol mass','Interpreter','latex', FontSize=20)

%subplot(2,2,2)
nexttile
plot(1:360,rwd_tsk1.rwd_ref,'Color',c1,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,rwd_tsk1.rwd_RL,'Color',c1,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,rwd_tsk2.rwd_ref,'Color',c2,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,rwd_tsk2.rwd_RL,'Color',c2,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,rwd_tsk3.rwd_ref,'Color',c3,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,rwd_tsk3.rwd_RL,'Color',c3,'LineStyle','-','LineWidth',2)
hold on
patch([1:360 fliplr(1:360)], [zeros(1,360) fliplr(combined_rwd_ctl)],...
    'k','FaceAlpha',0.1,'edgealpha',0.1)
hold on
patch([1:360 fliplr(1:360)], [zeros(1,360) fliplr(combined_trwd_ctl)],...
    'k','FaceAlpha',0.15,'edgealpha',0.15)
text(255,-90,'20% improve','FontSize',18,'Color',c1)
text(255,-135,'23% improve','FontSize',18,'Color',c2)
text(255,-50,'47% improve','FontSize',18,'Color',c3)
legend('Stabilize CC, constant SG','Stabilize CC, RL','Revert CC, constant SG',...
    'Revert CC, RL','Revert tropical CC, constant SG','Revert tropical CC, RL',Location='southwest')
%grid on
xlim([0,360])
% ylim([-1.2,0])
ylabel('R')
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',18,'box','off')
title('(b) cumulative reward $R$',...
    'Interpreter','latex',FontSize=20)

%subplot(2,2,3)
nexttile
plot(1:360,TS_grwd_ref_tsk1,'Color',c1,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,TS_grwd_tsk1,'Color',c1,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,TS_grwd_ref,'Color',c2,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,TS_grwd_tsk2,'Color',c2,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,TS_trwd_ref,'Color',c3,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,TS_trwd_tsk3,'Color',c3,'LineStyle','-','LineWidth',2)
hold on
patch([1:360 fliplr(1:360)], [zeros(1,360) ones(1,360)*TS_rwd_ctl],...
    'k','FaceAlpha',0.1,'edgealpha',0.1)
hold on
patch([1:360 fliplr(1:360)], [zeros(1,360) ones(1,360)*TS_rwd_ctl_tropics],...
    'k','FaceAlpha',0.15,'edgealpha',0.15)
legend('Stabilize CC, constant SG','Stabilize CC, RL','Revert CC, constant SG',...
    'Revert CC, RL','Revert tropical CC, constant SG','Revert tropical CC, RL',...
    Location='northeast')
%grid on
%xlabel('month')
ylabel('K')
xlabel('month')
xlim([0,360])
ylim([0,1.7])
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',18,'box','off')
title('(c) $\langle |\Delta \overline{T(t,\phi)}| \rangle$',...
    'Interpreter','latex',FontSize=20)

%subplot(2,2,4)
nexttile
plot(1:360,PminusE_grwd_ref_tsk1,'Color',c1,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,PminusE_grwd_tsk1,'Color',c1,'LineStyle','-','LineWidth',2)
hold on
plot(1:360,PminusE_grwd_ref,'Color',c2,'LineStyle','--','LineWidth',2)
hold on
plot(1:360,PminusE_grwd_tsk2,'Color',c2,'LineStyle','-','LineWidth',2)
hold on
patch([1:360 fliplr(1:360)], [zeros(1,360) ones(1,360)*PminusE_rwd_ctl],...
    'k','FaceAlpha',0.1,'edgealpha',0.1)
legend('Stabilize CC, constant SG','Stabilize CC, RL','Revert CC, constant SG',...
    'Revert CC, RL',Location='northeast')
%grid on
%xlabel('month')
ylabel('mm/yr')
xlabel('month')
set(gca,'Ytick',0:0.01:0.05)
yticklabels(0:10:50)
xlim([0,360])
ylim([0,0.05])
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',18,'box','off')
title(['(d) $\langle |\Delta \overline{P(t,\phi)} - ' ...
    '\Delta \overline{E(t,\phi)}| \rangle$'],...
    'Interpreter','latex',FontSize=20)

function [xnew,ynew] = calc_global_mean(x,y,lat)
xnew = dot(cos(lat*pi/180),x)/sum(cos(lat*pi/180));
ynew = dot(cos(lat*pi/180),y)/sum(cos(lat*pi/180));
end

function [xnew,ynew] = calc_tropical_mean(x,y,lat)
xnew = dot(cos(lat(11:22)*pi/180),x(11:22))/sum(cos(lat(11:22)*pi/180));
ynew = dot(cos(lat(11:22)*pi/180),y(11:22))/sum(cos(lat(11:22)*pi/180));
end