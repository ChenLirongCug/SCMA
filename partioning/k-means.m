function [ output_args ] = k-means(nnOutdata1, n )
%K-MEANS kmeans �����ݷ�Ϊn��
%  nnOutdata1 Ϊ������m��������p������ֵ

%%%%����Ĵ��룺
opts = statset('Display','final','MaxIter',1000); 
kmeans112 = kmeans( nnOutdata1 , n ,'Options',opts);

idx = reshape(kmeans112,250,283);
            idx = flipud(idx);
            figure;contourf(idx);

end

