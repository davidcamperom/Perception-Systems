function mCov = funcion_covarianza_conjunta(X, Y)
    
    valoresClases = unique(Y);
    numClases = length(valoresClases);
    [numDatos, numAtributos] = size(X);
    
    M = zeros(numClases, numAtributos);
    mCov = zeros(numAtributos, numAtributos, numClases);
    
    for i=1:numClases

       FoI = Y == valoresClases(i);
       XClase = X(FoI, :);
       M(i,:) = mean(XClase);
       mCov(:,:,i) = cov(XClase, 1);

    end
    
    mCov_clase1 = mCov(:,:,1);
    mCov_clase2 = mCov(:,:,2);
    
    numDatosClase1 = sum(Y==valoresClases(1));
    numDatosClase2 = sum(Y==valoresClases(1));
    mCov = (numDatosClase1*mCov_clase1 + numDatosClase2*mCov_clase2 / (numDatosClase1 + numDatosClase2));
    
end