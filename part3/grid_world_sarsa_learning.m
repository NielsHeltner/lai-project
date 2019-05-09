
close all
clear all
clc

disp('sarsa');

cr1s = [];
cr2s = [];
cr3s = [];
pl1s = [];
pl2s = [];
pl3s = [];
n_experiments = 50;
wh=waitbar(0,'Running experiments...');
for i=1:n_experiments
    [cr1, pl1] = sarsa(0.2, false);
    cr1s(i,:) = cr1;
    pl1s(i,:) = pl1;
    [cr2, pl2] = sarsa(0.1, false);
    cr2s(i,:) = cr2;
    pl2s(i,:) = pl2;
    [cr3, pl3] = sarsa(0.2, true);
    cr3s(i,:) = cr3;
    pl3s(i,:) = pl3;
    
    waitbar(i/n_experiments, wh);
end
close(wh);

disp("plotting");

figure
bar(median(pl1s), 'FaceColor', [0, 0.4470, 0.7410])
hold on
bar(median(pl2s), 'FaceColor', [0.9290, 0.6940, 0.1250])
hold on
bar(median(pl3s), 'FaceColor', [0.8500, 0.3250, 0.0980])
hold off
title('Path length per episode')
xlabel('Episodes')
ylabel('Path length')
legend({'\epsilon: 0.2', '\epsilon: 0.1', '\epsilon: 0.2, decaying'}, 'Location', 'northeast')

figure
plot(median(cr1s), 'Color', [0, 0.4470, 0.7410])
hold on
plot(median(cr2s), 'Color', [0.9290, 0.6940, 0.1250])
hold on
plot(median(cr3s), 'Color', [0.8500, 0.3250, 0.0980])
hold off
title('Cumulative reward per episode')
xlabel('Episodes')
ylabel('Cumulative reward')
legend({'\epsilon: 0.2', '\epsilon: 0.1', '\epsilon: 0.2, decaying'}, 'Location', 'southeast')


function [CR, PL] = sarsa(epsilon, decay)
showAnim=0;

a=0.1; %alpha
g=0.7; %gamma

%epsilon=0.1;

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
    
    if decay == true
        epsilon=E(episode); %epsilon decays from initial value to 0
    end
    
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
                movdir(t)=1;
            elseif dmov(1)==0 && dmov(2)==-1
                movdir(t)=2;
            elseif dmov(1)==-1 && dmov(2)==0
                movdir(t)=3;
            elseif dmov(1)==1 && dmov(2)==0
                movdir(t)=4;
            else
                movdir(t)=0;
            end;                 
            
            if t>1
                if movdir(t)~=0  && movdir(t-1)~=0
                    Qa=Q(s(t,1),s(t,2),movdir(t));
                    Qt=Q(s(t-1,1),s(t-1,2),movdir(t-1));
                    Q(s(t-1,1),s(t-1,2),movdir(t-1))=Qt + a*(R(s(t,1),s(t,2))+g*Qa-Qt);
                    CR(episode) = CR(episode) + R(s(t,1),s(t,2));
                end;
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
                    Qt=Q(s(t,1),s(t,2),movdir(t));
                    Q(s(t,1),s(t,2),movdir(t))=Qt + a*(R(s(t+1,1),s(t+1,2))-Qt);
                    CR(episode) = CR(episode) + R(s(t+1,1),s(t+1,2));
                    
                    PL(episode)=t;
                    %break;
                    running = false;
                end
            end
            if sum(abs(s(t+1,:) - G)) == 0 % reached goal
                Qt=Q(s(t,1),s(t,2),movdir(t));
                Q(s(t,1),s(t,2),movdir(t))=Qt + a*(R(s(t+1,1),s(t+1,2))-Qt);
                CR(episode) = CR(episode) + R(s(t+1,1),s(t+1,2));
                
                PL(episode)=t;
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
%{
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
%}
end
