function r_optimum = find_r_optimum(l_max, r_max,l_optimum)
    
	er = l_max/r_max;
    syms y
    l_fun = @ (y) 0*y;
    for i = 1:l_max
        l_fun = l_fun + l_optimum(i) * y^(i-1);     % deiktes !!!!
    end
    paragwgos = diff(l_fun);
    paragwgos = matlabFunction(paragwgos);
    l_fun = matlabFunction(l_fun);
    
    % CREATE THE A-MATRIX for f-function
    A_1st_part = - eye(r_max);
    y = er/10 : er/10 : 1 - er/10;
    a_matrix = zeros(length(y), r_max);
    for i = 1:length(y)
        for exponent = 1:r_max
            a_matrix(i, exponent) = - (1 - er * l_fun(y(i))) ^ (exponent-1);
        end
    end
%     A_3rd = zeros(1, r_max);
%     A_3rd(1) = 1;
    A = [A_1st_part; a_matrix];
    
    % CREATE THE MATRIX B
    B_1st_part = zeros(1, r_max);
    b_matrix = (y - 1);
%     b_3rd = 1 / (er * paragwgos(1));
    B = [B_1st_part b_matrix];
    
    % CREATE objective function f
    f = zeros(1, r_max);
    for i = 1:r_max
        f(i) = 1 / i;           % PARAMENEI ME '+', GIATI THELW MINIMIZE
    end
    
    
    % CREATE matrix Aeq
    Aeq = ones(1, r_max);
    beq = 1;
    lb = zeros(1, r_max);
    ub = ones(1, r_max);
    ub(1) = 0;
    % LINPROG
    r_optimum = linprog(f, A, B, Aeq, beq, lb, ub);
    r_optimum = r_optimum';
    
end