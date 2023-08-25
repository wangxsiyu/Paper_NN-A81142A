run('../setup_analysis.m')
%%
data = W_lp.load('dataset.mat');
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
savename = fullfile(datadir, 'behavior_sub');
W.save(savename, 'sub', sub);

%% RT regression analysis
rtREJECT = sub.midRT_REJECT_byCONDITION;
rtACCEPT = sub.midRT_ACCEPT_byCONDITION;
paccept = sub.avCHOICE_byCONDITION;
entropy = sub.ENTROPY_byCONDITION;

rtR = reshape(rtREJECT, [], 1);
rtA = reshape(rtACCEPT, [], 1);
pa = reshape(paccept, [], 1);
ent = reshape(entropy, [], 1);
mk = reshape(repmat(sub.idx_animal, 1, 9), [], 1);
mdl = fitlm([pa, ent, mk], rtR)


rtC = [rtR; rtA];
pa2 = [pa; pa];
ent2 = [ent; ent];
n = length(pa);
isA = [ones(n, 1); zeros(n, 1)];
mk2 = [mk; mk];
mdl2 = fitlm([pa2 ent2 isA mk2], rtC, 'VarNames', {'p(accept)', 'entropy', 'choice', 'monkey', 'RT'})

