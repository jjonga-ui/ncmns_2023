 % Create some sample data
x = linspace(0, 2*pi, 100);
y1 = sin(x);
y2 = cos(x);

% Plot the data
figure;
plot(x, y1, 'b-', 'LineWidth', 2); % Plot sine curve in blue
hold on;
plot(x, y2, 'r--', 'LineWidth', 2); % Plot cosine curve in red dashed line

% Add labels and title
xlabel('x');
ylabel('y');
title('Sine and Cosine Curves');
legend('sin(x)', 'cos(x)');
grid on;

% Add text annotation
text(2, 0.8, 'This is a simple figure in MATLAB', 'FontSize', 12);

% Adjust axis limits
xlim([0, 2*pi]);
ylim([-1.5, 1.5]);

% Show the figure
hold off;

imageData = screencapture(gcf);
imshow(imageData);





