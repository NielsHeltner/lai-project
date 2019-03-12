[x, t] = generate_inputs_and_targets(1000, -1, 1);
%[x, t] = simplefit_dataset;
%disp(x);
%disp(t);

neuralnet = fitnet(8);
%view(neuralnet)

neuralnet = train(neuralnet, x, t);

%view(neuralnet)


function [x, t] = generate_inputs_and_targets(amount, min, max)
    %x = zeros(1, amount);
    %t = zeros(1, amount);
    for i = 1:amount
        number = (max - min) * rand + min;
        x(i) = number;
        t(i) = formula1(number);
    end
end

function [x, t] = generate_inputs_and_targets2(amount, min, max)
    %x = zeros(1, amount);
    %t = zeros(1, amount);
    for i = 1:amount
        number = (max - min) * rand + min;
        number1 = (max - min) * rand + min;
        x(i) = [number, number1];
        t(i) = formula2(number, number1);
    end
end

function y = formula1(x)
    y = sin(2 * pi * x) + sin(5 * pi * x);
end

function z = formula2(x, y)
    z = exp(-(x^2 + y^2) / 0.1);
end