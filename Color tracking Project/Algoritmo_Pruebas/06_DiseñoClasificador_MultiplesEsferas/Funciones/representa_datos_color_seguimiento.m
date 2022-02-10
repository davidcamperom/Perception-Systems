function representa_datos_color_seguimiento(X,Y)
    [numDatos, numAtributos] = size(X);
    valoresY = unique(Y);
    numClases = length(valoresY);
    
    filasColor = Y == valoresY(2);

    ValoresR = X(filasColor,1);
    ValoresG = X(filasColor,2);
    ValoresB = X(filasColor,3);

    figure, plot3(ValoresR, ValoresG, ValoresB, '.r')
    
    xlabel('Componente Roja'), ylabel('Componente Verde'), zlabel('Componente Azul')
                                %Para que todos los ejes se muevan entre 0 a 255
    ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax])
    legend('Datos Color Seguimiento', 'Datos Fondo Escena')
end