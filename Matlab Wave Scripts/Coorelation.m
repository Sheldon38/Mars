fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_converted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
%uselesscomments=textscan(fid,'%c',169);
ImgData = fscanf(fid, '%x ',Inf);
Img_orig     = reshape(ImgData,[256 256]);
Img_orig = cat(3, Img_orig, Img_orig, Img_orig);
Img_orig = uint8(Img_orig);

image = double(Img_orig);
%image = double(image);


kernel_horizontal = [1 1 1; 0 0 0; -1 -1 -1]; % Horizontal edge detection
kernel_vertical = [1 0 -1; 1 0 -1; 1 0 -1]; % Vertical edge detection
kernel_diagonal = [1 0 -1; 0 0 0; -1 0 1]; % Diagonal edge detection


correlation_horizontal = conv2(image(:,:,1), kernel_horizontal, 'same');
correlation_vertical = conv2(image(:,:,1), kernel_vertical, 'same');
correlation_diagonal = conv2(image(:,:,1), kernel_diagonal, 'same');


disp(['Correlation in horizontal direction: ', num2str(max(correlation_horizontal(:)))]);
disp(['Correlation in vertical direction: ', num2str(max(correlation_vertical(:)))]);
disp(['Correlation in diagonal direction: ', num2str(max(correlation_diagonal(:)))]);


subplot(2,4,1), imshow(Img_orig), title('Original Image');
subplot(2,4,2), imshow(uint8(correlation_horizontal), []), title('Horizontal Correlation');
subplot(2,4,3), imshow(uint8(correlation_vertical), []), title('Vertical Correlation');
subplot(2,4,4), imshow(uint8(correlation_diagonal), []), title('Diagonal Correlation');


clear ImgData;
clear image;
fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_encrypted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid,'%c',169);
ImgData = fscanf(fid, '%x ',Inf);
Img_encr     = reshape(ImgData,[256 256]);
Img_encr = cat(3, Img_encr, Img_encr, Img_encr);
Img_encr = uint8(Img_encr);

image = double(Img_encr);

correlation_horizontal = conv2(image(:,:,1), kernel_horizontal, 'same');
correlation_vertical = conv2(image(:,:,1), kernel_vertical, 'same');
correlation_diagonal = conv2(image(:,:,1), kernel_diagonal, 'same');


disp(['Correlation in horizontal direction: ', num2str(max(correlation_horizontal(:)))]);
disp(['Correlation in vertical direction: ', num2str(max(correlation_vertical(:)))]);
disp(['Correlation in diagonal direction: ', num2str(max(correlation_diagonal(:)))]);

subplot(2,4,5), imshow(Img_encr), title('encrypted Image');
subplot(2,4,6), imshow(uint8(correlation_horizontal), []), title('Horizontal Correlation');
subplot(2,4,7), imshow(uint8(correlation_vertical), []), title('Vertical Correlation');
subplot(2,4,8), imshow(uint8(correlation_diagonal), []), title('Diagonal Correlation');
