clear all;
close all;
%imgs = readMNIST('train-images.idx3-ubyte', 100, 0);


fid = fopen('data0', 'r', 'b');
for i = 1:10
imgs(:,:,i) = fread(fid, [28 28], 'uchar');
imgs(:,:,i) = imgs(:,:,i)./255.0;
end

%imgs = rescale(imgs, 0.75);


%imshow(imgs(:,:,1), [0 1]);
figure
for i = 1:10
subplot(10,10,i)
imshow(imgs(:,:,i))
end

%x = simplecluster_dataset;
net = selforgmap([10 10],1000, 10, 'hextop');
[net, tr] = train(net, imgs(:,:));


%twoDims = imgs(:,:);
%imshow(twoDims);


%y = net(x);
%classes = vec2ind(y);



function imgs_rescaled = rescale(imgs, scale)
    imgs_rescaled = imresize(imgs(:,:,:), scale);
end