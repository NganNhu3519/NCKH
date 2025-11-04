clc;close all;clear;
load D:\Thungan\Github\NCKH\Lorenz\Result\Sine_results_v1.mat
z = results.z;
x_est = results.x_est(4,:);
if size(z) ~= size(x_est)
    x_est = x_est';
end

z_norm     = z / max(abs(z));
x_est_norm = x_est / max(abs(z));
error_z    = z_norm - x_est_norm;
nmse_sparse = mean(error_z.^2);

nmse_sine = helperNMSE(z,x_est,'linear');
fprintf('NMSE (normalized by max) = %.7e\n', nmse_sine);

fprintf('NMSE (normalized by max) = %.7e\n', nmse_sparse);

mse1 = mse(z,x_est,max(abs(z)))