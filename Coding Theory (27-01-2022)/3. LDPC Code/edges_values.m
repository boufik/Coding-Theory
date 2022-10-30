function var_nodes_receive = edges_values(var_nodes_receive, check_nodes_receive)
   
    n = size(check_nodes_receive,2);
    
    for i = 1:n
        
        check_node = check_nodes_receive{i};
        
        for j = 1:size(check_node, 2)
            
            value = check_node(1, j);
            index = check_node(2, j);
            
            % var_nodes_receive{index} = var_target
            for k = 1:size(var_nodes_receive{index}, 2)
                if var_nodes_receive{index}(2, k) == i
                    var_nodes_receive{index}(1, k) = value;
                    break
                end
            end
            
        end
        
    end

end
