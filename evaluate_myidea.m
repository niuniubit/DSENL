function evaluation_info=evaluate_myidea(XTrain,YTrain,LTrain,XTest,YTest,LTest,param)
      
    tic;
    % Hash codes learning
    seed=2024;
    rng('default');
    rng(seed);
    [L_tr, LTrain] = noisy_lable(LTrain,param);
    [ I_tr, I_te, T_tr, T_te] = centerlizeData(double(XTrain), double(XTest), double(YTrain),double(YTest));
    n = size(I_tr, 1);
    anchorIndex = sort(randperm(n, param.nanchors));
    [Ktr1, Ktr2, Kte1, Kte2, Kanchor1, Kanchor2] = kernelTrans(I_tr, T_tr, I_te, T_te, anchorIndex);
    
    [B, B1, B2] = myidea(Ktr1, Ktr2, LTrain, param, Kte1, Kte2);
    
    traintime=toc;
    evaluation_info.trainT=traintime;
    
    tic;
    
    % Cross-Modal Retrieval
    BxTest = compactbit(B1 > 0);
    BxTrain = compactbit(B>0);
    DHamm = hammingDist(BxTest, BxTrain);
    [~, orderH] = sort(DHamm, 2);
    evaluation_info.Image_VS_Text_MAP = mAP(orderH', L_tr, LTest);
    [evaluation_info.Image_VS_Text_precision, evaluation_info.Image_VS_Text_recall] = precision_recall(orderH', L_tr, LTest);
    evaluation_info.Image_To_Text_Precision = precision_at_k(orderH', L_tr, LTest,param.top_K);
    

    ByTest = compactbit(B2 > 0);
    ByTrain = compactbit(B>0);
    DHamm = hammingDist(ByTest, ByTrain);
    [~, orderH] = sort(DHamm, 2);
    evaluation_info.Text_VS_Image_MAP = mAP(orderH', L_tr, LTest);
    [evaluation_info.Text_VS_Image_precision,evaluation_info.Text_VS_Image_recall] = precision_recall(orderH', L_tr, LTest);
    evaluation_info.Text_To_Image_Precision = precision_at_k(orderH', L_tr, LTest,param.top_K);
    compressiontime=toc;
    
    evaluation_info.compressT=compressiontime;
    %evaluation_info.BxTrain = BxTrain;
    %evaluation_info.ByTrain = ByTrain;
    %evaluation_info.B = B;

end
