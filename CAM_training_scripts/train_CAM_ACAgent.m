clear,clc,close all
%% train RL ACAgent

load('EpisodeData.mat')

for i = 1:40
    rng(0);
    trainingStats = train(agent,env,trainOpts);
    Episode = Episode + 1;
    EpisodeReward = [EpisodeReward; trainingStats.EpisodeReward];
    StepReward = env.StepReward;
    save('EpisodeData.mat');
    !find ./ -type f -name 'SRM_RL_run.clm2.*' -exec rm -f {} \;
    
    if max(EpisodeReward) > -5
        !echo 'trained!'
        !scancel -u `whoami`
    end
end