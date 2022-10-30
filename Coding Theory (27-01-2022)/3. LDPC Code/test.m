%% Close all figures, clear workspace and console
close all;
clear;
clc;

%% Application - Hamming Code
%l_max = 3;
%r_max = 6;
l_optimum = [0.3, 0.5, 0.2];         
r_optimum = [0.2, 0.2, 0.1, 0.1, 0.3, 0.1];
l_optimum = [0, 0.4863, 0, 0.5137];
r_optimum = [0, 0, 0.1608, 0.8149, 0, 0.0242];
l_optimum = l_optimum(2:end);
r_optimum = r_optimum(2:end);




n = 202;
[H, num_variables, num_checks]= LDPC_simulation(n, l_optimum, r_optimum);

if isnan(H)
    disp("Unavailable to use this n")
    return
end 



er = 0.2;
% Message is the zero codeword (49) - codeword = x (200)
x = zeros(1, n);
[y, err] = bec(x, er);
disp("x = " + num2str(x))
disp("y = " + num2str(y))
disp("Initial errors: " + num2str(sum(err)));       
                                  


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

disp(' ')
disp("x^ = " + num2str(var_values)); 
% disp("Initial errors: " + num2str(sum(err)));
disp("Final errors: " + length(nonzeros(abs(x-var_values))))





