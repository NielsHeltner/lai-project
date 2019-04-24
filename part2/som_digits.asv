close all
clear all
close all hidden
clear all hidden
clc

showAnim=0; %set to 0 to disable animation

N1=15; % number of output neurons per dimension
N2=15; % number of output neurons per dimension
n=28; % number of pixels in original image nxn
Nf=15;%number of input neurons NfxNf
T=1000; % number of learning iterations
D=Nf*Nf;
offs=2; %number of border pixels

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
        
figure
colormap gray
k=0;
for i=1:10
    for j=1:10
        k=k+1;
        subplot(10,10,k)
        imagesc(reshape(X(k,:),Nf,Nf))
        axis off
    end;
end;

w=[];
w=rand(N1,N2,D)*max(max(X)); 
figure
colormap gray
k=0;
for i=1:N1
    for j=1:N2
        k=k+1;
        subplot(N1,N2,k)
        imagesc(reshape(w(i,j,:),Nf,Nf))
        axis off
    end;
end;
%pause

wh=waitbar(0,'Please wait... Learning');
for t=1:T
    
    ind=randperm(size(X,1));
    ind=ind(1);
    
    x=[];
    x(1,1,:)=X(ind,:);
    
    dist=[];
    for i=1:N1
        for j=1:N2
            dist(i,j)=sqrt(sum([x(1,1,:)-w(i,j,:)].^2));
%             cc=corrcoef(reshape(x(1,1,:),Nf,Nf),reshape(w(i,j,:),Nf,Nf));
%             dist(i,j)=1-cc(1,2); 
        end;
    end;

	[I,J]=find(dist==min(min(dist)));

    [XX,YY] = meshgrid(1:1:N2, 1:1:N1);
    h(:,:,1)=exp(-((XX-J(1)).^2+(YY-I(1)).^2)/sigma^2);

    for d=1:D
        w(:,:,d)=w(:,:,d)+(alfa*h).*(x(1,1,d)-w(:,:,d));
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
end;
close(wh);

figure(3)
cla
colormap gray
k=0;
for i=1:N1
    for j=1:N2
        k=k+1;
        subplot(N1,N2,k)
        imagesc(reshape(w(i,j,:),Nf,Nf))
        axis off
    end;
end;
