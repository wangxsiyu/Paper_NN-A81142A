run('../load_behavior.m')
files = W.dir(fullfile(datadir, '*/EL_x1Dsvm_t0t1000.mat'));
EL = W.load(files.fullpath);
files = W.dir(fullfile(datadir, '*/x1Dsvm_t0t1000.mat'));
x1D = W.load(files.fullpath);






