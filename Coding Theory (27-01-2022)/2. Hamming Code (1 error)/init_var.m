function y = init_var(chan_node, var_node)

    for i = 1:7
    
        if chan_node(1,i) > chan_node(2,i)

            var_node(i) = 0;
        else

            var_node(i) = 1;
            
        end
    end

    y = var_node;
    