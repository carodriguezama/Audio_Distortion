%% DSP_FINAL_PROJECT - Audio_Toy
clear all; close all; clc
%% Read Audio File
data = readmatrix('DATA06.CSV'); % load audio signal
y = data(:,2);
t = data(:,1);
t = t - min(t); % shift time so that there is no negatives

Fs = length(y)/max(t); % calculate the sampling frequency
Ts = 1/Fs;

figure
plot(t,y)
title('Original Signal')
xlabel('Time')
ylabel('Amplitude')
%% Find FFT 
y = y - mean(y);
Y_FFT = fft(y);
f_axis =[0:length(y)-1]/length(y)*Fs;
figure; 
plot(f_axis, abs(Y_FFT))
title('Original Signal')
xlabel('Time')
ylabel('Amplitude')

%% Play Audio
yhigh = shiftPitch(y,8);
ylow = shiftPitch(y,-4);
sound(y,Fs)

%% Make a file 
filenameOrignal = 'orignal.wav';
filenameHigh = 'high.wav';
filenameLow = 'low.wav';
Fs = round(Fs);

audiowrite(filenameOrignal,y,Fs);
audiowrite(filenameLow,ylow,Fs);
audiowrite(filenameHigh,yhigh,Fs);
