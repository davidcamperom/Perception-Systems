function datosEsfera = calcula_datos_esfera(X,Y)
    valoresY = unique(Y);
    
    FoI = Y == valoresY(2);
    FoF = Y == valoresY(1);
    
    seguimientoX = X(FoI,:);
    fondoX = X(FoF,:);
    
    % 1.- Calcula centroide de la nube de puntos del color de seguimiento: Rc,
    % Gc, Bc. (El centroide es el valor medio)
    
    valoresMediosColor = mean(seguimientoX);
    Rc = valoresMediosColor(1);
    Gc = valoresMediosColor(2);
    Bc = valoresMediosColor(3);
    
    % 2.- Calcula vector distancias entre el centroide anterior y cada uno de
    % los puntos de X (hay muestras de color del objeto y de fondo).
    % 3.- Extraer los valores de cada clase: por una parte los valores de
    % distancia entre centroide y las muestras de color del objeto y, por otra,
    % los valores de distancia entre el centroide y las muestras de fondo.
    
    P = [Rc; Gc; Bc];
    NP_color = seguimientoX';
    Pamp = repmat(P,1,size(NP_color,2));
    vectorDistanciaColor = sqrt(sum((Pamp-NP_color).^2));
    
    NP_fondo = fondoX';
    Pamp = repmat(P,1,size(NP_fondo,2));
    vectorDistanciaFondo = sqrt(sum((Pamp-NP_fondo).^2));
    
    % 4.- Calcular r1, r2 a partir de los vectores distancia anteriores
    r1 = max(vectorDistanciaColor);
    r2 = min(vectorDistanciaFondo);
    
    % 5.- Cacular el radio de compromiso r12
    if(r1 > r2)
        r12 = mean([r1 r2]);
    else
        r12 = 0;
    end
    
    % 6.- Devolver datosEsfera = [Rc, Gc, Bc, r1, r2, r12] (vector fila)
    datosEsfera = [Rc, Gc, Bc, r1, r2, r12];
end

