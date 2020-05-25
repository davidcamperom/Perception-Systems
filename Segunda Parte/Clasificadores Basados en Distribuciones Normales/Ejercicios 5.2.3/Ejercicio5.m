clear, clc, close all
addpath('DatosEjercicio5')
addpath('FuncionesEjercicios')
load datos_MDE_2dimensiones.mat
load datos_MDM_2dimensiones.mat
load datos_MDM_3dimensiones.mat

[mCov, coef_corr1, coef_corr2, numDatosClase1, numDatosClase2, numDatos, d1, d2, d12, coeficientes_d12, Acc1, Acc2] = Calculo_Clasificador(X, Y, "MDM")
funcion_covarianza_conjunta(X,Y)
%% 1.-
numDatos = size(X,1);
porcentajeTrain = 0.7;
numDatosTrain = round(porcentajeTrain*numDatos);
numerosMuestrasTrain = randsample(numDatos,numDatosTrain);
numerosMuestrasTest = find(not(ismember(1:numDatos,numerosMuestrasTrain)));

% Conjunto de Train
XTrain = X(numerosMuestrasTrain,:);
YTrain = Y(numerosMuestrasTrain);

% Conjunto de Test
XTest = X(numerosMuestrasTest,:);
YTest = Y(numerosMuestrasTest);

% EVALUAR EL CLASIFICADOR PARA EL CONJUNTO DE TEST %
XTrain = XTest;
YTrain = YTest;

clear X, clear Y

%% 2-.
% DOS GRÁFICAS POR FIGURE %
figure,
nexttile
plot(XTrain, YTrain, 'g*')
title('Train')

nexttile
plot(XTest, YTest, 'r*')
title('Test')

%% 3.-
% MÍNIMA DISTANCIA EUCLIDEA 2 DIMENSIONES
valoresClases = unique(YTrain);
numClases = length(valoresClases);
[numDatos, numAtributos] = size(XTrain);

% REPRESENTACIÓN DE LOS DATOS %
funcion_representa_muestras_clasificacion_binaria(XTrain,YTrain)

hold on

% CALCULO DE LAS MATRICES DE COVARIANZAS DE CADA CLASE
% OBJETIVO MEDIR CORRELACIÓN ENTRE LOS DATOS Y ANALIZAR LAS SUPOSICIONES
% QUE SE TIENEN QUE CUMPLIR PARA APLICAR EL CLASIFICADOR MDE

% Aprovechamos para calcular el vector de medias de cada clase

M = zeros(numClases, numAtributos);
mCov = zeros(numAtributos, numAtributos, numClases);

for i=1:numClases
    
   FoI = YTrain == valoresClases(i);
   XClase = XTrain(FoI, :);
   M(i,:) = mean(XClase);
   mCov(:,:,i) = cov(XClase, 1);

end

hold on, plot(M(:,1),M(:,2), 'ko--')

% PODEMOS OBSERVAR QUE LAS COVARIANZAS SON CASI IGUALES %

% Varianzas de los atributos aproximadamente iguales
% Variables no correladas, covarianza de las variables aproximadamente 0
mCov_clase1 = mCov(:,:,1);
coef_corr = funcion_calcula_coeficiente_correlacion_lineal_2variables(mCov_clase1)

mCov_clase2 = mCov(:,:,2);
coef_corr = funcion_calcula_coeficiente_correlacion_lineal_2variables(mCov_clase2)

% probabilidad a priori de clases
numDatosClase1 = sum(YTrain==valoresClases(1))
numDatosClase2 = sum(YTrain==valoresClases(2))
numDatos

% SE CUMPLEN TODAS LAS CONDICIONES DE APLICACIÓN PAR LA APLICACIÓN DE MDE

%% DISEÑO DEL CLASIFICADOR MDE

% [d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDE_clasificacion_binaria(XTrain,YTrain);
[d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(XTrain,YTrain);

%% REPRESENTACIÓN DE LA FRONTERA DE SEPARACIÓN ENTRE LAS DOS CLASES: LÍNEA RECTA D12 = 0
x1min = min(XTrain(:,1)); x1max = max(XTrain(:,1));
x2min = min(XTrain(:,2)); x2max = max(XTrain(:,2));
axis([ x1min x1max x2min x2max ])

A = coeficientes_d12(1); B = coeficientes_d12(2); C = coeficientes_d12(3);
x1Recta = x1min:0.01:x1max;
x2Recta = -(A*x1Recta+C)/(B+eps);

plot(x1Recta, x2Recta, 'g')


%% APLICACIÓN DEL CLASIFICADOR: OPCIÓN CUADRÁTICA - TANTAS FUNCIONES DE DECISIÓN COMO CLASES
Y_clasificador1 = zeros(size(YTrain));

for i=1:numDatos
    XoI = XTrain(i,:);
    x1 = XoI(1);
    x2 = XoI(2);
    
    valor_d1 = eval(d1);
    valor_d2 = eval(d2);
    
    if valor_d1 > valor_d2
        Y_clasificador1(i) = valoresClases(1);
    else
        Y_clasificador1(i) = valoresClases(2);
    end
    
end

%% APLICACIÓN DEL CLASIFICADOR: OPCIÓN LINEAL - 1 FUNCIÓN PARA SEPARAR DOS CLASES
Y_clasificador2 = zeros(size(YTrain));

for i=1:numDatos
    XoI = XTrain(i,:);
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
error = Y_modelo-YTrain;
num_aciertos = sum(error==0);
Acc1 = num_aciertos / numDatos

Y_modelo = Y_clasificador2;
error = Y_modelo-YTrain;
num_aciertos = sum(error==0);
Acc2 = num_aciertos / numDatos