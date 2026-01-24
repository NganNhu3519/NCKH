% Lazaros Moysis
% Youtube channel 
% https://www.youtube.com/@lazarosmoysis5095 
% RG: https://www.researchgate.net/profile/Lazaros-Moysis

% The SIPI database
% https://sipi.usc.edu/database/


% The following papers can be used as references for chaos based encryption
% https://dergipark.org.tr/en/pub/chaos/issue/54264/756229
% https://link.springer.com/chapter/10.1007/978-3-030-92166-8_7
% https://ieeexplore.ieee.org/abstract/document/9396395

% The following code computes the Number of Pixels Change Rate (NPCR)
% and Unified Average Changing Intensity (UACI) measures between two
% encrypted versions of the same image, different only by one pixel.

clear

ciphertext1=double(imread('ciphertext.png'));

ciphertext2=double(imread('ciphertext2.png'));

[rows,cols]=size(ciphertext1);

NPCR=100*sum(sum(ciphertext1~=ciphertext2))/(rows*cols)
UACI=100*sum(sum(abs(ciphertext1-ciphertext2)))/(rows*cols*255)

