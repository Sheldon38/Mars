%imgconvert
fid = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\image\ps2_pic_encrypted.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid,'%c',168);
ImgData = fscanf(fid, '%x ',Inf);
Img     = reshape(ImgData,[256 384]);
Img = cat(3, Img, Img, Img);
Img = uint8(Img);
imshow(Img);
fclose(fid);