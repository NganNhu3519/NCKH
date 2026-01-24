clc; clear;

imgExt = {'*.png','*.jpg','*.jpeg','*.tif','*.tiff','*.bmp'};
imgDir = fullfile(matlabroot,'toolbox');

files = [];
for k = 1:numel(imgExt)
    files = [files; dir(fullfile(imgDir,'**',imgExt{k}))];
end

maxPixels = 0;
maxFile   = '';

for k = 1:numel(files)
    try
        info = imfinfo(fullfile(files(k).folder, files(k).name));
        pixels = info.Width * info.Height;
        if pixels > maxPixels
            maxPixels = pixels;
            maxFile = fullfile(files(k).folder, files(k).name);
        end
    catch
        % bỏ qua file lỗi
    end
end

fprintf('Largest image:\n%s\n', maxFile);
fprintf('Size: %d x %d (%d pixels)\n', info.Width, info.Height, maxPixels);
