function y = ham_par(n)
%HAM_PAR returns a hamming code parity matrix in
% systematic form
% n: size of codewords {(2^n)-1 permutations excluding
%    the zero codeword}

    y = dec2bin(1:2^n-1)-'0';
    y = flip(y');
    
    for i = 1:n
        
        column = 2^(i-1);
        temp = y(:,end-n+i);
        y(:,end-n+i) = y(:,column);
        y(:,column) = temp;
    end
    
end