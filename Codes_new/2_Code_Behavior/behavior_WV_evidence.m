function subs = behavior_WV_evidence(subs, idx_animal)
    %% estimate RT for accept choices
    nsub = size(subs, 1);
    subs =  W.tab_fill(subs, 'non_decision_times', (0:50:200)/1000);
    subs.estRT_REJECT_byCONDITION = NaN(nsub, 9);
    for si = W.horz(unique(idx_animal))
        sub = subs(idx_animal == si, :);
        cc = sub.avCHOICE_byCONDITION;
        E = sub.ENTROPY_byCONDITION;
        rt = sub.midRT_REJECT_byCONDITION;
        cid = cc <= 0.5;
        tx = W.vert(E(cid));
        ty = W.vert(rt(cid));
        sesid = meshgrid(1:size(E,1),1:size(E,2))';
        ts = W.vert(sesid(cid));
        tbl = table(tx, ty, ts);      
        tmd = fitlme(tbl, 'ty ~ tx + (1|ts)');
        
        ttbl = table;
        ttbl.tx = W.vert(E(cc > 0.5));
        ttbl.ts = W.vert(sesid(cc > 0.5));
        
        rtest = rt;
        rtest(cc > 0.5) = predict(tmd, ttbl);
        subs.estRT_REJECT_byCONDITION(idx_animal == si,:) = rtest;
    end
    %% compute evidence for each cue
    subs.avDRIFTRATE_byCONDITION = NaN(nsub, 9);
    subs.avR_driftrates = NaN(nsub, 1);
    for i = 1:nsub
        driftrate_byCONDITION = [];
        for ti = 1:length(subs.non_decision_times(i,:))
            driftrate_byCONDITION(ti,:) = subs.INFORMATION_byCONDITION(i,:)./...
                (2*sqrt(subs.estRT_REJECT_byCONDITION(i,:) - subs.non_decision_times(i, ti)));
        end
        subs.avDRIFTRATE_byCONDITION(i,:) = W.avse(driftrate_byCONDITION);
        subs.DRIFTRATE_ndt100(i,:) = driftrate_byCONDITION(1,:);
        subs.DRIFTRATE_ndt200(i,:) = driftrate_byCONDITION(end,:);
        tcor = corr(driftrate_byCONDITION([1 end],:)', 'row', 'complete');
        subs.avR_driftrates(i) = mean(tcor(triu(~eye(size(tcor)))), 'omitnan');
    end
end