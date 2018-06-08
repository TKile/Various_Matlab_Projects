%% Project 1
% Death by waves
% Tad Kile, James Johnstone, Megan Cromis
% April 2017

%% Trying to plot stuff
clear all; close all; clc;

c = .1; %Dissipation value
k = -1; %Strength
m = .01; %Mass value

sigma = 12e-5;%Sigma value if small change end is desired
maxiter = 5;

%Initial Conditions
xvals = linspace(0,pi,21);
yvals = linspace(0,pi,21);
nx = length(xvals);
ny = nx;

for i = 1:length(xvals)
    for j = 1:length(yvals)
        winitial(i,j) = sin(xvals(i))*sin(yvals(j));
    end
end

for k = 1:nx
    winitial(1,k)=0;
    winitial(ny,k)=0;
end

for k = 1:ny
    winitial(k,1)=0;
    winitial(k,nx)=0;
end

surf(xvals,yvals,winitial) %Shows initial condition
figure

%Bunches of reshaping
dwinitial = zeros(nx,ny);
winitial = reshape(winitial,[441,1]);
dwinitial = reshape(dwinitial,[441,1]);
wi = [winitial;dwinitial];
w = wi;
iternum = 0;
%ODE Loops
while (iternum < maxiter) %&& (maxsigma > sigma)
    [t,w] = ode15s(@(t,w)wavefun(w,xvals,yvals,c,k,m),[0 .5],wi);
    iternum = iternum + 1;
end

%% 
loops = length(t);
F(loops) = struct('cdata',[],'colormap',[]);

surf(xvals,yvals,reshape(winitial,[21 21]))
%axis([0 pi 0 pi -1 1]);
for frme = 1:length(t)
    %Reshapes
    wplot = w(frme,(1:441))';
    wplot = reshape(wplot,[21 21]);
    surf(xvals,yvals,wplot)
    xlabel('x')
    ylabel('y')
    zlabel('Amplitude')
    axis([0 pi 0 pi -1 1]);
    drawnow
    F(j) = getframe(gcf);
end

% myVideo = VideoWriter('junk.avi');
% 
% open(myVideo)
% 
% writeVideo(myVideo, F)
% 
% close(myVideo)