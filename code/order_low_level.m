% low level function for calculating an offspring
% given 2 parent in the Parents - agrument
% Parents is a matrix with 2 rows, each row
% represent the genocode of the parent
%
% Returns a matrix containing the offspring


function Offspring=order_low_level(Parents)

    cols = size(Parents,2);

    Offspring=zeros(2,cols);

    start_index = rand_int(1, 1, [1, cols - 1]);
    end_index = rand_int(1, 1, [start_index + 1, cols]);

    Offspring(1, start_index:end_index) = Parents(1, start_index:end_index);
    Offspring(2, start_index:end_index) = Parents(2, start_index:end_index);


    for off=1:2
        % Create aux matrix to check the parent that has not been copied a segment
        Buff = Parents(off,:);

        members = ismember(Buff, Offspring(off, :));

        % Take only the values from aux different to zero (the values not copied in the offspring)

        Buff = Buff(members == 0);

        %Copy not used values in the offspring in the order they appear in the second parent (or first for the second round)

        % From second crossover point to the end of the vector
        
        Offspring(off, end_index+1:end) = Buff(start_index:end);
        Offspring(off, 1:start_index - 1) = Buff(1:start_index - 1);
    end
% end function



