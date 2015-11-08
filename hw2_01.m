%simulation variables
dt = .00001; %time step
simulationLength = 48; %length of time to simulate. In months
N = simulationLength/dt; %number of iterations

%xAxis array of timeSteps
times = zeros(1,N + 1);
timses(1) = 0;
%Population inits
Y = zeros(1,N + 1); %Prey
P = zeros(1,N + 1); %Predator  
H = zeros(1,N + 1); %Human
%Inital values
Y(1) = 100;
P(1) = 15;
H(1:N + 1) = 25;
%Proportion of Interaction Variables
KPY = .01; %Proportion of Predator births due to interactions with Prey
KYP = .02; %Proportion of Prey deaths due to interactions with Predators
KH = .08; %Proportion of deaths due to human interactions same for predators and prey
KY = 2; %Prey birth fraction
KP = 1.06; %Predator death fraction

% Model 1: Just species Y and P interactions, no H interactions
for i = 1:N
    preyGrowth = ... % amount Y grows =
        ((KY * Y(i)) ... % births
        - (KYP * Y(i) * P(i))) ...  % minus deaths to predator interactions
        * dt; %growth rate times timestep
    Y(i + 1) = Y(i) + preyGrowth; %set next population estimate
    predGrowth = ... % amount P grows =
        ((KPY * Y(i) * P(i)) ... % Births due to prey interactions
        - (KP * P(i))) ... % minus deaths
        * dt; %growth rate times timestep
    P(i + 1) = P(i) + predGrowth; %set next
    times(i + 1) = i * dt; %set next time
end

%graphing model 1
figure;
hold;
axis([0 simulationLength 0 500]);
plot(times,Y)
plot(times,P)
legend('Prey','Predator')
xlabel('Time in Months')
ylabel('Population')
title('Population Model of Two Species')
hold off;

%Model 2: Species H, Y, P interactions with H constant
for i = 1:N
    preyGrowth = ...
        ((KY * Y(i)) ...%prey birth unconstrained
        - (KYP * Y(i) * P(i)) ... % deaths due to predators
        - (KH * Y(i) * H(1))) ... % deaths due to fishing
        * dt; % growth rate * timestep
    Y(i + 1) = Y(i) + preyGrowth; % new pop
    predGrowth = ...
        ((KPY * Y(i) * P(i)) ... %pred births due to prey
        - (KH * P(i) * H(1)) ...%pred deaths due to fishing
         - (KP * P(i))) ... 
        * dt;% growth rate * timestep
    P(i + 1) = P(i) + predGrowth; %new population
    times(i + 1) = i * dt; %next time
end

%graphing model 2
figure;
hold;
axis([0 simulationLength 0 500]);
plot(times,Y)
plot(times,P)
plot(times,H)
legend('Prey','Predator','Human')
xlabel('Time in Months')
ylabel('Population')
title('Population Model of Three Species')
hold off;

%Model 3: Species H, Y, P interactions with H fishing rate periodic

%Initial values
Y(1) = 250;
P(1) = 150;
H(1:N + 1) = 50; %constant

%Proportion of Interaction Variables
KPY = .01; %Proportion of Predator births due to interactions with Prey
KYP = .02; %Proportion of Prey deaths due to interactions with Predators
KY = 4; %Prey birth fraction
KP = 1.06; %Predator death fraction

%cosine constants
f = 0; %raise graph by f
a = .04; %amplitude - this ends up being the max value of  
p = pi/6; %period

KHT = zeros(1,N + 1);%human fishing rate as function of time replaces KH

for t = 1:N + 1
   newRate = f + a * cos(times(t) * p); %calculate new proportion
   if newRate > 0 %rate is good set it
       KHT(t) = newRate;
   else %negative weights are the off season -> set to zero
       KHT(t) = 0;
   end
end


%Model 3
for i = 1:N
    preyGrowth = ...
        ((KY * Y(i)) ...%prey birth unconstrained
        - (KYP * Y(i) * P(i)) ... % deaths due to predators
        - (KHT(i) * Y(i) * H(1))) ... % deaths due to fishing
        * dt; % growth rate * timestep
    Y(i + 1) = Y(i) + preyGrowth; % new population
    predGrowth = ...
        ((KPY * Y(i) * P(i)) ... %pred births due to prey
         - (KP * P(i)) ... % minus naturally dying predators 
        - (KHT(i) * P(i) * H(1))) ...%pred deaths due to fishing
        * dt;% growth rate * timestep
    P(i + 1) = P(i) + predGrowth; %new population
    times(i + 1) = i * dt; %next time
end

%graphing model 3
figure;
hold;
axis([0 simulationLength 0 1000]);
plot(times,Y,'r')
[AX,H1,H2] = plotyy(times,P,times,KHT);
set(H1,'color','blue')
set(H2,'color','green')
set(AX,{'ycolor'},{'blue';'green'})
legend('Prey Population','Predator Population','Human Rate')
xlabel('Time in Months')
ylabel('Population')
title('Population Model of Three Species with human fishing rate periodic')
hold off;
%graphing fishing rate
% figure;
% hold;
% axis([0 simulationLength 0 .1]);
% plot(times,KHT)
% xlabel('Time in Months')
% ylabel('Rate')
% hold off