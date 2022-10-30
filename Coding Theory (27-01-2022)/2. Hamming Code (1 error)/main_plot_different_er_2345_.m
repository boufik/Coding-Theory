%% Close all figures, clear workspace and console
close all;
clear;
clc;

%% NICE COMBINATIONS
% n = 2 and er = 0.3
% n = 3 and er = 0.1
% n = 4 and er = 0.05
% n = 5 and er = 0.01

%% Application - Hamming Code
target = 500;
n_List = [2, 3, 4, 5];
er_List = [0.3, 0.1, 0.05, 0.01]
percentage100_List = zeros(1, length(n_List));
for i = 1:length(n_List)
    n = n_List(i); 
    er = er_List(i);
    percentage100 = HAMMING(n, er, target);
    percentage100_List(i) = percentage100;
end
n_List
er_List
percentage100_List

subplot(1, 2, 1);
plot(n_List, er_List, 'black');
title("Each 'm' matches a special 'er'");
xlabel('m');
ylabel('Error rate: er = er(m)');

subplot(1, 2, 2);
plot(n_List, percentage100_List, 'black');
title("Percentage of correction of a single bit");
xlabel('m');
ylabel('Percentage (%) of correction');

xini = 0;
yini = 0;
xsize = 600;
ysize = 600;
set(gcf,'units','centimeters','position',[xini,yini,xsize,ysize]); 
set(gca,'FontSize',10,'FontName','Times');
print("title",'-depsc2');



% Auxiliary Function
function y = HAMMING(n, er, target)

    %% Application - Hamming Code 
    m = 2^n - n - 1;         % message bits || rows of G
    H = ham_par(n);          % Creating a Hamming Code Parity Matrix 
    P = H(:, 1:(2^n-1-n));  
    G = [eye(2^n-1-n) P'];   % Creating Generator Matrix

    % Creating messages words
    cols_codewords = 2^n - 1;
    rows_codewords = 2^m;


    %% Create the stats
    counter_rounds = 0;
    num_of_corrections = 0;

    while counter_rounds < target

        %% Simulating the Binary Symmetric Channel
        u = dec2bin(randi([0 2^m-1]), m) - '0';
        in_data = mod(u*G,2);
        x = zeros(1, cols_codewords); % x(0,1) to x(-1,0)

        for i = 1:cols_codewords    
            if in_data(i) == 0
                x(i) = 1;
            else
                x(i) = -1;
            end   
        end

        [out_data,err] = bsc(in_data,er);              
        initial_errors = sum(err);




        if initial_errors == 1

            counter_rounds = counter_rounds + 1;
            disp("******** Counter " + num2str(counter_rounds) + " ********");
            %% Begin the process
            y = zeros(1, cols_codewords);     % out_data(0,1) to out_data(1,-1)
            for i = 1:length(out_data)   
                if out_data(i) == 0
                    y(i) = 1;
                else
                    y(i) = -1;
                end    
            end

            %% Print the state
            disp("x = " + num2str(x));
            disp("y = " + num2str(y));
            disp("Initial errors: "+num2str(initial_errors));

            %% Implementing the Graph

            pos = lk(x, y, er);   % old chan_node 
            var_nodes = cell(1, 2^n-1);
            for i = 1:2^n-1

               var_nodes{i} = connections(H,i,pos);

            end
            check_nodes = cell(1,n);

            for i = 1:n
               check_nodes{i} = var2check(H,i,pos,0);
            end

            % Iterations
            limit = 100;
            counter = 0;
            SUM = -1;
            while (counter <= limit) && SUM ~= 0

                counter = counter + 1;

                for i = 1:n
                    check_nodes =...
                    var2check_updated(var_nodes,check_nodes,pos,i);
                end

                check_to_var = check2var(check_nodes, n);
                var_rec_sum = var_rec(check_to_var, pos); 
                var_values = map_detection(var_rec_sum);
                % x^ = 1 - 2x => x = (1 - x^) / 2
                % x = x, x^ = var_values
                var_values_01 = (1 - var_values) / 2;
                temp = mod(H*var_values_01',2);
                SUM = sum(temp);
                var_nodes =...
                edges_values(var_nodes, check_to_var);

            end

            disp(' ')
            %disp("x^= " + num2str(var_values));
            %disp("x = " + num2str(x))
            disp("x = " + num2str(in_data));
            disp("x^= " + num2str(var_values_01));
            final_errors = sum(abs(x-var_values))/2;
            disp("Final errors: " + num2str(final_errors));
            display("**********************")
            display(' ')
            if final_errors == 0
                num_of_corrections = num_of_corrections + 1;
            end

        end

    end


    %% Display overall stats
    disp("Iterations: " + num2str(target));
    disp("Corrected codewords with 1 initial mistake: " + num2str(num_of_corrections))
    percentage100 = 100 * num_of_corrections / target;
    disp("Percentage of correction: " + num2str(percentage100) + "%");
    y = percentage100;
    
end




