close all; clear all; clc; daqreset;

daqlist("digilent");
dq = daq("digilent");
addinput(dq, "AD2_0", "ai0", "Voltage");

ch_in = dq.Channels(1);
ch_in.Name = "AD1_1_in";
rate = 192e3;
dq.Rate = rate;

secs = 1.92 / rate; 

v1 = []; %zeros(1,5e6);
t1 = [];

while true
    data = read(dq, seconds(secs));
    voltageData = data.AD1_1_in;
    meanVoltage = mean(voltageData);

    if abs(meanVoltage) > 0.3 && meanVoltage < 5
        disp("Threshold Met");
        data = read(dq, seconds(1));
        triggeredVoltage = data.AD1_1_in;
        triggeredTime = data.Time;

        while mean(abs(triggeredVoltage)) > 0.05
            disp("Recording");
            v1 = [v1;triggeredVoltage];
            %t1 = [t1;triggeredTime];

            data = read(dq, seconds(1));
            triggeredVoltage = data.AD1_1_in;
            triggeredTime = data.Time;
            %disp(num2str(mean(triggeredVoltage)));
        end
        disp("Break");
        break;
    end
    disp(num2str(meanVoltage));
end

% trigVolt = v1;
% y = downsample(trigVolt,10);
% y = max(min(y, 5), -5);
% rate_new = rate / 10;

y = v1 / 2;

figure;
plot(linspace(1,length(v1),length(v1)), y);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Triggered Signal');

y1 = shiftPitch(y,6);
y2 = shiftPitch(y,-4);

sound(y,rate)

daqreset;
pause(1);

daqlist("digilent");
dq = daq("digilent");
addoutput(dq, "AD2_0", "ao0", "Voltage");
ch_out = dq.Channels(1);
ch_out(1).Name = "AD1_1_out";
dq.Rate = 192e3;
write(dq,y);
