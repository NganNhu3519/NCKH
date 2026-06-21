clear; clc; close all;

load img_NIST_ver1_work.mat

X = x(:,1:3);
bitstream = [];

for i = 1:3
val = X(:,i);
temp_bits = mod(floor(abs(val) * 1e10), 256);
bin_matrix = dec2bin(temp_bits, 8) - '0';
% bitstream = [bitstream; bin_matrix(:)];
temp_stream = bin_matrix';
bitstream = [bitstream; temp_stream(:)];
end

bitstream = uint8(bitstream);
len = length(bitstream);

fprintf('Total bits: %d\n', len);
fprintf('Bit-1 ratio: %.4f\n', mean(bitstream));

Xpm = 2 * double(bitstream) - 1;

S_freq = sum(Xpm);
Sn = abs(S_freq) / sqrt(len);

fprintf('Frequency test statistic Sn = %.3f\n', Sn);

S_cumsum = cumsum(Xpm);
J = sum(S_cumsum == 0);

fprintf('Random Excursions cycle count J = %d\n', J);

if J < 500
fprintf('NIST Random Excursions requirement NOT satisfied (J < 500)\n');
else
fprintf('NIST Random Excursions requirement satisfied\n');
end

fid = fopen('chaos_nist_input.bin', 'wb');
fwrite(fid, bitstream, 'ubit1');
fclose(fid);

disp('Binary NIST input file generated.');

fid = fopen('chaos_nist_input.bin', 'rb');
bits = fread(fid, inf, 'ubit1');
fclose(fid);

bit_string = char(bits' + '0');

clipboard('copy', bit_string);

disp('Bitstream copied to clipboard.');
