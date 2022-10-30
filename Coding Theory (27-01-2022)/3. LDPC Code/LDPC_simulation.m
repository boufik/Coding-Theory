function [H, num_variables, num_checks, rate_expected]= LDPC_simulation(n, l_optimum, r_optimum)

    %% Estw oti brhkame ta PANTA SWSTA
    l_max = length(l_optimum);
    r_max = length(r_optimum);

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % MPOREI NA MIN BGOUN AKERAIOI!!!

    % l_optimum = [0.3, 0.5, 0.2];         
    % r_optimum = [0.2, 0.2, 0.1, 0.1, 0.3, 0.1];
    % n = 200;


    %% Create Pi dia i and Lamda i dia i
    r_i_dia_i_list = zeros(1, r_max);
    l_i_dia_i_list = zeros(1, l_max); 
    for index = 1:r_max
        r_i_dia_i_list(index) = r_optimum(index) / (index + 1);     % Epeidi arxizei apo to 2 enw emeis apo to 1
    end

    for index = 1:l_max
        l_i_dia_i_list(index) = l_optimum(index) / (index + 1);
    end
    SUM = sum(l_i_dia_i_list);

    r_i_dia_i_list;
    l_i_dia_i_list;

    %% Create LAMDA AND RHO LISTS
    RHO = r_i_dia_i_list / SUM * n;
    LAMDA = l_i_dia_i_list / SUM * n;
    RHO_HAT = floor(RHO);
    LAMDA_HAT = floor(LAMDA);
    % Calculate A
    A_condition = sum(RHO - RHO_HAT);


    %% GENERAL CONSTRAINTS
    % Declare 2 sum constant variables
    constant_19 = n - sum(LAMDA_HAT);
    i_r = 2:r_max+1;
    i_l = 2:l_max+1;
    constant_20 = sum(i_r .* RHO_HAT) - sum(i_l .* LAMDA_HAT);

    % Prwta stoixeia ta "l", kai meta ta "r"
    Aeq = zeros(2, l_max + r_max);
    Beq = zeros(2, 1);

    % Constraint 19
    Aeq(1, 1:l_max) = 1;
    Beq(1, 1) = constant_19;
    % Constraint 20
    Aeq(2, 1:l_max) = i_l;
    Aeq(2, l_max+1 : l_max+r_max) = - i_r;
    Beq(2, 1) = constant_20;
    % Constraint 21


    %% CASE CONSTRAINTS
    % CASE 1 -  ANISOTIKOS - MATRIX A1
    A1 = zeros(1, l_max + r_max);
    A1(1, l_max+1 : l_max+r_max) = -1;
    B1 = -ceil(A_condition);

    % CASE 2
    A2 = zeros(1, l_max + r_max);
    A2(1, l_max+1 : l_max+r_max) = 1;
    B2 = floor(A_condition);

    % OBJECTIVE FUNCTIONS
    % CASE 1
    f1 = zeros(1, l_max + r_max);
    f1(1, l_max+1 : l_max+r_max) = 1;
    f1 = f1';

    % CASE 2
    f2 = -f1;


    %% SIMULATIONS
    lb = zeros(1, l_max + r_max)';
    ub = ones(1, l_max + r_max)';
    
    intcon = 1:l_max + r_max;
    % CASE 1
    result1 = intlinprog(f1, intcon, A1, B1 , Aeq, Beq, lb, ub);
    % CASE 2
    result2 = intlinprog(f2, intcon, A2, B2 , Aeq, Beq, lb, ub);
    
    if isempty(result1) && isempty(result2) 
        H = NaN;
        num_variables = NaN;
        num_checks = NaN;
        rate_expected = 0;
        disp("Not possible solution found - exit code 1")
        return 
    end
