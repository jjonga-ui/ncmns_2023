function save_parameters(h0, ht0, d0, k, Sp, file_name, folder_path)


if ~exist(folder_path, 'dir')
    % If the folder does not exist, create it
    mkdir(folder_path);
end

file_path = folder_path + "/" + file_name;


%parameters = {"h0="+h0,"ht&r="+ht0,"d0="+d0,"k="+k,"Sp="+Sp};

parameters = ["h0" "ht&r" "d0" "k" "Sp"; h0 ht0 d0 k Sp];

save(file_path,"parameters","-mat")