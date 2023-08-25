function figdata = main_Figure_1_behavior(plt, outputname, sub, data)
games = W.cellfun(@(x)x.games, data, false);
%% print stats
fid = fopen(W.enext(outputname,'txt'), 'wt');
te_nt = cellfun(@(x)size(x.games,1), data);
W.fprintf(fid, '#trials(V) = %.2f, #trials(W) = %.2f', W.analysis_av_bygroup(te_nt', sub.idx_animal));
te_nt = cellfun(@(x)length(x.spikes), data);
W.fprintf(fid, '#cells(V) = %.2f, #cells(W) = %.2f', W.analysis_av_bygroup(te_nt', sub.idx_animal));
% print RT
W.fprintf(fid, 'reject: avRT(V) = %.2f, avRT(W) = %.2f', W.analysis_av_bygroup(sub.avRT_REJECT, sub.idx_animal));
W.fprintf(fid, 'accept: avRT(V) = %.2f, avRT(W) = %.2f', W.analysis_av_bygroup(sub.avRT_ACCEPT, sub.idx_animal));

W.fprintf(fid, 'reject: midRT(V) = %.2f, midRT(W) = %.2f', W.analysis_av_bygroup(sub.midRT_REJECT, sub.idx_animal));
W.fprintf(fid, 'accept: midRT(V) = %.2f, midRT(W) = %.2f', W.analysis_av_bygroup(sub.midRT_ACCEPT, sub.idx_animal));

% print RT
W.fprintf(fid, 'reject (pooled): avRT(V) = %.2f, avRT(W) = %.2f', arrayfun(@(t) mean(W.cell_vertcat_cellfun(@(x)x.rt_reject, games(sub.idx_animal == t)), 'omitnan'), 1:2));
W.fprintf(fid, 'reject (pooled): midRT(V) = %.2f, midRT(W) = %.2f', arrayfun(@(t) median(W.cell_vertcat_cellfun(@(x)x.rt_reject, games(sub.idx_animal == t)), 'omitnan'), 1:2));
fclose(fid);
%%     
figdata = FIGURE_behavior(plt, sub, games);
end
