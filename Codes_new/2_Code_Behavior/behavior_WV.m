function sub = behavior_WV(game)
    %% average by condition
    sub = W.analysis_tab_av_bygroup(game, 'condition', 1:9, {'choice', 'rt_reject', 'rt_accept', 'delay','drop'});
    %% median by condition
    tsub = W.analysis_tab_av_bygroup(game, 'condition', 1:9, {'rt_reject', 'rt_accept'}, true);
    sub = W.struct_merge(sub,tsub);
    %% compute entropy
    sub.ENTROPY_byCONDITION = W.entropys_bernoulli(sub.avCHOICE_byCONDITION);    
    %% compute information
    pa = W.vert(sub.avCHOICE_byCONDITION);
    fc = max([pa, 1-pa],[],2);
    fc = min(fc, 0.99);
    tinfo = 2*sqrt(2) * erfcinv(2 * (1-fc)) .* sign(pa - 0.5);
    sub.INFORMATION_byCONDITION = W.horz(tinfo);
    %% compute average RT (for standardization purpose)
    tsub = W.analysis_tab_av(game, {'choice', 'rt_reject', 'rt_accept'});
    sub = W.struct_merge(sub,tsub);
    tsub = W.analysis_tab_av(game, {'choice', 'rt_reject', 'rt_accept'}, true);
    sub = W.struct_merge(sub,tsub);
end
%% need to implement later
%     out = catstruct(out,te);
%     rg_fed = [0:0.25:1];
%     te = W.analysis_bincurve_bygroup('cond', [], d,{'choice_accept', 'rt_reject', 'rt_accept','rt_purple'}, 'perc_juice_previous', rg_fed,'all');
%     out = catstruct(out,te);
%     rg_fed = [0:200:2000];
%     d.trialnumber = W.vert(1:size(d,1));
%     te = W.analysis_bincurve_bygroup('cond', [], d,{'choice_accept', 'rt_reject', 'rt_accept','rt_purple'}, 'trialnumber', rg_fed,'all');
%     te = W.struct_name_pfxsfx(te, [],'_trialn');
%     out = catstruct(out,te);
%     
%     rg_fed = [1.25:0.5:3.75];
%     te = W.analysis_bincurve_bygroup('cond', [], d,{'choice_accept', 'rt_accept'}, 'rt_purple', rg_fed,'all');
%     te = W.struct_name_pfxsfx(te, [],'_purple');
%     out = catstruct(out,te);
