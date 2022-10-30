function check_node_sent = check2var(check_node_receive, num_check_nodes)
    
    check_node_sent = cell(1, num_check_nodes);
    
    
    for cell_counter = 1:num_check_nodes
        c = check_node_receive{cell_counter};
        cols_c = size(c,2);
        
        for i = 1:cols_c 

            columns = [1:i-1 i+1:cols_c];
            num = c(1,columns);
            % Num is sth like this: [0 1 0 1 Inf]
            UN = unique(num);
            last = UN(end);
            if last == Inf
                l = Inf;
            else
                l = mod(sum(num), 2);
            end
            
            check_node_sent{cell_counter}(1, i) = l;
            check_node_sent{cell_counter}(2, i) ...
                = check_node_receive{cell_counter}(2, i);
            
        end
    end

end