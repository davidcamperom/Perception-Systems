function pos_outliers = funcion_detecta_outliers_clase_interes(X,Y)
    X = double(X);

    valoresY = unique(Y);
    
    R = X(:,1);
    G = X(:,2);
    B = X(:,3);
    
    FoI = Y == valoresY(2);
    
    medias = mean(X(FoI,:)) ; desv = std(X(FoI,:));
    
    Rmean = medias(1); Rstd = desv(1);
    Gmean = medias(2); Gstd = desv(2);
    Bmean = medias(3); Bstd = desv(3);
    
    factor_outlier = 3;
    
    outR = (R > Rmean + factor_outlier* Rstd) | (R < Rmean - factor_outlier*Rstd);
    outG = (G > Gmean + factor_outlier* Gstd) | (G < Gmean - factor_outlier*Gstd);
    outB = (B > Bmean + factor_outlier* Bstd) | (B < Bmean - factor_outlier*Bstd);
    
    outR = and(FoI,outR);
    outG = and(FoI,outG);
    outB = and(FoI,outB);
    
    outR_G = or(outR,outG);
    outR_G_B = or(outR_G,outB);
    
    pos_outliers = find(outR_G_B);
    
end