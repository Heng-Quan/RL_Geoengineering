clear,clc,close all
% for CAM 3.0

LearnRate = 0.001;

% record:

%% initialize RL ACAgent
env = CAM_tsk2_env1;
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
UpperLimit = actInfo.UpperLimit;
LowerLimit = actInfo.LowerLimit;
ActionRange = UpperLimit - LowerLimit;
rng(0)

criticNetwork = [
    imageInputLayer([obsInfo.Dimension],'Normalization','none','Name','state');
    convolution2dLayer([4,4],10,'Stride',[4,4],'Name','conv1');
    % 64*32 to 16*8
    reluLayer('Name', 'relu1');
    maxPooling2dLayer([2,2],'Stride',[2,2],'Name','pooling1');
    % 16*8 to 8*4
    fullyConnectedLayer(10,'Name', 'fc1');
    reluLayer('Name', 'relu2');
    fullyConnectedLayer(1,'Name','out')];
criticOpts = rlRepresentationOptions('LearnRate',LearnRate,'GradientThreshold',1);
critic = rlValueRepresentation(criticNetwork,obsInfo,'Observation',{'state'},criticOpts);

inPath = [ 
           imageInputLayer([obsInfo.Dimension],'Normalization','none','Name','state');
           convolution2dLayer([4,4],10,'Stride',[4,4],'Name','conv1');
           % 64*32 to 16*8
           reluLayer('Name','ip_relu1');
           maxPooling2dLayer([2,2],'Stride',[2,2],'Name','pooling1');
           % 16*8 to 8*4
           fullyConnectedLayer(10,'Name','ip_fc1');
           reluLayer('Name','ip_relu2')];
meanPath = [ fullyConnectedLayer(10,'Name','mp_fc1');
             reluLayer('Name','mp_relu1');  
             fullyConnectedLayer(7,'Name','mp_fc2');
             sigmoidLayer('Name','mp_sigmoid'); % output range: (0,1)
             scalingLayer('Name','mp_out',...
             'Scale',ActionRange,'Bias',LowerLimit) ]; % output range: (0,4e-05)
sdevPath = [ fullyConnectedLayer(10,'Name', 'vp_fc1');
             reluLayer('Name', 'vp_relu1');
             fullyConnectedLayer(7,'Name','vp_fc2');
             sigmoidLayer('Name','vp_sigmoid'); % output range: (0,1)
             scalingLayer('Name', 'vp_out','Scale',ActionRange/20) ]; % output range: (0,2e-06)
outLayer = concatenationLayer(3,2,'Name','mean&sdev');
actorNetwork = layerGraph(inPath);
actorNetwork = addLayers(actorNetwork,meanPath);
actorNetwork = addLayers(actorNetwork,sdevPath);
actorNetwork = addLayers(actorNetwork,outLayer);
actorNetwork = connectLayers(actorNetwork,'ip_relu2','mp_fc1/in');   % connect output of inPath to meanPath input
actorNetwork = connectLayers(actorNetwork,'ip_relu2','vp_fc1/in');   % connect output of inPath to sdevPath input
actorNetwork = connectLayers(actorNetwork,'mp_out','mean&sdev/in1');% connect output of meanPath to mean&sdev input #1
actorNetwork = connectLayers(actorNetwork,'vp_out','mean&sdev/in2');% connect output of sdevPath to mean&sdev input #2

% plot(actorNetwork)

actorOpts = rlRepresentationOptions('LearnRate',LearnRate,'GradientThreshold',1);
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);

agentOpts = rlACAgentOptions(...
    'NumStepsToLookAhead',12,...
    'DiscountFactor',0.99);
agent = rlACAgent(actor,critic,agentOpts);

trainOpts = rlTrainingOptions(...
    'MaxEpisodes',1,...
    'MaxStepsPerEpisode',360,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-3,...
    'ScoreAveragingWindowLength',1,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',-5);

warning off

EpisodeReward = [];
Episode = 0;

save('EpisodeData.mat')

!echo 'initialized!'