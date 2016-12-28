%
% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in path
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%	ObjVal is a vector with the fitness values for each candidate tour 
%   (=each row of Phen)
%

function ObjVal = tspfun(Phen, Dist)
    % the objective function works with adjacency representation. In this
    % version, path representation is used, so the fitness function should
    % be adapted. Now, the phenotype is converted to adjacency
    % representation first, and then, the Objective Value is computed as it
    % was computed in the original version.
    adj = zeros(size(Phen));
    for row=1:size(Phen)
       adj(row,:) = path2adj(Phen(row,:));
    end
    
    ObjVal = Dist(adj(:,1), 1);
	for t=2:size(adj,2)  
    	ObjVal=ObjVal + Dist(adj(:,t), t);
	end

% End of function

