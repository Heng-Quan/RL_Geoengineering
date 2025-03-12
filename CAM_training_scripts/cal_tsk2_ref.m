clear,clc,close all

Lv = 2501 * 1000;
rou = 1000;
sec_per_yr = 86400 * 365;
load('basic.mat')

TS_control = zeros(64,32,60);
PminusE_control = zeros(64,32,60);
TS_2xCO2 = zeros(64,32,60);
PminusE_2xCO2 = zeros(64,32,60);
TS_initial = zeros(64,32,12);
PminusE_initial = zeros(64,32,12);


for i = 40:44
    for j = 1:12
        stepnum = (i-40)*12+j;
        filename_control = ['control_run.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        TS_control(:,:,stepnum) = ncread(filename_control,'TS');
        PminusE_control(:,:,stepnum) = ...
            ncread(filename_control,'PRECC') + ... 
            ncread(filename_control,'PRECL') - ...
            ncread(filename_control,'LHFLX')/(Lv*rou);
        PminusE_control(:,:,stepnum) = ...
            PminusE_control(:,:,stepnum) * 365 * 86400;
    end
end

for i = 75:79
    for j = 1:12
        stepnum = (i-75)*12+j;
        filename_2xCO2 = ['2xCO2_run.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        
        TS_2xCO2(:,:,stepnum) = ncread(filename_2xCO2,'TS');
        PminusE_2xCO2(:,:,stepnum) = ncread(filename_2xCO2,'PRECC') + ...
            ncread(filename_2xCO2,'PRECL') - ...
            ncread(filename_2xCO2,'LHFLX')/(Lv*rou);
        PminusE_2xCO2(:,:,stepnum) = ...
            PminusE_2xCO2(:,:,stepnum) * 365 * 86400;
    end
end

for j = 1:12
    stepnum = j;
    filename_initial = ['2xCO2_run.cam2.h0.0049',...
        '-', num2str(j,'%02d'), '.nc'];
    TS_initial(:,:,stepnum) = ncread(filename_initial,'TS');
    PminusE_initial(:,:,stepnum) = ...
        ncread(filename_initial,'PRECC') + ...
        ncread(filename_initial,'PRECL') - ...
        ncread(filename_initial,'LHFLX')/(Lv*rou);
    PminusE_initial(:,:,stepnum) = ...
        PminusE_initial(:,:,stepnum) * 365 * 86400;
end
TS_initial = repmat(TS_initial,[1,1,5]);
PminusE_initial = repmat(PminusE_initial,[1,1,5]);

save('tsk2_ref.mat','TS_control','PminusE_control',...
    'TS_2xCO2','PminusE_2xCO2','TS_initial','PminusE_initial')


figure
set(gcf,'outerposition',get(0,'screensize'));
subplot(2,1,1)
plot(lat,mean(mean(TS_initial-TS_control,3),1),'-k','LineWidth',1)
hold on
plot(lat,mean(mean(TS_2xCO2-TS_control,3),1),'-r','LineWidth',1)
hold on
plot(lat,zeros(1,32),'--k','LineWidth',1)

subplot(2,1,2)
plot(lat,mean(mean(PminusE_initial-PminusE_control,3),1),'-k','LineWidth',1)
hold on
plot(lat,mean(mean(PminusE_2xCO2-PminusE_control,3),1),'-r','LineWidth',1)
hold on
plot(lat,zeros(1,32),'--k','LineWidth',1)
