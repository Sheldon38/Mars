
image = imread('https://upload.wikimedia.org/wikipedia/commons/f/fa/Grayscale_8bits_palette_sample_image.png');


image = double(image);


kernel_horizontal = [1 1 1; 0 0 0; -1 -1 -1]; % Horizontal edge detection
kernel_vertical = [1 0 -1; 1 0 -1; 1 0 -1]; % Vertical edge detection
kernel_diagonal = [1 0 -1; 0 0 0; -1 0 1]; % Diagonal edge detection


correlation_horizontal = conv2(image, kernel_horizontal, 'same');
correlation_vertical = conv2(image, kernel_vertical, 'same');
correlation_diagonal = conv2(image, kernel_diagonal, 'same');


disp(['Correlation in horizontal direction: ', num2str(max(correlation_horizontal(:)))]);
disp(['Correlation in vertical direction: ', num2str(max(correlation_vertical(:)))]);
disp(['Correlation in diagonal direction: ', num2str(max(correlation_diagonal(:)))]);


figure;
subplot(1,3,1), imshow(uint8(correlation_horizontal), []), title('Horizontal Correlation');
subplot(1,3,2), imshow(uint8(correlation_vertical), []), title('Vertical Correlation');
subplot(1,3,3), imshow(uint8(correlation_diagonal), []), title('Diagonal Correlation');
