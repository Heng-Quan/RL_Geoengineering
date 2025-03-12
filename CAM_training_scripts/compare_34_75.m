clear,clc,close all

load('basic.mat')
pathctrl = '/gpfs/share/home/1800011374/CAM3_SOM_low_res/output_dir/control_run.cam2.h0.00';
pathref = '/gpfs/share/home/1800011374/CAM3_SOM_low_res/output_dir/SRM_run.cam2.h0.00';
path34 = '/gpfs/share/home/1800011374/SRM_RL_CAM_low_res5/SRM_RL_run.cam2.h0.00';
path75 = '/gpfs/share/home/1800011374/SRM_RL_CAM_low_res6/SRM_RL_run.cam2.h0.00';

RELHUM_ctrl = zeros(64,32,60);
RELHUM_ref = zeros(64,32,60);
RELHUM_34 = zeros(64,32,60);
RELHUM_75 = zeros(64,32,60);
CLDTOT_ctrl = zeros(64,32,60);
CLDTOT_ref = zeros(64,32,60);
CLDTOT_34 = zeros(64,32,60);
CLDTOT_75 = zeros(64,32,60);
FLNT_ctrl = zeros(64,32,60);
FLNT_ref = zeros(64,32,60);
FLNT_34 = zeros(64,32,60);
FLNT_75 = zeros(64,32,60);
FSNT_ctrl = zeros(64,32,60);
FSNT_ref = zeros(64,32,60);
FSNT_34 = zeros(64,32,60);
FSNT_75 = zeros(64,32,60);


for i = 0:4
    yr_ctrl = 45+i;
    yr_tsk1 = 75+i;
    for j = 1:12
        pos = i*12+j;
        file_ctrl = [pathctrl,num2str(yr_ctrl,'%02d'),'-',...
            num2str(j,'%02d'),'.nc'];
        file_ref = [pathref,num2str(yr_tsk1,'%02d'),'-',...
            num2str(j,'%02d'),'.nc'];
        file_34 = [path34,num2str(yr_tsk1,'%02d'),'-',...
            num2str(j,'%02d'),'_copy.nc'];
        file_75 = [path75,num2str(yr_tsk1,'%02d'),'-',...
            num2str(j,'%02d'),'_copy.nc'];
        temp = ncread(file_ctrl,'RELHUM');
        RELHUM_ctrl(:,:,pos) = temp(:,:,end);
        temp = ncread(file_ref,'RELHUM');
        RELHUM_ref(:,:,pos) = temp(:,:,end);
        temp = ncread(file_34,'RELHUM');
        RELHUM_34(:,:,pos) = temp(:,:,end);
        temp = ncread(file_75,'RELHUM');
        RELHUM_75(:,:,pos) = temp(:,:,end);
        CLDTOT_ctrl = ncread(file_ctrl,'CLDTOT');
        CLDTOT_ref = ncread(file_ref,'CLDTOT');
        CLDTOT_34 = ncread(file_34,'CLDTOT');
        CLDTOT_75 = ncread(file_75,'CLDTOT');
        FLNT_ctrl = ncread(file_ctrl,'FLNT');
        FLNT_ref = ncread(file_ref,'FLNT');
        FLNT_34 = ncread(file_34,'FLNT');
        FLNT_75 = ncread(file_75,'FLNT');
        FSNT_ctrl = ncread(file_ctrl,'FSNT');
        FSNT_ref = ncread(file_ref,'FSNT');
        FSNT_34 = ncread(file_34,'FSNT');
        FSNT_75 = ncread(file_75,'FSNT');
    end
end

RELHUM_diffref = mean(RELHUM_ref - RELHUM_ctrl,3);
RELHUM_diff34 = mean(RELHUM_34 - RELHUM_ctrl,3);
RELHUM_diff75 = mean(RELHUM_75 - RELHUM_ctrl,3);
CLDTOT_diffref = mean(CLDTOT_ref - CLDTOT_ctrl,3);
CLDTOT_diff34 = mean(CLDTOT_34 - CLDTOT_ctrl,3);
CLDTOT_diff75 = mean(CLDTOT_75 - CLDTOT_ctrl,3);
FLNT_diffref = mean(FLNT_34 - FLNT_ref,3);
FLNT_diff34 = mean(FLNT_34 - FLNT_ctrl,3);
FLNT_diff75 = mean(FLNT_75 - FLNT_ctrl,3);
FSNT_diffref = mean(FSNT_ref - FSNT_ctrl,3);
FSNT_diff34 = mean(FSNT_34 - FSNT_ctrl,3);
FSNT_diff75 = mean(FSNT_75 - FSNT_ctrl,3);

figure
set(gcf,'outerposition',get(0,'screensize'));

subplot(2,2,1)
plot(lat,mean(RELHUM_diffref,1),'LineWidth',1)
hold on
plot(lat,mean(RELHUM_diff34,1),'LineWidth',1)
hold on
plot(lat,mean(RELHUM_diff75,1),'LineWidth',1)
hold on
plot(lat,lat*0,'--k','LineWidth',1)
ylabel('RH (%)')
xlabel('latitude')
title('Relative humidity profile')
legend('constant','Episode34','Episode75')
set(gca,'Fontsize',15)
hold off

subplot(2,2,2)
plot(lat,mean(CLDTOT_diffref,1),'LineWidth',1)
hold on
plot(lat,mean(CLDTOT_diff34,1),'LineWidth',1)
hold on
plot(lat,mean(CLDTOT_diff75,1),'LineWidth',1)
hold on
plot(lat,lat*0,'--k','LineWidth',1)
ylabel('cloud fraction')
xlabel('latitude')
title('Column cloud fraction profile')
legend('constant','Episode34','Episode75')
set(gca,'Fontsize',15)
hold off

subplot(2,2,3)
plot(lat,mean(FLNT_diffref,1),'LineWidth',1)
hold on
plot(lat,mean(FLNT_diff34,1),'LineWidth',1)
hold on
plot(lat,mean(FLNT_diff75,1),'LineWidth',1)
hold on
plot(lat,lat*0,'--k','LineWidth',1)
ylabel('LR (wm^-2)')
xlabel('latitude')
title('TOA net longwave radiation profile')
legend('constant','Episode34','Episode75')
set(gca,'Fontsize',15)
hold off

subplot(2,2,4)
plot(lat,mean(FSNT_diffref,1),'LineWidth',1)
hold on
plot(lat,mean(FSNT_diff34,1),'LineWidth',1)
hold on
plot(lat,mean(FSNT_diff75,1),'LineWidth',1)
hold on
plot(lat,lat*0,'--k','LineWidth',1)
ylabel('SR (wm^-2)')
xlabel('latitude')
title('TOA net solar radiation profile')
legend('constant','Episode34','Episode75')
set(gca,'Fontsize',15)
hold off