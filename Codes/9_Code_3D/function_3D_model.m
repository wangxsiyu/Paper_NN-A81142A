function [mdfits] = function_3D_model(x3D, option, npool, nwin)
    nstep = nwin/unique(diff(x3D.time_at));
    c = x3D.games.choice;
    cond = x3D.games.condition;
   
    switch option
        case 'attractor'
            %% x(t+1) = x(t) + (X0 - A) x(t) + B
            [mdfits] = W.fit_nDdynamics('attractor', ...
                x3D.x3D, x3D.time_at, npool, nstep, cond, c+1, cond);
        case 'attractorlm'
            %% x(t+1) = (I - A) x(t) + B
            [mdfits] = W.fit_nDdynamics('attractor_lm', ...
                x3D.x3D, x3D.time_at, npool, nstep, cond, c+1);
        case 'linear'
            %% x(t+1) = A x(t) + B
            [mdfits] = W.fit_nDdynamics('linear', ...
                x3D.x3D, x3D.time_at, npool, nstep, cond, c+1);
    end
    %% compute the eigenvalues of each A
%         nd = size(mdfits.a{1},1);
%         teig = W.cellfun(@(x)svd(x), ta, false);
%         for di = 1:nd
%             eig{di} = cellfun(@(x)x(di), teig);
%         end
end