function sae = saesetup(size)
%  �˴��޸���nnsetup��������wȨֵ
    for u = 2 : numel(size)
        sae.ae{u-1} = nnsetup([size(u-1) size(u) size(u-1)]);
    end
end
