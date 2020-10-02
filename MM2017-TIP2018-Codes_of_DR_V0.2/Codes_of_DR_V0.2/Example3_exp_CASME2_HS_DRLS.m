% This is an example of using DRLS method to deal with cross-database micro-expression recognition
% experiment whose source database is CASME2 and target database is
% SMIC(HS). The micro-expression feature is LBP-TOP with R=3, P=8.
% For more detail of this experiment, you can refer to the following references:
% [Ref.1] Y. Zong, X. Huang, W. Zheng, Z. Cui, and G. Zhao. "Learning a Target Sample Re-Generator for Cross-Database
% Micro-Expression Recognition," ACM Multimedia, 2017.
% [Ref.2] Y. Zong, W. Zheng, X. Huang, J. Shi, Z. Cui, and G. Zhao. "Domain Regeneration for Cross-Database Micro-Expression
% Recognition," IEEE Transactions on Image Processing, 2018.
clear
clc
% --------------load data-------------------
load SMIC_HS_Corpus_LBPTOP
load CASME2_Corpus_LBPTOP

database_source_features = CASME2_micro_feature;
database_source_labels = CASME2_micro_label;
database_target_features = SMIC_micro_feature;
database_target_labels = SMIC_micro_label;

% --------------kernel parameter setting-------------------
options = [];
options.t = 3;
kernel = 'Linear';% 'Gaussian' , 'Polynomial', 'PolyPlus' , 'Linear'
options.KernelType = kernel; 

% --------------preparing souce and target data-------------------  
Y_s = database_source_features; 
Y_s = Y_s';
X_s_label = database_source_labels;

Y_te = database_target_features;
Y_te = Y_te';
X_te_label = database_target_labels;

% --------------generating label vectors for source data-------------------
Ls = zeros(3,length(X_s_label));
nbclass = unique(X_s_label);
for i = 1:length(nbclass)
    labels = (X_s_label' == nbclass(i));
    labels = double(labels);
    Ls(i,:) = labels;
end

% --------------experiment starts-------------------
cnt = 0;
for lambda = [0.001,0.01,0.1,1,10,100,1000]
    for mu = [0.001:0.001:0.009,0.01:0.01:0.09,0.1:0.1:1,2:10]
    
        cnt = cnt+1

        % --------------training DRLS-------------------
        [P,Ks,Kt] = IALM_DRLS(Y_s,Y_te,Ls,options,lambda,mu);
        
        % --------------regenerating target data -------------------
        Regenerated_Y_te = P'*Kt;
        
        % --------------Option 1: directly predicting target data according to regenerated
        % target data ------------------------
        [~,predict_label] = max(Regenerated_Y_te);

        % --------------Option 2: training SVM and predicting target data -------------------
%         Regenerated_Y_s = P'*Ks;
%         linear_model = svmtrain(X_s_label, Regenerated_Y_s', '-t 0');
%         [predict_label, accuracy] = svmpredict(X_te_label, Regenerated_Y_te', linear_model);

        uar_acc = UAR(X_te_label,predict_label);
        [war_acc,cm] = WAR(X_te_label,predict_label);

        acc(1,cnt) = lambda;
        acc(2,cnt) = mu;
        acc(3,cnt) = uar_acc;
        acc(4,cnt) = war_acc;
        cm % confusion matrix

    end
end