%     % CASE 1
%     result1 = linprog(f1, A1, B1 , Aeq, Beq, lb, ub);
%     % CASE 2
%     result2 = linprog(f2, A2, B2 , Aeq, Beq, lb, ub);

    %% FIND THE BEST
    
    if isempty(result1)
        
        result = result2;
    elseif isempty(result2)
        
        result = result1;
    else
         error1 = (sum(result1(l_max+1 : l_max+r_max)) - A_condition) ^ 2;
         error2 = (sum(result2(l_max+1 : l_max+r_max)) - A_condition) ^ 2;
         if error1 >= error2
            result = result2;
         else
            result = result1;
         end
    end
    
   
    % result = [xl1, xl2, xl3, xr1, ..., xr6] ---> length = 9


    %% FIND THE NEW LAMDA AND RHO - UPDATE
    result = floor(result');
    LAMDA_LIST = LAMDA_HAT + result(1 : l_max);
    RHO_LIST = RHO_HAT + result(l_max + 1 : l_max + r_max);
    
    
    
    
    
    
    

    %% DISPLAY AKMES
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % MPOREI KAPOIA NOUMERA NA MIN EINAI INTEGERS, ENW ANAPARISTOUN # AKMWN !
    num_variable_edges = sum(LAMDA_LIST .* i_l);
    num_check_edges = sum(RHO_LIST .* i_r);
    num_variables = sum(LAMDA_LIST);
    num_checks = sum(RHO_LIST);
    %   Above: L'(1) = P'(1)  (sxesh 2 kai 3)

    if num_check_edges ~= num_variable_edges
        H = NaN;
        num_variables = NaN;
        num_checks = NaN;
        rate_expected = 0;
        disp("Not possible solution found - exit code 2")
        return 
    end
        
    pretty_display("n = ", n);
    pretty_display("Variable degrees = ", LAMDA_LIST);
    pretty_display("Check degrees = ", RHO_LIST);
    pretty_display("Num of variable edges = ", num_variable_edges);
    pretty_display("Num of check edges = ", num_check_edges);
    pretty_display("Num of VARIABLES = ", num_variables);
    pretty_display("Num of CHECKS = ", num_checks);



    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    %% MATRIX 545 x 545 (about sockets)
    sockets = num_check_edges;
    checks = num_checks;
    vars = num_variables;
    comb1 = 1:sockets;

    %% Create a vector with 82 2's and 91 3's and 27 4's (n=200)
    var_temp = zeros(1, vars);
    counter = 1;
    for i = 1:length(LAMDA_LIST)
        var_temp(counter : counter + LAMDA_LIST(i) - 1) = ...
        (i+1) * ones(1, LAMDA_LIST(i));
        counter = LAMDA_LIST(i) + counter;
    end
    
    check_temp = zeros(1, checks);
    counter = 1;
    for i = 1:length(RHO_LIST)
        check_temp(counter : counter + RHO_LIST(i) - 1) = ...
        (i+1) * ones(1, RHO_LIST(i));
        counter = RHO_LIST(i) + counter;
    end

    %% ACCUMULATIVE RANGES
    var_ranges = zeros(1, length(var_temp));
    var_ranges = [0 var_ranges];

    for i = 1:length(var_temp)
        S = var_ranges(i) + var_temp(i);
        var_ranges(i+1) = S;
    end

    check_ranges = zeros(1, length(check_temp));
    check_ranges = [0 check_ranges];

    for i = 1:length(check_temp)
        S = check_ranges(i) + check_temp(i);
        check_ranges(i+1) = S;
    end






    anakyklwseis = 1000;
    H = zeros(checks, vars);
    counter_tries = 0;

    
    
    
    
    %% WHILE LOOP IN ORDER TO AVOID ANAKYKLWSEIS
    while anakyklwseis ~= 0

        counter_tries = counter_tries + 1;
        socket_matrix = zeros(sockets);
        % Socket Matrix is 545 x 545   
        comb2 = comb1(randperm(length(comb1)));
        for i = 1:sockets
            ch = comb1(i);
            var = comb2(i);
            socket_matrix(ch, var) = 1;
        end


        %% Decomposition onto submatrices - Creation of matrix
        % var_ranges and check-ranges have 1 more element (0 in the beginning)
        % socket_matrix = randi([0 1], 6, 9)
        % check_ranges = [0, 1, 3, 6]
        % var_ranges = [0, 2, 4, 6, 9]
        % H = zeros(3, 4);

        for i = 1:length(check_ranges) - 1
            for j = 1:length(var_ranges) - 1
                i;
                j;
                rows_range = check_ranges(i)+1 : + check_ranges(i+1);
                cols_range = var_ranges(j)+1 : var_ranges(j+1);
                submatrix = socket_matrix(rows_range, cols_range);
                SUM = sum(sum(submatrix));
                H(i, j) = mod(SUM, 2);
            end
        end


        anakyklwseis = num_variable_edges - sum(sum(H));
        pretty_display("Anakyklwseis: ", anakyklwseis / 2);

    end

    disp(' ');
    pretty_display("Anakyklwseis: ", anakyklwseis / 2);
    pretty_display("Tries needed: ", counter_tries);
    n = num_variables;
    k = num_variables - num_checks;
    rate_expected = k / n;
    pretty_display("Rate based on graph: ", rate_expected);

    
end

