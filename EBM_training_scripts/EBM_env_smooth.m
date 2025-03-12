classdef EBM_env_smooth < rl.env.MATLABEnvironment    
    
    %% Properties (set properties' attributes accordingly)
    properties
        % Specify and initialize environment's necessary properties    
        Q = 1360; %solar constant
        gamma = 0.482; %for calculating the insolation structure function
        sin_lat = -1:(1/180):1; %x = sin latitude, values from -1 to +1
        
        lat = zeros(1,361); %latitude, in degree
        P2 = zeros(1,361); %second Legendre polynomial
        S = zeros(1,361); %insolation structure function
        insolation_0 = zeros(1,361); %insolation profile
        S1 = 180; %amplitude of seasonal cycle
        
        A = -290; % Feedback co-efficients:
        B = 1.8; % Feedback co-efficients:
        D = 0.25; %diffusivity
        
        a0 = 0.32; %open water albedo
        a1 = 0.62; %sea ice albedo
        T0 = 262.15;
        ht = 6; %thickness parameter
        
        cw = 9.8; %heat capacity of mixed layer
        
        F = 3.6; % CO2 forcing
        
        Ts = 1; % sample time
        MinG = 0.005; % Min SRM reduction ratio
        MaxG = 0.055; % Max SRM reduction ratio
        
        T_initial = zeros(361,1); % initial temperature profile
        T_original = zeros(361,1); % equalibrium temperature profile 1*CO2
        T_2CO2 = zeros(361,1); % equalibrium temperature profile 2*CO2
        T_SRM_uniform = zeros(361,1);
        target_G_profile = zeros(361,1); % best SRM reduction ratio profile
        current_G_profile = zeros(361,1);
        
        step_num = 0;
        episode_num = 0;
        T_record = [];
        G_record = [];
        T_smooth_record = [];
        T_mean = [];
        G_mean = [];
        StepReward = [];
        
    end
    
    properties
        % Initialize system state T(lat)'
        State = zeros(361,1);
        T_buffer = zeros(361,12);
        T_smooth = zeros(361,1);
    end
    
    properties(Access = protected)
        % Initialize internal flag to indicate episode termination
        IsDone = false;      
        
        % Handle to figure
        Figure
    end

    %% Necessary Methods
    methods              
        % Create an environment
        function this = EBM_env_smooth()
            % Initialize Observation settings
            ObservationInfo = rlNumericSpec([8 1]);
            ObservationInfo.Name = 'Temperature profile';
            ObservationInfo.Description = 'T(lat)';
            
            % Initialize Action settings   
            ActionInfo = rlNumericSpec([8 1]);
            ActionInfo.Name = 'G';
            ActionInfo.Description = 'SRM ratio';
            
            % The following line implements built-in functions of RL env
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
            
            % Initialize property values and pre-compute necessary values
            Initialize_properties(this);
        end
        
        % Integrate for 1 year (1 step)
        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)
            LoggedSignals = [];
            
            t_init = this.step_num/12;
            t_end = t_init + 1/12;
            this.step_num = this.step_num + 1;
            month = mod(this.step_num,12);
            if month == 0
                month = 12;
            end
            
            buffer_size = 60;
            new_pos = mod(this.step_num,buffer_size);
            if new_pos == 0
                new_pos = buffer_size;
            end
            
            % Get initial temperature profile
            Ti = this.State;
            
            % Get SRM action 
            G = interp1([1,21,71,142,220,291,341,361],Action,1:361,'linear');
            G = transpose(G.*(G>0));
            this.current_G_profile = G;
            
            % Apply SRM and update state
            [~,T] = ode45(@(t,T) cal_rhs_tendency(t,T,this,G), t_init:(1/365):t_end, Ti);
            T = T(end,:)';
            this.State = T;
            this.T_buffer(:,new_pos) = T;
            this.T_smooth = mean(this.T_buffer,2);
            Observation = this.T_smooth([1,21,71,142,220,291,341,361]) - ...
                this.T_original([1,21,71,142,220,291,341,361]);
            
            this.T_record(this.episode_num,this.step_num,1:361) = T;
            this.T_smooth_record(this.episode_num,this.step_num,1:361) =...
                this.T_smooth;
            this.G_record(this.episode_num,this.step_num,1:361) = G;
            this.T_mean(this.episode_num,this.step_num) = mean(T);
            this.G_mean(this.episode_num,this.step_num) = mean(G);
                        
            % (optional) Check terminal condition
