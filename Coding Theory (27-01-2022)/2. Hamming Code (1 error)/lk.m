function l = lk(x, y, er)

    l = zeros(1, length(x));

%     p(1|1) = 1 - er
%     p(1|-1) = er
%     
%     p(-1|1) = er 
%     p(-1|-1) = 1 - er
    
    for k = 1:length(x)
       
        if y(k) == 1
            r_k = (1 - er) / er;
        else
            r_k = er / (1 - er);
        end
        l(k) = log(r_k);
        
    end

end

