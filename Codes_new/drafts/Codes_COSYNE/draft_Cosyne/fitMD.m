function md = fitMD(x, tev, cond, c, option)
     if ~exist('option', 'var')
         option = 'full';
     end
     ev = arrayfun(@(x)tev(x), cond);
     dummy_cond = dummyvar(cond);
     dummy_c = dummyvar(c);
     for ti = 1:(size(x,2)-1)
         [tmd, tLL] = myfit(x(:,ti+1), x(:, ti), ev, dummy_cond, dummy_c, option);
         pred = modelEV(tmd.a, tmd.x0, tmd.coef_ev, x(:, ti), ev, dummy_cond, dummy_c, option);   
         er = x(:, ti+1) - pred;
         evar = 1 - sum(er.^2)/sum(x(:, ti+1).^2);
         md.explained_var(ti) = evar;
         md.error(:, ti) = er;
         md.pred(:,ti) = pred;
         md.pred_noise(:,ti) = pred + shuffle(er);
         md.error_bycond(:, ti) = W.analysis_av_bygroup(er.^2, cond, 1:9);
         tot_var = W.analysis_av_bygroup(x(:, ti+1).^2, cond, 1:9);
         md.error_variance(:, ti) = W.analysis_av_bygroup(er.^2, cond, 1:9)./tot_var;
         md.a(:, ti) = tmd.a';
         md.x0(:, ti) = tmd.x0';
         md.b(:, ti) = tmd.coef_ev';
     end
     md.data_simu = [x(:,1), md.pred];
     md.data_simu_noise = [x(:,1), md.pred_noise];
end
function [params, LL] = myfit(y, x, ev, dummy_cond, dummy_c, option)
    func = @(t)loss_model(y, ...
        t(1:9), t(10:11), t(12), x, ev, dummy_cond, dummy_c, option);
    X0 = [rand(1,9) zeros(1,2) 0];
    LB = [zeros(1,9) -ones(1,2)*Inf -Inf];
    UB = [ones(1,9) ones(1,2)*Inf Inf];
    [xfit, LL] = fmincon(func, X0, [],[],[],[], LB, UB);
    params.a = xfit(1:9);
    params.x0 = xfit(10:11);
    params.coef_ev = xfit(12);
end

function LL = loss_model(y, varargin)
    ypred = modelEV(varargin{:});
    LL = sum((y - ypred).^2, [], 'omitnan');
end