%             IsDone = norm(this.State - this.T_original,1)/361 > 2;
%             this.IsDone = IsDone;
            IsDone = false;

            % Get reward
            Reward = getReward(this);
            this.StepReward(this.episode_num,this.step_num) = Reward;
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
        
        % Reset environment to initial state and output initial observation
        function InitialObservation = reset(this)
            this.episode_num = this.episode_num + 1;
            this.step_num = 0;
            T_data = load('T_initial_smooth.mat');
            this.State = transpose(T_data.T_buffer2(end,:));
            this.T_buffer = transpose(T_data.T_buffer2);
            this.T_smooth = transpose(mean(T_data.T_buffer2));
            InitialObservation = this.T_smooth([1,21,71,142,220,291,341,361])...
                - this.T_original([1,21,71,142,220,291,341,361]);
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
    end
    
    %% Optional Methods (set methods' attributes accordingly)
    methods               
        % Helper methods to create the environment
          
        % update the action info based on max and min G value
        function Initialize_properties(this)
            this.ActionInfo.LowerLimit = this.MinG;
            this.ActionInfo.UpperLimit = this.MaxG;
            this.lat = asin(this.sin_lat)*180/pi; %latitude, in degree
            this.P2 = 0.5*(3*this.sin_lat.^2-1); %second Legendre polynomial
            this.S = 1 - this.gamma * this.P2; %insolation structure function
            this.insolation_0 = 0.25 * this.Q * this.S'; %insolation profile
            
            T_data = load('T_initial_smooth.mat');
            % this.T_original = transpose(T_data.T_control); 
            % control T 10yr            
            % this.T_original = transpose(mean(T_data.T_buffer));
            % control T 1yr
            this.T_original = transpose(mean(T_data.T_buffer2));
            this.T_initial = transpose(mean(T_data.T_buffer2));
            % control T 5yr
            this.T_2CO2 = transpose(mean(T_data.T_trans(542:601,:))); 
            % equalibrium T 2*CO2
            this.target_G_profile = T_data.target_G_profile;
            % this.T_buffer = transpose(T_data.T_buffer);
            % this.T_smooth = transpose(mean(T_data.T_buffer));
            % buffer 1yr
            this.T_buffer = transpose(T_data.T_buffer2);
            this.T_smooth = transpose(mean(T_data.T_buffer2));
            % buffer 5yr
            
            load('EBM_uniform17_SRM.mat','T_SRM_uniform')
            this.T_SRM_uniform = transpose(mean(T_SRM_uniform,1));
        end
        
        % Reward function
        function Reward = getReward(this)
            Reward = -norm(this.T_smooth - this.T_original,1)/361;
            Reward = Reward/12;
        end
        
        function dTdt = cal_rhs_tendency(t,T,this,G)
            % G(lat) is SRM reduction ratio, column vector
            % T is a column vector
            
            % feedback
            feedback = this.A + this.B * T;
            
            % insolation
            al = (this.a0 + this.a1)/2 + (this.a0 - this.a1)/2 * tanh((T - this.T0)/this.ht);
            insolation = this.insolation_0 - this.S1 * this.sin_lat' * cos( t * 2. * pi);
            ins = insolation .* (1 - al).* (1 - G);
            ins = ins.*(ins>0);
            
            % diffusion
            dx = this.sin_lat(2) - this.sin_lat(1);
            diffusion = zeros(361,1);
            diffusion(2:360) = (this.D / (dx^2)) * (1-this.sin_lat(2:360)'.^2)...
                .* (T(3:361)-2*T(2:360)+T(1:359)) - (this.D * this.sin_lat(2:360)'/dx) .* (T(3:361)-T(1:359));
            diffusion(1) = -this.D * 2 * this.sin_lat(1) * (T(2) - T(1)) / dx;
            diffusion(361) = -this.D * 2 * this.sin_lat(361) * (T(361) - T(360)) / dx;
            
            dTdt = (ins - feedback + diffusion + this.F)/this.cw;
        end
        
        % (optional) Visualization method
        function plot(this)
            % Initiate the visualization
            this.Figure = figure('Visible','on','HandleVisibility','off');
           
            % Update the visualization
            envUpdatedCallback(this)
        end
    end
    
    methods (Access = protected)
        % (optional) update visualization everytime the environment is updated 
        % (notifyEnvUpdated is called)
        function envUpdatedCallback(this)
            set(gcf,'outerposition',get(0,'screensize'));
            
            subplot(2,1,1)
            axis([-90 90 this.MinG this.MaxG])
            plot(this.lat,this.target_G_profile,'--k','LineWidth',1)
            hold on
            plot(this.lat,0.017 * ones(1,361),'-k','LineWidth',1)
            hold on
            plot(this.lat,this.current_G_profile,'-b','LineWidth',1)
            ylabel('G')
            xlabel('latitude')
            title('(a) G profile')
            legend('perfect G','uniform G=0.017','RL G')
            set(gca,'Fontsize',15,'XTick',-90:15:90)
            hold off
            
            subplot(2,1,2)
            axis([-90 90 -6 6])
%             plot(this.lat,this.T_2CO2 - this.T_original,'-r','LineWidth',1)
%             hold on
            plot(this.lat,this.T_initial - this.T_original,'--k','LineWidth',1)
            hold on
            plot(this.lat,this.T_SRM_uniform - this.T_original,'-k','LineWidth',1)
            hold on
            plot(this.lat,this.T_smooth - this.T_original,'-b','LineWidth',1)
            ylabel('ΔT(K)')
            xlabel('latitude')
            title('(b) ΔT profile')
            legend('2*CO2 + perfect G','2*CO2 + uniform G=0.017','2*CO2 + RL G')
            set(gca,'Fontsize',15,'XTick',-90:15:90)
            hold off
            end
        end
end
    
