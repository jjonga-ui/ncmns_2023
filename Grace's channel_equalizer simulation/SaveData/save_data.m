function save_data(hmat, dt, df, file_name, folder_path)

if ~exist(folder_path, 'dir')
    % If the folder does not exist, create it
    mkdir(folder_path);
end


file_path = folder_path + "/" + file_name;
save(file_path,'hmat', 'dt', 'df','-mat');
    
end