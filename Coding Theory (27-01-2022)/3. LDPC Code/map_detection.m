function y = map_detection(var_nodes_receive)
    
    y = zeros(1, length(var_nodes_receive));
    
    for i = 1:length(var_nodes_receive)
        
        if var_nodes_receive(i) > 0
            y(i) = 1;
            
        else if var_nodes_receive(i) < 0
            y(i) = -1;
            
        else
            r = (-1) ^ randi([0 1]);
            y(i) = r;
        end
           
    end

end