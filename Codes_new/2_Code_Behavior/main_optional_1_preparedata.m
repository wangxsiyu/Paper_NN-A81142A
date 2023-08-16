W_lp = W_looper_folder('../TempData/all_CUEON_win50_step50');
data = W_lp.looper_loadall('dataset.mat');
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
