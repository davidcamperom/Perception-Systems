function representa_datos_color_seguimiento_fondo(X,Y)
    [numDatos, numAtributos] = size(X);
    valoresY = unique(Y);
    numClases = length(valoresY);

    Colores = ['r'; 'b'; 'g'; 'y'; 'm'; 'c'; 'w'; 'k']; %Colores para los Plots
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
    legend('Datos Color Seguimiento', 'Datos Fondo Escena')
end

