% DEFAULT PARAMETERS FROM INITIAL DOWNLOAD

% h0=100; % surface height (depth) [m]
% ht0=75; % TX height [m]
% hr0=75; % RX height [m]
% d0=1000; % channel distance [m]
% k=1.7; % spreading factor
% Sp= 20; % number of intra-paths (assumed constant for all paths)



function [changed_parameter] = name_changed_parameter(h0, ht0, hr0, d0, k, Sp)

count = 0;
    if h0~=100
        changed_parameter = "h0_" + h0;
        count = count + 1;
    end
    if (ht0&hr0)~=75
        if ht0~=hr0
            count = count + 1;
        end
        changed_parameter = "ht&r_" + ht0;
        count = count + 1;
    end
    if d0~=1000
        changed_parameter = "d0_" + d0;
        count = count + 1;
    end
    if k~=1.7
        changed_parameter = "k_" + k;
        count = count + 1;
    end
    if Sp~=20
        changed_parameter = "Sp_" + Sp;
        count = count + 1;
    end


    if count>1
        errorMsg = "Please only change one parameter, and transmitter/receiver " + ...
            "height should be the same.";
        error(errorMsg);
    end
end