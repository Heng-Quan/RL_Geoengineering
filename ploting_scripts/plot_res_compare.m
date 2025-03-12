clear,clc,close all


load("basic.mat",'lat')
load("tsk1_high_res_data.mat")
StepReward_high_res = StepReward;
MSUL_V_top_high_res = MSUL_V_top;

load("RL_schematic_tsk1.mat")
load("tsk1_data.mat","MSUL_V_top")

cumulative_rwd = cumsum(StepReward_trained);
cumulative_rwd_ref = cumsum(StepReward_ref);
cumulative_rwd_high_res = cumsum(StepReward_high_res);

MSUL_V_top_gmean = zeros(360,1);
MSUL_V_top_gmean_high_res = zeros(360,1);

for i = 1:360
    MSUL_V_top_gmean(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top(i,:)')/sum(cos(lat*pi/180));
    MSUL_V_top_gmean_high_res(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top_high_res(i,:)')/sum(cos(lat*pi/180));
end

figure
set(gcf,'position',[100 50 1500 500])
tiledlayout(1,3,'TileSpacing', 'compact');

nexttile
plot(1:360,cumulative_rwd,'-b',LineWidth=2)
hold on
plot(1:360,cumulative_rwd_high_res,'-r',LineWidth=2)
hold on
plot(1:360,cumulative_rwd_ref,'--k',LineWidth=2)
xlabel('month')
ylabel('R')
xlim([0,360])
xticks(0:60:360)
legend('RL low resolution','RL high resolution','constant SG')
set(gca,'FontSize',15,'box','off')
title('(a) Prevent CC, RL evaluation',FontSize=20)


nexttile
plot(1:360,MSUL_V_top_gmean,'-b',LineWidth=2)
hold on
plot(1:360,MSUL_V_top_gmean_high_res,'-r',LineWidth=2)
hold on
plot(1:360,ones(1,360)*3e-05,'--k','LineWidth',2)
legend('RL low resolution','RL high resolution','constant SG')
xlabel('month')
ylabel('kg/m^2')
xlim([0,360])
ylim([2.4e-05,3.6e-05])
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',15,'box','off')
title('(b) Aerosol mass (global mean)', FontSize=20)

nexttile
plot(sin(lat*pi/180),MSUL_V_top(1,:),'-bo',LineWidth=2)
hold on
plot(sin(lat*pi/180),MSUL_V_top_high_res(1,:),'-ro',LineWidth=2)
hold on
plot(sin(lat*pi/180),ones(1,32)*3e-05,'--k','LineWidth',2)
xlabel('latitude')
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([2.4e-05,3.6e-05])
legend('RL low resolution','RL high resolution','constant SG')
set(gca,'FontSize',15)
title('(c) Aerosol mass (0yr)', FontSize=20)