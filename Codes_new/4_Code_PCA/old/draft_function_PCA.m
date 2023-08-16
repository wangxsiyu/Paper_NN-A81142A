function pc = function_PCA(data, option)
    %%
    pc = struct;
    rg = W.str_select(ver_pc);
    vpc = unique(W.str_select(ver_pc,'!digit'));
    switch vpc{1}
        case 'q'
            pc.pca_window = quantile(data.games.rt_reject, rg/100) * 1000;
        case 't'
            pc.pca_window = rg;
    end
    pc.pca_timeidx = [find(pc.pca_window(1)<data.time_at, 1, 'first'), ...
        find(pc.pca_window(2)>data.time_at, 1, 'last')];
    pc.pca_timepoint = data.time_at(pc.pca_timeidx);
    [tpc, pc.pca_r2, pc.coeff, pc.mu] = ...
            W.neuro_PCA(data.spikes, choicebycond, pc.pca_timeidx(1):pc.pca_timeidx(2));
    pc.pc = tpc; %W.cellfun(@(x)x(:, 1:20), tpc);
    pc.time_at = data.time_at;
    if exist('savename', 'var')
        W.save(savename, 'pc', pc);
    end
end

