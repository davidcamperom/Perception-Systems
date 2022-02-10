function centroides = calcula_centroides(Matriz_etiquetada)

    A = unique(Matriz_etiquetada);
    etiquetas = A(find(A~=0));
    [n,c] = size(etiquetas);
    centroides = zeros(n,2);

    for i=1:n
        [fi,co] = find(Matriz_etiquetada==etiquetas(i,1));
        [numx,~] = size(co);
        [numy,~] = size(fi);
        x = sum(co)/numx;
        y = sum(fi)/numy;
        centroides(i,1) = round(x);
        centroides(i,2) = round(y);
    end
end