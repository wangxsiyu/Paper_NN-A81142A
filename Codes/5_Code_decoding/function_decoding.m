function result_svm = function_decoding(pc, option_dim, is_delay_drop)
    if ~exist('is_delay_drop', 'var') || isempty(is_delay_drop)
        is_delay_drop = true;
    end
    games = pc.games;
    tpc = W.get_subspace_stringcommand(pc.pc, option_dim);
    cc = games.choice;
    [t1] = W.W_neuro_decoding_movingwindow(tpc, cc, 'svm');
    result_svm = W.struct_pfxsfx(t1, '', 'choice');
    if is_delay_drop
        dly = games.delay;
        [t2] = W.W_neuro_decoding_movingwindow(tpc, dly, 'svm');
        result_svm = W.struct_merge(result_svm, W.struct_pfxsfx(t2, '', 'delay'));
        drp = games.drop;
        [t3] = W.W_neuro_decoding_movingwindow(tpc, drp, 'svm');
        result_svm = W.struct_merge(result_svm, W.struct_pfxsfx(t3, '', 'drop'));
    end
end