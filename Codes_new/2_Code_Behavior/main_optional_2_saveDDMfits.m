%% load pyDDM results
p1 = W.readtable('./Temp/fit_ddm_v1_vanilla.csv');
p2 = W.readtable('./Temp/fit_ddm_v2_collapsingbound.csv');
%% turn pyDDM results into session by condition tables
t1 = NaN(16,9);
t2 = NaN(16,9);
for i = 1:size(p1,1)
    t1(p1.sessionID(i)+1, p1.condition(i)+1) = p1.drift(i);
end
for i = 1:size(p2,1)
    t2(p2.sessionID(i)+1, p2.condition(i)+1) = p2.drift(i);
end
%%
sub.pyDDM_vanilla = t1;
sub.pyDDM_collapsingbound = t2;
%% save sub
save(fullfile('./Temp/behavior_sub_ddm.mat'), 'sub');