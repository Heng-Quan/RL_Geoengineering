clear,clc,close all

load("EBM_tsk1_rng_perturb_data\rng_perturb_data.mat")

G_tmean_average = mean(G_tmean_list);
G_tmean_std = std(G_tmean_list);
G_tmean_upper = G_tmean_average + G_tmean_std;
G_tmean_lower = G_tmean_average - G_tmean_std;

figure(1)
sinlat = -1:(1/180):1;
load('T_initial_smooth.mat','target_G_profile')
% plot(sinlat,0.017*ones(1,361),'--k','LineWidth',1)
% hold on
plot(sinlat,target_G_profile,'-b',LineWidth=2)
hold on
plot(sinlat,G_tmean_average,'-k',LineWidth=2)
hold on
patch([sinlat fliplr(sinlat)], [G_tmean_lower fliplr(G_tmean_upper)],...
    'k','FaceAlpha',0.1,'EdgeColor','None')
hold on
for latidx = [1,21,71,142,220,291,341,361]
    plot(sinlat(latidx),G_tmean_average(latidx), ...
    Marker='o',Color='k',MarkerSize=5,LineWidth=2)
    hold on
end
hold off
set(gca,'Xtick',[-1,-0.71,-0.5,0,0.5,0.71,1])
xticklabels([-90,-45,-30,0,30,45,90])
xlim([-1,1])
ylim([0.005,0.055])
xlabel('latitude')
ylabel('G')
set(gca,'FontSize',18)
% legend('constant','perfect','RL',Location='north',fontsize=20)
legend('perfect','RL',Location='north',fontsize=20)