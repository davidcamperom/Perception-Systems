function areas = calcula_areas(Matriz_etiquetada)

    A = unique(Matriz_etiquetada);
    etiquetas = A(find(A~=0));
    [n,c] = size(etiquetas);
    areas = zeros(n,c);

    for i=1:n
        B = find(Matriz_etiquetada == etiquetas(i,1));
        [areas(i,1),~] = size(B);
    end
end
