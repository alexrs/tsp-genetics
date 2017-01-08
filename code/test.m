%%%%
%{
Modifications: 

run_ga_t --> Now returns a value, minimun, and does not use
the function visualizeTSP (line ~56). 

tspgui_t --> Now runs automatically the test with the first citis 
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

%CROSSOVER = 'order_crossover';
%CROSSOVER = 'xalt_edges';

% 1 for specific tests (limited tests, with graph saving)
% 2 for benchmark (obtain just the distance)
% 3 for both
%perform_tests(3, CROSSOVER);


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
PRECI=1;		% Precision of variables
ELITIST=15;    % percentage of the elite population
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'order_crossover';  % default crossover operator

run_ga(x,y,NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, ...
    PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP)



function perform_tests(n, CROSSOVER)
    if ~exist(strcat('tests/',CROSSOVER), 'dir')
        mkdir(strcat('tests/',CROSSOVER));    
    end

    if(n==1 || n==3)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        NIND=[50,150,50,50,50,50,100,150];		% Number of individuals
        MAXGEN=[100,100,300,100,100,100,100,150];		% Maximum no. of generations
        ELITIST=[0.05,0.05,0.05,0.05,0.05,0.3,0.2,0.1];    % perce ntage of the elite population
        PR_CROSS=[.95,.95,.95,.80,.20,.95,.85,.2];     % probability of crossover
        PR_MUT=[.05,.05,.05,.2,.8,.05,.15,.8];       % probability of mutation
        LOCALLOOP=1;      % local loop removal
        
        %Name of tests
        name = {'base','higherComputCost_1','higherComputCost_2',...
                'exploVexplo_1','exploVexplo_2'...
                'theBest', 'mix', 'mix_2'};

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        upbound = size(name);
        for i=1:upbound(2)
            tspgui_test(CROSSOVER, NIND(i), MAXGEN(i),ELITIST(i), ...
            PR_CROSS(i),PR_MUT(i),LOCALLOOP, ...
                strcat( 'tests/', CROSSOVER,'/','general_',num2str(i) ) );
        end
        
    end %end if(n==1 || n==3)
    
    if(n==2 || n==3)
        
        reps = 5;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        NIND=[50,100,150,200,500,750,1000];		% Number of individuals
        MAXGEN=[50,100,150,200,500,750,1000];		% Maximum no. of generations
        ELITIST=[0,0.05, 0.1, 0.25, 0.5, 0.75, 1] ;    % percentage of the elite population
        STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
        PR_CROSS=[0, 0.05, 0.1, 0.25, 0.5, 0.75, 1];     % probability of crossover
        PR_MUT=[1,0.95, 0.9, 0.75, 0.5, 0.25, 0];       % probability of mutation
        LOCALLOOP=1;      % local loop removal
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        datasetslist = dir('datasets/');
        datasets=cell( size(datasetslist,1)-2 ,1);
        
        upbound = size(NIND);
        modality = 0;
        
        if (CROSSOVER == 'order_crossover')
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
        %values
        end %for n=1,size(NIND)
        
        %values
        
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
        
    end %if
end