function [x3D] = function_3D_projection(ver, pc, x1D)
    games = pc.games;
    x3D = struct;
    x3D.games = games;
    x3D.time_at = pc.time_at;
    %%
    switch ver
        case 'r'
            x3D.x3D = W.cellfun(@(x)x(:, 1:3), pc.pc);
            x3D.xResidue = W.cellfun(@(x)x(:, 4:end), pc.pc);
        case {'svm', 'svmp'}
            tpc = W.cellfun(@(x)x(:,1:20), pc.pc);
            ntrial = size(games,1);
            ntime = length(pc.pc);
            xx = repmat({NaN(ntrial, 3)},1,ntime);
            tx = vertcat(tpc{x1D.idx_timerange});

            xx_res = tpc;
            tw = x1D.w_svm;
            tb = x1D.b_svm;
            x_res = W.proj_orthogonal(tx, tw);
            x3D.pcinfo = W.pca(x_res(:, 1:end-1));
            for ti = 1:ntime % loop over time
                xx_res{ti} = W.proj_orthogonal(tpc{ti}, tw);
                xx{ti}(:, 1) = (tpc{ti} - xx_res{ti})/tw;
                tepc = W.get_PCA(x3D.pcinfo, xx_res{ti}(:,1:end-1));                
                xx{ti}(:, 2:3) = tepc(:,1:2);
            end
            x3D.x3D = xx;
            x3D.xResidue = xx_res;
    end
end