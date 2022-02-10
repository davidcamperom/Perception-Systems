function representa_datos_fondo(X,Y)
    [numDatos, numAtributos] = size(X);
    valoresY = unique(Y);
    numClases = length(valoresY);
    
    %Añadir los valores RGB de los píxeles de fondo en otro color
    filasFondo = Y == valoresY(1);
    
    ValoresR = X(filasFondo,1);
    ValoresG = X(filasFondo,2);
    ValoresB = X(filasFondo,3);
    
    hold on, plot3(ValoresR, ValoresG, ValoresB, '.b')

    xlabel('Componente Roja'), ylabel('Componente Verde'), zlabel('Componente Azul')
                                %Para que todos los ejes se muevan entre 0 a 255
    ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax])
    legend('Datos Fondo Escena')
end

