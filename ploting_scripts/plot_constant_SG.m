clear,clc,close all

c1 = [180 213 255]/256;
c6 = [140 190 255]/256;
c7 = [100 170 255]/256;
c2 = [74 155 255]/256;
c4 = [44 94 255]/256;
c3 = [44 94 156]/256;

load("constant_SG.mat")
load("constant_SG2.mat")
load("constant_SG3.mat")
load("basic.mat","lat")
load('tsk23_ctl_rwd.mat','combined_rwd_ctl')

TS_control = squeeze(mean(TS_control,1));
TS_2xCO2 = [TS_control,squeeze(mean(TS_2xCO2,1))];
TS_SRM = [TS_control,squeeze(mean(TS_SRM,1))];
TS_SRM2 = [TS_control,squeeze(mean(TS_SRM2,1))];
TS_SRM3 = [TS_control,squeeze(mean(TS_SRM3,1))];
TS_SRM4 = [TS_control,squeeze(mean(TS_SRM4,1))];
TS_SRM5 = [TS_control,squeeze(mean(TS_SRM5,1))];
TS_SRM6 = [TS_control,squeeze(mean(TS_SRM6,1))];
TS_SRM7 = [TS_control,squeeze(mean(TS_SRM7,1))];

PminusE_control = squeeze(mean(PminusE_control,1));
PminusE_2xCO2 = [PminusE_control,squeeze(mean(PminusE_2xCO2,1))];
PminusE_SRM = [PminusE_control,squeeze(mean(PminusE_SRM,1))];
PminusE_SRM2 = [PminusE_control,squeeze(mean(PminusE_SRM2,1))];
PminusE_SRM3 = [PminusE_control,squeeze(mean(PminusE_SRM3,1))];
PminusE_SRM4 = [PminusE_control,squeeze(mean(PminusE_SRM4,1))];
PminusE_SRM5 = [PminusE_control,squeeze(mean(PminusE_SRM5,1))];
PminusE_SRM6 = [PminusE_control,squeeze(mean(PminusE_SRM6,1))];
PminusE_SRM7 = [PminusE_control,squeeze(mean(PminusE_SRM7,1))];

dTS_2xCO2_ref = mean(TS_2xCO2(:,361:420) - TS_control,2);
dPminusE_2xCO2_ref = mean(PminusE_2xCO2(:,361:420) - PminusE_control,2);
[r1_ref,r2_ref] = ...
    calc_global_mean(abs(dTS_2xCO2_ref),abs(dPminusE_2xCO2_ref),lat);


r_2xCO2 = zeros(1,361);
r_SRM = zeros(1,361);
r_SRM2 = zeros(1,361);
r_SRM3 = zeros(1,361);
r_SRM4 = zeros(1,361);
r_SRM5 = zeros(1,361);
r_SRM6 = zeros(1,361);
r_SRM7 = zeros(1,361);

for i = 1:361
    d1 = mean(TS_2xCO2(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_2xCO2(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_2xCO2(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM2(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM2(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM2(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM3(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM3(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM3(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM4(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM4(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM4(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM5(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM5(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM5(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM6(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM6(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM6(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);

    d1 = mean(TS_SRM7(:,i:(i+59)) - TS_control,2);
    d2 = mean(PminusE_SRM7(:,i:(i+59)) - PminusE_control,2);
    [r1,r2] = calc_global_mean(abs(d1),abs(d2),lat);
    r_SRM7(i) = - sqrt((r1/r1_ref)^2+(r2/r2_ref)^2);
end

R_2xCO2 = cumsum(r_2xCO2);
R_SRM = cumsum(r_SRM); %30
R_SRM2 = cumsum(r_SRM2); %20
R_SRM3 = cumsum(r_SRM3); %40
R_SRM4 = cumsum(r_SRM4); %35
R_SRM5 = cumsum(r_SRM5); %25
R_SRM6 = cumsum(r_SRM6); %28
R_SRM7 = cumsum(r_SRM7); %29
R_ctl = cumsum(combined_rwd_ctl);


figure()
lh = plot(0:360,R_SRM2,'-',LineWidth = 2,Color = c1);
%lh.Color(4) = 0.2;
hold on
lh = plot(0:360,R_SRM6,'-',LineWidth = 2,Color = c6);
%lh.Color(4) = 1;
hold on
lh = plot(0:360,R_SRM7,'-',LineWidth = 2,Color = c7);
%lh.Color(4) = 1;
hold on
lh = plot(0:360,R_SRM,'-',LineWidth = 2,Color = c2);
%lh.Color(4) = 0.6;
hold on
lh = plot(0:360,R_SRM4,'-',LineWidth = 2,Color = c4);
%lh.Color(4) = 1;
hold on
lh = plot(0:360,R_SRM3,'-',LineWidth = 2,Color = c3);
%lh.Color(4) = 1;
hold on


plot(0:360,R_2xCO2,'-r',LineWidth = 2)
hold on
% patch([1:360 fliplr(1:360)], [zeros(1,360) fliplr(R_ctl)],...
%     'k','FaceAlpha',0.1,'edgealpha',0.1)
legend( ...
    '$2.0 \times 10^{-5} kg/m^2, R(30yr)=-144$',...
    '$2.8 \times 10^{-5} kg/m^2, R(30yr)=-114$',...
    '$2.9 \times 10^{-5} kg/m^2, R(30yr)=-113$',...
    '$3.0 \times 10^{-5} kg/m^2, R(30yr)=-114$',...
    '$3.1 \times 10^{-5} kg/m^2, R(30yr)=-117$',...
    '$4.0 \times 10^{-5} kg/m^2, R(30yr)=-222$',...
    '2xCO2, no SG, $R(30yr)=-437$',Location='southwest',Interpreter='latex')
xlabel('month')
xlim([0,360])
% ylim([-1.2,0])
set(gca,'Xtick',0:60:360)
set(gca,'FontSize',18,'box','off')
title('cumulative reward $R$',...
    'Interpreter','latex',FontSize=20)

function [xnew,ynew] = calc_global_mean(x,y,lat)
xnew = dot(cos(lat*pi/180),x)/sum(cos(lat*pi/180));
ynew = dot(cos(lat*pi/180),y)/sum(cos(lat*pi/180));
end