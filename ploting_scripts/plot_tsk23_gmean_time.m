clear,clc,close all

load('basic.mat','lat')

load('tsk2_data.mat','TS_original','PminusE_original')

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

load('tsk2_data.mat','MSUL_V_top');
MSUL_V_top2 = MSUL_V_top;
load('tsk2_data3.mat','MSUL_V_top');
MSUL_V_top3 = MSUL_V_top;

MSUL_V_top_gmean2 = zeros(360,1);
MSUL_V_top_gmean3 = zeros(360,1);

for i = 1:360
    MSUL_V_top_gmean2(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top2(i,:)')/sum(cos(lat*pi/180));
    MSUL_V_top_gmean3(i) = ...
        dot(cos(lat*pi/180),MSUL_V_top3(i,:)')/sum(cos(lat*pi/180));
end

load("tsk23_ctl_rwd.mat")
rwd_tsk2 = load('tsk2_rwd.mat');
rwd_tsk3 = load('tsk2_rwd3.mat');

figure(2)
set(gcf,'position',[0 0 1300 800])

subplot(2,3,1)
plot(1:360,TS_grwd_ref,'-k','LineWidth',1)
hold on
plot(1:360,TS_grwd_tsk2,'-b','LineWidth',1)
hold on
plot(1:360,TS_rwd_ctl,'-r','LineWidth',1)
legend('constant SG','RL trained','control run')
grid on
xlabel('month')
ylabel('$K$','Interpreter','latex')
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',15)
title('(a) task 2 global mean $|\Delta TS|$',...
    'Interpreter','latex',FontSize=20)

subplot(2,3,2)
plot(1:360,PminusE_grwd_ref,'-k','LineWidth',1)
hold on
plot(1:360,PminusE_grwd_tsk2,'-b','LineWidth',1)
hold on
plot(1:360,PminusE_rwd_ctl,'-r','LineWidth',1)
legend('constant SG','RL trained','control run')
grid on
xlabel('month')
ylabel('$m/yr$','Interpreter','latex')
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',15)
title('(b) task 2 global mean $|\Delta (P-E)|$',...
    'Interpreter','latex',FontSize=20)

subplot(2,3,3)
plot(1:360,rwd_tsk2.rwd_ref,'-k','LineWidth',1)
hold on
plot(1:360,rwd_tsk2.rwd_RL,'-b','LineWidth',1)
hold on
plot(1:360,combined_rwd_ctl,'-r','LineWidth',1)
grid on
legend('constant SG','RL trained','control run',Location='southeast')
xlabel('month')
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',15)
title('(c) task 2 combined reward',...
    'Interpreter','latex',FontSize=20)

subplot(2,3,4)
plot(1:360,TS_trwd_ref,'-k','LineWidth',1)
hold on
plot(1:360,TS_trwd_tsk3,'-b','LineWidth',1)
hold on
plot(1:360,TS_rwd_ctl_tropics,'-r','LineWidth',1)
legend('constant SG','RL trained','control run')
grid on
xlabel('month')
ylabel('$K$','Interpreter','latex')
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',15)
title('(d) task 3 tropical mean $|\Delta TS|$',...
    'Interpreter','latex',FontSize=20)

subplot(2,3,5)
plot(1:360,ones(1,360)*3e-05,'-k','LineWidth',1)
hold on
plot(1:360,MSUL_V_top_gmean2,'-b','LineWidth',1)
hold on
plot(1:360,MSUL_V_top_gmean3,'-r','LineWidth',1)
grid on
legend('constant SG','RL trained, task 2','RL trained, task 3')
xlabel('month')
ylabel('$kgm^{-2}$','Interpreter','latex')
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',15)
title('(e) global mean $MSUL$',...
    'Interpreter','latex',FontSize=20)

function [xnew,ynew] = calc_global_mean(x,y,lat)
xnew = dot(cos(lat*pi/180),x)/sum(cos(lat*pi/180));
ynew = dot(cos(lat*pi/180),y)/sum(cos(lat*pi/180));
end

function [xnew,ynew] = calc_tropical_mean(x,y,lat)
xnew = dot(cos(lat(11:22)*pi/180),x(11:22))/sum(cos(lat(11:22)*pi/180));
ynew = dot(cos(lat(11:22)*pi/180),y(11:22))/sum(cos(lat(11:22)*pi/180));
end


