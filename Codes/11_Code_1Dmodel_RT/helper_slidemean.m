function outx = helper_slidemean(x, w)
    if ~exist('w','var')
        w = [-1 0 1];
    end
    nx = size(x,1);
    outx = x * NaN;
    for i = 1:nx
        ti = i + w;
        ti = intersect(ti, 1:nx);
        outx(i,:) = mean(x(ti,:));
    end
end