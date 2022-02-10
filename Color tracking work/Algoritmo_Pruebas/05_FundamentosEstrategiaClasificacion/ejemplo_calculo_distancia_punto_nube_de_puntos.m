close all, clear

%% RUTAS A DIRECTORIOS CON INFORMACION
addpath('../02_ExtracionDatos/VariablesGeneradas')

%% LECTURA DE CONJUNTO DE DATOS
load Conjunto_de_Datos.mat;

%% AYUDA MATLAB: CALCULO DE DISTANCIAS DE UN PUNTO A UNA NUBE DE PUNTOS

% Ejemplo1:
% Calculo distancia entre dos puntos A y B: por ejemplo los dos primeros
% puntos de X

% En enunciado PDF, p?gina 5, ayuda calculo de distancia, si A y B con los
% dos puntos definidos en MATLAB como vectores columna:
% Distancia = sqrt((sum(A-B).^2)); % Distancia = sqrt((A-B)'*(A-B));
A = X(1,:)';
B = X(2,:)';
[A B]
dAB = sqrt((sum(A-B).^2)); % Distancia = sqrt((A-B)'*(A-B));

% Ejemplo2:
% Calculo distancia un punto P a una nube de puntos NP

% Sea P el primer punto de X y la NP los 5 primeros puntos de X
P = X(1,:)';
NP = X(1:5,:)';

% Observar que se hace la traspuesta para trabajar con los puntos en
% columnas
vectorDistancia = zeros(1,size(NP,2))

% Se puede, tras definir el punto P, recorrer con un bucle cada punto de
% NP, e ir aplicando la expresion de la linea 21, para completar el vector
% de distancia

% Mas eficiente: hacerlo de forma matricial
% 1.- Repetimos utilizando la funcion repmat, el vector P, tantas veces
% como muestras hay en la nube de puntos
Pamp = remat(P,1,size(NP,2)) % 1 fila de P y size(NP,2) columnas

% 2.- Calculamos la distancia de forma matricial
vectorDistancia = sqrt(sum((Pamp-NP).^2))

