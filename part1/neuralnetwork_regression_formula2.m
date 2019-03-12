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
        number1 = (max - min) * rand + min;
        a(1, i) = number;
        a(2, i) = number1;
        b(i) = neuralnet([number; number1]);
    end
    fsurf(@(x, y) formula(x, y), [-1 1]);
    hold on
    scatter3(a(1,:), a(2,:), b, 35, 'red')
end

function [x, t] = generate_inputs_and_targets(amount, min, max)
    for i = 1:amount
        number = (max - min) * rand + min;
        number1 = (max - min) * rand + min;
        x(1, i) = number;
        x(2, i) = number1;
        t(i) = formula(number, number1);
    end
end

function z = formula(x, y)
    z = exp(-(x^2 + y^2) / 0.1);
end
