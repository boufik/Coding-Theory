function l_optimum = find_l_optimum_ravg(l_max, r_max, er, ravg)

    syms y
    r = floor(ravg);
    coeff1 = r * (r + 1 - ravg) / ravg;
    coeff2 = (ravg - r * (r + 1 - ravg)) / ravg;
    rho_fun =  (coeff1 * y^(r-1) + coeff2 * y^r)
    paragwgos = diff(rho_fun);
    paragwgos = matlabFunction(paragwgos);
    rho_fun = matlabFunction(rho_fun);
    
    % CREATE THE A-MATRIX for f-function
    A_1st_part = - eye(l_max - 1);
    x = er/10 : er/10 : er - er/10;
    a_matrix = zeros(length(x), l_max - 1);
    for i = 1:length(x)
        for exponent = 2:l_max
            a_matrix(i, exponent - 1) = (1 - rho_fun(1 - x(i))) ^ (exponent - 1);
        end
    end
    A_3rd = zeros(1, l_max-1);
    A_3rd(1) = 1;
    A = [A_1st_part; a_matrix; A_3rd]
    
    % CREATE THE MATRIX B
    B_1st_part = zeros(1, l_max-1);
    b_matrix = x / er;
    b_3rd = 1 / (er * paragwgos(1));
    B = [B_1st_part b_matrix b_3rd]
    
    % CREATE objective function f
    f = zeros(1, l_max - 1);
    for i = 2:l_max
        f(i-1) = 1 / i;           % KANONIKA '+', ALLA THELOUME MINIMIZE
    end
    f;
    
    % CREATE matrix Aeq
    Aeq = ones(1, l_max - 1);
    beq = 1;
    lb = zeros(1, l_max - 1);
    ub = ones(1, l_max - 1);
    ub(1) = 0;
    % LINPROG
    l_optimum = linprog(-f, A, B, Aeq, beq);
    l_optimum = l_optimum';

end