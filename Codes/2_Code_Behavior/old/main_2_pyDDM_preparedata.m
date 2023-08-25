run('../setup_analysis.m')
data = W_lp.load('dataset.mat');
games = W.cellfun(@(x)x.games, data, false);
%% get basic
tab = table;
for si = 1:length(games)
    tg = games{si};
    tg = tg(:, ["condition","rt_reject","choice"]);
    tg = W.tab_fill(tg, 'session', si);
    tab = W.tab_vertcat(tab, tg);
end
%% save group behavior
W.writetable(tab, './Temp/data_ddm.csv');
