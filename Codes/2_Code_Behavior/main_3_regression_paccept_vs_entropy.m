function out = main_3_regression_paccept_vs_entropy(sub)
    %%
    sub = W.cell_vertcat_cellfun(@(x)struct2table(x), sub);
    %% RT regression analysis
    cc = sub.avCHOICE_byCONDITION;
    idR = cc <= 0.5;
    idA = cc >= 0.5;

    rtREJECT = sub.avRT_REJECT_byCONDITION;
    rtACCEPT = sub.avRT_ACCEPT_byCONDITION;
    rtREJECT(idA) = NaN;
    rtACCEPT(idR) = NaN;

    rtav = sub.avRT_REJECT;
    rtse = sub.seRT_REJECT;
%     ty0 = W.vert(arrayfun(@(x)(ty(x) - rtav(ts(x)))/rtse(ts(x)) * mean(rtse) + mean(rtav), ...
%         1:length(ty)));


    paccept = sub.avCHOICE_byCONDITION;
    entropy = sub.ENTROPY_byCONDITION;
    sesid = meshgrid(1:size(entropy,1),1:size(entropy,2))';

    rtR = reshape(rtREJECT, [], 1);
    rtA = reshape(rtACCEPT, [], 1);
    pa = reshape(paccept, [], 1);
    ent = reshape(entropy, [], 1);
    sid = reshape(sesid, [], 1);
    mk = reshape(repmat(sub.idx_animal, 1, 9), [], 1);
%     mdl = fitlm([pa, ent, sid], rtR, 'VarNames', {'p(accept)', 'entropy', 'sessionID', 'RT'},...
%         'CategoricalVars', [3]);


    rtC = [rtR; rtA];
    pa2 = [pa; pa];
    ent2 = [ent; ent];
    n = length(pa);
    isA = [zeros(n, 1); ones(n, 1)];
    mk2 = [mk; mk];
    sid2 = [sid;sid];
    td = [pa2 ent2 isA sid2,mk2, rtC];
    td = td(~isnan(rtC),:);
%     mdl2 = fitlm(td(:,1:end-2),td(:,end), 'VarNames', {'p(accept)', 'entropy', 'choice', 'session', 'RT'}, ...
%         'CategoricalVars',[3, 4])


    tbl = array2table(td,'VariableNames',{'pA', 'entropy', 'choice', 'session', 'monkey', 'RT'});
    tbl.choice = nominal(tbl.choice);
    tbl.session = nominal(tbl.session);
    tbl.monkey = nominal(tbl.monkey);
    out.md0 = fitlme(tbl, 'RT ~ choice * monkey + pA * monkey + entropy * monkey + (1|session)', ...
        'DummyVarCoding','reference');
    out.md1 = fitlme(tbl, 'RT ~ choice + pA + entropy + monkey + (1|session)', ...
        'DummyVarCoding','reference'); % this one was wrong, has both positive coeffs
    out.md2 = fitlme(tbl, 'RT ~ pA * monkey + entropy * monkey + (1|session)', ...
        'DummyVarCoding','reference');
    out.md3 = fitlme(tbl, 'RT ~ pA * monkey + entropy * monkey + (1|session) + (1|monkey)', ...
        'DummyVarCoding','reference');
    out.md4 = fitlme(tbl, 'RT ~ pA + entropy + (1|session) + (1|monkey) + (1|choice)', ...
        'DummyVarCoding','reference');
%     tbl2 = tbl(tbl.choice == nominal(1), :);
%     fitlme(tbl2, 'RT ~ entropy + pA * monkey + entropy * monkey + (1|session)')

end


%     options = {'ACCEPT', 'REJECT'};
%     for oi = 1:length(options)
%         option = options{oi};
%             tt = sub(sub.idx_animal == si,:);
%             cc = tt.avCHOICE_byCONDITION;
%             E = tt.ENTROPY_byCONDITION;
%             rt = tt.(sprintf('avRT_%s_byCONDITION', option));
%             switch option
%                 case 'REJECT'
%                     cid = cc <= 0.5;
%                 case 'ACCEPT'
%                     cid = cc >= 0.5;
%             end
%             tx = E(cid);
%             ty = rt(cid);
%             sesid = meshgrid(1:size(E,1),1:size(E,2))';
%             ts = sesid(cid);
%             %         ttab = table(tx, ty, ts);
%             %         tmd = fitlme(ttab, 'ty ~  tx + (1|ts)');
%             %         randeff = tmd.randomEffects;
%             %         ty0 = arrayfun(@(x)ty(x) - randeff(ts(x)), 1:length(ts))';
%             rtav = tt.(['avRT_' option]);
%             rtse = tt.(['seRT_' option]);
%             ty0 = W.vert(arrayfun(@(x)(ty(x) - rtav(ts(x)))/rtse(ts(x)) * mean(rtse) + mean(rtav), ...
%                 1:length(ty)));
%             tz = cc(cid);
%             md = fitlm([tx, tz], ty0)
%             %         ty0 = W.vert(arrayfun(@(x)(ty(x) - rtav(ts(x))) + mean(rtav), ...
%             %             1:length(ty)));