function var_receive = var_rec(var_nodes, y)
    
    cols = length(var_nodes);
    var_receive = zeros(1,length(var_nodes));
    
    for var_counter = 1:cols
        
        c = var_nodes{var_counter};
        cols_c = size(c,2);
        
        columns = 1:cols_c;
        num = [c(1,columns) y(var_counter)];
        % Num is a vector with 0 or 1 or Inf
        UN = unique(num);
        % UN will be in form [0] or [1] or [Inf]   or  [0 Inf] or [1 Inf]
        if length(UN) == 1
            % l = sending value
            l = UN;
        else
            l = UN(1);
        end

        var_receive(var_counter) = l;
              
    end

end


