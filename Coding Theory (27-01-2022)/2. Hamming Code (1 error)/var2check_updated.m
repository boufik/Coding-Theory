function check_node = var2check_updated(var_nodes, check_node, pos, n)
    
    cols = length(var_nodes);
    
    for var_counter = 1:cols
        
        c = var_nodes{var_counter};
        cols_c = size(c,2);
        
        for i = 1:cols_c 
            
            columns = [1:i-1 i+1:cols_c];
            num = c(1,columns);
            
            if var_nodes{var_counter}(2,i) == n
                l = pos(var_counter) + sum(num);
                
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