pkg load image
pkg load statistics

close all;
clear all;
clc;

[y u v] = yuvRead('imagens/foreman.yuv', 352, 288, 2);

figure, imshow(y(:,:,1));
figure, imshow(y(:,:,2));

anterior = double(y(:,:,1));
atual = double(y(:,:,2));

[h w] = size(anterior);

count = 1;

s = 32;
tamBloco = 16;

iniciais = zeros(h/tamBloco * w/tamBloco,2);
deltas = zeros(h/tamBloco * w/tamBloco,2);

count = 1;
compensado = zeros(h,w);
for i = 1:tamBloco:h
  for j = 1:tamBloco:w
    minimo = 10000000;
    blocoFrame2 = atual(i:i+tamBloco-1, j:j+tamBloco-1);
    iniciais(count,:) = [i j];
    for k = i-s-1:i+s/2
      for l = j-s-1:j+s/2
        if 1<=k && k<=288-tamBloco && 1<=l && l<=352-tamBloco
          blocoFrame1 = anterior(k:k+tamBloco-1, l:l+tamBloco-1);
          sad = sum(sum(abs(blocoFrame2-blocoFrame1)));
          if sad < minimo
            minimo = sad;
            deltas(count,:) = [k l];
          end
        end
      end 
    end
  compensado(i:i+tamBloco-1, j:j+tamBloco-1) = anterior(deltas(count,1):deltas(count,1)+tamBloco-1, deltas(count,2):deltas(count,2)+tamBloco-1);
  #figure, imshow(blocoFrame2,[]);
  #figure, imshow(anterior(deltas(count,1):deltas(count,1)+tamBloco-1, deltas(count,2):deltas(count,2)+tamBloco-1),[]);
  #pause
  count = count+1;
  end
end

figure, imshow(compensado,[]);
hold on
quiver(iniciais(:,2),iniciais(:,1), iniciais(:,2)-deltas(:,2),iniciais(:,1)-deltas(:,1));
hold off

[m n] = size(atual);
imgray = reshape(atual, m*n, 1);
z = double(imgray);
z = kmeans(z, 3);
z = reshape(z, m, n);
figure, imshow(z, []);












