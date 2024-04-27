
fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_converted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
%uselesscomments=textscan(fid,'%c',169);
ImgData = fscanf(fid, '%x ',Inf);
Img_orig     = reshape(ImgData,[256 256]);
Img_orig = cat(3, Img_orig, Img_orig, Img_orig);
Img_orig = uint8(Img_orig);

clear fid;
clear ImgData;

fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_encrypted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid,'%c',169);
ImgData = fscanf(fid, '%x ',Inf);
Img_encr     = reshape(ImgData,[256 256]);
Img_encr = cat(3, Img_encr, Img_encr, Img_encr);
Img_encr = uint8(Img_encr);

clear fid;
clear ImgData;


fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_decrypted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid,'%c',169);
ImgData = fscanf(fid, '%x ',Inf);
Img_decr     = reshape(ImgData,[256 256]);
Img_decr = cat(3, Img_decr, Img_decr, Img_decr);
Img_decr = uint8(Img_decr);

clear fid;
clear ImgData;

%Img_orig,Img_encr,Img_decr
subplot(2,2,1);
imshow(Img_decr);

if ndims(Img_orig) == 3
  Img_orig = rgb2gray(Img_orig);
end


[rows, cols] = size(Img_orig);
intensity_levels = 0:255; 
intensity_counts = zeros(1, length(intensity_levels));


for row = 1:rows
  for col = 1:cols
    intensity = Img_orig(row, col);
    intensity_counts(intensity + 1) = intensity_counts(intensity + 1) + 1;
  end
end


subplot(2,2,2);
bar(intensity_levels, intensity_counts);
xlabel('Intensity Level');
ylabel('Pixel Count');
title('Histogram of the original Image');


subplot(2,2,3);
imshow(Img_encr);

if ndims(Img_encr) == 3
  Img_encr = rgb2gray(Img_encr);
end


[rows, cols] = size(Img_encr);
intensity_levels = 0:255; 
intensity_counts = zeros(1, length(intensity_levels));


for row = 1:rows
  for col = 1:cols
    intensity = Img_encr(row, col);
    intensity_counts(intensity + 1) = intensity_counts(intensity + 1) + 1;
  end
end


subplot(2,2,4);
bar(intensity_levels, intensity_counts);
xlabel('Intensity Level');
ylabel('Pixel Count');
title('Histogram of the encrypted Image');
