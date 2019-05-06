
close all
clear all
clc

showAnim=0;

a=0.1; %alpha
g=0.9; %gamma

epsilon=0.1;

n_episodes=1000;

w = 12; % grid size width
h = 4;  % grid size height

G = [12 1]; %goal (terminal state)
C = [2 1; 3 1; 4 1; 5 1; 6 1; 7 1; 8 1; 9 1; 10 1; 11 1]; %cliff (terminal states)

R=zeros(w,h);
for i=1:w
    for j=1:h
        R(i,j)=-1;
    end
end
for i=1:length(C)
    R(C(i, 1), C(i, 2)) = -100;
end
%R(G(1),G(2))=0;
Q=zeros(w,h,4);% 4 = the four directions you can move in (movedir)
for i=1:w
    for j=1:h
        for k=1:4
            if k==1 % up
                if j==h
                    Q(i, j, k) = -100;
                end
            end
            if k==2 % down
                if j==1 && i == 1
                    Q(i, j, k) = -100;
                end
            end
            if k==3 % left
                if i==1
                    Q(i, j, k) = -100;
                end
            end
            if k==4 % right
                if i==w
                    Q(i, j, k) = -100;
                end
            end
        end
    end
end

move_to=[0 1; 0 -1; -1 0; 1 0];

E=linspace(epsilon,0,n_episodes);


for episode=1:n_episodes
    
    CR(episode) = 0;
    
    s=[];
    s(1,:)=[1 1];
    
    %epsilon=E(episode);
    
    if showAnim==1
        figure(1)
        cla
        axis([0.5 w+0.5 0.5 h+0.5])
        hold on
        for i=1:h
            plot([0.5 w+0.5],[i-0.5 i-0.5]);
        end;
        for i=1:w
            plot([i-0.5 i-0.5],[0.5 h+0.5]);
        end;
        plot(s(1,1),s(1,2),'g.','markersize',50);
        plot(G(1,1),G(1,2),'r.','markersize',50);
        for i1=1:w
            for i2=1:h
                str=num2str(max(Q(i1,i2,:)));
                text(i1+0.1,i2+0.1,str);
                quiver([i1 i1 i1 i1],[i2 i2 i2 i2],0.5*[0 0 -Q(i1,i2,3) Q(i1,i2,4)]/max(Q(i1,i2,:)),0.5*[Q(i1,i2,1) -Q(i1,i2,2) 0 0]/max(Q(i1,i2,:)),'k','linewidth',2);
            end;
        end;
    end;

    
    t=1;
    running = true;
    while running
        
        if rand<epsilon
            rn=randperm(4);%random move - four directions
            s(t+1,:)=s(t,:)+move_to(rn(1),:);
        else
            if  max(Q(s(t,1),s(t,2),:))==0
                rn=randperm(4);%random move - four directions
                s(t+1,:)=s(t,:)+move_to(rn(1),:);
            else
                [Y,I]=max(Q(s(t,1),s(t,2),:));
                s(t+1,:)=s(t,:)+move_to(I,:);
            end;
        end;
        
        if s(t+1,1)<1 || s(t+1,1)>w || s(t+1,2)<1 || s(t+1,2)>h
            s(t+1,:)=s(t,:);
        else
            
            dmov=s(t+1,:)-s(t,:);
            if dmov(1)==0 && dmov(2)==1
                movdir=1;
            elseif dmov(1)==0 && dmov(2)==-1
                movdir=2;
            elseif dmov(1)==-1 && dmov(2)==0
                movdir=3;
            elseif dmov(1)==1 && dmov(2)==0
                movdir=4;
            else
                movdir=0;
            end;
            
            if movdir~=0               
                Q(s(t,1),s(t,2),movdir)=Q(s(t,1),s(t,2),movdir) + a*(R(s(t+1,1),s(t+1,2))+g*max(Q(s(t+1,1),s(t+1,2),:))-Q(s(t,1),s(t,2),movdir));
                CR(episode) = CR(episode) + R(s(t+1,1),s(t+1,2));
            end;
            
            if showAnim==1
                figure(1)
                cla
                axis([0.5 w+0.5 0.5 h+0.5])
                hold on
                for i=1:h
                    plot([0.5 w+0.5],[i-0.5 i-0.5]);
                end;
                for i=1:w
                    plot([i-0.5 i-0.5],[0.5 h+0.5]);
                end;
                plot(G(1,1),G(1,2),'r.','markersize',50);
                plot(s(t+1,1),s(t+1,2),'g.','markersize',50);
                
                for i1=1:w
                    for i2=1:h
                        str=num2str(max(Q(i1,i2,:)));
                        text(i1+0.1,i2+0.1,str);
                        quiver([i1 i1 i1 i1],[i2 i2 i2 i2],0.5*[0 0 -Q(i1,i2,3) Q(i1,i2,4)]/max(Q(i1,i2,:)),0.5*[Q(i1,i2,1) -Q(i1,i2,2) 0 0]/max(Q(i1,i2,:)),'k','linewidth',2);
                    end;
                end;
            end;
            %pause(0.001)
            
            for i=1:length(C)
                if sum(abs(s(t+1,:) - C(i,:))) == 0 % fell off cliff
                    %disp("fell off cliff");
                    %s(t+1,:)=[1 1];
                    PL(episode)=t;
                    %break;
                    running = false;
                end
            end
            if sum(abs(s(t+1,:) - G)) == 0 % reached goal
                PL(episode)=t;
                %disp("reached goal");
                %break;
                running = false;
            else
                t=t+1;
            end;
        end;

    end;
    %episode
end;

Q = normalize(Q, 'range');
for i=1:w
    for j=1:h
        for k=1:4
            if j==1 && i ~= 1
                Q(i, j, k) = 0;
            end
        end
    end
end

if showAnim==0
    figure
    axis([0.5 w+0.5 0.5 h+0.5])
    hold on
    
    for i=1:h
        plot([0.5 w+0.5],[i-0.5 i-0.5]);
    end;
    for i=1:w
        plot([i-0.5 i-0.5],[0.5 h+0.5]);
    end;
    
    plot(G(1,1),G(1,2),'r.','markersize',50);
    for i1=1:w
        for i2=1:h
            str=num2str(max(Q(i1,i2,:)));
            text(i1+0.1,i2+0.1,str);
            quiver([i1 i1 i1 i1],[i2 i2 i2 i2],0.5*[0 0 -Q(i1,i2,3) Q(i1,i2,4)]/max(Q(i1,i2,:)),0.5*[Q(i1,i2,1) -Q(i1,i2,2) 0 0]/max(Q(i1,i2,:)),'k','linewidth',2);
        end;
    end;
end;

figure(1)
plot(s(:,1),s(:,2),'g','linewidth',2)

figure
bar(PL)

figure
plot(medfilt1(medfilt1(CR)))
