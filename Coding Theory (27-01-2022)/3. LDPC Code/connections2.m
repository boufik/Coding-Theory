function check_connections = connections2(H, n, chan_node)
    
    cols_H = size(H,2);
    check_connections = zeros(2, cols_H);
    
    for i = 1:cols_H
        
        if H(n,i) == 1
 
            check_connections(1,i) = 0;
            check_connections(2,i) = i;
        end
        
    end
   
    for column = 1:size(H,2)
    
        if check_connections(2, column) ~= 0  
            check_connections(:, column) = check_connections(:, column) + 1;
        end
    end
    
    check_connections = [nonzeros(check_connections(1,:))'; nonzeros(check_connections(2,:))'];
    check_connections = check_connections-1;
    
end