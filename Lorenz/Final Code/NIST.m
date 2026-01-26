clc; clear; close all

load img_NIST_ver1.mat

x1 = x_est(1,:)';
x2 = x_est(2,:)';
x3 = x_est(3,:)';

chaos = [x1; x2; x3];

chaos = chaos - mean(chaos);
chaos = chaos ./ max(abs(chaos));

q = uint8( floor( (chaos + 1) * 127.5 ) );

fid = fopen('nist_input.bin','wb');
fwrite(fid, q, 'uint8');
fclose(fid);

len_bits = numel(q) * 8;
disp(len_bits)
