function result_svm = decodetemp(tpc, games)
    ntime = length(tpc);
    result_svm = struct('ac_choice',NaN(1, ntime),'se_chocie',NaN(1, ntime),...
        'ac_delay',NaN(1, ntime),'se_delay',NaN(1, ntime),...
        'ac_drop',NaN(1, ntime),'se_drop',NaN(1, ntime));
    cc = games.choice;
    dly = games.delay;
    drp = games.drop;
    for ti = 1:ntime % loop over time
        tx = tpc{ti};
        %% decode choice
        W.print('classifying choice at time point #%d/%d', ti, ntime);
        SVMmd = fitcsvm(tx, cc, 'CrossVal', 'on', 'Prior', 'uniform');
        [result_svm.ac_choice(ti), result_svm.se_choice(ti)] = W.avse(SVMmd.kfoldPredict == SVMmd.Y);
    end
end