function [l_optimum, r_optimum, rate_calculated] = iterations_with_avg(l_max, r_max, r_avg_range)
        
    rate_real = 1 - l_max/r_max;
    all_rates = zeros(1, length(r_avg_range));
    
    % ALGORITHMS   
    for index = 1:length(r_avg_range)
   
        [~, ~, rate_calculated]...
                    = find_l_optimum_ravg_new(l_max, r_max, r_avg_range(index));
        all_rates (index) = rate_calculated;
    end
    
    [~, max_index] = max(all_rates); 
    
    opt_ravg = r_avg_range(max_index);
    [l_optimum, r_optimum, rate_calculated]...
                    = find_l_optimum_ravg_new(l_max, r_max, opt_ravg);
   
    disp("**** DONE ****")
    pretty_display("Found l_optimum = ", l_optimum);
    pretty_display("Found r_optimum = ", r_optimum);
    pretty_display("REAL rate = ", rate_real);
    pretty_display("CALC rate = ", rate_calculated);
    
end