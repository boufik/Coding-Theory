%% Close all figures, clear workspace and console
close all;
clear;
clc;


%% MAIN FUNCTION
er = 0.1;
LEN = 20;
repeat_List = 1 : 2 : 19;
rate_List = 1 ./ repeat_List;
xy_average_List = zeros(1, length(repeat_List));
message_average_List = zeros(1, length(repeat_List));
for i = 1:length(repeat_List)
    repeat = repeat_List(i);
    [xy_average, message_average] = simulate(LEN, repeat, er);
    xy_average_List(i) = xy_average;
    message_average_List(i) = message_average;
end


%% PLOT
subplot(1,3,1);
plot(repeat_List, rate_List, 'black');
title("Rate for every value of repeat");
xlabel('n: # of repeated bits');
ylabel('r = 1/n');

subplot(1,3,2);
plot(repeat_List, xy_average_List, 'black');
title("Average errors in codewords");
xlabel('n: # of repeated bits');
ylabel('Errors in codeword');

subplot(1,3,3);
plot(repeat_List, message_average_List, 'black');
title("Average errors in message");
xlabel('n: # of repeated bits');
ylabel('Errors in messafe');

xini = 0;
yini = 0;
xsize = 600;
ysize = 600;
set(gcf,'units','centimeters','position',[xini,yini,xsize,ysize]); 
set(gca,'FontSize',10,'FontName','Times');
print("title",'-depsc2');

display(' ');
repeat_List
rate_List
xy_average_List
message_average_List


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [xy_average, message_average] = simulate(LEN, repeat, er)
    %% AUXILIARY FUNCTION - Repetition Code
    % Create the stats
    counter_rounds = 0;
    target = 100;
    num_of_corrections = 0;
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
    xy_average;
    message_average;
end