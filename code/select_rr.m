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
        ind = randi(size(Chrom,1)) ;
        q(i) = FitnV(ind); 
    end
    
    %Tournament variable, only index and amount of wins is stored
    tournament = zeros(size(Chrom,1),2);
    %Tournament-> every indv compites against q rivals
    for i=1:size(Chrom,1)
        tournament(i,1) = i;
        for j=1:size(q,1)
            if(FitnV(i) > q(j))
                tournament(i,2) = tournament(i,2) + 1;       
            end            
        end
    end
    
    %Sort tournament by amount of wins
    sortedTournament = sortrows(tournament,2);
    
    %Indexes of the mu better individuals
    indexes = sortedTournament(size( ...
        sortedTournament,1)-mu:size(sortedTournament,1),1);
    
    
    SelCh = [];
    FitnVSub = FitnV(indexes);
    ChrIx=feval(SEL_F, FitnVSub, mu);
    SelCh=[SelCh; Chrom(ChrIx,:)];
       
% End of function
