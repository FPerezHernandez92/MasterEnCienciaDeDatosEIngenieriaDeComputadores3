%pwd: /Users/herpefran92/Dropbox/zMaster/zRStudio/Master-en-Ciencia-De-Datos-e-Ingenieri?a-de-Computadores-3/4 Extraccion de caracteristicas en imagenes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%   1 Implementación de un descriptor  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Variable para mostrar salidas
mostrar = 1;
%Cojo una imagen y la paso a escala de grises
im = imread('data/prueba.png');
im_escala_grises = rgb2gray(im);
if (mostrar == 1)
    figure
    imshow(im_escala_grises)
end

%Aplico la función de LBPu y muestro la imagen resultante
salida = LBPu(im_escala_grises);
if (mostrar == 1)
    figure
    imshow(salida)
end

% Histograma LBPu
salida_double = double(salida);
histograma = zeros(60,1);
for i=1:size(salida_double,1)
    for j=1:size(salida_double,2)
        k = salida_double(i,j);
        histograma(k+1) = histograma(k+1)+1;
    end
end
if (mostrar == 1)
    figure
    bar(histograma);
end

%Saco las características de una imagen
caractericticas = lbp_features(salida_double);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   2 Cálculo de características  %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Leemos las imágenes
path = 'data/train/pedestrians/'; 
lista = dir([path '*.png']);
matriz_pedestrians_train = sacar_caractericticas_lista(path,lista);
matriz_pedestrians_train = transpose(matriz_pedestrians_train);
csvwrite('matriz_pedestrians_train.csv',matriz_pedestrians_train);
path = 'data/train/background/'; 
lista = dir([path '*.png']);
matriz_pedestrians_train = sacar_caractericticas_lista(path,lista);
matriz_pedestrians_train = transpose(matriz_pedestrians_train);
csvwrite('matriz_background_train.csv',matriz_pedestrians_train);
path = 'data/test/pedestrians/'; 
lista = dir([path '*.png']);
matriz_pedestrians_train = sacar_caractericticas_lista(path,lista);
matriz_pedestrians_train = transpose(matriz_pedestrians_train);
csvwrite('matriz_pedestrians_test.csv',matriz_pedestrians_train);
path = 'data/test/background/'; 
lista = dir([path '*.png']);
matriz_pedestrians_train = sacar_caractericticas_lista(path,lista);
matriz_pedestrians_train = transpose(matriz_pedestrians_train);
csvwrite('matriz_background_test.csv',matriz_pedestrians_train);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%   FUNCIONES   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creo la función para pasar la imagen en escala de grises a LBPu
function lbp = LBPu(im)
    %Variable para transformar a LBPu
    m = size(im,1);
    n = size(im,2);
    %Creo una fila de 0 para añadirla
    fila = zeros(1,n);
    c = [fila;im];
    c = [c;fila];
    %Creo una columna de 0 para añadirla
    columna = zeros((m+2),1);
    d = [c columna];
    lbp = [columna d];
    %Recorro la matriz para hacer lbp
    valor_lbpu = zeros(255,1);
    contador_etiqueta = 0;
    salida = zeros(m,n);
    %Recorro filas y columnas
    for i=2:(m+1)
        for j=2:(n+1)
            valor_a_comparar = lbp(i,j);
            lbp(i,j);
            %Sup,izq
            if (lbp(i-1,j-1)>=valor_a_comparar)
                binario = '1';
            else
                binario = '0';
            end
            %Sup,arr
            if(lbp(i-1,j)>=valor_a_comparar)
                binario(2) = '1';
            else
                binario(2)='0';
            end
            %Sup,der
            if (lbp(i-1,j+1)>=valor_a_comparar)
                binario(3)='1';
            else
                binario(3)='0';
            end
            %lad,der
            if (lbp(i,j+1)>=valor_a_comparar)
                binario(4)='1';
            else
                binario(4)='0';
            end
            %inf,der
            if (lbp(i+1,j+1)>=valor_a_comparar)
                binario(5)='1';
            else
                binario(5)='0';
            end
            %inf,abj
            if (lbp(i+1,j)>=valor_a_comparar)
                binario(6)='1';
            else
                binario(6)='0';
            end
            %inf,izq
            if (lbp(i+1,j-1)>=valor_a_comparar)
                binario(7)='1';
            else
                binario(7)='0';
            end
            %lat,izq
            if (lbp(i,j-1)>=valor_a_comparar)
                binario(8)='1';
            else
                binario(8)='0';
            end
            %sup,izq
            if (lbp(i-1,j-1)>=valor_a_comparar)
                binario(9)='1';
            else
                binario(9)='0';
            end
            %Examino el número de cambios en las transacciones
            contador_cambios = 0;
            anterior_elemento_binario = binario(1);
            for h=2:9
                if (anterior_elemento_binario ~= binario(h))
                    contador_cambios = contador_cambios +1;
                    anterior_elemento_binario = binario(h);
                end
            end
            %Convierto el binario a decimal
            convertido_a_decimal = bin2dec(binario(1:8));
            %Asigno una etiqueta
            if (convertido_a_decimal ~= 0)
                if (contador_cambios > 2)
                    valor_lbpu(convertido_a_decimal) = 58;
                elseif (valor_lbpu(convertido_a_decimal) == 0)
                    contador_etiqueta = contador_etiqueta + 1;
                    if (contador_etiqueta > 57)
                        contador_etiqueta = 57;
                    end
                    valor_lbpu(convertido_a_decimal) = contador_etiqueta;
                end
                salida(i-1,j-1) = valor_lbpu(convertido_a_decimal);
            else
                salida(i-1,j-1) = 0;
            end
        end
    end
    %Transformo la salida a uint8
    lbp = uint8(salida);
