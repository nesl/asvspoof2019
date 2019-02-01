function prepare_plot(plot_obj)
% Creates a new figure, switches hold on, embellishes and returns handle.

plot_obj.fh = figure();
hold on

axis('square');

set(gca, 'xlim', probit(plot_obj.pfa_limits));
set(gca, 'xtick', probit(plot_obj.xticks));
set(gca, 'xticklabel', plot_obj.xticklabels);
set(gca, 'xgrid', 'on');
xlabel('False Alarm probability (in %)');

set(gca, 'ylim', probit(plot_obj.pmiss_limits));
set(gca, 'ytick', probit(plot_obj.yticks));
set(gca, 'yticklabel', plot_obj.yticklabels);
set(gca, 'ygrid', 'on')
ylabel('Miss probability (in %)')

end
