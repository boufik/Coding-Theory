function [y, err] = bec(x, er)
    
    % Simulates ALL the channel
    [y, err] = bsc(x, er);
    for i = 1:length(err)
    
        if err(i) == 1
        
            y(i) = Inf;
            
        end
        
    end

end