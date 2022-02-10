function Ib = calcula_deteccion_1esfera_en_imagen(I,centroides_radios)
    
    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,2));
    
    Rc = centroides_radios(1,1);
    Gc = centroides_radios(1,2);
    Bc = centroides_radios(1,3);
    
    radio = centroides_radios(1,4);
    
    MD = sqrt((R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2);
    
    Ib = MD < radio;
end

