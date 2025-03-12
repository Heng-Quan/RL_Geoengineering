clear,clc,close all

% TS_control = zeros(64,32,600);
% PminusE_control = zeros(64,32,600);
% Lv = 2501 * 1000;
% rou = 1000;
% for i = 0:49
%     for j = 1:12
%         stepnum = i*12+j;
%         file_ctl = ['control_run.cam2.h0.00',num2str(i,'%02d'),...
%             '-',num2str(j,'%02d'),'.nc'];
%         TS_control(:,:,stepnum) = ncread(file_ctl,'TS');
%         PminusE_control(:,:,stepnum) = ncread(file_ctl,'PRECC') + ...
%             ncread(file_ctl,'PRECL') - ncread(file_ctl,'LHFLX')/(Lv*rou);
%     end
% end
% PminusE_control = PminusE_control * 365 * 86400;
% save('ctl_res.mat',"PminusE_control","TS_control")

load('ctl_res.mat')
load("basic.mat")
load("tsk2_ref_rwd.mat")

% t1 = 180;
% t2 = 600 - t1 - 60;
% 
% TS_control = squeeze(mean(TS_control(:,:,(t1+1):600),1));
% PminusE_control = squeeze(mean(PminusE_control(:,:,(t1+1):600),1));
% TS_rwd_ctl = zeros(1,t2);
% TS_rwd_ctl_tropics = zeros(1,t2);
% PminusE_rwd_ctl = zeros(1,t2);
% combined_rwd_ctl = zeros(1,t2);
% 
% for i = 1:t2
%     TS_5yr = mean(TS_control(:,i:(i+59)),2) - ...
%         mean(TS_control(:,1:60),2);
%     PminusE_5yr = mean(PminusE_control(:,i:(i+59)),2) - ...
%         mean(PminusE_control(:,1:60),2);
%     TS_rwd_ctl(i) = dot(cos(lat*pi/180),abs(TS_5yr))/...
%         sum(cos(lat*pi/180));
%     TS_rwd_ctl_tropics(i) = dot(cos(lat(11:22)*pi/180),abs(TS_5yr(11:22)))/...
%         sum(cos(lat(11:22)*pi/180));
%     PminusE_rwd_ctl(i) = dot(cos(lat*pi/180),abs(PminusE_5yr))/...
%         sum(cos(lat*pi/180));
%     combined_rwd_ctl(i) = -sqrt((TS_rwd_ctl(i)/TS_ref_rwd)^2 + ...
%         (PminusE_rwd_ctl(i)/PminusE_ref_rwd)^2);
% end

% save('tsk23_ctl_rwd.mat',"TS_rwd_ctl","TS_rwd_ctl_tropics",...
%     "PminusE_rwd_ctl","combined_rwd_ctl")


TS_control = squeeze(mean(TS_control(:,:,301:600),1));
PminusE_control = squeeze(mean(PminusE_control(:,:,301:600),1));
TS_control_5yr = zeros(32,240);
PminusE_control_5yr = zeros(32,240);
for i = 1:240
    TS_control_5yr(:,i) = mean(TS_control(:,i:(i+59)),2);
    PminusE_control_5yr(:,i) = mean(PminusE_control(:,i:(i+59)),2);
end

TS_ctl_std = std(transpose(TS_control_5yr));
PminusE_ctl_std = std(transpose(PminusE_control_5yr));

save('ctl_std.mat',"TS_ctl_std","PminusE_ctl_std")
