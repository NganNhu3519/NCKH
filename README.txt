
Sept 18, 2024
Test with input: Sine, ECG, Audio, Sparse Singal and Image Signal.

PROCEDURE: 
	1/ Compress signal S(t) via CS theory. Output Y(t)
	2/ Y(t) become m(t)-additional state of chaotic system ---> transmit to com. channel	
	3/ At receiver, design an observer to estimate all the states of chaotic system. 
	4/ m^(t) is recovered 
	5/ Via Reconstruction algorithm of CS theory, S^(t) is reconstructed

File MATLAB:
	1/ Run Compress_Signal. m to save the original input signal, sensing matrix Phi, linear measurement Y and Psi
	2/ The data of linear measyrement y will be loaded in Observer_Compress_Signal.m. 
	In this part, the simulation for comm. system will be simulated. At receiver, we collect the estimated signal
	x_est(t) via observer design
