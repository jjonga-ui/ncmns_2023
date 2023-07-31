function save_figure(data, figure_name, changed_parameter, file_path)

file_path = file_path + changed_parameter + "_" + figure_name;
saveas(data, file_path, "png");
    
end
