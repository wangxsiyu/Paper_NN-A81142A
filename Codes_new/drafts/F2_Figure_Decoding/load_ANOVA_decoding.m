run('../load_behavior.m');    
%% load anova
files = W.dir(fullfile(datadir, '*/anova.mat'));
wv_anova = W.load(files.fullpath);
%% load decoding
files = W.dir(fullfile(datadir, '*/decode_t0t1000.mat'));
wv_decode = W.load(files.fullpath);