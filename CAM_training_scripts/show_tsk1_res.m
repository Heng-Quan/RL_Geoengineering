clear,clc,close all

load('/gpfs/share/home/1800011374/SRM30_tsk1_low_res1/EpisodeData','env')
env_ref = env;

load('EpisodeData','EpisodeReward','env')
load('basic.mat')
EpisodeNum = 75;

figure(1)
plot(-123*ones(1,EpisodeNum),'-k','LineWidth',1)
hold on
plot(EpisodeReward(1:EpisodeNum),'-b','LineWidth',1)
legend('constant','RL')
xlabel('EpisodeNumber')
ylabel('EpisodeReward')
set(gca,'FontSize',15)

figure(2)
set(gcf,'outerposition',get(0,'screensize'));
plot(lat,3e-05*ones(32,1),'-k','LineWidth',1)
hold on
plot(lat,squeeze(env.MSUL_V_top_record(EpisodeNum,1,:)),'-b','LineWidth',1)
hold on
plot(lat,squeeze(env.MSUL_V_top_record(EpisodeNum,end,:)),'--b','LineWidth',1)
legend('constant','RL 0yr','RL 30yr')
xlabel('latitude')
ylabel('kg m^-2')
title('TOA aerosol mass')
set(gca,'Xtick',-90:30:90)
set(gca,'FontSize',15)

figure(3)
set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,1)
plot(lat,mean(env.TS_2CO2 - env.TS_original,1)','-r','LineWidth',1)
hold on
plot(lat,squeeze(env_ref.TS_smooth_record(1,end,:)) - ...
    mean(env.TS_original,1)','-k','LineWidth',1)
hold on
plot(lat,squeeze(env.TS_smooth_record(EpisodeNum,end,:)) - ...
    mean(env.TS_original,1)','-b','LineWidth',1)
hold on
plot(lat,zeros(32,1),'--k','LineWidth',1)
legend('2CO2 only','2CO2 + constant SRM','2CO2 + RL')
xlabel('latitude')
ylabel('K')
title('ΔTS in yr30')
set(gca,'Xtick',-90:30:90)
set(gca,'FontSize',15)

subplot(2,1,2)
plot(lat,mean(env.PminusE_2CO2 - env.PminusE_original,1)','-r','LineWidth',1)
hold on
plot(lat,squeeze(env_ref.PminusE_smooth_record(1,end,:))- ...
    mean(env.PminusE_original,1)','-k','LineWidth',1)
hold on
plot(lat,squeeze(env.PminusE_smooth_record(EpisodeNum,end,:)) - ...
    mean(env.PminusE_original,1)','-b','LineWidth',1)
hold on
plot(lat,zeros(32,1),'--k','LineWidth',1)
legend('2CO2 only','2CO2 + constant SRM','2CO2 + RL')
xlabel('latitude')
ylabel('m/yr')
title('ΔPminusE in yr30')
set(gca,'Xtick',-90:30:90)
set(gca,'FontSize',15)