clear,clc,close all

load("tsk23_EpisodeReward.mat")


%c1 = [0.9290 0.6940 0.1250];
c1 = [1 0.5 1];

figure()
set(gcf,'position',[100 100 1000 400])

subplot(1,2,1)
plot(EpisodeReward_tsk2(1:33),'-k',LineWidth=2)
hold on
plot(-180*ones(33,1),'--k',LineWidth=2)
xlabel('episode')
ylabel('R')
ylim([-510,-100])
plot(28,EpisodeReward_tsk2(28),Marker='o',Color='b',MarkerSize=10,LineWidth=1)
text(28,EpisodeReward_tsk2(28)+15,'trained','FontSize',18,Color='b')
plot(1,EpisodeReward_tsk2(1),Marker='o',Color=c1,MarkerSize=10,LineWidth=1)
text(2,EpisodeReward_tsk2(1)+15,'untrained','FontSize',18,Color=c1)
legend('RL','constant SG',Location='east')
set(gca,'FontSize',18,'box','off')
title('(a) Revert CC, RL training',FontSize=24)
% -180 to -139

subplot(1,2,2)
plot(EpisodeReward_tsk3(1:18),'-k',LineWidth=2)
hold on
plot(-162*ones(18,1),'--k',LineWidth=2)
xlabel('episode')
ylabel('R')
ylim([-210,-80])
plot(16,EpisodeReward_tsk3(16),Marker='o',Color='b',MarkerSize=10,LineWidth=1)
text(16,EpisodeReward_tsk3(16)+5,'trained','FontSize',18,Color='b')
plot(1,EpisodeReward_tsk3(1),Marker='o',Color=c1,MarkerSize=10,LineWidth=1)
text(1,EpisodeReward_tsk3(1)+5,'untrained','FontSize',18,Color=c1)
legend('RL','constant SG',Location='east')
set(gca,'FontSize',18,'box','off')
title('(b) Revert tropical CC, RL training',FontSize=24)
% -162 to -92
