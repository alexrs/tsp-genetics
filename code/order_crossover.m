% Syntax:  NewChrom = order_crossover(OldChrom, XOVR)
%
% Input parameters:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%                (in any form, not necessarily real values).
%    XOVR      - Probability of recombination occurring between pairs
%                of individuals.
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
%

function NewChrom = order_crossover(OldChrom, XOVR)

if nargin < 2, XOVR = NaN; end
[rows,~]=size(OldChrom);
   
   maxrows=rows;
   if rem(rows,2)~=0
	   maxrows=maxrows-1;
   end
   
   for row=1:2:maxrows
	
    % crossover of the two chromosomes
   	% results in 2 offsprings
	if rand<XOVR			% recombine with a given probability
        MatrixChrom = order_low_level([OldChrom(row,:);OldChrom(row+1,:)]);
		NewChrom(row,:) = MatrixChrom(1, :);
		NewChrom(row+1,:) = MatrixChrom(2, :);
	else
		NewChrom(row,:) = OldChrom(row,:);
		NewChrom(row+1,:) = OldChrom(row+1,:);
	end
   end

   if rem(rows,2) ~= 0
	   NewChrom(rows,:)=OldChrom(rows,:);
   end

% End of function
