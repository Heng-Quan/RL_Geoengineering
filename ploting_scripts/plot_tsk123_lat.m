clear,clc,close all

load('basic.mat','lat')
load("ctl_std.mat")

load('tsk1_data.mat')
TS_ref_tsk1 = TS_ref;
TS_RL_tsk1 = TS_RL;
PminusE_ref_tsk1 = PminusE_ref;
PminusE_RL_tsk1 = PminusE_RL;
MSUL_V_top_tsk1 = MSUL_V_top;

load('tsk2_data.mat')
TS_ref_tsk2 = TS_ref;
TS_RL_tsk2 = TS_RL;
PminusE_ref_tsk2 = PminusE_ref;
PminusE_RL_tsk2 = PminusE_RL;
MSUL_V_top_tsk2 = MSUL_V_top;

load('tsk2_data3.mat','TS_RL','PminusE_RL','MSUL_V_top')
TS_ref_tsk3 = TS_ref;
TS_RL_tsk3 = TS_RL;
PminusE_ref_tsk3 = PminusE_ref;
PminusE_RL_tsk3 = PminusE_RL;
MSUL_V_top_tsk3 = MSUL_V_top;

%dTS_2CO2 = 0.5 + (mean(TS_2CO2 - TS_original,1)'-0.5)/5;
%dTS_ref_tsk1 = 0.5 + (mean(TS_2CO2 - TS_original,1)'-0.5)/5;
dTS_2CO2 = rescale(mean(TS_2CO2 - TS_original,1)');
dTS_ref_tsk1 = rescale(TS_ref_tsk1(end,:)' - mean(TS_original,1)');
dTS_ref_tsk2 = rescale(TS_ref_tsk2(end,:)' - mean(TS_original,1)');
dTS_ref_tsk3 = rescale(TS_ref_tsk3(end,:)' - mean(TS_original,1)');
dTS_RL_tsk1 = rescale(TS_RL_tsk1(end,:)' - mean(TS_original,1)');
dTS_RL_tsk2 = rescale(TS_RL_tsk2(end,:)' - mean(TS_original,1)');
dTS_RL_tsk3 = rescale(TS_RL_tsk3(end,:)' - mean(TS_original,1)');


figure()
set(gcf,'position',[100 50 1500 800])
tiledlayout(3,3,'TileSpacing', 'compact');

%subplot(3,3,1)
nexttile
plot(sin(lat*pi/180),dTS_2CO2,'-r','LineWidth',2)
hold on
plot(sin(lat*pi/180),dTS_ref_tsk1,'--k','LineWidth',2)
hold on
plot(sin(lat*pi/180),dTS_RL_tsk1,'-b','LineWidth',2)
hold on
plot(sin(lat*pi/180),zeros(32,1),'-k','LineWidth',0.5)
hold on
patch([sin(lat*pi/180)' fliplr(sin(lat*pi/180)')], [-TS_ctl_std fliplr(TS_ctl_std)],...
    'k','FaceAlpha',0.1)
ylabel('$\Delta \overline{T}$ (K)','Interpreter','latex')
%legend('2xCO2','constant SG','RL trained')
%ylim([-1,6.5])
set(gca,'YTick',-0.5:0.5:1.5,'XTick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
yticklabels([-0.5,0,0.5,2.5,5.5])
xlim([-1,1])
set(gca,'FontSize',18)
title('(a) Task 1',fontsize=20)

%subplot(3,3,2)
nexttile
plot(sin(lat*pi/180),dTS_2CO2,'-r','LineWidth',2)
hold on
plot(sin(lat*pi/180),dTS_ref_tsk2,'--k','LineWidth',2)
hold on
plot(sin(lat*pi/180),dTS_RL_tsk2,'-b','LineWidth',2)
hold on
plot(sin(lat*pi/180),zeros(32,1),'-k','LineWidth',0.5)
hold on
patch([sin(lat*pi/180)' fliplr(sin(lat*pi/180)')], [-TS_ctl_std fliplr(TS_ctl_std)],...
    'k','FaceAlpha',0.1)
%ylabel('$K$','Interpreter','latex')
%legend('2xCO2','constant SG','RL trained')
%ylim([-1,6.5])
set(gca,'YTick',-0.5:0.5:1.5,'XTick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
yticklabels([-0.5,0,0.5,2.5,5.5])
xlim([-1,1])
set(gca,'FontSize',18)
title('(b) Task 2',fontsize=20)

%subplot(3,3,3)
nexttile
plot(sin(lat(11:22)*pi/180),dTS_2CO2(11:22),'-r','LineWidth',2)
hold on
plot(sin(lat(11:22)*pi/180),dTS_ref_tsk3(11:22),'--k','LineWidth',2)
hold on
plot(sin(lat(11:22)*pi/180),dTS_RL_tsk3(11:22),'-b','LineWidth',2)
hold on
plot(sin(lat(11:22)*pi/180),zeros(12,1),'-k','LineWidth',0.5)
hold on
lh = plot(sin(lat(1:11)*pi/180),dTS_2CO2(1:11),'-r','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(1:11)*pi/180),dTS_ref_tsk3(1:11),'--k','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(1:11)*pi/180),dTS_RL_tsk3(1:11),'-b','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(1:11)*pi/180),zeros(11,1),'-k','LineWidth',0.5);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),dTS_2CO2(22:32),'-r','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),dTS_ref_tsk3(22:32),'--k','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),dTS_RL_tsk3(22:32),'-b','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),zeros(11,1),'-k','LineWidth',0.5);
lh.Color(4) = 0.3;
hold on
% plot([-0.5,-0.5],[-0.8,1.5],'--g','LineWidth',1)
% hold on
% plot([0.5,0.5],[-0.8,1.5],'--g','LineWidth',1)
% hold on
patch([sin(lat*pi/180)' fliplr(sin(lat*pi/180)')], [-TS_ctl_std fliplr(TS_ctl_std)],...
    'k','FaceAlpha',0.1)
