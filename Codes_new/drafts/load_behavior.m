run('./setup_analysis.m');
sub = W.load(fullfile(datadir, 'behavior_sub.mat'));
files = W.dir(fullfile(datadir, '*/dataset.mat'));
data = W.load(files.fullpath);
games = W.cellfun(@(x)x.games, data, false);