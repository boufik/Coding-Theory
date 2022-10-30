function [l_optimum, r_optimum, rate_new] = iterations(l_max, r_max)
        
    rate_real = 1 - l_max/r_max;
    rate_old = -1000;
   
    i_r = 1:r_max;
    i_l = 1:l_max;
  
    threshold = 10^(-3);
    % INITIALIZE
    r_optimum = randi([1 10], 1, r_max-1);
    r_optimum = [0 r_optimum / sum(r_optimum)];     % reguralized
    % ALGORITHMS
    l_optimum = find_l_optimum(l_max, r_max, r_optimum);
    r_optimum = find_r_optimum(l_max, r_max, l_optimum);    
    rate_calculated = 1 - (sum(i_l.*l_optimum)/sum(i_r.*r_optimum));
    rate_new = rate_calculated;
    % END OF ITERATION 1
    counter = 1;
    disp("**** COUNTER " + num2str(counter) + " ****")
    pretty_display("l_optimum: ", l_optimum)
    pretty_display("r_optimum: ", r_optimum)
    pretty_display("Real Rate: ", rate_real)
    pretty_display("Calculated Rate: ", rate_calculated)
    limit = 20;
    
    while (abs(rate_real - rate_calculated) >= threshold) && (counter < limit) ...
            && abs(rate_new - rate_old) >= threshold
        
        rate_old = rate_calculated;
        counter = counter + 1;
        disp("**** COUNTER " + num2str(counter) + " ****")
        l_optimum = find_l_optimum(l_max, r_max, r_optimum);
        r_optimum = find_r_optimum(l_max, r_max, l_optimum);
        if isempty(l_optimum) || isempty(l_optimum)
            l_optimum = zeros(1, l_max);
            r_optimum = zeros(1, l_max);
            rate_new = 0;
            return 
        end
        rate_calculated = 1 - (sum(i_l.*l_optimum)/sum(i_r.*r_optimum));
        rate_new = rate_calculated;
        pretty_display("l_optimum: ", l_optimum)
        pretty_display("r_optimum: ", r_optimum)
        pretty_display("Real Rate: ", rate_real)
        pretty_display("Calculated Rate: ", rate_calculated)
        
    end
    
    
    disp("**** DONE ****")
    pretty_display("Found l_optimum = ", l_optimum);
    pretty_display("Found r_optimum = ", r_optimum);
    pretty_display("Iterations needed: ", counter);
    
end