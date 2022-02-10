function funcion_visualiza(I, Ib, Color)
    [F C Ca] = size(I); %% Hay que devolver 3, osea una imagen a color
    
    if Ca == 1
        R = I;
        G = I;
        B = I;
    else
        R = I(:,:,1);
        G = I(:,:,2);
        B = I(:,:,3);
        
    end
    
    R(Ib==1) = Color(1);  %% == 1 para pasarla a logica
    G(Ib==1) = Color(2);
    B(Ib==1) = Color(3);
    
    imshow(cat(3,R,G,B)) 
end