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

    Offspring(1, start_index:end_index) = Parents(2, start_index:end_index);
    Offspring(2, start_index:end_index) = Parents(1, start_index:end_index);


    for off=1:2
        Buff = Parents(off,:);
        Buff = [Buff(end_index+1:end), Buff(1:end_index)];

        members = ismember(Buff, Offspring(off, :));
        Buff(members == 1) = 0;
        
        ii = 1;
        X = find(Buff);
        for jj=1:start_index - 1
           if Buff(X(ii)) ~= 0
              Offspring(off, jj) = Buff(X(ii));
              Buff(X(ii)) = 0;
              ii = mod(ii, cols) + 1;
           end
        end
        
        ii = 1;
        X = find(Buff);
        for jj=end_index + 1:cols
           if Buff(X(ii)) ~= 0
              Offspring(off, jj) = Buff(X(ii));
              Buff(X(ii)) = 0;
              ii = mod(ii, cols) + 1;
           end
        end
        %Offspring(off, end_index+1:end) = Buff(start_index:end);
        %Offspring(off, 1:start_index - 1) = Buff(1:start_index - 1);
    end
% end function



