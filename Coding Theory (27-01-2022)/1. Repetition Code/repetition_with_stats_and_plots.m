%% Close all figures, clear workspace and console
close all;
clear;
clc;


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Application - Repetition Code
%% Create the data
counter_rounds = 0;
target = 100;
num_of_corrections = 0;
er = 0.1;
repeat = 3;
LEN = 30;
%% Create the stats
rounds_list = 1:target;
xy_mistakes_list = zeros(1, target);
message_mistakes_list = zeros(1, target);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% MAIN FUNCTION - PLOTS
while counter_rounds < target
    
    counter_rounds = counter_rounds + 1;
    disp("******** Counter " + num2str(counter_rounds) + " ********");
    
    %% Simulating the Repetition
    message = randi([0 1], 1, LEN);
    x = zeros(1, repeat * LEN);
    for i = 1:LEN
        for j = 1:repeat
            x(j + (i - 1)*repeat) = message(i);
        end
    end
    % Example
    % message = [1, 0, 1]
    % x = [1,1,1, 0,0,0, 1,1,1]
    
    [y, err] = bsc(x,er);
    message_guess = zeros(1, LEN);
    % This is not a Hamming code, so it can correct many errors
    for i = 1:LEN
        bitstream = y((i-1)*repeat + 1 : i*repeat);
        SUM = sum(bitstream);
        if SUM > repeat / 2
            bit_guess = 1;
        elseif SUM < repeat / 2
            bit_guess = 0  ;  
        else
            bit_guess = randi([0 1]);
        end
        message_guess(i) = bit_guess;
    end
    x;
    y;
    message_guess;
    % Mistakes - Display and lists
    xy_mistakes = sum(abs(x - y));
    message_mistakes = sum(abs(message - message_guess));
    disp("x-y mistakes:    " + num2str(xy_mistakes));
    disp("message mistakes:" + num2str(message_mistakes));
    display(' ');
    xy_mistakes_list(counter_rounds) = xy_mistakes;
    message_mistakes_list(counter_rounds) = message_mistakes;
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



%% Display overall stats
xy_average = sum(xy_mistakes_list) / length(xy_mistakes_list);
message_average = sum(message_mistakes_list) / length(message_mistakes_list);
xy_average_list = xy_average * ones(1, target);
message_average_list = message_average * ones(1, target);
disp("Average mistakes in x-y (codewords):  " + num2str(xy_average));
disp("Average mistakes in original message: " + num2str(message_average));


figure();
plot(rounds_list, xy_mistakes_list, 'black');
hold on
plot(rounds_list, message_mistakes_list, 'black--');
hold on
plot(rounds_list, xy_average_list, 'blacko-');
hold on
plot(rounds_list, message_average_list, 'black*-');
title("Errors with: er = " + num2str(er) + " and codeword length = " + num2str(repeat * LEN));
xlabel('# of channel simulation');
ylabel('Errors and average error');
legend('Errors in codeword sent', 'Errors in message sent', 'Average error in codewords', 'Average error in messages');

xini = 0;
yini = 0;
xsize = 600;
ysize = 600;
set(gcf,'units','centimeters','position',[xini,yini,xsize,ysize]); 
set(gca,'FontSize',10,'FontName','Times');
print("title",'-depsc2');

