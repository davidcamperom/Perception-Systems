clear, clc, close all
addpath('DatosEjercicio4')
addpath('FuncionesEjercicios')

load datos_biomarcadores_exp1.mat
X1 = datos;
Y1 = clases;

load datos_biomarcadores_exp2.mat
X2 = datos;
Y2 = clases;

clear datos, clear clases;

%% Apartado A)
funcion_representa_muestras_clasificacion_binaria(X1,Y1)
funcion_representa_muestras_clasificacion_binaria(X2,Y2)

%% Apartado B)
% Vamos a comprobar que modelo de decisión se ajusta mejor a nuestros
% datos, para ello suponemos que las muestras son equiprobables y las
% matrices de covarianzas son iguales

disp('Número de correlación del primer experimento:')

valoresClases = unique(Y1);
numClases = length(valoresClases);

for i=1:numClases
    FoI = Y1 == valoresClases(i);
    XClase = X1(FoI,:);
    funcion_calcula_coeficiente_correlacion_lineal_2variables(cov(XClase,1))
end

disp('Número de correlación del segundo experimento:')

valoresClases = unique(Y2);
numClases = length(valoresClases);

for i=1:numClases
    FoI = Y2 == valoresClases(i);
    XClase = X2(FoI,:);
    funcion_calcula_coeficiente_correlacion_lineal_2variables(cov(XClase,1))
end

% Podemos observar que el primer experimento sus valores están cercanos a
% 0, luego podemos usar MDE, sin embargo, para el segundo los valores son
% cercanos a 1, luego es mejor usar MDM

%% MDE EXPERIMENTO 1
[d1,d2,d12,coeficientes_d12] = funcion_calcula_funciones_decision_MDE_clasificacion_binaria(X1,Y1);

%% APLICACIÓN DEL CLASIFICADOR: OPCIÓN CUADRÁTICA - TANTAS FUNCIONES DE DECISIÓN COMO CLASES
Y_clasificador1 = zeros(size(Y1));
for i=1:size(X1,1)
    
    XoI = X1(i,:);
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

Y_modelo = Y_clasificador1;
error = Y_modelo - Y1;
num_aciertos = sum(error==0);
Acc = num_aciertos/size(X1,1)

%% MDE EXPERIMENTO 2
[d1,d2,d12,coeficientes_d12] = funcion_calcula_funciones_decision_MDE_clasificacion_binaria(X2,Y2);

Y_clasificador1 = zeros(size(Y2));
for i=1:size(X2,1)
    
    XoI = X2(i,:);
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

Y_modelo = Y_clasificador1;
error = Y_modelo - Y2;
num_aciertos = sum(error==0);
Acc = num_aciertos/size(X2,1)

% Como podemos comprobar obtenemos valores casi de 1, esto significa que
% tenemos un buen ajuste, no obstante, vamos a comprobar MDM

[d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(X1,Y1);

Y_clasificador1 = zeros(size(Y1));
valoresClases = unique(Y1);
for i=1:size(X1,1)
    
    XoI = X1(i,:);
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

Y_modelo = Y_clasificador1;
error = Y_modelo - Y1;
num_aciertos = sum(error==0);
Acc = num_aciertos/size(X1,1)

[d1,d2,d12,coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(X2,Y2);
valoresClases = unique(Y2);
Y_clasificador1 = zeros(size(Y2));
for i=1:size(X2,1)
    
    XoI = X2(i,:);
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

Y_modelo = Y_clasificador1;
error = Y_modelo - Y2;
num_aciertos = sum(error==0);
Acc = num_aciertos/size(X2,1)

% Aunque MDE daba muy buenos resultados, MDM lo supera, luego para el
% experimento 1 sería correcto usar MDE y para el experimento 2 usar MDM.

%% Representacion
[d1, d2, d12, coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(X1,Y1);
funcion_representa_muestras_clasificacion_binaria(X1,Y1)
hold on

valoresClases = unique(Y1);
numClases = length(valoresClases);
[numDatos, numAtributos] = size(X1);

M = zeros(numClases, numAtributos);
mCov = zeros(numAtributos, numAtributos, numClases);
for i=1:numClases
   FoI = Y1 == valoresClases(i);
   XClase = X1(FoI, :);
   M(i,:) = mean(XClase);
   mCov(:,:,i) = cov(XClase, 1);
end
hold on, plot(M(:,1),M(:,2), 'ko--')

x1min = min(X1(:,1));x1max = max(X1(:,1));
x2min = min(X1(:,2));x2max = max(X1(:,2));
axis([x1min x1max x2min x2max]);

A = coeficientes_d12(1); B = coeficientes_d12(2); C= coeficientes_d12(3);
x1Recta = x1min:0.01:x1max;
x2Recta = -(A*x1Recta+C)/(B+eps); % A*x1+B*x2+C = 0;
plot(x1Recta,x2Recta,'g');
hold off

[d1,d2,d12,coeficientes_d12] = funcion_calcula_funciones_decision_MDM_clasificacion_binaria(X2,Y2);
funcion_representa_muestras_clasificacion_binaria(X2,Y2)
hold on

valoresClases = unique(Y2);
numClases = length(valoresClases);
[numDatos, numAtributos] = size(X2);

M = zeros(numClases, numAtributos);
mCov = zeros(numAtributos, numAtributos, numClases);
for i=1:numClases
   FoI = Y2 == valoresClases(i);
   XClase = X2(FoI, :);
   M(i,:) = mean(XClase);
   mCov(:,:,i) = cov(XClase, 1);
end
hold on, plot3(M(:,1),M(:,2), M(:,3), 'ko--')

x1min = min(X2(:,1));x1max = max(X2(:,1));
x2min = min(X2(:,2));x2max = max(X2(:,2));
x3min = min(X2(:,3));x3max = max(X2(:,3));
axis([x1min x1max x2min x2max x3min x3max]);

A = coeficientes_d12(1); B = coeficientes_d12(2); C= coeficientes_d12(3);D = coeficientes_d12(4);

Xmin = min(X2(:));
Xmax = max(X2(:));
paso = (Xmax-Xmin)/100;
[x1Plano, x2Plano] = meshgrid(Xmin:paso:Xmax);
x3Plano = -(A*x1Plano + B*x2Plano + D) / (C+eps);
surf(x1Plano,x2Plano,x3Plano);

hold off