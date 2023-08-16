run('../setup_analysis.m');
run('../load_behavior.m');
%% load x1D
files = W.dir(fullfile(datadir, '*/x1Dsvm_t0t1000.mat'));
x1D = W.load(files.fullpath);
time_at = x1D{1}.time_at;
midRTs = cellfun(@(x)x.midRT, x1D);
x1D = W.cellfun(@(x)x.x1D, x1D, false);
%% fit scaled EV model
nses = 16;
md = cell(1, nses);
for si = 1:nses
    xx = x1D{si};
    tev = sub.avDRIFTRATE_byCONDITION(si,:);
    cond = data{si}.games.condition;
    c = data{si}.games.choice + 1;
    md{si} = fitMD(xx, tev, cond, c);
end
save('1D_model.mat','md');
%% fit model B/C - noise alone
md_diff = cell(1, nses);
md_drift = cell(1, nses);
for si = 1:nses
    xx = x1D{si};
    tev = sub.avDRIFTRATE_byCONDITION(si,:);
    cond = data{si}.games.condition;
    c = data{si}.games.choice + 1;
    md_diff{si} = fitMD(xx, tev, cond, c, 'diff');
    md_drift{si} = fitMD(xx, tev, cond, c, 'drift');
end
save('1D_model_diff.mat','md_diff');
save('1D_model_drift.mat','md_drift');
%% drift alone
md_drift = cell(1, nses);
for si = 1:nses
    xx = x1D{si};
    tev = sub.avDRIFTRATE_byCONDITION(si,:);
    cond = data{si}.games.condition;
    c = data{si}.games.choice + 1;
    md_drift{si} = fitMD2(xx, tev, cond, c, 'drift9');
end
save('1D_model_drift9.mat','md_drift');
%% fit model B/C - noise alone
md_diff = cell(1, nses);
md_drift = cell(1, nses);
for si = 1:nses
    xx = x1D{si};
    tev = sub.avDRIFTRATE_byCONDITION(si,:);
    cond = data{si}.games.condition;
    c = data{si}.games.choice + 1;
    md_diff{si} = fitMD(xx, tev, cond, c, 'diffav');
    md_drift{si} = fitMD(xx, tev, cond, c, 'driftav');
end
save('1D_model_diffav.mat','md_diff');
save('1D_model_driftav.mat','md_drift');
%% check figure 5 
addpath(genpath('../'));
plt = W_plt;

plt.set_custom_variables('color_monkeys', {'AZred', 'AZblue'}, ...
    'color_rejectaccept', {'RSgreen', 'RSred'}, ...
    'color_anova', {'RSred','AZcactus','AZsand','AZsky'});
%%
load('1D_model.mat')
load('1D_model_diff.mat')
load('1D_model_drift.mat')
%%
npool = 1;
nstep = 1;
for bi = 1:(length(time_at)-1)
    time_md(bi) = mean([time_at(bi:(bi+npool-1)), ...
        time_at((bi:(bi+npool-1)) + nstep)]);
end
%%
plt.figure;
plt.param_scale(1,[],1,1.3);

plt = fig_ax_EV(plt, tmd, sub, time_md);
plt.update([],' ');
%%
plt.figure;
plt.setfig_ax('xtickangle', 0);
plt = fig_ax_accept_reject(plt, tmd, sub, time_md);
plt.update([],' ');
%%
plt.figure;
plt.param_scale(1,[],1,1.0);
plt.setfig_ax('xtickangle', 0);
plt = fig_ax_x0(plt, tmd, sub, time_md);
plt.update([],' ');
%%
plt.figure;
plt.setfig_ax('xtickangle', 0);
plt = fig_ax_err(plt, tmd, sub, time_md);
plt.update([],' ');
%% Figure 4 (regular)
tmd = md;
plt.figure(2,3);
plt = fig_ax_x0(plt, tmd, sub, time_md);
plt.new;
plt = fig_ax_EV(plt, tmd, sub, time_md);

