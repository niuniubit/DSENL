function [B, B1, B2] = myidea(X1, X2, Y, param, XTest, YTest)
% beta*|E|_1 +  mu*|PiXi-SG|
% + phi*|B-V| + |V'B-rD|
% Y = SG + E, X0=G, VV' = nI, V1=0


X1 = X1'; X2=X2'; Y = Y';
X1_nor = NormalizeFea(X1,1);
X2_nor = NormalizeFea(X2,1);

[dx1, n ] = size(X1); [dx2, ~ ] = size(X2); [c, ~] = size(Y);


beta = param.beta;
mu = param.mu;
lambda = param.lambda;
phi = param.phi;
alpha = param.alpha;
bits = param.nbits;

etaX=1;
etaS=0.5;
aS = 8;

C1 = ones(c, n);
N1 = zeros(c, n);

C2 = ones(c, n);
N2 = zeros(c, n);
V = randn(bits, n);

E1 = zeros(size(Y));
E2 = zeros(size(Y));
B = sign(V); B(B==0)=-1;

X1X1 = X1*X1';
X2X2 = X2*X2'; 
G2 = Y;
G1 = Y;


P1 = (mu*(Y-E1)*X1')*pinv(mu*X1X1 + lambda*eye(dx1));
P2 = (mu*(Y-E2)*X2')*pinv(mu*X2X2 + lambda*eye(dx2));
F1 = zeros(size(Y));
F2 = zeros(size(Y));
Y1 = Y./repmat(sqrt(sum(Y.*Y))+1e-8,[size(Y, 1),1]);
Y2 = Y./repmat(sqrt(sum(Y.*Y))+1e-8,[size(Y, 1),1]);
M1 = Y1;
M2 = Y2;
O1 = zeros(size(M1));
O2 = zeros(size(M2));
rho = 1;

for iter = 1:param.iter  
    % B
    
    B = sign(phi*V+bits*...
        (etaS/(aS+etaX)*(aS*(V*Y1')*Y1 + etaX*(V*X1_nor')* X1_nor)+...
        (1-etaS)/(aS+etaX)*(aS*(V*Y2')*Y2+ etaX*(V*X2_nor')* X2_nor)/2)-V);
    B(B==0)=-1;
    
    %Y denote noisy label matrix
    %P1, P2, G1, G2 P denote projection matrix, G denote recovery label
    %N1, N2 denote auxiliary to replace PX-G
    %C1, C2, denote Lagrangian multipliers in l_2,1 norm
    %F1, F2, denote Lagrangian multipliers in L=L+E
    %M1, M2, denote an auxiliary to replace G1, G2
    %O1, O2, denote Lagrangian multipliers in kernel norm
    [P1,G1] = updateWL(Y,N1,X1,C1,rho,param,G1,F1,G2,E1,P1,M1,O1);
    [P2,G2] = updateWL(Y,N2,X2,C2,rho,param,G2,F2,G1,E2,P2,M2,O2);
    H1 = P1*X1-G1-C1*(1/rho);
    N1 = updateN(H1, rho);
    C1 = C1+rho*(N1-P1*X1 +G1);
    H2 = P2*X2-G2-C2*(1/rho);
    N2 = updateN(H2, rho);
    C2 = C2+rho*(N2-P2*X2+G2);

    [U1,S1,V1] = svd(G1+O1/rho,'econ');
    a = diag(S1)-alpha/rho;
    a(a<0)=0; 
    T = diag(a);
    M1 = U1*T*V1';  clear U1 S1 V1 T;

    [U1,S1,V1] = svd(G2+O2/rho,'econ');
    a = diag(S1)-alpha/rho;
    a(a<0)=0; 
    T = diag(a);
    M2 = U1*T*V1';  clear U1 S1 V1 T;
    

    % E Noisy martix
    Etp = Y - G1 + 1/rho*F1;
    E1 = sign(Etp).*max(abs(Etp)- beta/rho,0);
    Etp = Y - G2 + 1/rho*F2;
    E2 = sign(Etp).*max(abs(Etp)- beta/rho,0);

    Y1 = Y -E1;
    L1 = Y1;
    Y1 = Y1./repmat(sqrt(sum(Y1.*Y1))+1e-8,[size(Y1, 1),1]);
    Y2 = Y -E2;
    L2 = Y2;
    Y2 = Y2./repmat(sqrt(sum(Y2.*Y2))+1e-8,[size(Y2, 1),1]);    
    
    % V Hash code real-vaule matrix    
    Z2 = bits*...
        (etaS/(aS+etaX)*(aS*(B*Y1')*Y1+etaX*(B*X1_nor')* X1_nor)+...
        (1-etaS)/(aS+etaX)*(aS*(B*Y2')*Y2+etaX*(B*X2_nor')* X2_nor)-B);
    Z3 = phi*B;
    Z = Z2+Z3;
    Z = Z';
    Temp = Z'*Z-1/n*(Z'*ones(n,1)*(ones(1,n)*Z));
    [~,Lmd,QQ] = svd(Temp); clear Temp
    idx = (diag(Lmd)>1e-6);
    Q = QQ(:,idx); Q_ = orth(QQ(:,~idx));
    Pt = (Z-1/n*ones(n,1)*(ones(1,n)*Z)) *  (Q / (sqrt(Lmd(idx,idx))));
    P_ = orth(randn(n,bits-length(find(idx==1))));
    V = sqrt(n)*[Pt P_]*[Q Q_]';
    V = V';       

    F1 = F1 + rho*(Y - G1 -E1);
    F2 = F2 + rho*(Y - G2 -E2);
    O1 = O1 + rho*(G1 - O1);
    O2 = O2 + rho*(G2 - O2);
    rho = min(1e4, 1.21*rho);
    
    % A1 = P1*X1-G1;
    % A2 = P2*X2-G2;
    % norm1 = mu*(sum(sqrt(sum(A1.^2,1)))+sum(sqrt(sum(A2.^2,1))));
    % norm2 = eta*norm(G1-G2, "fro");
    % norm3 = phi*norm(B-V, "fro");
    % norm4 = beta*(norm(E1,1) + norm(E2, 1));
    % S = 0.5*(a*bits*(Y1')*Y1 + etaX*bits*(X1_nor')* X1_nor)+...
    %     0.5*(a*bits*(Y2')*Y2+ etaY*bits*(X2_nor')* X2_nor);
    % norm5 = norm(S-B'*V, "fro");
    % norm6 = lambda*(norm(P1,"fro") + norm(P2, "fro"));
    % currentF = norm1 + norm2+norm3+norm4+norm5+norm6;
    % fprintf('\nobj at iteration %d: %.4f', iter, currentF);
end
    
    W1 = (B*X1')/(X1X1+1e-3*eye(size(X1,1)));
    W2 = (B*X2')/(X2X2+1e-3*eye(size(X2,1)));
    B = B'>0;
    B1 = XTest*W1'>0;
    B2 = YTest*W2'>0;
    result_name1 = sprintf('./results/recovery/%s_%.2f_%d_1.mat', ...
                        param.db_name, param.ratio, bits);
    result_name2 = sprintf('./results/recovery/%s_%.2f_%d_2.mat', ...
                        param.db_name, param.ratio, bits);
    save(result_name1, "L1");
    save(result_name2, "L2");
end

