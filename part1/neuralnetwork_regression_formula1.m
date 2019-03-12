amount = 1000;
min = -1;
max = 1;

[x, t] = generate_inputs_and_targets(amount, min, max);


neuralnet = fitnet([10, 10]);
%view(neuralnet)

neuralnet = train(neuralnet, x, t);

test(amount, min, max, neuralnet);


function test(amount, min, max, neuralnet)
    for i = 1:amount
        number = (max - min) * rand + min;
        a(i) = number;
        b(i) = neuralnet(number);
    end
    fplot(@(x) formula(x), [-1 1], 'blue')
    hold on
    scatter(a, b, 35, 'red')
end

function [x, t] = generate_inputs_and_targets(amount, min, max)
    for i = 1:amount
        number = (max - min) * rand + min;
        x(i) = number;
        t(i) = formula(number);
    end
end

function y = formula(x)
    y = sin(2 * pi * x) + sin(5 * pi * x);
end
