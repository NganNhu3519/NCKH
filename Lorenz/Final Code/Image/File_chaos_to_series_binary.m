fid = fopen('chaos_nist_input.bin','rb');
bits = fread(fid, inf, 'ubit1');
fclose(fid);

bit_string = char(bits' + '0');

clipboard('copy', bit_string);
disp('Copied!');