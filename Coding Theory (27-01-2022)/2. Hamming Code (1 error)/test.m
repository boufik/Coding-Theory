%% Close all figures, clear workspace and console
close all;
clear;
clc;

%% Application - Hamming Code 

n = 3;                   % rows of H  
m = 2^n - n - 1;         % message bits || rows of G
H = ham_par(n);          % Creating a Hamming Code Parity Matrix 
P = H(:, 1:(2^n-1-n));  
G = [eye(2^n-1-n) P'];   % Creating Generator Matrix
              
% Creating messages words
u_list = dec2bin(0:2^m-1)-'0';

% Creating codewords
codewords = ones(2^m,2^n-1);
rows_codewords = size(codewords, 1);
cols_codewords = size(codewords, 2);

for i = 1:rows_codewords
    codewords(i,:) = mod(u_list(i,:)*G,2); % EINAI MOD 2?
end


%% Simulating the Binary Symmetric Channel

er = 0.1;  % Channel error

in_data = codewords(randi([1 rows_codewords]),:); % Random codeword
% in_data = codewords(2,:);
x = zeros(1, cols_codewords); % x(0,1) to x(-1,0)

for i = 1:cols_codewords
    
    if in_data(i) == 0
        x(i) = 1;
    else
        x(i) = -1;
    end
    
end

[out_data,err] = bsc(in_data,er); % Passing codeword through channel
                                  % out_data: output of channel
                                  % err     : bits where errors occured
                 
                                  
y = zeros(1, cols_codewords);     % out_data(0,1) to out_data(1,-1)
for i = 1:length(out_data)
    
    if out_data(i) == 0
        y(i) = 1;
    else
        y(i) = -1;
    end
    
end


%disp("initial data is: "+num2str(in_data));
%disp("output data is: "+num2str(out_data));
disp("x = " + num2str(x))
disp("y = " + num2str(y))
disp("errors: "+num2str(sum(err)));

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
disp("Errors: " + num2str(sum(abs(x-var_values))/2));




