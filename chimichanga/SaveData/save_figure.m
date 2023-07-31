function save_figure(figure, figure_name, folder_path)

if ~exist(folder_path, 'dir')
    % If the folder does not exist, create it
    mkdir(folder_path);
end


file_path = folder_path + "\" + figure_name;
saveas(figure, file_path, "png");
    
end
