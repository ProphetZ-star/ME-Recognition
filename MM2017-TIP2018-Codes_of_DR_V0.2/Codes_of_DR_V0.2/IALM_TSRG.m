function [P,Ks,Kt] = IALM_TSRG(Xs,Xt,options,lambda,mu)
% Written by Yuan Zong, April 4, 2017.
% For ACM MM 2017
% TSRG is actually DRFS-S under the DR framework proposed in [Ref.2].
% DRFS-T is similar to DRFS-S and is implemented by exchanging the inputs
% of Xs and Xt.
% [Ref.1] Y. Zong, X. Huang, W. Zheng, Z. Cui, and G. Zhao. "Learning a Target Sample Re-Generator for Cross-Database
% Micro-Expression Recognition," ACM Multimedia, 2017.
% [Ref.2] Y. Zong, W. Zheng, X. Huang, J. Shi, Z. Cui, and G. Zhao. "Domain Regeneration for Cross-Database Micro-Expression
% Recognition," IEEE Transactions on Image Processing, 2018.
tol = 1e-8;
maxIter4p = 1e6;
rho = 1.1;
max_kappa = 1e15;
kappa = 1e-3;
% iter = 0;
nbs = size(Xs,2);
nbt = size(Xt,2);
Kss = constructKernel(Xs',[],options);
Ktt = constructKernel(Xt',[],options);
Kts = constructKernel(Xt',Xs',options);
Kst = constructKernel(Xs',Xt',options);
Ks = [Kss;Kts];
Kt = [Kst;Ktt];
K_delta = Ks*ones(nbs,1)/nbs - Kt*ones(nbt,1)/nbt;
K_new = [Ks,sqrt(lambda)*K_delta];
[U,D,U] = svd(K_new*K_new');


% W = ones(nbs,nbt);
d = size(Xs,1);
% [tmpP,D,tmpP] = svd(K_new);
P = ones(nbs+nbt,d);
T=P;

      
    % step 1. fix W, update P
    iter4p = 0;
    % update P    
%     L = Xs;
while iter4p<maxIter4p
    iter4p = iter4p + 1;


    % 1.1 update Q
     
    tmp = diag(D)+kappa/2*ones(size(D,1),1);
    inv_tmp = tmp.^-1;
    Q = U*(diag(inv_tmp))*(U'*(Ks*Xs'+(kappa*P+T)/2));
    
    % 1.2 update P
    W1 = Q - T/kappa;
    P = max(W1-mu/kappa,0);
    P = P + min(W1+mu/kappa,0);
%     P_rmb{iter} = P;
    
    % 1.3 update kappa and T
%     kappa = max(kappa_max,rho*kappa);
%     T = T + kappa*(P-Q);
    
    % 1.4 check convergence
    leq = P-Q;
    stopC =max(max(abs(leq)));
    if iter4p==1 || mod(iter4p,50)==0 || stopC<tol
        disp(['iter ' num2str(iter4p) ',mu=' num2str(kappa,'%2.1e') ...
            ',stopALM=' num2str(stopC,'%2.3e')]);
    end
    if stopC<tol 
        disp('The optimization of P is done.');
        break;
    else
        T = T + kappa*leq;
        kappa = min(max_kappa,kappa*rho);
    end
end
%     loss(iter) = norm(Xs-P'*Ks)^2 + norm(Xs*W-P'*Kt)^2 + lambda*sum(sum(abs(W)))+mu*sum(sum(abs(P)));

