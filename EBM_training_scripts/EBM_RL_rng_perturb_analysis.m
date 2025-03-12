clear,clc,close all

n = 21;
idx_list = zeros(n,1);
EpisodeReward_list = cell(n,1);
G_xmean_list = zeros(n,360);
G_tmean_list = zeros(n,361);
StepReward_list = zeros(n,360);
T_smooth_final_list = zeros(n,361);

for i = 1:21
    filename = ['./EBM_tsk1_rng_perturb_data/rng'  num2str(i-1)  '.mat'];
    load(filename,'env')
    EpisodeReward = sum(env.StepReward(1:(end-1),:)*12,2);
    [MaxEpisodeReward,idx] = max(EpisodeReward);
    G_xmean = env.G_mean(idx,:);
    G_tmean = squeeze(mean(env.G_record(idx,:,:)));
    StepReward = env.StepReward(idx,:);
    T_smooth_final = squeeze(env.T_smooth_record(idx,end,:));

    idx_list(i) = idx;
    EpisodeReward_list{i} = EpisodeReward;
    G_xmean_list(i,:) = G_xmean;
    G_tmean_list(i,:) = G_tmean;
    StepReward_list(i,:) = StepReward;
    T_smooth_final_list(i,:) = T_smooth_final;
end

save("EBM_tsk1_rng_perturb_data\rng_perturb_data.mat", ...
    "idx_list","EpisodeReward_list","G_xmean_list","G_tmean_list", ...
    "StepReward_list","T_smooth_final_list")

% Episode_list = [32,73,57,80,44];
% 
% figure(1)
% plot(ones(1,100)*(-109),'--k','LineWidth',1)
% hold on
% for i = 1:5
%     idx = 1:(Episode_list(i)+5);
%     filename = ['./EBM_tsk1_rng_perturb_data/rng'  num2str(i-1)  '.mat'];
%     load(filename,'env')
%     EpisodeReward = sum(env.StepReward*12,2);
%     plot(idx,EpisodeReward(idx),'-k',LineWidth=2)
%     hold on
%     plot(Episode_list(i),EpisodeReward(Episode_list(i)), ...
%         Marker='o',Color='b',MarkerSize=10,LineWidth=2)
%     hold on
% end
% 
% 
% hold off
% xlabel('episode')
% ylabel('Reward R')
% ylim([-1000,0])
% xlim([0,100])
% set(gca,'FontSize',18)
% legend('constant','RL',Location='southeast',fontsize=20)
% 
% 
% figure(2)
% sinlat = -1:(1/180):1;
% load('T_initial_smooth.mat','target_G_profile')
% plot(sinlat,0.017*ones(1,361),'--k','LineWidth',1)
% hold on
% plot(sinlat,target_G_profile,'-b',LineWidth=2)
% hold on
% 
% 
% for i = 1:5
%     idx = 1:(Episode_list(i)+5);
%     filename = ['./EBM_tsk1_rng_perturb_data/rng'  num2str(i-1)  '.mat'];
%     load(filename,'env')
%     G_tmean = squeeze(mean(env.G_record(Episode_list(i),:,:)));
%     plot(sinlat,G_tmean,'-k',LineWidth=2)
%     hold on
% end
% 
% set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
% xticklabels([-90,-45,-30,0,30,45,90])
% xlim([-1,1])
% ylim([0.005,0.055])
% xlabel('latitude')
% ylabel('G')
% set(gca,'FontSize',18)
% legend('constant','perfect','RL',Location='north',fontsize=20)
