fid = fopen('E:\clg work\Sem 8\final_year_project\Mars\RTL\sawtooth_wave.txt', 'r');
if fid == -1, error('Cannot open file'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid,'%c',168);
sawtoothdata = fscanf(fid, '%x',Inf);
singleValue = zeros(1000,1);
for i=1:1000 
    %singleValue(i) = typecast(sawtoothdata, 'single');
    singleValue(i) = typecast(uint32(hex2dec(dec2hex(sawtoothdata(i)))),'single');
end

