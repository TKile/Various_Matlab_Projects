function [dwavedt] = wavefun(w,xvals,yvals,c,k,m)

nx = length(xvals);
ny = nx;
deltax = xvals(2) - xvals(1);
%Boundary conditions of everything is 0
% for xvals = 1:nx
%     dwavedt(1,x)=0;
%     dwavedt(ny,x)=0;
% end
% 
% for yvals = 1:ny
%     dwavedt(y,1)=0;
%     dwavedt(y,nx)=0;
% end

nablasq = zeros((nx), (ny));
w1 = w(1:441);
w2 = w(442:882);
wtop = reshape(w1,[21,21]);

for i = 2:(nx-1)
    for j = 2:(ny-1) 
        nablasq(i,j) = ((wtop((i+1),j) + wtop((i-1),j) - 2*(wtop(i,j))) + (wtop(i,(j+1))...
            + wtop(i,(j-1)) -2*wtop(i,j)))/deltax^2;
    end
end


nablasq = reshape(nablasq,[441,1]);
%w = [u; dudt]
%dwdt = [dudt; d2udt2]
dwavedt = [w2
          (k/m)*nablasq - (c/m)*w2;];
        
%         w(4);
%         (k/m)*dwdy() - (c/m)*w(4)]

% for i = 2:(nx-1)
%     for j = 2:(ny-1) 
%         dwavedt(i,j) = -((c/m)(-c*(temps(i+1) - temps(i))/delta_x) +...
%             ((temps(i+1) - 2*temps(i) + temps(i-1))/delta_x^2)*alpha;
% end