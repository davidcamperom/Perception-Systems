%2.2.Caracterización color
clear, close all

addpath('../02_ExtracionDatos/VariablesGeneradas')
addpath('FuncionesDatos')
load Conjunto_de_Datos.mat

[numDatos, numAtributos] = size(X);
valoresY = unique(Y);
numClases = length(valoresY);

%Ejercicio explicativo: Representar en espacio RGB, los valores RGB de 
%los pixeles de color.
%%ESTE MODO NO ES EL DESEADO!!

close all
filasColor = Y == valoresY(2);

ValoresR = X(filasColor,1);
ValoresG = X(filasColor,2);
ValoresB = X(filasColor,3);

plot3(ValoresR, ValoresG, ValoresB, '.r')

%Añadir los pixeles de fondo con otro color

filasFondo = Y == valoresY(1);

ValoresR = X(filasFondo,1);
ValoresG = X(filasFondo,2);
ValoresB = X(filasFondo,3);

hold on, plot3(ValoresR, ValoresG, ValoresB, '.b')

%%PARA AÑADIR LEYENDAS A LA GRÁFICA
xlabel('Componente Roja'), ylabel('Componente Verde'), zlabel('Componente Azul')
                            %Para que todos los ejes se muevan entre 0 a 255
ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax])
legend('Datos Color', 'Datos Fondo')

%2.2.1
%%ESTE ES EL DESEADO Y USADO EN EL ALGORITMO FINAL!!
[numDatos, numAtributos] = size(X);
valoresY = unique(Y);
numClases = length(valoresY);

Colores = ['g'; 'm']; %Colores para los Plots
figure, hold on;
for i=1:numClases
    filasY = Y == valoresY(i);

    ValoresR = X(filasY,1);
    ValoresG = X(filasY,2);
    ValoresB = X(filasY,3);

    plot3(ValoresR, ValoresG, ValoresB, strcat('.',Colores(i)))
end

xlabel('Componente Roja'), ylabel('Componente Verde'), zlabel('Componente Azul')
                            %Para que todos los ejes se muevan entre 0 a 255
ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax])
legend('Datos Color', 'Datos Fondo')

