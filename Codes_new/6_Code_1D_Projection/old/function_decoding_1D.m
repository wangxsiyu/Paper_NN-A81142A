function result_svm = function_decoding_1D(x1D, games, is_delay_drop, savename)
%     if exist('savename', 'var') && ndim ~= 20
%         savename = strcat(savename, '_pc', num2str(ndim));
%     end
    if exist('savename', 'var') && exist(savename, 'file')
        return;
    end
    if ~exist('is_delay_drop', 'var')
        is_delay_drop = true;
    end
    games = games.games;
    tpc = x1D.x1D;
%     tpc = W.cellfun(@(x)x(:, 1:ndim), tpc, false);
    ntime = size(tpc,2);
    result_svm = struct('ac_choice',NaN(1, ntime),'se_chocie',NaN(1, ntime),...
        'ac_delay',NaN(1, ntime),'se_delay',NaN(1, ntime),...
        'ac_drop',NaN(1, ntime),'se_drop',NaN(1, ntime));
    cc = games.choice;
    dly = games.delay;
    drp = games.drop;
    for ti = 1:ntime % loop over time
        tx = tpc(:, ti);
        %% decode choice
        W.print('classifying choice at time point #%d/%d', ti, ntime);
        SVMmd = fitcsvm(tx, cc, 'CrossVal', 'on', 'Prior', 'uniform');
        [result_svm.ac_choice(ti), result_svm.se_choice(ti)] = W.avse(SVMmd.kfoldPredict == SVMmd.Y);
        if is_delay_drop
            %% decode delay
            W.print('classifying delay at time point #%d/%d', ti, ntime);
            SVMmd = fitcecoc(tx, dly, 'CrossVal', 'on', 'Prior', 'uniform');
            [result_svm.ac_delay(ti), result_svm.se_delay(ti)] = W.avse(SVMmd.kfoldPredict == SVMmd.Y);
            %% decode drop
            W.print('classifying drop at time point #%d/%d', ti, ntime);
            SVMmd = fitcecoc(tx, drp, 'CrossVal', 'on', 'Prior', 'uniform');
            [result_svm.ac_drop(ti), result_svm.se_drop(ti)] = W.avse(SVMmd.kfoldPredict == SVMmd.Y);
        end
    end
    if exist('savename', 'var')
        W.save(savename, 'decoding_svm', result_svm);
    end
end