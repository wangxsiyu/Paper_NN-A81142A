function out = main_1_behaviors(data)
    games = W.cellfun(@(x)x.games, data, false);
    %% compile all games
    games = W.tab_vertcat(games{:});
    [idxsub] = W.selectsubject(games, 'filename');
    %% calculate sub
    sub = W.analysis_sub(games, idxsub, 'behavior_WV');
    %% add basic information
    sub.animal = W.file_getprefix(sub.filename);
    sub.idx_animal = W.arrayfun(@(x) find(x == unique(sub.animal)), sub.animal);
    %% save group behavior
    out = sub;
end