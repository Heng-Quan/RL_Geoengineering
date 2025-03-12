clear,clc,close all

load('basic.mat')

TS_control = zeros(64,32,60);
TS_preindustrial = zeros(64,32,60);
TS_2CO2 = zeros(64,32,60);

for i = 45:49
    for j = 1:12
        stepnum = (i-45)*12+j;
        filename_control = ['control_run.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        filename_preindustrial = ['preindustrial_run.cam2.h0.00',...
            num2str(i), '-', num2str(j,'%02d'), '.nc'];
        filename_2CO2 = ['2xCO2_run.cam2.h0.00', num2str(i),...
            '-', num2str(j,'%02d'), '.nc'];
        TS_control(:,:,stepnum) = ncread(filename_control,'TS');
        TS_preindustrial(:,:,stepnum)=ncread(filename_preindustrial,'TS');
        TS_2CO2(:,:,stepnum) = ncread(filename_2CO2,'TS');
    end
end

TS_control = mean(mean(TS_control,3),1);
TS_preindustrial = mean(mean(TS_preindustrial,3),1);
TS_2CO2 = mean(mean(TS_2CO2,3),1);

dT1 = calc_global_mean(TS_control,lat) - calc_global_mean(TS_preindustrial,lat);
dT2 = calc_global_mean(TS_2CO2,lat) - calc_global_mean(TS_control,lat);

dT1 = mean(TS_control) - mean(TS_preindustrial);
dT2 = mean(TS_2CO2) - mean(TS_control);

function [xnew] = calc_global_mean(x,lat)
xnew = dot(cos(lat*pi/180),x)/sum(cos(lat*pi/180));
end