end
%Calculo del descriptor
function x = lbp_features(patch)
    %Voy a recorrer todos los bloques uno por uno
    total_bloques = 105;
    indice_i1 = 1;
    indice_j1 = 1;
    indice_i2 = 16;
    indice_j2 = 16;
    %Para todos los bloques calculo su histograma y se lo agrego al vector
    %resultante
    for h=1:total_bloques
        %Calculo el histograma de un bloque concreto
        histograma = zeros(59,1);
        for i=indice_i1:indice_i2
            for j=indice_j1:indice_j2
                k = patch(i,j);
                histograma(k+1) = histograma(k+1)+1;
            end
        end
        %Normalizo el histograma para que en total sume 1
        suma_para_normalizar = 0;
        for i=1:59
            suma_para_normalizar = suma_para_normalizar + (histograma(i)*histograma(i));
        end
        suma_para_normalizar = sqrt(suma_para_normalizar);
        for i=1:59
            histograma(i) = histograma(i)/suma_para_normalizar;
        end
        %Actualizo los índices de los bloques
        if (indice_j2 == size(patch,2))
            indice_j1 = 9;
            indice_j2 = 24;
        elseif ((indice_j2+8) == size(patch,2))
            indice_j1 = 1;
            indice_j2 = 16;
            indice_i1 = indice_i1 + 8;
            indice_i2 = indice_i2 + 8;
        else
            indice_j1 = indice_j1 + 16;
            indice_j2 = indice_j2 + 16;
        end
        if (h == 1)
            x = histograma;
        else
            x = [x;histograma];
        end
    end
end
%Calcular caractericticas de una lista de imágenes
function matriz_caract = sacar_caractericticas_lista(path,list)
    for k = 1:numel(list)
        im = imread([path list(k).name]);
        im_escala_grises = rgb2gray(im);
        %Aplico la función de LBPu y muestro la imagen resultante
        salida = LBPu(im_escala_grises);
        salida_double = double(salida);
        %Saco las características de una imagen
        caractericticas = lbp_features(salida_double);
        if (k==1)
            matriz_caract = caractericticas;
        else
            matriz_caract = [matriz_caract caractericticas];
        end
    end
end