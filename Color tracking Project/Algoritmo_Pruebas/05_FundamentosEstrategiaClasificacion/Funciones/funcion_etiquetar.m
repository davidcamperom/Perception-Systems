function [Ires,N] = funcion_etiquetar(Ib)
    %Ires es la matriz double con los valores de 1 a N dependiendo
    %de los objetos que se hayan etiquetado.
    %Se pasa por par�metro una matriz binaria (Ib), donde 0 es el fondo y
    %1 la figura.

    %unique -> Devuelve los valores distintos que hay en una matriz

    %size(Ib) devuelve dos variables (en este caso), que son el n�mero
    %de filas (el total) y n�mero de columnas (el total)
    [F,C] = size(Ib);
    %Convertimos a double para trabajar con ella
    Id = double(Ib); %Id ser� nuestra matriz inicial original

    %Rellenamos con 0
    fila = zeros(1,C+2);
    columna = zeros(F,1);
    I = [fila;columna,Id,columna;fila];
    
    %Hay que tener en cuenta que hemos a�adido 0s para hacer la vecindad
    %de 8
    %%  0 0 0 0 0
    %%  0 X X X 0
    %%  0 X X X 0
    %%  0 X X X 0
    %%  0 0 0 0 0

    %%Recorremos la matriz double y asignamos el valor del contador + 1
    %%ESTO ES EL ETIQUETADO DE LA IMAGEN
    contador = 1;
    for c=2:C-1 %Desde la segunda columna hasta la �ltima - 1
        for f=2:F-1 %Desde la segunda fila hasta la �ltima - 1
            if I(f,c) == 1 %Si es mi imagen (y no fondo)
                I(f,c) = contador; %Aqu� etiquetamos los valores distintos de 0
                contador = contador + 1; %Le asignamos valores distintos a
                %a cada uno de ellos
            end
        end
    end

    %%Seguimos etiquetando mientras haya cambios. Salimos en el momento
    %en el que no haya
    cambio = true;
    while(cambio)
        cambio = false;
        %Recorrido Arriba-Abajo
        %V = columna-1 (primera columna) y, fila-1 y fila concatenada
        %Sacamos el m�nimo n�mero para concatenar y aplicamos el n�mero
        %al pixel en cuesti�n (M).
        %%Se usa conectividad-4, con orden de izq a der y arriba-abajo
        %%Como es vecindad 8 con conectividad-4, solo ser�n los 3 p�xeles
        %%de arriba y el cuarto, siendo el primero de abajo izquierda.
        %V = [I(f-1:f,c-1)', I(f-1,c-1:c+1)];
        %% A A A
        %% A M X
        %% X X X
        %% La M indica el primer pixel y las A lo que tenemos que obtener
        %% (la conectividad-4 que hemos comentado anteriormente)
        for c=2:C-1 %Desde la segunda columna hasta la �ltima - 1
            for f=2:F-1 %Desde la segunda fila hasta la �ltima - 1
                if (I(f,c)~= 0) %Si hay distintos numero de 0 (numeros que han
                               %sido etiquetados), pasamos a obetner el menor
                               %numero de todos ellos.
                    V = [I(f-1:f,c-1)', I(f-1,c-1:c+1)];
                    menor = min(V(V>0 & V<I(f,c)));
                    %Cambiamos los valores superiores por el menor n�mero obtenido anteriormente
                    if menor < I(f,c) 
                        I(f,c) = menor;
                        cambio = true; %Como hay cambio, sigo haci�ndolo.
                    end
                end
            end
        end
        
        %Recorrido Abajo-Arriba
        %V = columna+1 (ultima columna) y, fila+1 y fila. concatenada
        %Sacamos el minimo n�mero para concatenar y aplicamos el n�mero
        %al pixel en cuesti�n (M).
        %%Se usa conectividad-4, con orden de der a izq y abajo-arriba
        %%Como es vecindad 8 con conectividad-4, solo ser�n los 3 p�xeles
        %%de abajo y el cuarto, siendo el �ltimo de la fila izquierda.
        %V = [I(f:f+1,c+1)', I(f+1,c-1:c+1)];
        %% A A A
        %% A M X
        %% X X X
        %% La M indica el primer pixel y las X lo que tenemos que obtener
        %% (la conectividad-4 que hemos comentado anteriormente)
        for c=C-1:-1:2 %Desde C-1, con paso -1 (decremento) hasta 2
                       %(no queremos la columna 1, ya que es de 0s)
            for f=F-1:-1:2
                if(I(f,c) ~=0)
                    V = [I(f:f+1,c+1)', I(f+1,c-1:c+1)];
                    menor = min(V(V>0 & V<I(f,c)));
                    if menor < I(f,c)
                        I(f,c) = menor;
                        cambio = true;
                    end
                end
            end
        end
        
        %%Tenemos nuestra imagen etiquetada, ahora solo queda eliminar
        %%los 0s (que representan el fondo)
        Ires = I(2:F-1,2:C-1); %%Devolvemos la matriz sin los marcos
        B = unique(Ires);
        B(1) = [];
        [N, ~] = size(B);
        [F, C] = size(Ires);
        for i=1:N
            for f=1:F
                for c=1:C
                    index = B(i);
                    if Ires(f,c) == index
                        Ires(f,c) = i;
                    end
                end
            end
        end

    end
end
        