% H will be 4x15 and G is 11x15 (systematic form)
H = zeros(4, 15);
colCounter = 0;
for a = 1:-1:0
    for b = 1:-1:0
        for c = 1:-1:0
            for d = 1:-1:0
                colCounter = colCounter + 1;
                column = [a b c d]';
                H(:, colCounter) = column;
            end
        end
    end
end

H = H(:, 1:15)
H = [H(:, 1:11) eye(4)]

