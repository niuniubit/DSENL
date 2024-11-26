function [P,G,U]=updateWL(Y,N,X,C,rho,param,G,F,L,E,P,M,F2)
d2=size(X,1);
U=G+N+C*(1/rho);
H=P*X-N-C/rho;
[c, ~] = size(Y);
XX = X*X';
for i=1:1000
    P=(param.mu*rho*U*X')/(param.mu*rho*(XX)+2*param.lambda*eye(d2));
    G = ((rho*param.mu+2*param.eta+2*rho)*eye(c))\(rho*(Y-E+1/rho*F)+2*param.eta*L+param.mu*rho*H+rho*(M-1/rho*F2));
    obj(i)=(param.mu*rho/2)*trace((P*X-U)*(P*X-U)')+param.lambda*trace((P*P'));
    if i>2
        if abs(obj(i)-obj(i-1))<0.01
            break
        end
    end
end




