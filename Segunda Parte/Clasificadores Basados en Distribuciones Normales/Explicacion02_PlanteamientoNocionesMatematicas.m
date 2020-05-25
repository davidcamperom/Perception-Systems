clear, clc, close all
addpath('Datos')

% EJEMPLO DISTRIBUCIÓN DE DATOS - ESPACIO DE CARACTERÍSTICAS BIDIMENSIONAL
% OBJETOS DE UNA CLASE CARACTERIZADOS POR X1, X2

load DatosBasicos.mat

[numDatos, numCcas] = size(datos);
x1 = datos(:,1);
x2 = datos(:,2);
nombreCcas{1} = 'Caracteristica columna 1 - x1';
nombreCcas{2} = 'Caracteristica columna 1 - x2';

% Representacion de datos

DatosEjeX = x1;
DatosEjeY = x2;
plot(DatosEjeX, DatosEjeY, '*r')
axis([0 6 0 10])
legend('Datos de objetos de una Clase')
xlabel(nombreCcas{1}), ylabel(nombreCcas{2});
grid on

%Ahora tendremos que calcular el vector de medias y la matriz de
%covarianzas

% Punto Medio
M = mean(datos);
hold on, plot(M(1), M(2),'xb')

% Varianza Características 1 y 2

% En el Vector1, cada valor de la columna 1, le restamos la media (2) y al cuadrado
% En el Vector2, cada valor de la columna 2, le restamos la media (4) y al cuadrado
% IMPORTANTE, LA MEDIA SE ENCUENTRA EN LA VARIABLE M
V1 = var(datos(:,1),1) %V1 = ((1-2)^2 + (1-2)^2 + (3-2)^2 + (3-2)^2 + (2-2)^2)/5;
V2 = var(datos(:,2),1) %V2 = ((3-4)^2 + (5-4)^2 + (3-4)^2 + (7-4)^2 + (2-4)^2)/5;
V12 = ((1-2)*(3-4) + (1-2)*(5-4) + (3-2)*(3-4) + (3-2)*(7-4) + (2-2)*(2-4)) / 5

% MATRIZ DE COVARIANZAS
MCovarianza = cov(datos,1)

% CORRELACIÓN LINEAL
% Es necesario calcular la Matriz de Covarianzas para poder calcular la
% correlación. Podemos hacerlo de dos formas:

% 1. Con la Correlación Lineal de Pearson: cov{xy} / sigmax * sigmay
corr_x1_x2 = MCovarianza(1,2) / (sqrt(MCovarianza(1,1))*sqrt(MCovarianza(2,2)))

% 2. O directamente con la función de MATLAB corr( , )
corr(x1,x2)


%% CÁLCULO DE DISTANCIA EUCLÍDEO ENTRE EL PUNTO MEDIO Y UN PUNTO CUALQUIERA
% DISTANCIA EUCLÍDEA AL CUADRADO

clear, clc, close all
addpath('Datos')
load DatosBasicos.mat

[numDatos, numCcas] = size(datos);
x1 = datos(:,1);
x2 = datos(:,2);
nombreCcas{1} = 'Caracteristica columna 1 - x1';
nombreCcas{2} = 'Caracteristica columna 1 - x2';

% Representacion de datos

DatosEjeX = x1;
DatosEjeY = x2;
plot(DatosEjeX, DatosEjeY, '*r')
axis([0 6 0 10])
legend('Datos de objetos de una Clase')
xlabel(nombreCcas{1}), ylabel(nombreCcas{2});
grid on

% Punto Medio

M_vector_fila = mean(datos);
hold on, plot(M_vector_fila(1), M_vector_fila(2),'xb')

% Forma de introducir manualmente valores de dos puntos
x1 = 3; x2 = 5; X = [x1; x2];
M = M_vector_fila';
d_2 = ((X-M)'*(X-M)) %Distancia entre dos puntos en 2D (plano)
% d^2 (Distancia al cuadrado)

% Planteamiento Teórico Distancia del Centro a Cualquier punto dado por x1
% y x2

x1 = sym('x1','real');
x2 = sym('x2','real');

X = [x1; x2];
d_2 = expand((X-M)'*(X-M));
x1 = 3; x2 = 5; eval(d_2)


%% CÁLCULO DE DISTANCIA EUCLÍDEA ENTRE EL PUNTO MEDIO Y UN PUNTO CUALQUIERA

% DISTANCIA EUCLÍDEA AL CUADRADO
% Se haría de la misma forma que anteriormente hemos hecho

% DISTANCIA DE MAHALANOBIS
%Introduciríamos los datos como hemos hecho anteriormente

MCovarianza = cov(datos, 1)
x1 = sym('x1', 'real');
x2 = sym('x2', 'real');
X = [x1; x2];
dM2 = expand((X-M)'*pinv(MCovarianza)*(X-M));
% Siendo pinv(MCovarianza) el producto inverso de la Matriz de Covarianzas (MCovarianza)
x1 = 3; x2 = 5; eval(dM2)
x1 = 6; x2 = 7; eval(dM2)






