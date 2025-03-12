clear,clc,close all

Lv = 2501 * 1000;
rou = 1000;
sec_per_yr = 86400 * 365;
load('basic.mat')

TS_control = zeros(64,32,60);
PminusE_control = zeros(64,32,60);
TS_2xCO2 = zeros(64,32,360);
PminusE_2xCO2 = zeros(64,32,360);
TS_SRM4 = zeros(64,32,360); % 35 uniform aerosol
PminusE_SRM4 = zeros(64,32,360);
TS_SRM5 = zeros(64,32,360); % 25 uniform aerosol
PminusE_SRM5 = zeros(64,32,360);



for i = 45:49
    for j = 1:12
        stepnum = (i-45)*12+j;
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

for i = 50:79
    for j = 1:12
        stepnum = (i-50)*12+j;
        filename_2xCO2 = ['2xCO2_run.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        filename_SRM4 = ['SRM_run4.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        filename_SRM5 = ['SRM_run5.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        
        TS_2xCO2(:,:,stepnum) = ncread(filename_2xCO2,'TS');
        PminusE_2xCO2(:,:,stepnum) = ncread(filename_2xCO2,'PRECC') + ...
            ncread(filename_2xCO2,'PRECL') - ...
            ncread(filename_2xCO2,'LHFLX')/(Lv*rou);
        PminusE_2xCO2(:,:,stepnum) = ...
            PminusE_2xCO2(:,:,stepnum) * 365 * 86400;
        
        TS_SRM4(:,:,stepnum) = ncread(filename_SRM4,'TS');
        PminusE_SRM4(:,:,stepnum) = ncread(filename_SRM4,'PRECC') + ...
            ncread(filename_SRM4,'PRECL') - ...
            ncread(filename_SRM4,'LHFLX')/(Lv*rou);
        PminusE_SRM4(:,:,stepnum) = ...
            PminusE_SRM4(:,:,stepnum) * 365 * 86400;
        
        TS_SRM5(:,:,stepnum) = ncread(filename_SRM5,'TS');
        PminusE_SRM5(:,:,stepnum) = ncread(filename_SRM5,'PRECC') + ...
            ncread(filename_SRM5,'PRECL') - ...
            ncread(filename_SRM5,'LHFLX')/(Lv*rou);
        PminusE_SRM5(:,:,stepnum) = ...
            PminusE_SRM5(:,:,stepnum) * 365 * 86400;
    end
end

save('constant_SG2.mat','TS_control','PminusE_control',...
    'TS_2xCO2','PminusE_2xCO2',"TS_SRM4",...
    "PminusE_SRM4","TS_SRM5","PminusE_SRM5")
