function [l_optimum, r_optimum, rate] = find_l_optimum_ravg_new(l_max, r_max, ravg)

    er = l_max/r_max;
    
    syms y
    r = floor(ravg);
    coeff1 = r * (r + 1 - ravg) / ravg;
    coeff2 = (ravg - r * (r + 1 - ravg)) / ravg;
    rho_fun =  (coeff1 * y^(r-1) + coeff2 * y^r);
    paragwgos = diff(rho_fun);
    paragwgos = matlabFunction(paragwgos);
    rho_fun = matlabFunction(rho_fun);
    
    % CREATE THE A-MATRIX for f-function
    A_1st_part = - eye(l_max);
    x = 0 : er : 1;
    a_matrix = zeros(length(x), l_max);
    for i = 1:length(x)
        for exponent = 1:l_max
            a_matrix(i, exponent) = (1 - rho_fun(1 - x(i))) ^ (exponent-1);
        end
    end
    A_3rd = zeros(1, l_max);
    A_3rd(2) = 1;
    A = [A_1st_part; a_matrix; A_3rd];
    
    % CREATE THE MATRIX B
    B_1st_part = zeros(1, l_max);
    b_matrix = x / er;
    b_3rd = 1 / (er * paragwgos(1));
    B = [B_1st_part b_matrix b_3rd];
    
    % CREATE objective function f
    f = zeros(1, l_max);
    for i = 2:l_max
        f(i-1) = 1 / i;           % KANONIKA '+', ALLA THELOUME MINIMIZE
    end
   
    
    % CREATE matrix Aeq
    Aeq = ones(1, l_max);
    beq = 1;
%     lb = zeros(1, l_max);
%     ub = ones(1, l_max);
%     ub(1) = 0;
    % LINPROG
    l_optimum = linprog(-f, A, B, Aeq, beq);
    l_optimum = l_optimum';
    
    i_l = 1:l_max;
    i_r = 1:r_max;
    r_optimum = zeros(1, r_max);
    r_optimum(r-1) = coeff1;
    r_optimum(r) = coeff2;
    
    rate = 1 - sum(i_l.*l_optimum)/sum(i_r.*r_optimum);

end