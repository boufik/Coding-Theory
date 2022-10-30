function var_connections = connections(H, n, pos)
    
    rows_H = size(H,1);
    var_connections = zeros(2, rows_H);
    
    for i = 1:rows_H
        
        if H(i, n) == 1
 
            var_connections(1,i) = 0; % pos(i);
            var_connections(2,i) = i;
        end
        
    end
   
    for column = 1:size(H,1)
    
        if var_connections(2, column) ~= 0  
            var_connections(:, column) = var_connections(:, column) + 1;
        end
    end
    
    var_connections = [nonzeros(var_connections(1,:))'; nonzeros(var_connections(2,:))'];
    var_connections = var_connections-1;
    
end