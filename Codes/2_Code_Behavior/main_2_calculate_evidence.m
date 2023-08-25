function subs = main_2_calculate_evidence(sub, subddm)
    if exist('subddm')
        sub = W.tab_horzcat(sub, struct2table(subddm));
    end
    %% compute evidence 
    sub = behavior_WV_evidence(sub, sub.idx_animal);
    %% distribute data to individual sessions
    subs = W.arrayfun(@(x)table2struct(sub(x,:)), 1:size(sub,1), false);
end