plt.new;
plt = fig_ax_accept_reject(plt, tmd, sub, time_md);
plt.new;
plt = fig_ax_A(plt, tmd, sub, time_md);
plt.new;
plt = fig_ax_Acor(plt, tmd, sub,[5 6], time_md);
plt.update;
%%
mds = {md, md_drift, md_diff};
%% plot explained variance (noise vs condition) 
plt.figure;
av= [];se = [];
evar = W.cellfun(@(x)x.explained_var, md, false);
evar = vertcat(evar{:});
[av(1,:), se(1,:)] = W.avse(evar);
evar = W.cellfun(@(x)x.explained_var, md_drift, false);
evar = vertcat(evar{:});
[av(2,:), se(2,:)] = W.avse(evar);
evar = W.cellfun(@(x)x.explained_var, md_diff, false);
evar = vertcat(evar{:});
[av(3,:), se(3,:)] = W.avse(evar);
plt.plot(time_md, av, se, 'line');
plt.setfig_ax('legend', {'full model', 'ev only', 'noise only'}, 'xlabel', 'time',...
    'ylabel', 'explained variance');
plt.update;
%% noise by cond
plt.figure(3,2);
for i = 1:3
    plt.ax(i,1);
    plt = fig_bycond_var(plt, mds{i}, sub, time_md);
    plt.ax(i,2);
    plt = fig_avcer_var(plt, mds{i}, sub, time_md);
end
plt.update;
%% overwrite datasimu
options = {'full','drift', 'diffav'};
for si = 1:nses
    tev = sub.avDRIFTRATE_byCONDITION(si,:);
    cond = data{si}.games.condition;
    c = data{si}.games.choice + 1;
    ev = arrayfun(@(x)tev(x), cond);
    dummy_cond = dummyvar(cond);
    dummy_c = dummyvar(c);
    for i = 1:3
        W.print('%d,%d',si,i);
        tmd = mds{i}{si};
        x = x1D{si}(:,1);
        xn = x;
        for ti = 1:size(tmd.a,2)
            x(:, ti+1) = modelEV(tmd.a(:,ti)', tmd.x0(:,ti)', tmd.b(:,ti)', ...
                x(:, ti), ev, dummy_cond, dummy_c, options{i});
            xn(:, ti+1) = x(:, ti+1) +  shuffle(tmd.error(:,ti));
        end
        mds{i}{si}.data_simu = x;
        mds{i}{si}.data_simu_noise = xn;
    end
end
%% Energy landscape
npool = 1;
nstep = 1;
ELnoise = {};
for si = 1:nses
    W.print('%d: ...', si);
    ELnoise{si,1} = main_energy_landscape(x1D{si}, time_at, data{si}.games, npool, nstep);
    for i = 1:3
        te = mds{i}{si}.data_simu_noise;
        ELnoise{si,i+1} = main_energy_landscape(te, time_at, data{si}.games, npool, nstep);
    end
end
save('EL_noise.mat', 'ELnoise');
%%
EL = {};
for si = 1:nses
    W.print('%d: ...', si);
    EL{si,1} = main_energy_landscape(x1D{si}, time_at, data{si}.games, npool, nstep);
    for i = 1:3
        te = mds{i}{si}.data_simu;
        EL{si,i+1} = main_energy_landscape(te, time_at, data{si}.games, npool, nstep);
    end
end
save('EL.mat', 'EL');
%% 
load('EL_noise.mat');
load('EL.mat');
%% plot energy landscape
plt.figure(4,2,'is_title', 1, 'gapW_custom', [0 1 1] * 100);
for i = 1:4
    fig_EL_choice(plt, x1D, time_at,ELnoise(:,i), games, sub.animal);
end
plt.update;
%%
plt.figure(4,2,'is_title', 1, 'gapW_custom', [0 1 1] * 100);
for i = 1:4
    fig_EL_cue(plt, ELnoise(:,i), sub, 'median')
end
plt.update;
%%

plt.figure(1,2, 'is_title', 1, 'gapW_custom', [0 1 1] * 100);
plt.reload_paramdatabase();
    fig_EL_cue(plt, ELnoise(:,3), sub, 'median')
%     fig_EL_cue(plt, ELnoise(:,4), sub, 'median')
plt.update([],'  ');
%%
plt.figure(1,2, 'is_title', 1, 'gapW_custom', [0 1 1] * 30);
plt.reload_paramdatabase();

        te = W.cellfun(@(x)x.data_simu_noise,mds{2});

    fig_EL_choice(plt, te, time_at,ELnoise(:,3), games, sub.animal);
%     fig_EL_cue(plt, ELnoise(:,4), sub, 'median')
plt.update([],'  ');