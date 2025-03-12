% start from control state
clear,clc,close all

env = EBM_env_smooth;

% buffer_size = 5yrs, 12 steps, 0.99, 0.008, Epi 42, rwd > -3;
% noise = 5*randn, can still learn

%% 
rng(0);
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
UpperLimit = actInfo.UpperLimit;
LowerLimit = actInfo.LowerLimit;
ActionRange = UpperLimit - LowerLimit;

criticNetwork = [
    featureInputLayer(8,'Normalization','none','Name','state');
    fullyConnectedLayer(10,'Name', 'fc1');
    reluLayer('Name', 'relu1');
    fullyConnectedLayer(10,'Name', 'fc2');
    reluLayer('Name', 'relu2');
    fullyConnectedLayer(1,'Name','out')];
criticOpts = rlRepresentationOptions('LearnRate',0.008, ...
    'GradientThreshold',1,'UseDevice','gpu');
critic = rlValueRepresentation(criticNetwork,obsInfo,'Observation', ...
    {'state'},criticOpts);

inPath = [ 
           featureInputLayer(8,'Normalization','none','Name','state');
           fullyConnectedLayer(10,'Name','ip_fc1');
           reluLayer('Name','ip_relu1');
           fullyConnectedLayer(10,'Name','ip_fc2'); 
           reluLayer('Name','ip_relu2')];
meanPath = [ fullyConnectedLayer(10,'Name','mp_fc1');
             reluLayer('Name','mp_relu1');  
             fullyConnectedLayer(8,'Name','mp_fc2');
             sigmoidLayer('Name','mp_sigmoid'); % output range: (0,1)
             scalingLayer('Name','mp_out',...
             'Scale',ActionRange,'Bias',LowerLimit) ]; % output range: (0,5e-05)
sdevPath = [ fullyConnectedLayer(10,'Name', 'vp_fc1');
             reluLayer('Name', 'vp_relu1');
             fullyConnectedLayer(8,'Name','vp_fc2');
             sigmoidLayer('Name','vp_sigmoid'); % output range: (0,1)
             scalingLayer('Name', 'vp_out','Scale',ActionRange/20) ]; % output range: (0,2.5e-06)
outLayer = concatenationLayer(1,2,'Name','mean&sdev');
actorNetwork = layerGraph(inPath);
actorNetwork = addLayers(actorNetwork,meanPath);
actorNetwork = addLayers(actorNetwork,sdevPath);
actorNetwork = addLayers(actorNetwork,outLayer);
actorNetwork = connectLayers(actorNetwork,'ip_relu2','mp_fc1/in');   % connect output of inPath to meanPath input
actorNetwork = connectLayers(actorNetwork,'ip_relu2','vp_fc1/in');   % connect output of inPath to sdevPath input
actorNetwork = connectLayers(actorNetwork,'mp_out','mean&sdev/in1');% connect output of meanPath to mean&sdev input #1
actorNetwork = connectLayers(actorNetwork,'vp_out','mean&sdev/in2');% connect output of sdevPath to mean&sdev input #2

% plot(actorNetwork)

actorOpts = rlRepresentationOptions('LearnRate',0.008, ...
    'GradientThreshold',1,'UseDevice','gpu');
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);

agentOpts = rlACAgentOptions(...
    'NumStepsToLookAhead',12,...
    'DiscountFactor',0.99);
agent = rlACAgent(actor,critic,agentOpts);


%% 

% trainOpts = rlTrainingOptions(...
%     'MaxEpisodes',200,...
%     'MaxStepsPerEpisode',360,...
%     'Verbose',true,...
%     'Plots','training-progress',...
%     'StopTrainingCriteria','AverageReward',...
%     'StopTrainingValue',-4,...
%     'ScoreAveragingWindowLength',5,...
%     'SaveAgentCriteria','EpisodeReward',...
%     'SaveAgentValue',-4);

trainOpts = rlTrainingOptions(...
    'MaxEpisodes',100,...
    'MaxStepsPerEpisode',360,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-3,...
    'ScoreAveragingWindowLength',5);


warning off
trainingStats = train(agent,env,trainOpts);
% episode 32, R = -4.54

env_sim = EBM_env_smooth;
simOptions = rlSimulationOptions('MaxSteps',360);
experience = sim(env_sim,agent,simOptions);
totalReward = sum(experience.Reward);

%save('EBM_RL_smooth_rng00.mat')