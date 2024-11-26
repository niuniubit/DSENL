function E = updateN(H,rho)
inmu = 1/rho;
[d1,d2]=size(H);
E=zeros(d1,d2);
for i = 1:d2
        w = H(:,i);
        la = sqrt(w'*w);
        lam = 0;
        if la > inmu
            lam = 1-inmu/la;
        elseif la < -inmu
            lam = 1+inmu/la;
        end
        E(:,i) = lam*w;
end

