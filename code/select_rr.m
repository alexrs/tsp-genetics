% Modified SELECT.M, now uses round robin tournament instead of elitism

% Syntax:  SelCh = select_rr(SEL_F, Chrom, FitnV, GGAP)
%
% Input parameters:
%    SEL_F     - Name of the selection function
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    GGAP      - (optional) Rate of individuals to be selected
%                if omitted 1.0 is assumed
%
% Output parameters:
%    SelCh     - Matrix containing the selected individuals.

function SelCh = select_rr(SEL_F, Chrom, FitnV, mu)

    % Check parameter consistency
    if nargin < 3, error('Not enough input parameter'); end

    % Identify the population size (Nind)
    [NindCh,~] = size(Chrom);
    [NindF,VarF] = size(FitnV);
    if NindCh ~= NindF, error('Chrom and FitnV disagree'); end
    if VarF ~= 1, error('FitnV must be a column vector'); end

    Nind = NindCh;  

    if nargin < 4, mu = 10; end

    if nargin > 3
        if isempty(mu), mu = 10;
            elseif isnan(mu), mu = 10;
            elseif length(mu) ~= 1, error('Mu must be a scalar');
            elseif (mu < 9), error('Mu must be a scalar bigger than 9');
        end
    end
    
    %Select q random individuals
    q = zeros(10,1);
    for i=1:10
        ind = uint8( rand()*size(Chrom,1) ) ;
        q(i) = FitnV(ind); 
    end
    
    tournament = zeros(size(Chrom,1),3);
    %Tournament
    for i=1:size(Chrom,1)
        tournament(i,1) = Chrom(i);
        tournament(i,3) = FitnV(i);
        for j=1:size(q,1)
            if(FitnV(i) > q(j))
                tournament(i,2) = tournament(i,2) + 1;       
            end            
        end
    end
    
    sortedTournament = sort(tournament,1);
    sizTour = size(sortedTournament,1);
    
    SelCh = [];
    FitnVSub = sortedTournament((sizTour-mu-1):sizTour,3);
    ChrIx=feval(SEL_F, FitnVSub, mu);
    SelCh=[SelCh; Chrom(ChrIx,:)];
    
    %{
    
    
    %Choosing mu individuals    
    [maxTour,indicesTour] = sort(tournament(:),'descend');

    choosen = choosen(1:mu);
    indicesTour = sortingIndices(1:mu);
    
    %Coger los valores de chrom con los indices de indicesTour
    
    SelCh = zeros();
    SelCh=[Selch; choosen];
    
    % Select individuals from population
    FitnVSub = FitnV((1:Nind));
    ChrIx=feval(SEL_F, FitnVSub, NSel);
    SelCh=[SelCh; Chrom(ChrIx,:)];
    %}

% End of function
