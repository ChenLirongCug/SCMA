function [er, bad] = nntest(nn, x, y)
    % er �ǲ�������ֵռ�����Ķ��ٱ�����bad��λ��
    % labels Ϊλ��ָ��array
    
    labels = nnpredict(nn, x);
    [dummy, expected] = max(y,[],2);
    bad = find(labels ~= expected);    
    er = numel(bad) / size(x, 1);
    
end
