function l_optimum = find_l_optimum(l_max, r_max, r_optimum)

    er = l_max/r_max;
    
    syms y
    rho_fun = @ (y) 0*y;
    for i = 1:r_max
        rho_fun = rho_fun + r_optimum(i) * y^(i-1);       % deiktes !!!!
    end
    paragwgos = diff(rho_fun);
    paragwgos = matlabFunction(paragwgos);
    rho_fun = matlabFunction(rho_fun);
    
    % CREATE THE A-MATRIX for f-function
    A_1st_part = - eye(l_max);
    x = er/10 : er/10 : 1 - er/10;
    a_matrix = zeros(length(x), l_max);
    for i = 1:length(x)
        for exponent = 1:l_max
            a_matrix(i, exponent) = (1 - rho_fun(1 - x(i))) ^ (exponent - 1);
        end
    end
%     A_3rd = zeros(1, l_max);
%     A_3rd(1) = 1;
    A = [A_1st_part; a_matrix];
    
    % CREATE THE MATRIX B
    B_1st_part = zeros(1, l_max);
    b_matrix = x / er;
%     b_3rd = 1 / (er * paragwgos(1));
    B = [B_1st_part b_matrix];
    
    % CREATE objective function f
    f = zeros(1, l_max);
    for i = 1:l_max
        f(i) = 1 / i;           % KANONIKA '+', ALLA THELOUME MINIMIZE
    end
    
    
    % CREATE matrix Aeq
    Aeq = ones(1, l_max);
    beq = 1;
    lb = zeros(1, l_max);
    ub = ones(1, l_max);
    ub(1) = 0;
    % LINPROG
    l_optimum = linprog(-f, A, B, Aeq, beq, lb, ub);
    l_optimum = l_optimum';
    
end