close all;
clear all;

% Data Generation
I1 = rand( 512, 512 );
I2 = rand( 512, 512 );

% Visualization
figure;

subplot(1,2,1);
imagesc( I1 );
axis image;
colormap gray;
colorbar;

subplot(1,2,2);
imagesc( I2 );
axis image;
colormap gray;
colorbar;

combinedMat = zeros( 512, 512, 2 );
combinedMat( :, :, 1 ) = I1;
combinedMat( :, :, 2 ) = I2;

save( 'combinedMat.mat', "combinedMat" )
