datadir = W.mkdir('../Data');
version_spikes = 'CUEON_win100_step50';
version_behavior = 'clean';
%% load behavior 
[games, files_games] = W.load(fullfile('../Data/games'),'csv');
%% load spikes
[spikes, files_spikes] = W.load(fullfile('../Data/spikes_epoched/', version_spikes));
%%
data = struct;
data.nsession = length(games);
data.games = cell(1, data.nsession);
data.spikes = cell(1, data.nsession);
for i = 1:data.nsession
    %% select exclusion criteria
    switch version_behavior
        case 'all'
            id_exclude = games{i}.is_error;
        case 'clean'
            id_exclude = games{i}.is_error | games{i}.is_post_error;
    end
    data.games{i} = games{i}(~id_exclude,:);
    data.spikes{i} = W.cellfun(@(x)x(~id_exclude,:), spikes{i}.epochs, false);
    data.time_at = spikes{i}.time_at;
    data.time_window = spikes{i}.time_window;
end
%% add info
data.animal = cellfun(@(x)W.str_selectbetween2patterns(unique(x.filename),[],'_'), data.games);
data.sessionname = cellfun(@(x)W.str_selectbetween2patterns(unique(x.filename),'_',[]), data.games);
%%
savename = sprintf('dataset_%s_%s', version_behavior, version_spikes);
W.save(fullfile(datadir, savename), 'data', data, '-v7.3');