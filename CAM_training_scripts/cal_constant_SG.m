clear,clc,close all

Lv = 2501 * 1000;
rou = 1000;
sec_per_yr = 86400 * 365;
load('basic.mat')

TS_control = zeros(64,32,60);
PminusE_control = zeros(64,32,60);
TS_2xCO2 = zeros(64,32,360);
PminusE_2xCO2 = zeros(64,32,360);
TS_SRM = zeros(64,32,360); % 30 uniform aerosol
PminusE_SRM = zeros(64,32,360);
TS_SRM2 = zeros(64,32,360); % 20 uniform aerosol
PminusE_SRM2 = zeros(64,32,360);
TS_SRM3 = zeros(64,32,360); % 40 uniform aerosol
PminusE_SRM3 = zeros(64,32,360);


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
        filename_SRM = ['SRM_run.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        filename_SRM2 = ['SRM_run2.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        filename_SRM3 = ['SRM_run3.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        
        TS_2xCO2(:,:,stepnum) = ncread(filename_2xCO2,'TS');
        PminusE_2xCO2(:,:,stepnum) = ncread(filename_2xCO2,'PRECC') + ...
            ncread(filename_2xCO2,'PRECL') - ...
            ncread(filename_2xCO2,'LHFLX')/(Lv*rou);
        PminusE_2xCO2(:,:,stepnum) = ...
            PminusE_2xCO2(:,:,stepnum) * 365 * 86400;
        
        TS_SRM(:,:,stepnum) = ncread(filename_SRM,'TS');
        PminusE_SRM(:,:,stepnum) = ncread(filename_SRM,'PRECC') + ...
            ncread(filename_SRM,'PRECL') - ...
            ncread(filename_SRM,'LHFLX')/(Lv*rou);
        PminusE_SRM(:,:,stepnum) = ...
            PminusE_SRM(:,:,stepnum) * 365 * 86400;
        
        TS_SRM2(:,:,stepnum) = ncread(filename_SRM2,'TS');
        PminusE_SRM2(:,:,stepnum) = ncread(filename_SRM2,'PRECC') + ...
            ncread(filename_SRM2,'PRECL') - ...
            ncread(filename_SRM2,'LHFLX')/(Lv*rou);
        PminusE_SRM2(:,:,stepnum) = ...
            PminusE_SRM2(:,:,stepnum) * 365 * 86400;
        
        TS_SRM3(:,:,stepnum) = ncread(filename_SRM3,'TS');
        PminusE_SRM3(:,:,stepnum) = ncread(filename_SRM3,'PRECC') + ...
            ncread(filename_SRM3,'PRECL') - ...
            ncread(filename_SRM3,'LHFLX')/(Lv*rou);
        PminusE_SRM3(:,:,stepnum) = ...
            PminusE_SRM3(:,:,stepnum) * 365 * 86400;
    end
end

save('constant_SG.mat','TS_control','PminusE_control',...
    'TS_2xCO2','PminusE_2xCO2',"TS_SRM","PminusE_SRM","TS_SRM2",...
    "PminusE_SRM2","TS_SRM3","PminusE_SRM3")
