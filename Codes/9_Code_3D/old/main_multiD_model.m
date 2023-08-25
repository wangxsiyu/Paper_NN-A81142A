function [mdfits,time_md] = main_multiD_model(pc, data, npool, nstep)
    %% x(t+1) = (I - A) x(t) + B  
    c = data.games.choice;
    cond = data.games.condition;
    [mdfits, time_md] = W.fit_nDdynamics('dynamics_linear', ...
        pc, data.time_at, npool, nstep, cond, c+1);
    %% compute the eigenvalues of each A
%         nd = size(mdfits.a{1},1);
%         teig = W.cellfun(@(x)svd(x), ta, false);
%         for di = 1:nd
%             eig{di} = cellfun(@(x)x(di), teig);
%         end
end