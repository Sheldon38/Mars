%showing image in matlab
clear all;
close all;

img = imread('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic.png');
fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_converted.txt', 'w');
if fid == -1, error('Cannot open file'); end
%fprintf(fid, '%d\n%d\n', size(img));  % Assuming it is an RGB image
fprintf(fid, '%x\n', img(:,:,1));
fclose(fid);
