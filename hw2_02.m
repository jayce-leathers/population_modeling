%simulation variables
dt = .00001; %time step
simulationLength = 24; %length of time to simulate. In months
N = simulationLength/dt; %number of iterations

%xAxis array of timeSteps
times = zeros(1,N + 1);
times(1) = 0;

%Population inits
Y = zeros(1,N + 1); %Prey
P = zeros(1,N + 1); %Predator  
H = zeros(1,N + 1); %Human

%Inital values
Y(1) = 150;
P(1) = 50;
H(1:N + 1) = 25;

%Proportion of Interaction Variables
KPY = .02; %Proportion of Predator births due to interactions with Prey
KPH = .01; %Proportion of Predator deaths due to H
KP = 1.06; % P death fraction

KYP = .02; %Proportion of Prey deaths due to interactions with Predators
KYH = .01; %Proportion of Prey deaths due to interactions with H
KY = 2; %Prey birth fraction

KHP = .01; %Proportion of H births due to P interactions
KHY = .01; %Proportion of H births due to Y interactions
KH = 4; %Human death fraction

%Model 1: Species H hunts P, P hunts Y
for i = 1:N
    
    predGrowth = ...
        ((KPY * Y(i) * P(i)) ... %pred births due to prey
        - (KPH * P(i) * H(i))) ...%pred deaths due to fishing
        * dt;% growth rate * timestep
    P(i + 1) = P(i) + predGrowth; %new population
    
    preyGrowth = ...
        ((KY * Y(i)) ...%prey birth unconstrained
        - (KYP * Y(i) * P(i))) ... % deaths due to predators
        * dt; % growth rate * timestep
    Y(i + 1) = Y(i) + preyGrowth; % new pop
    
    humanGrowth = ...
        ((KHP * H(i) * P(i)) ... %births due to P
        - (KH * H(i)))... %natural deaths
        * dt;% growth rate * timestep
    H(i + 1) = H(i) + humanGrowth; %new population
    
    times(i + 1) = i * dt; %next time
end

%graphing model 1 
figure;
hold;
axis([0 simulationLength 0 500]);
plot(times,Y)
plot(times,P)
plot(times,H)
legend('Prey','Predator','Human')
xlabel('Time in Months')
ylabel('Population')
title('Population Model of Three Species: H hunts P,  P hunts Y')
hold off;


%Model 2: Species H hunts P & Y, P hunts Y
for i = 1:N
    
    predGrowth = ...
        ((KPY * Y(i) * P(i)) ... %pred births due to prey
        - (KPH * P(i) * H(i)) ...%pred deaths due to fishing
      - (KP * P(i))) ... %natural deaths
        * dt;% growth rate * timestep
    P(i + 1) = P(i) + predGrowth; %new population
    
    preyGrowth = ...
        ((KY * Y(i)) ...%prey birth unconstrained
        - (KYP * Y(i) * P(i)) ... % deaths due to predators
        - (KYH * Y(i) * H(i))) ... % deaths due to fishing
        * dt; % growth rate * timestep
    Y(i + 1) = Y(i) + preyGrowth; % new pop
    
   humanGrowth = ...
        ((KHP * H(i) * P(i)) ... %births due to P
        + (KHY * H(i) * Y(i)) ...%births due to Y
        - (KH * H(i)))... %natural deaths
        * dt;% growth rate * timestep
    H(i + 1) = H(i) + humanGrowth; %new population
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
title('Population Model of Three Species: H hunts P & Y, P hunts Y')
hold off;