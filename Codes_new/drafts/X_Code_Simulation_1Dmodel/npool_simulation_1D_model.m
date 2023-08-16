run('../setup_analysis.m')
%%
files = W.dir(fullfile(datadir, '*/model1D_scaledEV_x1Dsvm_t0t1000.mat'));
md1 = W.load(files.fullpath);
%% load x1D
files = W.dir(fullfile(datadir, '*/x1Dsvm_t0t1000.mat'));
x1D = W.load(files.fullpath);
%%
nses = length(x1D);
%% simulation 1 - full model
x1D1 = cell(1, nses);
for si = 1:nses
    x1D1{si} = x1D{si};
    a = md1{si}.mdfit.a;
    x0 = md1{si}.mdfit.x0;
    coef_ev = md1{si}.mdfit.coef_ev;
    games = data{si}.games;
    cond = games.condition;
    c = games.choice + 1;
    ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION(si,:), cond);
    o1 = x1D{si}.x1D;
    n1 = o1 * NaN;
    n1(:,1) = o1(:,1);
    for ti = 2:length(x1D{si}.time_at)
        tid = max(ti-nstep,1):min(ti-1, length(md1{si}.time_md));
        ta = a(tid,:);
        tcoef_ev = coef_ev(tid);
        tx0 = x0(tid,:);
        ta = mean(ta,1);
        tx0 = mean(tx0,1);
        tcoef_ev = mean(tcoef_ev,1);

        tx0 = W.nan_selects(tx0, c);
        ta = W.nan_selects(ta, cond);
        n1(:,ti) = o1(:,ti-1) .* (1-ta) + tx0 .* ta + tcoef_ev * ev;
    end
    x1D1{si}.x1D = n1;
end
save('./x1D1.mat', 'x1D1');
%% compute energy landscape
addpath('../7_Code_1D_landscape/');
addpath('../8_Code_1D_model/');
nstep = 1;
npool = 3;
md1r = cell(1, nses);
for si = 1:nses
   md1r{si} = main_1D_model(x1D1{si}, data{si}.games, sub(si,:), npool, nstep, 'scaledEV');
end
save('./md1r.mat', 'md1r');
%% parameter recovery
a0 = [];
a1 = [];
x0 = [];
x1 = [];
b0 = [];
b1 = [];
tid = 27:29
for si = 1:nses
    a0 = [a0; md1{si}.mdfit.a(tid,:)];
    x0 = [x0; md1{si}.mdfit.x0(tid,:)];
    b0 = [b0; md1{si}.mdfit.coef_ev(tid,:)];
    a1 = [a1; md1r{si}.mdfit.a(tid,:)];
    x1 = [x1; md1r{si}.mdfit.x0(tid,:)];
    b1 = [b1; md1r{si}.mdfit.coef_ev(tid,:)];
end
%%
plt.figure(3,4);
for i = 1:9
plt.scatter(a0(:,i), a1(:,i), 'diag');
plt.new;
end
for i = 1:2
plt.scatter(x0(:,i), x1(:,i), 'diag');
plt.new;
end
plt.scatter(b0, b1, 'diag');



