function [rate_SHANNON, rate_expected, rate_decided] = test_return(l_max, r_max, n)

 
    %% Application - LDPC Code
    % l_max = 4;
    % r_max = 10;                          % MUST BE >= 4
    rate_SHANNON = 1 - l_max/r_max;

    init = 3.1;                         % ITS THE MINIMUM
    step = 0.2;
    last = r_max - 0.1;
    r_avg_range = init:step:last;







    %% Run 2 different simulations and select the best results
    [l_optimum1, r_optimum1, rate1] = iterations_with_avg(l_max, r_max, r_avg_range);
    [l_optimum2, r_optimum2, rate2] = iterations(l_max, r_max);


    if rate1 >= rate2 && rate1 <= rate_SHANNON
        l_optimum = l_optimum1;
        r_optimum = r_optimum1;
        rate_decided = rate1;
    elseif rate2 <= rate_SHANNON
        l_optimum = l_optimum2;
        r_optimum = r_optimum2;
        rate_decided = rate2;
    else
        display("An unexpected error occured. Not our problem, algorithm's fault");
        l_optimum = 1000 * ones(1, l_max);
        r_optimum = 1000 * ones(1, r_max);
        rate_decided = rate_SHANNON;
        return
    end

    display(' ');
    % pretty_display(" Rate 1 (average):  ", rate1);
    % pretty_display("Rate 2 (iterations):", rate2); 
    pretty_display("   Rate SHANNON:    ", rate_SHANNON); 
    pretty_display("   Rate decided:    ", rate_decided); 


    l_optimum = l_optimum(2:end)
    r_optimum = r_optimum(2:end)


    % n = 201;
    [H, num_variables, num_checks, num_edges, rate_expected, counter_tries, initial_errors, final_errors]= LDPC_simulation_stats_plots(n, l_optimum, r_optimum, "anakyklwseis");
    if isnan(H)
        
        disp("Unavailable to use this n")  
        rate_SHANNON = 0;
        rate_expected = 0;
        rate_decided = 0;
        %return
    else
        
        
        %% BEC
        % Message is the zero codeword (49) - codeword = x (200)
        er = 0.2;
        x = zeros(1, n);
        [y, err] = bec(x, er);
        disp("x = " + num2str(x))
        disp("y = " + num2str(y))
        disp("errors: " + num2str(sum(err)));       









        %% Implementing the Graph

        var_nodes = cell(1, num_variables);

        for i = 1:num_variables

           var_nodes{i} = connections(H,i,y);

        end

        check_nodes = cell(1,num_checks);

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % WS EDW OK

        for i = 1:num_checks

           check_nodes{i} = var2check(H,i,y,1);

        end

        % Iterations
        limit = 10;
        counter = 0;
        SUM_ALL = Inf;
        while (counter <= limit) && SUM_ALL == Inf

            counter = counter + 1

            if counter > 1
                for i = 1:num_checks

                    check_nodes =...
                    var2check_updated(var_nodes,check_nodes,y,i);

                end
            end

            check_to_var = check2var(check_nodes, num_checks);
            var_nodes = edges_values(var_nodes, check_to_var);
            var_rec_sum = var_rec(var_nodes, y);
            SUM_ALL = sum(var_rec_sum);


        end

        var_values = var_rec_sum;

        disp(' ')
        disp("x^ = " + num2str(var_values)); 
        disp("Initial errors: " + num2str(sum(err)));
        disp("Final errors: " + length(nonzeros(abs(x-var_values))))
        display(' ');
        pretty_display("SHANNON rate: ", rate_SHANNON);             % THEORY
        pretty_display("GRAPH rate:   ", rate_expected);            % GRAPHS = (n-k) / n
        pretty_display("ACHIEVED rate: ", rate_decided);            % Based on iterations
        perc_success100 = round((100 * rate_decided / rate_SHANNON), 2);
        disp("Success percentage: " + num2str(perc_success100) + "%");

        
    end




    
    
    
end



