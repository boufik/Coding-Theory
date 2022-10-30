function check_node = var2check_updated(var_nodes, check_node, y, n)
    
    cols = length(var_nodes);
    
    
    for var_counter = 1:cols
        
        c = var_nodes{var_counter};
        cols_c = size(c,2);
        
        for i = 1:cols_c 
            
            columns = [1:i-1 i+1:cols_c];
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
            
            
            if var_nodes{var_counter}(2,i) == n
                
                for j = 1:size(check_node{n},2)
                    
                    if check_node{n}(2, j) == var_counter
                        
                        check_node{n}(1, j) = l;
                        break 
                    end
                end
                
                break
            end     
        end
    end

end