close all
clear all
close all hidden
clear all hidden
clc
addpath('./somtoolbox/')


means = [];
iterations = [];
for i=1:10
    [mean, t] = som();
    means(i) = mean;
    iterations(i) = t;
end
figure
scatter(iterations, means)
title('Mean of the U-Matrix')
ylabel('Mean')
xlabel('Iterations')

function [mean_U, t] = som()
showAnim=0; %set to 0 to disable animation

N1=10; % number of output neurons per dimension
N2=10; % number of output neurons per dimension
n=28; % number of pixels in original image nxn
Nf=10;%number of input neurons NfxNf
T=5000; % number of learning iterations
D=Nf*Nf;
offs=2; %number of border pixels
threshold = 0.000000001;

sigma0=7; %initial width of Gaussian neighbourhood function 
alfa0=0.75; %initial learning rate
sigma=sigma0;
alfa=alfa0;

M=10; %number of samples per class




k=0; 
for i=0:9 
    fid=fopen(['data' num2str(i)],'r');
    for j=1:M
        k=k+1;
        tmp=[];
        tmp=fread(fid,[n n],'uchar');
        tmp=tmp(offs+1:n-offs,offs+1:n-offs);
        tmp=imresize(tmp,[Nf Nf]);
        X(k,:)=reshape(tmp',1,D);
        X(k,:)=X(k,:)-min(X(k,:));
        X(k,:)=X(k,:)/max(X(k,:));
    end;
    fclose(fid);
end;
        
%figure
%colormap gray
k=0;
for i=1:10
    for j=1:10
        k=k+1;
        %subplot(10,10,k)
        %imagesc(reshape(X(k,:),Nf,Nf))
        %axis off
    end;
end;

w=[];
%w= rand(N1,N2,D)*max(max(X)); 
for i=1:100
    for ii=1:10
        for jj=1:10
            w(ii,jj,i) = X (randi(10000));
        end
    end
end
%figure
%colormap gray
k=0;
for i=1:N1
    for j=1:N2
        k=k+1;
        %subplot(N1,N2,k)
        %imagesc(reshape(w(i,j,:),Nf,Nf))
        %axis off
    end;
end;
%pause

wh=waitbar(0,'Please wait... Learning');
running = true;
t = 1;
while running
    
    ind=randperm(size(X,1));
    ind=ind(1);
    
    x=[];
    x(1,1,:)=X(ind,:);
    
    dist=[];
    for i=1:N1
        for j=1:N2
            %dist(i,j)=sqrt(sum([x(1,1,:)-w(i,j,:)].^2));
             cc=corrcoef(reshape(x(1,1,:),Nf,Nf),reshape(w(i,j,:),Nf,Nf));
             dist(i,j)=1-cc(1,2); 
        end;
    end;

	[I,J]=find(dist==min(min(dist)));

    [XX,YY] = meshgrid(1:1:N2, 1:1:N1);
    h(:,:,1)=exp(-((XX-J(1)).^2+(YY-I(1)).^2)/sigma^2);

    
    
    for d=1:D
        weight_change = (alfa*h).*(x(1,1,d)-w(:,:,d));
        w(:,:,d)=w(:,:,d)+weight_change;
        if abs(mean(mean(weight_change))) < threshold
            disp('threshold hit');
            running = false;
        end
    end;   
    if alfa>0.01
	    alfa=alfa-alfa0/T;
    end;
    
    if sigma>0.1
	    sigma=sigma-sigma0/T;
    end;

    if showAnim==1
        k=0;
        figure(3)
        cla
        colormap gray
        for i=1:N1
            for j=1:N2
                k=k+1;
                subplot(N1,N2,k)
                imagesc(reshape(w(i,j,:),n,n))
                axis off
            end;
        end;
        pause(0.001)
    end;
	waitbar(t/T,wh);

    if t >= T
        disp('t > T');
        running = false;
    else
        t = t + 1;
    end
end;
disp(t);
close(wh);
%figure(3)
%cla
%colormap gray
k=0;
for i=1:N1
    for j=1:N2
        k=k+1;
        %subplot(N1,N2,k)
        %imagesc(reshape(w(i,j,:),Nf,Nf))
        %axis off
    end;
end;

%figure(4)
%colormap(flipud(gray));
U = som_umat(w);
%ha = som_cplane('hexa',[19 19],U(:));
%set(ha,'edgecolor','none');


mean_U = mean(mean(U).');
disp('mean of u-matrix');
disp(mean_U);
end

