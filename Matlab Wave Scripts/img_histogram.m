
img = imread('https://upload.wikimedia.org/wikipedia/commons/f/fa/Grayscale_8bits_palette_sample_image.png');


if ndims(img) == 3
  img = rgb2gray(img);
end


[rows, cols] = size(img);
intensity_levels = 0:255; 
intensity_counts = zeros(1, length(intensity_levels));


for row = 1:rows
  for col = 1:cols
    intensity = img(row, col);
    intensity_counts(intensity + 1) = intensity_counts(intensity + 1) + 1;
  end
end


bar(intensity_levels, intensity_counts);
xlabel('Intensity Level');
ylabel('Pixel Count');
title('Histogram of the Grayscale Image');
