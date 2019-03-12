imgs = readMNIST('train-images.idx3-ubyte', 10, 0);
imgs = rescale(imgs, 0.75);

%imshow(imgs(:,:,1), [0 1]);


%x = simplecluster_dataset;
net = selforgmap([10 10]);
net = train(net, imgs(:,:));


twoDims = imgs(:,:);
imshow(twoDims);


y = net(x);
classes = vec2ind(y);



function imgs_rescaled = rescale(imgs, scale)
    imgs_rescaled = imresize(imgs(:,:,:), scale);
end