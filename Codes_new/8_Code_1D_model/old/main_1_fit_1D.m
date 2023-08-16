run('../setup_analysis.m')
%%
W_lp.overwrite_on;
W_lp.reset();
%% fit svm vs mean & fit pool 1 vs 3
W_lp.add_loopsfx("t0t1000", {"svm","svm1000", "mean"}, "scaledEV", {"npool1","npool3"});
%% fit EV vs residue
W_lp.add_loopsfx("t0t1000", {"svm1000","svm"}, {'scaledEV', 'residue'}, {"npool1","npool3"});
%% fit based on location alone/soft
W_lp.add_loopsfx("t0t1000", {'svm1000','svm'}, {'scaledEVsoftfixwin', 'residuesoftfixwin', ...
    'scaledEVsoft', 'scaledEVloc', ...
    'residuesoft', 'residueloc'}, {'npool1','npool3'});
%%
W_lp.parloopsfx('function_1D_model', {'data_cleaned', 'sub', 'x1D_autosfx2', 'Pos1D_autosfx2'}, 'model1D', 'variable3', 'variable4_num');

%% fit 1 basin
W_lp.add_loopsfx("t0t1000", {"svm"}, {"scaledEV","1basin"}, {"npool1"});
W_lp.parloopsfx('function_1D_model', {'data_cleaned', 'sub', 'x1D_autosfx2', 'Pos1D_autosfx2'}, 'model1D', 'variable3', 'variable4_num');

%%
te = W_lp.loadsfx('model1D');
%%
mean(cellfun(@(x)mean(x.model1D_t0t1000_svm_1basin_npool1.mdfit.LL), te))
mean(cellfun(@(x)mean(x.model1D_t0t1000_svm_1basin_npool1.mdfit.AIC), te))
mean(cellfun(@(x)mean(x.model1D_t0t1000_svm_1basin_npool1.mdfit.BIC), te))

mean(cellfun(@(x)mean(x.model1D_t0t1000_svm_scaledEV_npool1.mdfit.LL), te))
mean(cellfun(@(x)mean(x.model1D_t0t1000_svm_scaledEV_npool1.mdfit.AIC), te))
mean(cellfun(@(x)mean(x.model1D_t0t1000_svm_scaledEV_npool1.mdfit.BIC), te))
% ver_npool = [1 3];
% ver_pca = "t0t1000";
% ver_1Dproj = {'svm','mean'};
% ver_1Dmodel = {'scaledEV', 'residue'};
% versions = W.get_combinations(ver_npool, ver_pca, ver_1Dproj, ver_1Dmodel);
%% fit all versions
% for veri = 1:size(versions,1)
%     vers = versions(veri,:);
%     npool = vers.ver_npool;
%     str_x1D = sprintf('x1D%s_%s.mat', vers.ver_1Dproj, vers.ver_pca);
%     savename = sprintf('model1D_%s_x1D%s_%s_npool%d.mat', vers.ver_1Dmodel, vers.ver_1Dproj, vers.ver_pca, npool);
%     W_lp.parloop(8, 'function_1D_model', {'data_cleaned', 'sub', str_x1D}, savename, npool, vers.ver_1Dmodel)
% end
