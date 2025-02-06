while(1)

    close all; clear all; clc; daqreset;

    daqlist("digilent");
    dq = daq("digilent");
    addinput(dq, "AD1", "1", "Voltage");

    ch_in = dq.Channels(1);
    ch_in.Name = "AD1_1_in";
    rate = 44.1e3;
    dq.Rate = rate;

    secs = 3e-5;

    v1 = [];
    t1 = [];

    while true
        data = read(dq, seconds(secs));
        voltageData = data.AD1_1_in;
        meanVoltage = mean(voltageData);

        if abs(meanVoltage) > 0.3 && meanVoltage < 5
            v1 = [v1;voltageData];
            disp("Threshold Met");
            data = read(dq, seconds(3));
            triggeredVoltage = data.AD1_1_in;
            triggeredTime = data.Time;

            while mean(abs(triggeredVoltage(1:44100))) > 0.045
                disp("Recording");
                v1 = [v1;triggeredVoltage];

                data = read(dq, seconds(1));
                triggeredVoltage = data.AD1_1_in;
                triggeredTime = data.Time;
            end
            disp("Break");
            break;
        end
        disp(num2str(meanVoltage));
    end

    if length(v1)>5
        y = v1;
        y = y;
        % y = max(min(data, 5), -5);
        % y = table2array(y);
        fc = 4000;
        [b, a] = butter(12,fc/(rate/2));
        y = filter(b,a,y);

        y1 = shiftPitch(y,8);
        y2 = shiftPitch(y,-4);

        daqreset;
        pause(1);

        daqlist("digilent");
        dq = daq("digilent");
        addoutput(dq, "AD1", "1", "Voltage");
        ch_out = dq.Channels(1);
        ch_out(1).Name = "AD1_1_out";
        dq.Rate = 44.1e3;
        write(dq,y1);

        % t = linspace(0,length(y),length(y));
        % ffty = fft(y,rate);
        % figure;
        % plot(abs(ffty));
        % xlim([0,10000])
        % 
        % ffty1 = fft(y1,rate);
        % figure;
        % plot(abs(ffty1));
        % xlim([0,10000])

    end
end


