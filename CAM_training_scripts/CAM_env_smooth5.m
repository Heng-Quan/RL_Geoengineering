classdef CAM_env_smooth5 < rl.env.MATLABEnvironment    
    
    %% Properties (set properties' attributes accordingly)
    properties
        % Specify and initialize environment's necessary properties         
        lat = zeros(64,1); 
        lon = zeros(128,1);
        datenum = [31,28,31,30,31,30,31,31,30,31,30,31]; % dictionary
          
        Min_MSUL_V_top = 2e-05; % Min MSUL_V at top layer
        Max_MSUL_V_top = 4e-05; % Max MSUL_V at top layer
        
        TS_initial = zeros(1,64); % initial surface temperature (TS)
        TS_original = zeros(1,64); % equalibrium TS 1*CO2
        TS_2CO2 = zeros(1,64); % equalibrium TS 2*CO2
        TS_buffer = zeros(128,64,60);
        TS_smooth = zeros(1,64);
        buffer_size = 60;
        
        MSUL_V_top_lat = zeros(1,64);
        BNDTVAER_default_file = ['/gpfs/share/home/1800011374/',...
            'CAM3_SOM/atm/cam2/rad/AerosolMass_V_64x128_clim_c031022.nc'];
        BNDTVAER_file = ['/gpfs/share/home/1800011374/',...
            'CAM3_SOM/AerosolMass_V_64x128_varying10.nc'];
        init_file = '';
        init_file_clm = '';
        init_head = ['/gpfs/share/home/1800011374/',...
            'SRM_RL_CAM10/SRM_RL_run.cam2.i.00'];
        init_head_clm = ['/gpfs/share/home/1800011374/',...
            'SRM_RL_CAM10/SRM_RL_run.clm2.i.00']
        output_head = ['/gpfs/share/home/1800011374/',...
            'SRM_RL_CAM10/SRM_RL_run.cam2.h0.00'];
        
        step_num = 0;
        episode_num = 0;
        TS_record = [];
        TS_mean = []; % global mean surface temperature  
        TS_smooth_record = [];
        TS_smooth_mean = [];
        MSUL_V_top_record = [];
        MSUL_V_top_mean = []; % global mean MSUL_V at top layer
        StepReward = []; 
        
    end
    
    properties
        % Initialize system state 
        State = zeros(128,64); % current surface temperature
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
        function this = CAM_env_smooth5()
            % Initialize Observation settings
            
            % lat_index = 1:9:64
            ObservationInfo = rlNumericSpec([8 1]);
            ObservationInfo.Name = 'TS(lat)';
            ObservationInfo.Description = 'surface temperature';
            
            % Initialize Action settings   
            ActionInfo = rlNumericSpec([8 1]);
            ActionInfo.Name = 'MSUL_V_top(lat)';
            ActionInfo.Description = 'MSUL_V at top layer';
            
            % The following line implements built-in functions of RL env
            this=this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
            
            % Initialize property values and pre-compute necessary values
            Initialize_properties(this);
        end
        
        % Integrate for 1 year (1 step)
        function [Observation,Reward,IsDone,LoggedSignals] = ...
                step(this,Action)                                   
            LoggedSignals = [];
            this.step_num = this.step_num + 1;
            system(['echo ' '''Episode=' num2str(this.episode_num) '''']);
            system(['echo ' '''step=' num2str(this.step_num) '''']);
            year = 50 + fix((this.step_num-1)/12);
            month = mod(this.step_num,12);
            if month == 0
                month = 12;
            end
            new_pos = mod(this.step_num,this.buffer_size);
            if new_pos == 0
                new_pos = this.buffer_size;
            end
            
            % Get Geoengineering action: MSUL_V_top  
            MSUL_V_top = zeros(1,64);
            MSUL_V_top(1:64) = interp1(1:9:64,Action,1:64,'linear');
            MSUL_V_top = MSUL_V_top.* (MSUL_V_top>0);
            this.MSUL_V_top_lat = MSUL_V_top;
            MSUL_V_top = repmat(MSUL_V_top,[128,1]);
            MSUL_V = ncread(this.BNDTVAER_default_file,'MSUL_V');
            % MSUL_V(:,:,1,month) = squeeze(MSUL_V(:,:,1,month)) + MSUL_V_top;
            MSUL_V(:,:,1,:) = ...
                squeeze(MSUL_V(:,:,1,:)) + repmat(MSUL_V_top,[1,1,12]);
            ncwrite(this.BNDTVAER_file,'MSUL_V',MSUL_V);
            
            if this.step_num > 1
                this.init_file = [this.init_head, num2str(year,'%02d'),...
                    '-', num2str(month,'%02d'), '-01-00000.nc'];
                this.init_file_clm = [this.init_head_clm, num2str(year,'%02d'),...
                    '-', num2str(month,'%02d'), '-01-00000.nc'];
            end
            
            while exist(this.init_file,'file') == 0
                pause(1)
                !echo 'awaiting initial file!'
            end
            
            !echo 'initial file found!'
            
            % build namelist
            namelist_command = ...
            ['/gpfs/share/home/1800011374/CAM3_SOM/cam1/models/atm/cam/bld/build-namelist ',...
            '--csmdata /gpfs/share/home/1800011374/CAM3_SOM ',...
            '--config /gpfs/share/home/1800011374/CAM3_SOM/build_dir/config_cache.xml ',...
            '--case SRM_RL_run ',... 
            ['-namelist "&camexp nelapse=-' num2str(this.datenum(month)) ', '],...
            ['iyear_ad=20' num2str(year) ', '],...
            'co2vmr=0.0007800, ',...
            'nrefrq=0, ',...
            ['ncdata=''' this.init_file ''', '],...
            'bndtvaer=''/gpfs/share/home/1800011374/CAM3_SOM/AerosolMass_V_64x128_varying10.nc'', ',...
            'bndtvs=''/gpfs/share/home/1800011374/CAM3_SOM/sst_HadOIBl_bc_64x128_clim_SOM_c021214.nc'', ',...
            'inithist=''MONTHLY''/ ',...
            ['&clmexp finidat=''' this.init_file_clm '''/" '],...
            '-o /gpfs/share/home/1800011374/CAM3_SOM/namelist_SRM_RL10'];
            
            system(namelist_command);
            
            % run CAM for 1 month
            while exist('/gpfs/share/home/1800011374/CAM3_SOM/namelist_SRM_RL10','file') == 0
                pause(1)
                !echo 'awaiting namelist!'
            end
            
            !echo 'namelist built!'
            
            mpirun_command = ...
            ['mpirun -np 64 ',...
            '/gpfs/share/home/1800011374/CAM3_SOM/cam < ',...
            '/gpfs/share/home/1800011374/CAM3_SOM/namelist_SRM_RL10'];
        
            system(mpirun_command);
            
            % update state and get observarion
            output_file = [this.output_head, num2str(year,'%02d'), '-', ...
                num2str(month,'%02d'), '.nc'];
            
            while exist(output_file,'file') == 0
                !echo 'mpirun fails, try again!'
                system(mpirun_command);
            end
            
            !echo 'mpirun completed!'
            
            this.State = ncread(output_file,'TS');
            this.TS_buffer(:,:,new_pos) = ncread(output_file,'TS');
            this.TS_smooth = mean(mean(this.TS_buffer,3,'omitnan'),1);
            Observation = this.TS_smooth(1:9:64) - this.TS_original(1:9:64);            
            
            % save the latitude profile record
            this.TS_record(this.episode_num,this.step_num,1:64) = ...
                mean(this.State,1);
            this.TS_smooth_record(this.episode_num,this.step_num,1:64) =...
                this.TS_smooth;
            this.MSUL_V_top_record(this.episode_num,this.step_num,1:64)=...
                this.MSUL_V_top_lat;
            
            % calculate global mean TS and MSUL_V_top
            this.TS_mean(this.episode_num,this.step_num) = ...
                cal_global_mean(this,this.State);
            this.TS_smooth_mean(this.episode_num,this.step_num) = ...
                cal_global_mean(this,mean(this.TS_buffer,3,'omitnan'));
            this.MSUL_V_top_mean(this.episode_num,this.step_num) = ...
                cal_global_mean(this,MSUL_V_top);
                        
            % (optional) Check terminal condition
            IsDone = false;

            % Get reward
            Reward = getReward(this);
            !echo 'reward got!'
            this.StepReward(this.episode_num,this.step_num) = Reward;
            
            % delete namelist and rename history file!!!!
            delete('/gpfs/share/home/1800011374/CAM3_SOM/namelist_SRM_RL10');
            output_file_new = [this.output_head, num2str(year,'%02d'),...
                '-', num2str(month,'%02d'), '_copy', '.nc'];
            movefile(output_file,output_file_new);
            !> '/gpfs/share/home/1800011374/SRM_RL_CAM10/SRM_RL_run.out'
            % clear but not delete!
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
        
        % Reset environment to initial state and output initial observation
        function InitialObservation = reset(this)
            this.episode_num = this.episode_num + 1;
            this.step_num = 0;
            this.init_file = ['/gpfs/share/home/1800011374/CAM3_SOM/',...
                'output_dir/2xCO2_run.cam2.i.0050-01-01-00000.nc'];
            this.init_file_clm = ['/gpfs/share/home/1800011374/CAM3_SOM/',...
                'output_dir/2xCO2_run.clm2.i.0050-01-01-00000.nc'];
            
            load('SRM_CAM_ref.mat','TS_5yr')
            this.TS_buffer = repmat(TS_5yr,[1,1,5]);
            this.TS_smooth = mean(mean(this.TS_buffer,3,'omitnan'),1);
            this.State = this.TS_buffer(:,:,end);
            InitialObservation = ...
                this.TS_smooth(1:9:64) - this.TS_original(1:9:64);
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
            basic_data = load('basic.mat');
            this.lat = basic_data.lat;
            this.lon = basic_data.lon;
            this.ActionInfo.LowerLimit = this.Min_MSUL_V_top;
            this.ActionInfo.UpperLimit = this.Max_MSUL_V_top;
            
            load('SRM_CAM_ref.mat','TS_control','TS_2xCO2','TS_5yr');
            this.TS_original = mean(mean(TS_control,3),1);
            this.TS_2CO2 = mean(mean(TS_2xCO2,3),1);
            this.TS_initial = mean(mean(TS_5yr,3),1);      
            
        end
        
        % Reward function
        function Reward = getReward(this)
            T_diff = abs(this.TS_smooth - this.TS_original);
            Reward = -dot(cos(this.lat*pi/180),T_diff)/sum(cos(this.lat*pi/180));
            Reward = Reward/12;
        end
        
        function res = cal_global_mean(this,f)
           % f(lon,lat) 128*64
           res = dot(cos(this.lat*pi/180),mean(f,1))/sum(cos(this.lat*pi/180));
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
            axis([-90 90 this.Min_MSUL_V_top this.Max_MSUL_V_top])
            plot(this.lat,this.MSUL_V_top_lat,'-k','LineWidth',1)
            ylabel('kgm^(-2)')
            xlabel('latitude')
            title('MSUL_V_top(lat)')
            set(gca,'Fontsize',15)
            
            subplot(2,1,2)
            axis([-90 90 -6 6])
            plot(this.lat,this.TS_2CO2 - this.TS_original,'-r','LineWidth',1)
            hold on
            plot(this.lat,this.TS_initial - this.TS_original,'--k','LineWidth',1)
            hold on
            plot(this.lat,this.TS_smooth - this.TS_original,'-k','LineWidth',1)
            ylabel('K')
            xlabel('latitude')
            title('ΔTS profile')
            legend('2*CO2','initial','2*CO2+SRM')
            set(gca,'Fontsize',15)
            hold off
            
            saveas(gcf,'/gpfs/share/home/1800011374/SRM_RL_CAM10/temp.jpg')
        end
    end
end
    
