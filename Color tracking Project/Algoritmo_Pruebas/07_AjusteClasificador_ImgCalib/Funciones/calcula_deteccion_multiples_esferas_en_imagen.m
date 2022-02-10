function Ib = calcula_deteccion_multiples_esferas_en_imagen(I, centroides_radios)
    numEsferas = size(centroides_radios,1);
    
    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    
    Ib = zeros(size(I,1),size(I,2));
    
    for i=1:numEsferas
        Rc = centroides_radios(i,1);
        Gc = centroides_radios(i,2);
        Bc = centroides_radios(i,3);
        
        radio = centroides_radios(i,4);

        MD = sqrt( (R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2 );

        % Matriz lógica
        Ib = or(Ib, MD < radio);
    end
end