run('../load_behavior.m')
files = W.dir(fullfile(datadir, '*/EL_t0t1000_npool3_choice.mat'));
EL = W.load(files.fullpath);
files = W.dir(fullfile(datadir, '*/x1Dsvm_t0t1000_choice.mat'));
x1D = W.load(files.fullpath);






