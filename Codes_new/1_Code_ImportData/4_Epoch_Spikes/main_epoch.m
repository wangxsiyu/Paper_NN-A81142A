[data, files] = W.load_twofolders_matchingsuffix('../../../Data/trials', ...
    '../../../Data/spikes', 'csv', [], false, true);
%%
files = arrayfun(@(x)W.file_prefix(x, 'epoched'), files);
%% set up savedir
epochdir = W.mkdir('../../../Data/spikes_epoched');
%%
winsize = [50, 100];
isoverwrite = false;
W.parpool(8);
for wi = 1:length(winsize)
    W.epochs_bybox(data.spikes, data.trials, fullfile(epochdir, files), ...
        'CUEON', 1198, 1, -1000, 2000, 50, winsize(wi), isoverwrite, false, 0);
end