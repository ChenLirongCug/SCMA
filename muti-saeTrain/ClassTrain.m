%   ������ѵ����������ϲ�     


load('D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\datadeal\1540data_clafy.mat');
     map_x1 = map_1(1:5,:)';
     map_x2 = map_2(1:5,:)';
     map_x3 = map_3(1:5,:)';
     
     t1 = threelays(map_x1,1540,1741,1,14797);      
     t2 = threelays(map_x2,1540,1741,2,36979);
     t3 = threelays(map_x3,1540,1741,3,14863);
% load('E://DataResulterGraph/�������ѵ��ͼ/threelays/��Ԫ���ݿ�190����Ԫ1ǧ.mat.mat');
% load('D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\1540data_clafy.mat');
% load('D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\1540data_clafy.mat');

%      t1 = threelays(train_x_six,1540,1741);  
%      t2 = fivelays(train_x_six,190,250,283); 
%      t3 = sevenlays(train_x_six,t2,250,283);  
%      t4 = ninelays(train_x_six,t3,1540,1741); 
%      t5 = elevenlays(train_x_six,t4,250,283);  
% 
%      disp(['11������ṹΪ:5-',num2str(t5(1,1)), '-' ,num2str(t5(1,2)), '-',num2str(t5(1,3)), '-',...
%          num2str(t5(1,4)),'-5-',num2str(t5(1,4)), '-' ,num2str(t5(1,3)), '-',num2str(t5(1,2)), '-',num2str(t5(1,1)),'-5']);
%      disp(['��ʮһ����������Ԫ���ǣ�', num2str(t5(1,5))]);
     
%  figure;plot(er);
%  saveas(gcf,strcat('E://DataResulterGraph/��������ѵ��ͼ/���粻ͬ�������仯ͼ'),'fig');