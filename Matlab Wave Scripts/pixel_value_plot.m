fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_encrypted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid,'%c',169);
ImgData = fscanf(fid, '%x ',Inf);
Img_orig     = reshape(ImgData,[256 256]);
Img_orig = cat(3, Img_orig, Img_orig, Img_orig);
Img_orig = uint8(Img_orig);

img = Img_orig;
%img = imread('https://upload.wikimedia.org/wikipedia/commons/f/fa/Grayscale_8bits_palette_sample_image.png'); 


if ndims(img) == 3
  
  img = rgb2gray(img);
end


[rows, cols] = size(img);


x = img(1:rows-1, 1:cols-1);  % Grayscale values at (x, y)
y_right = img(1:rows-1, 2:cols);  % Grayscale values at (x+1, y)
y_down = img(2:rows, 1:cols-1);  % Grayscale values at (x, y+1)
y_diag = img(2:rows, 2:cols);    % Grayscale values at (x+1, y+1)


figure;
subplot(2,2,1);
scatter(x, y_right, 'b.');
xlabel('Pixel Value (x, y)');
ylabel('Pixel Value (x+1, y)');
title('Right Neighbor');

subplot(2,2,2);
scatter(x, y_down, 'b.');
xlabel('Pixel Value (x, y)');
ylabel('Pixel Value (y+1, x)');
title('Down Neighbor');

subplot(2,2,3);
scatter(x, y_diag, 'b.');
xlabel('Pixel Value (x, y)');
ylabel('Pixel Value (x+1, y+1)');
title('Diagonal Neighbor');


sgtitle('Scatter Plots of Neighboring Pixel Intensities');
