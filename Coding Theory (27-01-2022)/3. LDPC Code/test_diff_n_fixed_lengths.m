%% Close all figures, clear workspace and console
close all;
clear;
clc;





%% Application - LDPC Code
l_max = 4;
r_max = 6;                          % MUST BE >= 4
rate_SHANNON = 1 - l_max/r_max;

init = 3.1;                         % ITS THE MINIMUM
step = 0.2;
last = r_max-0.1;
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


begin_n = 101;
end_n = 301;
step_n = 5;
n_list = begin_n : step_n : end_n;
all_n = floor((end_n - begin_n) / step_n) + 1;

for index = 1:length(n_list)
    n = n_list(index);
    [H, num_variables, num_checks, num_edges, rate_expected, counter_tries, initial_errors, final_errors]= LDPC_simulation_stats_plots(n, l_optimum, r_optimum, "find_appropriate_n");
    if isnan(H)
        n_list(index) = 0;
    end
end


% if isnan(H)
%     disp("Unavailable to use this n")
%     return
% end 













%% Our data - stats variables
n_list = nonzeros(n_list);
LEN = length(n_list);
er = 0.1;
var_num_list = zeros(1, LEN);
check_num_list = zeros(1, LEN);
edges_num_list = zeros(1, LEN);
rates_list = zeros(1, LEN);
tries_list = zeros(1, LEN);
initial_list = zeros(1, LEN);
final_list = zeros(1, LEN);




% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for INDEX = 1:LEN
    
    
    
    n = n_list(INDEX);
    [H, num_variables, num_checks, num_edges, rate_expected, counter_tries, initial_errors, final_errors]= LDPC_simulation_stats_plots(n, l_optimum, r_optimum, "anakyklwseis");
    
    
    
    
    %% Implementing the BEC and Graph
    x = zeros(1, n);
    [y, err] = bec(x, er);
    var_nodes = cell(1, num_variables);

    for i = 1:num_variables    
       var_nodes{i} = connections(H,i,y);    
    end

    check_nodes = cell(1,num_checks);

    for i = 1:num_checks   
       check_nodes{i} = var2check(H,i,y,1);
    end

    % Iterations
    limit = 100;
    counter = 0;
    SUM_ALL = Inf;
    while (counter <= limit) && SUM_ALL == Inf

        counter = counter + 1;    
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
    initial_errors = sum(err);
    final_errors = length(nonzeros(abs(x-var_values)));
    
    % FOR STATISTICS PURPOSE
    var_num_list(INDEX) = num_variables;
    check_num_list(INDEX) = num_checks;
    edges_num_list(INDEX) = num_edges;
    rates_list(INDEX) = rate_expected;
    tries_list(INDEX) = counter_tries;
    initial_list(INDEX) = initial_errors;
    final_list(INDEX) = final_errors;
    
    
    
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% STATS
display(' ');
display(' ');
pretty_display("      Appropriate n list:      ", n_list');
pretty_display("Num of variables nodes list:   ", var_num_list);
pretty_display("   Num of check nodes list:    ", check_num_list);
pretty_display("      Num of edges list:       ", edges_num_list);
pretty_display("     Expected rate list:       ", rates_list);
pretty_display("Tries to find NO RECYCLE list: ", tries_list);
pretty_display("       Initial errors list:    ", initial_list);
pretty_display("       Final errors list:      ", final_list);
display(' ');

appropriate_n = length(n_list);
perc100 = round(100 * appropriate_n / all_n, 2);
disp("In the interval [" + num2str(begin_n) + ", " + num2str(end_n) + "] with step = " + num2str(step_n) + ": ");
disp("There are " + num2str(appropriate_n) + "/" + num2str(all_n) + ... 
    " values of 'n', that can be used for this LDPC code.");
disp("Percentage = " + num2str(perc100) + "%");

    
%% PLOTS
figure(1);
plot(n_list, var_num_list, 'blackx-');
title("Graph characteristics");
xlabel("n = message length (variables)");
ylabel("Var, check, edges");
hold on
plot(n_list, check_num_list, 'blacko-');
hold on
plot(n_list, edges_num_list, 'black');
legend("Variables", "Checks", "Edges");

figure(2);
plot(n_list, rates_list, 'black');
title("Transmission rate 'r'");
xlabel("n = message length (variables)");
ylabel("Rate = r = r(n)");

figure(3);
plot(n_list, tries_list, 'black');
title("Tries until perfect graph");
xlabel("n = message length (variables)");
ylabel("Tries = Tries(n)");

figure(4);
ideal_list = n_list * er;
plot(n_list, initial_list, 'black');
hold on
plot(n_list, ideal_list, 'black*-');
hold on
plot(n_list, final_list, 'blacko-');
title("Initial and final codeword errors");
xlabel("n = message length (variables)");
ylabel("Errors in codeword");
legend("Initial errors", "Expected errors" ,"Final errors");

xini = 0;
yini = 0;
xsize = 600;
ysize = 600;
set(gcf,'units','centimeters','position',[xini,yini,xsize,ysize]); 
set(gca,'FontSize',10,'FontName','Times');
print("title",'-depsc2');
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

