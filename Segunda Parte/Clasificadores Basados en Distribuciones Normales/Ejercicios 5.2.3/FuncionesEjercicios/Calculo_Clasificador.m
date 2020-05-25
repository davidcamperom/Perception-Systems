function [mCov, coef_corr1, coef_corr2, numDatosClase1, numDatosClase2, numDatos, d1, d2, d12, coeficientes_d12, Acc1, Acc2] = Calculo_Clasificador(X, Y, Tipo)
    close all
    addpath('FuncionesEjercicios')

    valoresClases = unique(Y);
    numClases = length(valoresClases);
    [numDatos, numAtributos] = size(X);
    
    % REPRESENTACIÓN DE LOS DATOS %
    funcion_representa_muestras_clasificacion_binaria(X,Y)
    hold on
    
    % CALCULO DE LAS MATRICES DE COVARIANZAS DE CADA CLASE
    % OBJETIVO MEDIR CORRELACIÓN ENTRE LOS DATOS Y ANALIZAR LAS SUPOSICIONES
    % QUE SE TIENEN QUE CUMPLIR PARA APLICAR EL CLASIFICADOR MDE

    % Aprovechamos para calcular el vector de medias de cada clase

    M = zeros(numClases, numAtributos);
    mCov = zeros(numAtributos, numAtributos, numClases);

    for i=1:numClases

       FoI = Y == valoresClases(i);
       XClase = X(FoI, :);
       M(i,:) = mean(XClase);
       mCov(:,:,i) = cov(XClase, 1);

    end
    
    if numAtributos < 3
        hold on, plot(M(:,1),M(:,2), 'ko--')
    else
        hold on, plot3(M(:,1),M(:,2), M(:,3), 'ko--')
    end

    % PODEMOS OBSERVAR QUE LAS COVARIANZAS SON CASI IGUALES %

    % Varianzas de los atributos aproximadamente iguales
    % Variables no correladas, covarianza de las variables aproximadamente 0
    mCov_clase1 = mCov(:,:,1);
    coef_corr1 = funcion_calcula_coeficiente_correlacion_lineal_2variables(mCov_clase1);

    mCov_clase2 = mCov(:,:,2);
    coef_corr2 = funcion_calcula_coeficiente_correlacion_lineal_2variables(mCov_clase2);

    % probabilidad a priori de clases
    numDatosClase1 = sum(Y==valoresClases(1));
    numDatosClase2 = sum(Y==valoresClases(2));

    % SE CUMPLEN TODAS LAS CONDICIONES DE APLICACIÓN PAR LA APLICACIÓN DE MDE

    %% DISEÑO DEL CLASIFICADOR MDE

    if Tipo == "MDE"
        [d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDE_clasificacion_binaria(X,Y);
    elseif Tipo == "MDM"
        [d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(X,Y);
    end

    %% REPRESENTACIÓN DE LA FRONTERA DE SEPARACIÓN ENTRE LAS DOS CLASES: LÍNEA RECTA D12 = 0
    x1min = min(X(:,1)); x1max = max(X(:,1));
    x2min = min(X(:,2)); x2max = max(X(:,2));
    
    if numAtributos == 3
        x3min = min(X(:,3));x3max = max(X(:,3));
        axis([ x1min x1max x2min x2max x3min x3max ])
    else
        axis([ x1min x1max x2min x2max ])
    end
    
    A = coeficientes_d12(1); B = coeficientes_d12(2); C = coeficientes_d12(3);
    x1Recta = x1min:0.01:x1max;
    x2Recta = -(A*x1Recta+C)/(B+eps);

    if numAtributos == 3
        D = coeficientes_d12(4);
        Xmin = min(X(:));
        Xmax = max(X(:));
        paso = (Xmax-Xmin)/100;
        [x1Plano, x2Plano] = meshgrid(Xmin:paso:Xmax);
        x3Plano = -(A*x1Plano + B*x2Plano + D) / (C+eps);
        surf(x1Plano,x2Plano,x3Plano);
    else
        plot(x1Recta, x2Recta, 'g')
    end

    %% APLICACIÓN DEL CLASIFICADOR: OPCIÓN CUADRÁTICA - TANTAS FUNCIONES DE DECISIÓN COMO CLASES
    Y_clasificador1 = zeros(size(Y));

    for i=1:numDatos
        XoI = X(i,:);
        x1 = XoI(1);
        x2 = XoI(2);
        
        if numAtributos == 3
            x3 = XoI(3);
        end

        valor_d1 = eval(d1);
        valor_d2 = eval(d2);

        if valor_d1 > valor_d2
            Y_clasificador1(i) = valoresClases(1);
        else
            Y_clasificador1(i) = valoresClases(2);
        end

    end

    %% APLICACIÓN DEL CLASIFICADOR: OPCIÓN LINEAL - 1 FUNCIÓN PARA SEPARAR DOS CLASES
    Y_clasificador2 = zeros(size(Y));

    for i=1:numDatos
        XoI = X(i,:);
        x1 = XoI(1);
        x2 = XoI(2);
        
        d12_manual = A*x1 + B*x2 + C;
        if numAtributos == 3
            x3 = XoI(3);
            d12_manual = A*x1 + B*x2 + C*x3 + D;
        end
        eval(d12);

        if d12_manual > 0
            Y_clasificador2(i) = valoresClases(1);
        else
            Y_clasificador2(i) = valoresClases(2);
        end

    end
    %% EVALUAMOS LA PRECISIÓN

    Y_modelo = Y_clasificador1;
    error = Y_modelo-Y;
    num_aciertos = sum(error==0);
    Acc1 = num_aciertos / numDatos;

    Y_modelo = Y_clasificador2;
    error = Y_modelo-Y;
    num_aciertos = sum(error==0);
    Acc2 = num_aciertos / numDatos;

end