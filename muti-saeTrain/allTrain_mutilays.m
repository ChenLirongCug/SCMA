function [ output_args ] = allTrain_mutilays( input_args )
%ALLTRAIN �˴���ʾ�йش˺�����ժҪ


%   ��Ҫ��nn���Ȩֵ˥��wd�������޸�


%    load('C:\Program Files\MATLAB\R2012a\toolbox\final-DeepLearnToolbox-masterComXING\fenCengKmeans-AE\2leiInputdata.mat');
     load('E:\0nanhuashan\Indata\clasify_data.mat');
        
%        Er1 = threelays(map_1(1:5,:)',39,1,4000);  
%        clearvars -except Er1  map_1 map_2;
%        Er2 = threelaysOne(map_2(1:5,:)',9,2,4000);  
%         clearvars -except Er1 Er2  map_1 map_2;
%        TwodataCombin(Er1,Er2,map_1(6,:),map_2(6,:));
       

       fivelays(map_1(1:4,:)',10,5,16274); %nofilter2�ĸ���36547  filter����36827
       fivelays(map_2(1:4,:)',10,5,4938);
%        fivelays(map_3(1:5,:)',10,5,23508);
      
       sevenlays(map_1(1:4,:)',5,7,16274); %nofilter2�ĸ���36547  filter����36827
       sevenlays(map_2(1:4,:)',5,7,4938);
%        sevenlays(map_3(1:5,:)',4,7,23508);
      
       ninelays(map_1(1:4,:)',2,9,16274); %nofilter2�ĸ���36547  filter����36827
       ninelays(map_2(1:4,:)',2,9,4938);
%        ninelays(map_3(1:5,:)',2,9,23508);
         
       elevenlays(map_1(1:4,:)',1,11,16274); %nofilter2�ĸ���36547  filter����36827
       elevenlays(map_2(1:4,:)',1,11,4938);
%        elevenlays(map_3(1:5,:)',1,11,23508);
      
%        t1 = threelays(train_x_six,29,1,500); 
% 
%           tic_1 = clock;
%       t2 = threelays(train_x_six,29,1,70750); 
%           tic_2 = clock;
%       t2 = fivelays(train_x_six,100,1,4000); 
%           tic_3 = clock;
%       t3 = sevenlays(train_x_six,250,283);  
%           tic_4 = clock;
%       t4 = ninelays(train_x_six,250,283); 
%           tic_5 = clock;
%       t5 = elevenlays(train_x_six,250,283);  
%           tic_6 = clock;
          
%      t_3 = etime(tic_2,tic_1);   %��¼����ʱ��
%      t_5 = etime(tic_3,tic_2); 
%      t_7 = etime(tic_4,tic_3); 
%      t_9 = etime(tic_5,tic_4); 
%      t_11 = etime(tic_6,tic_5); 
%       
%      disp('======================================');
%      disp(['t_3�������ӿ�ʼ���������е�ʱ��:',num2str(t_3)]);
%      disp(['t_5�������ӿ�ʼ���������е�ʱ��:',num2str(t_5)]);
%      disp(['t_7�������ӿ�ʼ���������е�ʱ��:',num2str(t_7)]);
%      disp(['t_9�������ӿ�ʼ���������е�ʱ��:',num2str(t_9)]);
%      disp(['t_11�������ӿ�ʼ���������е�ʱ��:',num2str(t_11)]);
     disp('======================================');
     
%      disp(['11������ṹΪ:5-',num2str(t5(1,1)), '-' ,num2str(t5(1,2)), '-',num2str(t5(1,3)), '-',...
%          num2str(t5(1,4)),'-5-',num2str(t5(1,4)), '-' ,num2str(t5(1,3)), '-',num2str(t5(1,2)), '-',num2str(t5(1,1)),'-5']);
%      disp(['��ʮһ����������Ԫ���ǣ�', num2str(t5(1,5))]);
%      
%    figure;plot(er);
%    saveas(gcf,strcat('E://DataResulterGraph/��������ѵ��ͼ/���粻ͬ�������仯ͼ'),'fig');
end
