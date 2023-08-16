datadir = W.mkdir('../../Data/data_bysession');
tempdir = W.mkdir('../TempData');
dir_spikes = '../../Data/spikes_epoched/';
version_spikes = W.dir(dir_spikes);
%%

%%
version_behavior = {'all'};
for vi = 1:length(version_spikes.filename)
    %% load spikes
    [dataall, files] = W.load_twofolders_matchingsuffix('../../Data/games', ...
        version_spikes.fullpath(vi), 'csv', [], [], []);
    %%
    games = W.encell(dataall.games);
    spikes = W.encell(dataall.epoched);
    for vvi = 1:length(version_behavior)
        for i = 1:length(files)
            data = struct;
            %% select exclusion criteria
            switch version_behavior{vvi}
                case 'all'
                    id_exclude = games{i}.is_error;
                case 'clean'
                    id_exclude = games{i}.is_error | games{i}.is_post_error;
            end
            id_exclude2 = isnan(games{i}.delay) | isnan(games{i}.drop) | ...
                isnan(games{i}.choice);
            id_exclude = id_exclude | id_exclude2;
            data.games = games{i}(~id_exclude,:);
            data.spikes = W.cellfun(@(x)x(~id_exclude,:), spikes{i}.epochs, false);
            data = W.struct_merge(data, rmfield(spikes{i}, 'epochs'),'overwrite');
            versionname = sprintf('%s_%s', version_behavior{vvi}, version_spikes.filename{vi});
            subfd = fullfile(datadir, versionname);            
            savename = sprintf('dataset_%s', files(i));
            savename2 = fullfile(tempdir, versionname, files(i), 'dataset');   
            W.save(fullfile(subfd, savename), 'data', data, '-v7.3');
            W.save(savename2, 'data', data, '-v7.3');
        end
    end
end