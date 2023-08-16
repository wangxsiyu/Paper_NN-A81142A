function [x3D, xx_res] = main_1D_projection_plusPCA(pc, games, savename)
    x3D = struct;
    x3D.midRT = W.avse(games.rt_reject, 1) * 1000;
    x3D.midRT_idx = dsearchn(W.vert(pc.time_at), x3D.midRT) + [-1:1];
    cc = games.choice;
    tpc = pc.pc;
    ntrial = size(games,1);
    ntime = length(pc.pc);
    %% projection to 1D space
    xx = repmat({NaN(ntrial, 3)},1,ntime);
    tx = vertcat(tpc{x3D.midRT_idx});
    ty = repmat(cc, length(x3D.midRT_idx), 1);
    xx_res = tpc;
    tmodel = fitcsvm(tx, ty);
    tw = (tmodel.SupportVectorLabels.*tmodel.Alpha)' * tmodel.SupportVectors;
    tb = tmodel.Bias;
    x3D.w_svm = tw;
    x3D.b_svm = tb;
    
    ww = tw/sqrt(tw*tw');
    x_res = (tx - tx * ww' * ww);
    [coeff,score,~,~, r2, mu] = pca(x_res);
    
    
    for ti = 1:ntime % loop over time
        xx{ti}(:, 1) = tpc{ti} * ww'; % needs to double check
        tepc = W.cellfun(@(x)x * coeff, tpc{ti});
        xx_res{ti} = tpc{ti} - tpc{ti} * ww' * ww;
        xx{ti}(:, 2:3) = tepc{1}(:,1:2);
    end
    
    x3D.x3D = xx;
    x3D.time_at = pc.time_at;
    %%
    if exist('savename', 'var')
        W.save(savename,'x3D', x3D);
    end
end