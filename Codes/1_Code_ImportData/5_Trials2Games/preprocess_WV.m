function game = preprocess_WV(trial)  
    %% trial idx
    [idcols, indices] = W.get_eventmarker_indices(trial.eventmarkers, 'template', trial.event_template, 'cueon', 1198, 'reject', 1039, ...
        'purple', 1121, 'accept', 1141, 'acceptdone', 1030, 'error', [1034 1035 1040 1041], 'condition', [4000:4018]);
    %% include complete trials only
    ntrial = size(trial,1);
    game = table;
    game.is_complete = indices.accept | indices.reject | indices.error;
    game.is_error = indices.error;
    game.choice = NaN(ntrial, 1);
    game.choice(indices.accept | indices.acceptdone) = 1; % accept
    game.choice(indices.reject) = 0;
    game.is_post_error = [false; game.is_error(1:end-1)];
    %% compute condition (not implemented for cue set 2/1&2)
    game.condition = trial.eventmarkers(:, idcols.condition(end)) - 4000;    
    game.drop = ceil(game.condition/3) * 2;
    game.delay = W.nan_selects([1 5 10], W.mod0(game.condition, 3));
    %% compute reaction time
    if any(contains(trial.Properties.VariableNames, 'timestamps'))
        rts = W.get_timestamps_indices(trial.timestamps_est, idcols, indices); %
        game.rt_reject = rts.reject - rts.cueon;
        game.rt_cueon2purple = rts.purple - rts.cueon;
        game.rt_accept = rts.accept - rts.purple;
        game.rt_choice = changem(sum([game.rt_reject, game.rt_accept], 2, 'omitnan'), NaN);
    end
end