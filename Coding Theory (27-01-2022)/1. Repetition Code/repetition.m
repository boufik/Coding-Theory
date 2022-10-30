%% Close all figures, clear workspace and console
close all;
clear;
clc;



%% Application - Repetition Code
%% Create the stats
counter_rounds = 0;
target = 1;
num_of_corrections = 0;

while counter_rounds < target
    
    counter_rounds = counter_rounds + 1;
    disp("Counter " + num2str(counter_rounds));
    
    %% Simulating the Repetition
    er = 0.1;
    repeat = 3;
    LEN = 10;
    message = randi([0 1], 1, LEN)
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
    x
    y
    message_guess
    % Mistakes
    xy_mistakes = sum(abs(x - y));
    message_mistakes = sum(abs(message - message_guess));
    disp("x-y mistakes:    " + num2str(xy_mistakes));
    disp("message mistakes:" + num2str(message_mistakes));
    
end


%% Display overall stats

