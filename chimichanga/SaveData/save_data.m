function save_data(data, file_name, folder_path)

if ~exist(folder_path, 'dir')
    % If the folder does not exist, create it
    mkdir(folder_path);
end


file_path = folder_path + "/" + file_name;
save(file_path,'data','-mat');
    
end