%ylabel('$K$','Interpreter','latex')
%ylim([-1,6.5])
set(gca,'YTick',-0.5:0.5:1.5,'XTick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
yticklabels([-0.5,0,0.5,2.5,5.5])
xlim([-1,1])
set(gca,'FontSize',18)
title('(c) Task 3',fontsize=20)
legend('2xCO2','constant SG','RL',fontsize=20)

%subplot(3,3,4)
nexttile
plot(sin(lat*pi/180),mean(PminusE_2CO2 - PminusE_original,1)','-r','LineWidth',2)
hold on
plot(sin(lat*pi/180),PminusE_ref_tsk1(end,:)' - ...
    mean(PminusE_original,1)','--k','LineWidth',2)
hold on
plot(sin(lat*pi/180),PminusE_RL_tsk1(end,:)' - ...
    mean(PminusE_original,1)','-b','LineWidth',2)
hold on
plot(sin(lat*pi/180),zeros(32,1),'-k','LineWidth',0.5)
hold on
patch([sin(lat*pi/180)' fliplr(sin(lat*pi/180)')], [-PminusE_ctl_std fliplr(PminusE_ctl_std)],...
    'k','FaceAlpha',0.1)
ylabel('$\Delta \overline{P} - \Delta \overline{E}$ (m/yr)',...
    'Interpreter','latex')
%legend('2xCO2','constant SG','RL trained')
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([-0.1,0.1])
set(gca,'FontSize',18)
title('(d)',fontsize=20)

%subplot(3,3,5)
nexttile
plot(sin(lat*pi/180),mean(PminusE_2CO2 - PminusE_original,1)','-r','LineWidth',2)
hold on
plot(sin(lat*pi/180),PminusE_ref_tsk2(end,:)' - ...
    mean(PminusE_original,1)','--k','LineWidth',2)
hold on
plot(sin(lat*pi/180),PminusE_RL_tsk2(end,:)' - ...
    mean(PminusE_original,1)','-b','LineWidth',2)
hold on
plot(sin(lat*pi/180),zeros(32,1),'-k','LineWidth',0.5)
hold on
patch([sin(lat*pi/180)' fliplr(sin(lat*pi/180)')], [-PminusE_ctl_std fliplr(PminusE_ctl_std)],...
    'k','FaceAlpha',0.1)
%ylabel('$m/yr$','Interpreter','latex')
%legend('2xCO2','constant SG','RL trained')
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([-0.1,0.1])
set(gca,'FontSize',18)
title('(e)',fontsize=20)

nexttile
axis off

c1 = [154 195 182]/256;
c2 = [96 143 159]/256;

%subplot(3,3,7)
nexttile
plot(sin(lat*pi/180),3e-05*ones(32,1),'--k','LineWidth',2)
hold on
plot(sin(lat*pi/180),MSUL_V_top_tsk1(1,:)','-b','LineWidth',2)
hold on
plot(sin(lat*pi/180),MSUL_V_top_tsk1(end,:)','Color',c1,'LineWidth',2)
%legend('constant SG','RL trained 0yr','RL trained 30yr')
xlabel('latitude')
ylabel('aerosol mass (kg/m^2)')
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([2.4e-05,3.6e-05])
set(gca,'Ytick',[2.5,3,3.5]*1e-05)
set(gca,'FontSize',18)
title('(f)',fontsize=20)

%subplot(3,3,8)
nexttile
plot(sin(lat*pi/180),3e-05*ones(32,1),'--k','LineWidth',2)
hold on
plot(sin(lat*pi/180),MSUL_V_top_tsk2(1,:)','-b','LineWidth',2)
hold on
plot(sin(lat*pi/180),MSUL_V_top_tsk2(end,:)','Color',c1,'LineWidth',2)
%legend('constant SG','RL trained 0yr','RL trained 30yr')
xlabel('latitude')
%ylabel('$kgm^{-2}$','Interpreter','latex')
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([1e-05,5e-05])
set(gca,'Ytick',[1,2,3,4,5]*1e-05)
set(gca,'FontSize',18)
title('(g)',fontsize=20)

%subplot(3,3,9)
nexttile
plot(sin(lat(11:22)*pi/180),3e-05*ones(12,1),'--k','LineWidth',2)
hold on
plot(sin(lat(11:22)*pi/180),MSUL_V_top_tsk3(1,(11:22))','-b','LineWidth',2)
hold on
plot(sin(lat(11:22)*pi/180),MSUL_V_top_tsk3(end,(11:22))','Color',c1,'LineWidth',2)
hold on
lh = plot(sin(lat(1:11)*pi/180),3e-05*ones(11,1),'--k','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(1:11)*pi/180),MSUL_V_top_tsk3(1,(1:11))','-b','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(1:11)*pi/180),MSUL_V_top_tsk3(end,(1:11))','Color',c1,'LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),3e-05*ones(11,1),'--k','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),MSUL_V_top_tsk3(1,(22:32))','-b','LineWidth',2);
lh.Color(4) = 0.3;
hold on
lh = plot(sin(lat(22:32)*pi/180),MSUL_V_top_tsk3(end,(22:32))','Color',c1,'LineWidth',2);
lh.Color(4) = 0.3;
hold on
%plot([-0.5,-0.5],[1e-05,5e-05],'--g','LineWidth',1)
%plot([0.5,0.5],[1e-05,5e-05],'--g','LineWidth',1)
xlabel('latitude')
%ylabel('$kgm^{-2}$','Interpreter','latex')
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([1e-05,5e-05])
set(gca,'Ytick',[1,2,3,4,5]*1e-05)
set(gca,'FontSize',18)
legend('constant SG','RL 0yr','RL 30yr',fontsize=20)
title('(h)',fontsize=20)

function x_rescale = rescale(x)
x_rescale = x;
for i = 1:length(x)
    if x(i)>0.5
        x_rescale(i) = 0.5 + (x(i)-0.5)/5;
    end
end
end
        