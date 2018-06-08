%% Homework 11
% Tad Kile
% 4/6/17

%% Problem 1
%Use Monte Carlo integration to estimate value of 10D integral

%random x values [10]
%random y value from 0 to 100
%check to see if y value is above or below the expected y value
%keep if below
%Percentage is 

hit = 0;
for rock = 1:1000000 %Throw one million rocks
    x = rand(1,10); %Random x values
    y = 100*rand(1); %Random y values
    yexpected = sum(x)^2; %What we expect to find on the line
    if y <= yexpected %If below line we accept the value
        hit = hit + 1;
    end
end

percentage = (hit/rock); %Find percentage that were accepted
area = 1*100; %Area to multiply by

answer = percentage*area %Answer my rock throwing code has found
givenanswer = 155/6 %Answer that is correct
error = answer - givenanswer %Error

%% Problem 2 (Curie Pendulum)
%Magnet that is attracted to another magnet, but heat is introduced causing
%the alignments of each atom's magenetic field to flip at random causing
%half of the atoms to cancel each other out (curie temperature). The magnet
%then falls to zero (gravity)(out of the flame), causing it to cool,
%remagnetize, and be attracted to the magnet again, lying within the flame.

%Use the Metropolis Algorithm to calculate the lowest engergy through
%iteration, probability, and likely some black magic

num = 100;
atoms = rand(1,num)- .5;
for i = 1:num;
    if atoms(i) < 0
        atoms(i) = -1;
    else
        atoms(i) = 1;
    end
end

Beta = 0; %Zero for simplicity
Mu = 1; %Unimportant
k = 1; %T is altered, so do not alter k
T = [1 2 3 4 5 6 7 8 9 10]; %Simulate for kT = 1,2,3,4,5,6,7,8,9,10
J = 1; %Ferromagnet, -1 is antiferromagnet

%Starting code (almost exact same as looping code)
sameorflip = zeros(num);
sameorflip(num) = atoms(num)*atoms(1); %Periodic boundary conditions
for i = 1:(num - 1)
    sameorflip = atoms(i)*atoms(i+1);
end  
checkflip = sum(sameorflip); %Find total of the flip values (more positive
    %means it is more similar
    
E = (J*checkflip) - Beta*Mu*sum(atoms); %Calculate E

itermax = 1000;
chartsave = zeros(itermax,num);
for v = 1:10
    numiter = 0;
    while((checkflip < 1800) && (numiter < itermax))
        numiter = numiter + 1;
        whichflip = ceil(rand(1)*num); %Choose which atom to flip
        atomsnew = atoms;
        atomsnew(whichflip) = atoms(whichflip)*-1; %Flip it
        %Calculate the new Efield
        sameorflip = zeros(1,num);
        sameorflip(1,num) = atomsnew(num)*atomsnew(1); %Periodic boundary conditions
        for i = 1:(num - 1)
            sameorflip(1,i) = atomsnew(i)*atomsnew(i+1);
        end  
        checkflip = sum(sameorflip); %Find total of the flip values (more positive
            %means it is more similar

        Enew = (-J*checkflip) - Beta*Mu*sum(atomsnew); %Calculate E

        if Enew < E %If lower energy, keep the change
            atoms = atomsnew;
            E = Enew;
        else %If equal or higher engery, there is a chance we keep, chance revert
            r = rand(1);
            Prob = exp(-(Enew - E)/(k*T(v)));
            if Prob > r
                atoms = atomsnew;
                E = Enew;
            end
        end
        chartsave(numiter,:) = atoms;
        Esave(numiter) = E;
    end
    Ecalc(v) = E/num;
    Eactual(v) = -(num*J*tanh(J/(k*T(v))))/num;
    pcolor(chartsave')
    shading flat
    title(sprintf('kT = %d', v))
    xlabel('Iteration')
    ylabel('Atom Magnetic spin')
    figure
    plot(Esave)
    title(sprintf('Energy per flips kT = %d', v))
    xlabel('Flip')
    ylabel('Energy')
    figure
end

plot(Ecalc,'r')
hold on
plot (Eactual,'b')
legend('Ecalc','Eactual')
title('Calculated Energy v Verified Energy')
xlabel('kT value')
ylabel('Energy/num')


fprintf('done')

