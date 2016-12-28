% low level function for TSP mutation
% Representation is an integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%

function NewChrom = insertion(OldChrom)

    NewChrom = OldChrom;
    % select two positions in the tour
    rndi = zeros(1,2);
    while rndi(1) == rndi(2)
        rndi=rand_int(1,2,[1 size(NewChrom,2)]);
    end
    rndi = sort(rndi);
    
    % get the value of the first random position
    temp = NewChrom(rndi(1));
    % insert this value in the second random position
    NewChrom = insertAt(NewChrom, temp, rndi(2));
    % remove the first random position
    NewChrom(rndi(1)) = [];
    % End of function
end

function arrOut = insertAt(arr,val,index)
    if index == numel(arr)+1
        arrOut = [arr val];
    else
        arrOut = [arr(1:index-1) val arr(index:end)];
    end
end