function [ output_args ] = TwodataCombin( er1, er2 ,map1, map2)
%   er1, er2 �ϲ�
%   �˴���ʾ��ϸ˵��
   
   er_1       = [er1';map1];
   er_2       = [er2';map2];
   er_combin  = [er_1 er_2];
   OutEr      =  sortrows(er_combin', 2 );          % 27�� * 2 ����
   outEr = reshape(OutEr(:,1),1540,1741);
   save(strcat('E://DataResulterGraph/3-29-2������ѵ��ͼ/threelays/20-17�����ϲ�.mat'));
end

