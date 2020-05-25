%%EJEMPLO DE CONCEPTOS BÁSICOS - HISTOGRAMAS

I = uint8([ 0 1 5 0; 2 2 2 5 ])
imhist(I)
h = imhist(I);
stem(0:5,h(1:6),'.r'), grid on

%%VALOR MEDIO:

% 1.- RECORRIENDO TODOS LOS PÍXELES DE LA IMAGEN

%FORMA LARGA
Id = double(I);
[numFilas, numColumnas] = size (Id);
numPix = numFilas * numColumnas;
ValorMedio = 0;

for i = 1:numFilas
    for j = 1:numColumnas
        ValorMedio = ValorMedio + Id(i,j);
    end
end

ValorMedio = ValorMedio / numPix

%FOR CORTA
ValorMedio = mean(Id(:))


% 2.- A PARTIR DEL HISTOGRAMA

h = imhist(I);
p = h/sum(h);
ValorMedio = 0;
for g = 0:255
    ind = g+1; %Indice del histograma del vector
    ValorMedio = ValorMedio + g*p(ind)
end

%%VARIANZA: DESVIACIÓN TÍPICA AL CUADRADO

% 1.- RECORRIDO DE TODOS LOS PÍXELES DE LA IMAGEN

Id = double(I); %Operaciones en tipo double
[numFilas, numColumnas] = size (Id);
numPix = numFilas*numColumnas;
varianza = 0; %Nos creamos una variable a 0 y vamos acumulando todas las 
              %sumas
for i=1:numFilas
    for j=1:numColumnas
        varianza = varianza + (Id(i,j)- ValorMedio)^2;
                              %Esto es cada pixel, como se desvía
                              %cuadráticamente respecto al valor medio de
                              %la imagen
    end
end

varianza = varianza/numPix
varianza = var(Id(:),1) %La función es var( , 1)

% 2.- A PARTIR DEL HISTOGRAMA

h = imhist(I);
numPix = sum(h);

varianza = 0;
for g=0:255
    ind = g+1;
    varianza = varianza + h(ind)*(g-ValorMedio)^2;
end
varianza = varianza/numPix
