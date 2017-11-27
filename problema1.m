close all
clear all
clc

im = imread("imagens/cookies.tif");
figure, imshow(im);

bw = im2bw(im,graythresh(im));
figure, imshow(bw);

se = strel('disk',60,0);
erodido = imerode(bw, se);
figure, imshow(erodido);

dilatado = imdilate(erodido,se);
figure, imshow(dilatado);

result = im .* dilatado;
figure, imshow(result);
