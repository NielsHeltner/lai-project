[x, t] = simplefit_dataset;

net = fitnet([10, 5]);

%view(net)

net = train(net, x, t);

view(net)