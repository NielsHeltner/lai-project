imgs = readMNIST('train-images.idx3-ubyte', 100, 0);

imgs = rescale(imgs, 0.75);

%imshow(imgs(:,:,1), [0 1]);
figure
for i = 1:100
subplot(10,10,i)
imshow(imgs(:,:,i))
end

%x = simplecluster_dataset;
net = selforgmap([10 10],100, 3, 'gridtop');
[net, tr] = train(net, imgs(:,:));


%twoDims = imgs(:,:);
%imshow(twoDims);


%y = net(x);
%classes = vec2ind(y);



function imgs_rescaled = rescale(imgs, scale)
    imgs_rescaled = imresize(imgs(:,:,:), scale);
end