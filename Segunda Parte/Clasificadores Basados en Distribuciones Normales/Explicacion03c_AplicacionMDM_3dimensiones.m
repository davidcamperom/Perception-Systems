clear, clc, close all
addpath('Datos')
addpath('Funciones')

load datos_MDM_3dimensiones.mat

valoresClases = unique(Y);
numClases = length(valoresClases);
[numDatos, numAtributos] = size(X);

%% REPRESENTACIÓN DE LOS DATOS
funcion_representa_muestras_clasificacion_binaria(X,Y)

hold on

%% DISEÑOR DEL CLASIFICADOR MDM

[d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(X,Y);

%% REPRESENTACIÓN DE LA FRONTERA DE SEPARACIÓN ENTRE LAS DOS CLASES: LINEA RECTA d12 = 0
% AHORA ES UN PLANO -'UTILIZAMOS FUNCION DE MATLAB meshgrid y surf PARA
% REPRESENTARLO: A*x1+B*x2+C*x3+D = 0

x1min = min(X(:,1)); x1max = max(X(:,1));
x2min = min(X(:,2)); x2max = max(X(:,2));
x3min = min(X(:,3)); x3max = max(X(:,3));
axis([x1min x1max x2min x2max x3min x3max])

A = coeficientes_d12(1); B = coeficientes_d12(2); C = coeficientes_d12(3), D = coeficientes_d12(3);

Xmin = min(X(:));
Xmax = max(X(:));
paso = (Xmax-Xmin)/100;
[x1Plano, x2Plano] = meshgrid(Xmin:paso:Xmax);
x3Plano = -(A*x1Plano + B*x2Plano + D)/(C+eps);
surf(x1Plano, x2Plano, x3Plano)

%% APLICACIÓN DEL CLASIFICADOR: OPCIÓN CUADRÁTICA - TANTAS FUNCIONES DE DECISIÓN COMO CLASES

Y_clasificador1 = zeros(size(Y));

for i=1:numDatos
    XoI = X(i,:);
    x1 = XoI(1);
    x2 = XoI(2);
    x3 = XoI(3);
    
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
A = coeficientes_d12(1); B = coeficientes_d12(2); C = coeficientes_d12(3);

for i=1:numDatos
    XoI = X(i,:);
    x1 = XoI(1);
    x2 = XoI(2);
    x3 = XoI(3);
    
    d12_manual = A*x1 + B*x2 + C*x3 +D;
    eval(d12);

    if d12_manual > 0
        Y_clasificador2(i) = valoresClases(1);
    else
        Y_clasificador2(i) = valoresClases(2);
    end
end

%% EVALUAMOS LA PRECISIÓN

% Precisión del Clasificador 1
Y_modelo = Y_clasificador1;

error = Y_modelo-Y;

num_aciertos = sum(error==0);

Acc1 = num_aciertos/numDatos

% Precisión del Clasificador 2
Y_modelo = Y_clasificador2;

error = Y_modelo-Y;

num_aciertos = sum(error==0);

Acc2 = num_aciertos/numDatos