function main_DSENL()
clear;
clc;
%% parameters setting
n_anchors=1500;
%% load dataset
db_name = 'MIRFLICKR';
datasets = ['datasets/' db_name '.mat'];
load(datasets); 
XTrain = I_tr; YTrain = T_tr; LTrain = L_tr;
XTest = I_te; YTest = T_te; LTest = L_te;
if ~exist('result/', 'dir')
    mkdir('result/');
end

%% kernel
seed=2024;
rng('default');
rng(seed);
[ I_tr, I_te, T_tr, T_te] = centerlizeData(double(XTrain), double(XTest), double(YTrain),double(YTest));
n = size(I_tr, 1);
anchorIndex = sort(randperm(n, n_anchors));
[Ktr1, Ktr2, Kte1, Kte2, Kanchor1, Kanchor2] = kernelTrans(I_tr, T_tr, I_te, T_te, anchorIndex);
%% initial data
param.nbits = 16;

    param.beta = 1e2;
    param.mu = 1e-2;
    param.phi = 1e1;
    param.eta = 1e2;
    param.lambda = 1e-3;
    param.alpha = 1e-2;

param.iter = 10;
%% train
eva_info=evaluate_DSENL(Ktr1, Ktr2,LTrain,Kte1, Kte2,LTest,param);
% MAP
param.Image_to_Text_MAP = eva_info.Image_VS_Text_MAP;
param.Text_to_Image_MAP = eva_info.Text_VS_Image_MAP;
% train time

end
