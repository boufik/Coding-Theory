%% Close all figures, clear workspace and console
close all;
clear;
clc;





%% Application - LDPC Code
% Stats data
l_max_list = [3, 4, 3, 4, 5, 4, 5, 4, 5, 4, 5, 6];
r_max_list = [5, 5, 6, 6, 6, 7, 7, 8, 8, 9, 9, 9];
% l_max_list = [4, 6];
% r_max_list = [6, 8];
n = 101;
LEN = length(l_max_list);
SHANNON_list = zeros(1, LEN);
EXPECTED_list = zeros(1, LEN);
DECIDED_list = zeros(1, LEN);

for MY_INDEX = 1:LEN
	
    l_max = l_max_list(MY_INDEX)
    r_max = r_max_list(MY_INDEX)
    [rate_SHANNON, rate_expected, rate_decided] = test_return(l_max, r_max, n);
    if rate_SHANNON == 0 && rate_expected == 0 && rate_decided == 0
    	% I have to drop this l_max, r_max
        l_max_list(MY_INDEX) = 0;
        r_max_list(MY_INDEX) = 0;
        SHANNON_list(MY_INDEX) = 0;
        EXPECTED_list(MY_INDEX) = 0;
        DECIDED_list(MY_INDEX) = 0;
    else
        SHANNON_list(MY_INDEX) = rate_SHANNON;
        EXPECTED_list(MY_INDEX) = rate_expected;
        DECIDED_list(MY_INDEX) = rate_decided;
    end
    
    
end



%% NONZEROS
l_list = nonzeros(l_max_list)'
r_list = nonzeros(r_max_list)'
SHANNON = nonzeros(SHANNON_list)'
EXPECTED = nonzeros(EXPECTED_list)'
DECIDED = nonzeros(DECIDED_list)'
%% PLOTS
plot3(l_list, r_list, SHANNON, 'black*');
hold on
plot3(l_list, r_list, EXPECTED, 'blacko');
hold on
plot3(l_list, r_list, DECIDED, 'black+');
title("Rates");
xlabel("Length of l_list");
ylabel("Length of r_list");
zlabel("Rates");
legend("SHANNON", "GRAPHS", "ACHIEVED");

xini = 0;
yini = 0;
xsize = 600;
ysize = 600;
set(gcf,'units','centimeters','position',[xini,yini,xsize,ysize]); 
set(gca,'FontSize',10,'FontName','Times');
print("title",'-depsc2');
grid on
