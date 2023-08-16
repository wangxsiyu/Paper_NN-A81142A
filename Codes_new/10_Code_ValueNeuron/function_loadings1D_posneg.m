function out = function_loadings1D_posneg(anv, pc, x1D)
    npc = length(x1D.w_svm);
    ld = pc.info_pc.coeff(:, 1:npc) * x1D.w_svm'./sqrt(sum(x1D.w_svm.^2));
%     ld = ld.^2 /sum(ld.^2);
    ppos = anv.perc_positive;
    out.av_ld = W.bin_avY_byX(ld, ppos, [0:0.1:1]);
%     out.av_ld = W.bin_sumY_byX(ld, ppos, [0:0.1:1]);
end