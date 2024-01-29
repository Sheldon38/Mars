%showing image in matlab
img = imread('E:\clg work\Sem 4\Matlab Files\ABC.jpg');
fid = fopen('E:\clg work\Sem 4\Matlab Files\im16.txt', 'w');
if fid == -1, error('Cannot open file'); end
%fprintf(fid, '%d\n%d\n', size(img));  % Assuming it is an RGB image
fprintf(fid, '%x\n', img(:));
fclose(fid);