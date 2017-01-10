%%%%
%{
Modifications: 

run_ga_test --> Now returns a value, minimun, does not use
the function visualizeTSP (line ~56), and takes into account which 
crossover operator is used, and whether the selection for the new offspring
is elitism or roundrobin tournament

tspgui_test --> Now runs automatically the test with the benchmark bcl380 
configuration, saves and closes the figure

test --> There are 2 sets of tests. First, specific tests, limited in
number, made with a purpose. Those tests are run with tspgui_test, using
the dataset from the benchmark bcl380, and saving the figure.
The second set is the generalistic tests, which check the 4 different 
components to be changed (aka: number of individuals, number of 
generations, elitism, and percentage of crossover and mutation), with all 
the datasets. Each test is made with a certain number of values, 
repeated *reps* (variable in the code, currently set to 5) times, and the 
mean obtained by that is the value we use for the plots.


%}
%%%%

%Clear previous existing variables
clear

%Check if folder tests exists, if not, create it
if ~exist('tests', 'dir')
  mkdir('tests');
end


%Options for Crossover (depending on the crossover, a representation will
%be choosen

%CROSSOVER = 'order_crossover';
%CROSSOVER = 'xalt_edges';


% 1 for specific tests (limited tests, with graph saving)
% 2 for benchmark (obtain just the distance)
% 3 for both
%perform_tests(3, CROSSOVER);

perform_optest();

function perform_tests(n, CROSSOVER)
    if ~exist(strcat('tests/',CROSSOVER), 'dir')
        mkdir(strcat('tests/',CROSSOVER));    
    end

    %Specific test
    if(n==1 || n==3)
        
        %Depending on the representation (crossover choosen), the data 
        % for the specific test is choosen
        if(strcmp(CROSSOVER,'order_crossover'))
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            NIND=    [50,200,1000,1250,50,50,50,1250];		
            MAXGEN=  [50,50,50,50,200,50,50,200];		
            ELITIST=0.05;    
            PR_CROSS=[.95,.95,.95,.95,.95,.1,.5,.5,.5];     
            PR_MUT=  [.05,.05,.05,.05,.05,.9,.5,.5];       
            LOCALLOOP=1;      
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        else
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            NIND=    [50,200,50,50,50,50,50,50,200,200];		
            MAXGEN=  [50,50,200,750,1000,50,50,50,200,200];		
            ELITIST=0.05;    
            PR_CROSS=[.95,.95,.95,.95,.95,.5,.20,.80,.95,.5];     
            PR_MUT=  [.05,.05,.05,.05,.05,0.5,.8,.2,.05,.5];       
            LOCALLOOP=1;      
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        end
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        upbound = size(NIND);
        for i=1:upbound(2)
            tspgui_test(CROSSOVER, NIND(i), MAXGEN(i),ELITIST(i), ...
            PR_CROSS(i),PR_MUT(i),LOCALLOOP, ...
                strcat( 'tests/', CROSSOVER,'/','general_',num2str(i) ) );
        end
        
    end %end if(n==1 || n==3)
    
    %General tests
    if(n==2 || n==3)
        
        reps = 5;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        NIND=[50,100,150,200,500,750,1000];		
        MAXGEN=[50,100,150,200,500,750,1000];		
        ELITIST=[0,0.05, 0.1, 0.25, 0.5, 0.75, 1] ;    
        STOP_PERCENTAGE=.95;    
        PR_CROSS=[0, 0.05, 0.1, 0.25, 0.5, 0.75, 1];     
        PR_MUT=[1,0.95, 0.9, 0.75, 0.5, 0.25, 0];       
        LOCALLOOP=1;      
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        datasetslist = dir('datasets/');
        datasets=cell( size(datasetslist,1)-2 ,1);
        
        upbound = size(NIND);
        modality = 0;
        
        if (strcmp(CROSSOVER,'order_crossover'))
            modality=1;
        end
        
        %possible values for each test, city configurations,# of different tests
        values = zeros(upbound(2),size(datasets,1),4); 
        
        for j=1:upbound(2)
            for i=1:size(datasets,1)
                
                datasets{i} = datasetslist(i+2).name;
                data = load(['datasets/' datasets{i}]);
                x=data(:,1)/max([data(:,1);data(:,2)]);
                y=data(:,2)/max([data(:,1);data(:,2)]);
                NVAR=size(data,1);

                
                %Tests for number of indv
                temp = zeros(reps,1);
                for n=1:reps
                    temp(n)=run_ga_test(modality, x,y,NIND(j), MAXGEN(1),...
                                    NVAR, ELITIST(1), ...
                                    STOP_PERCENTAGE, PR_CROSS(1),PR_MUT(1),...
                                    CROSSOVER,LOCALLOOP );
                end
                values(j,i,1) = median(temp)  ;
                
                
                %Tests for number of generations
                temp = zeros(reps,1);
                for n=1:reps
                    temp(n)=run_ga_test(modality,x,y,NIND(1), ...
                                MAXGEN(j),NVAR, ELITIST(1), ...
                                STOP_PERCENTAGE, PR_CROSS(1),PR_MUT(1),...
                                    CROSSOVER,LOCALLOOP );
                end
                values(j,i,2) = median(temp)  ;     
           
                %Tests for elitism
                temp = zeros(reps,1);
                for n=1:reps
                    temp(n)=run_ga_test(modality,x,y,NIND(1), MAXGEN(1), ...
                                NVAR, ELITIST(j), ...
                                STOP_PERCENTAGE, PR_CROSS(1),PR_MUT(1),...
                                    CROSSOVER,LOCALLOOP );
                end
                values(j,i,3) = median(temp)  ;
                
                %Tests for % of crossover and mutation
                temp = zeros(reps,1);
                for n=1:reps
                    temp(n)=run_ga_test(modality,x,y,NIND(1), MAXGEN(1), ...
                                NVAR, ELITIST(1), ...
                                STOP_PERCENTAGE, PR_CROSS(j),PR_MUT(j),...
                                    CROSSOVER,LOCALLOOP );
                end
                values(j,i,4) = median(temp)  ;
                
             
            end %for i=1:size(datasets,1);
        end %for n=1,size(NIND)
        
        
        %Plots
        %Number of indv plot
        nindF = figure;
        p = plot(NIND,values(:,:,1));
        xlabel('# of Individuals');
        title('Increase of number of individuals (all datasets)');
        ylabel('TSP distance');
        set(gca,'XTick', NIND);
        saveas(nindF, strcat('tests/',CROSSOVER, '/numberIndiv'), 'jpg');
        close(nindF);
        
        %Number of gen plot
        genF = figure;
        p = plot(NIND,values(:,:,2));
        xlabel('# of Generations');
        title('Increase of generations (all datasets)');
        ylabel('TSP distance');
        set(gca,'XTick', MAXGEN);
        saveas(genF, strcat('tests/',CROSSOVER, '/numberGens'), 'jpg');
        close(genF);
        
        %Elitism plot
        elitF = figure;
        p = plot(ELITIST,values(:,:,3));
        xlabel('% of elitism');
        title('Increase of elitism (all datasets)');
        ylabel('TSP distance');
        set(gca,'XTick', ELITIST);
        saveas(elitF, strcat('tests/',CROSSOVER, '/elitism'), 'jpg');
        close(elitF);
        
        %Crossover/mutation plot
        porcF = figure;
        p = plot([1:size(PR_CROSS,2)],values(:,:,4));
        xlabel('% of Crossover|Mutation');
        title('Percentage of Crossover and mutation');
        ylabel('TSP distance');
        xlab = {'0|1', '0.05|0.95', '0.1|0.9', '0.25|0.75', '0.5|0.5'...
                '0.75|0.25', '1|0'};
        set(gca,'XLim',[1 size(PR_CROSS,2)],'XTick',1:size(PR_CROSS,2) ...
            ,'XTickLabel',xlab)
        saveas(porcF, strcat('tests/',CROSSOVER, '/crossMut'), 'jpg');
        close(porcF);
        
    end %if (n==2 || n==3)
end %end of function

function perform_optest()

    %Testing optional
    datasetslist = dir('datasets/');
    datasets=cell( size(datasetslist,1)-2,1);
    for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
    end
    data = load(['datasets/' datasets{1}]);
    x=data(:,1)/max([data(:,1);data(:,2)]);
    y=data(:,2)/max([data(:,1);data(:,2)]);

    NVAR=size(data,1);
    NIND=50;		% Number of individuals
    MAXGEN=100;		% Maximum no. of generations
    NVAR=26;		% No. of variables
    SELECTION=15;    % Number of indv to be selected after tournament
    STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
    PR_CROSS=.95;     % probability of crossover
    PR_MUT=.05;       % probability of mutation
    LOCALLOOP=0;      % local loop removal
    CROSSOVER = 'order_crossover';  % default crossover operator

    val = run_ga_test(1,x,y,NIND, MAXGEN, NVAR, SELECTION, STOP_PERCENTAGE, ...
    PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP);
    display(val);
end