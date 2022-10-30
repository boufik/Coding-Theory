function minimize(x0, y0, gamma)
    
    clear all
    clc
    
    fun = @(x)100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
    x0 = [-1.2,1];
    x = fminsearch(fun,x0)
    
end