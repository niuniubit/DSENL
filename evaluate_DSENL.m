function evaluation_info=evaluate_DSENL(XTrain,YTrain,LTrain,XTest,YTest,LTest,param)

    % Hash codes learning

    
    [B, B1, B2] = train_DSENL(XTrain,YTrain, LTrain, param, XTest,YTest);
    
    % Cross-Modal Retrieval
    BxTest = compactbit(B1 > 0);
    BxTrain = compactbit(B>0);
    DHamm = hammingDist(BxTest, BxTrain);
    [~, orderH] = sort(DHamm, 2);
    evaluation_info.Image_VS_Text_MAP = mAP(orderH', LTrain, LTest);
    fprintf('%dbits Image_to_Text_MAP: %f.\n', param.nbits, evaluation_info.Image_VS_Text_MAP);

    ByTest = compactbit(B2 > 0);
    ByTrain = compactbit(B>0);
    DHamm = hammingDist(ByTest, ByTrain);
    [~, orderH] = sort(DHamm, 2);
    evaluation_info.Text_VS_Image_MAP = mAP(orderH', LTrain, LTest);
    fprintf('%dbits Text_to_Image_MAP: %f.\n', param.nbits, evaluation_info.Text_VS_Image_MAP);
    
end
