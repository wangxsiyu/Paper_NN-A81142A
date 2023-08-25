run('../setup_analysis.m')
%%
ver_1Dmodel = {'scaledEVrejectonly','scaledEVpyDDM', 'scaledEVpyDDMCB'};
W_lp.reset;
W_lp.set_loopsfx("t0t1000", {'svm'}, ver_1Dmodel, {'npool1', 'npool3'});
%%
W_lp.parloopsfx('function_1D_model', {'data_cleaned', 'sub', 'x1D_t0t1000_svm'}, 'model1D', [], 'variable3', 'variable4_num');
%%
% ver_npool = [3];
% ver_pca = "t0t1000";
% ver_1Dproj = {'svm'};
% ver_1Dmodel = {'scaledEV_rejectonly','scaledEV_pyDDM', 'scaledEV_pyDDM_CB'};
% versions = W.get_combinations(ver_npool, ver_pca, ver_1Dproj, ver_1Dmodel);
% %% fit all versions
% for veri = 1:size(versions,1)
%     vers = versions(veri,:);
%     npool = vers.ver_npool;
%     str_x1D = sprintf('x1D%s_%s.mat', vers.ver_1Dproj, vers.ver_pca);
%     savename = sprintf('model1D_%s_x1D%s_%s_npool%d.mat', vers.ver_1Dmodel, vers.ver_1Dproj, vers.ver_pca, npool);
%     W_lp.parloop(8, 'main_1D_model', {'data_cleaned', 'sub', str_x1D}, savename, npool, vers.ver_1Dmodel)
% end
