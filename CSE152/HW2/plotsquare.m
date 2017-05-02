function plotsquare(I)
colors = 'rrrr';
I = I ./repmat(I(3, :), 3, 1);
hold on
for i = 1 : 4
    line([I(1, i) I(1, mod(i, 4) + 1)], [I(2, i) I(2, mod(i, 4) + 1)], 'LineWidth', 2);
    plot(I(1, i), I(2, i), strcat(colors(i),'*'));
    text(I(1,i)-sign(I(1,i)) * .05, I(2,i) - sign(I(2,i)) *.05, sprintf('[%.3f, %.3f]', I(1,i), I(2,i)));
end

end