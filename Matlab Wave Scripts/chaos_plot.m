fid1 = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\testing area\x1_wave.txt', 'r');
fid2 = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\testing area\x2_wave.txt', 'r');
fid3 = fopen('E:\clg work\Sem 8\final_year_project\Mars_Local\testing area\x3_wave.txt', 'r');
if fid1 == -1, error('Cannot open file 1'); end
if fid2 == -1, error('Cannot open file 2'); end
if fid3 == -1, error('Cannot open file 3'); end
%ImgSize = fscanf(fid, '%d %d', 2);
uselesscomments=textscan(fid1,'%c',173);
uselesscomments2=textscan(fid2,'%c',173);
uselesscomments3=textscan(fid3,'%c',173);
x1data = fscanf(fid1, '%x',Inf);
x2data = fscanf(fid2, '%x',Inf);
x3data = fscanf(fid3, '%x',Inf);
x1Value = zeros(20000,1);
x2Value = zeros(20000,1);
x3Value = zeros(20000,1);
for i=1:20000 
    %singleValue(i) = typecast(uint32(hex2dec(dec2hex(sawtoothdata(i)))),'single');
    x1Value(i) = typecast(uint32(hex2dec(dec2hex(x1data(i)))),'single');
    x2Value(i) = typecast(uint32(hex2dec(dec2hex(x2data(i)))),'single');
    x3Value(i) = typecast(uint32(hex2dec(dec2hex(x3data(i)))),'single');
end
x = 1:20000;
subplot(3,1,1);
plot(x,x1Value)
xlabel('iteration------>');
ylabel('x1');

subplot(3,1,2);
plot(x,x2Value)
xlabel('iteration------>');
ylabel('x2');


subplot(3,1,3);
plot(x,x3Value)
xlabel('iteration------>');
ylabel('x3');
