clear; clc;
load img_NIST_ver1_work.mat
X = x(:,1:3); % Giả sử x có 3 cột trạng thái

% 1. Trích xuất nhiều bit hơn từ phần thập phân (Deep Extraction)
% Cách này nhạy hơn với sự hỗn loạn và tăng độ dài chuỗi bit
bitstream = [];
for i = 1:3
    val = X(:,i);
    % Lấy 8 bit từ phần thập phân của mỗi mẫu để tăng dữ liệu (32768 * 8)
    temp_bits = mod(floor(abs(val) * 10^10), 256); 
    bin_matrix = dec2bin(temp_bits, 8) - '0'; % Chuyển sang ma trận bit
    bitstream = [bitstream; bin_matrix(:)]; 
end

% 2. Kiểm tra sơ bộ (Sanity Check)
bitstream = uint8(bitstream);
len = length(bitstream);
fprintf('Tổng số bits: %d (Yêu cầu NIST ~1,000,000 bit để chính xác nhất)\n', len);
fprintf('Tỉ lệ bit 1 (Càng gần 0.5 càng tốt): %.4f\n', mean(bitstream));

% 3. Phân tích thống kê nhanh (Sn < 1.96 là đạt test Frequency)
S = sum(2*double(bitstream) - 1);
Sn = abs(S) / sqrt(len);
fprintf('Chỉ số Sn (NIST Frequency Test): %.3f %s\n', Sn, char(double(Sn<1.96)*10003 + double(Sn>=1.96)*10007));

% 4. Ghi file đúng định dạng cho NIST (Binary thô)
fid = fopen('chaos_nist_input.bin','wb');
% Lưu ý: Ghi dạng 'ubit1' để NIST STS đọc file dạng binary (-b)
fwrite(fid, bitstream, 'ubit1');
fclose(fid);
disp('Đã xuất file chaos_nist_input.bin thành công.');