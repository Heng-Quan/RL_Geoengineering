clear,clc,close all

load('RL_schematic_tsk1.mat')
CumulativeReward_ref = zeros(1,360);
CumulativeReward_init = zeros(1,360);
CumulativeReward_trained = zeros(1,360);
for i = 1:360
    CumulativeReward_ref(i) = sum(StepReward_ref(1:i));
    CumulativeReward_init(i) = sum(StepReward_init(1:i));
    CumulativeReward_trained(i) = sum(StepReward_trained(1:i));
end

%c1 = [0.9290 0.6940 0.1250];
c1 = [1 0.5 1];

% for i = 1:70
%     if EpisodeReward(i) < -150
%         EpisodeReward(i) = -150 + (EpisodeReward(i)+150)/10;
%     end
% end
% 
% for i = 1:360
%     if CumulativeReward_init(i) < -125
%         CumulativeReward_init(i) = -125 + (CumulativeReward_init(i)+125)/11;
%     end
% end

figure()
set(gcf,'position',[100 100 1000 400])

subplot(1,2,1)
plot(EpisodeReward(1:36),'-k',LineWidth=2)
hold on
plot(sum(StepReward_ref)*ones(36,1),'--k',LineWidth=2)
xlabel('episode')
ylabel('Reward R')
ylim([-400,-90])
plot(34,EpisodeReward(34),Marker='o',Color='b',MarkerSize=10,LineWidth=1)
text(34,EpisodeReward(34)+5,'trained','FontSize',18,Color='b')
plot(1,EpisodeReward(1),Marker='o',Color=c1,MarkerSize=10,LineWidth=1)
text(2,EpisodeReward(1)+2,'untrained','FontSize',18,Color=c1)
legend('RL','constant SG',Location='southeast')
set(gca,'YTick',[-400,-375,-150,-125,-100])
% yticklabels([-400,-150,-125,-100])
set(gca,'FontSize',18,'box','off')
title('(b) Prevent CC, RL training',FontSize=24)
breakyaxis([-370 -155]);
%title('(b) $\Delta(P-E)$ in year 30','Interpreter','latex')

subplot(1,2,2)
plot(CumulativeReward_init,'Color',c1,LineWidth=2)
hold on
plot(CumulativeReward_trained,'-b',LineWidth=2)
hold on
plot(CumulativeReward_ref,'--k',LineWidth=2)
xlabel('month')
ylabel('Reward R')
xlim([0,360])
ylim([-400,0])
xticks(0:60:360)
legend('RL untrained','RL trained',...
    'constant SG',Location='southwest')
set(gca,'YTick',[-400,-375,-125:25:0])
% yticklabels([-400,-125:25:0])
set(gca,'FontSize',18,'box','off')
title('(c) Prevent CC, RL evaluation',FontSize=24)
breakyaxis([-370 -130]);

