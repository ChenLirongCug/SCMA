function [ output_args ] = allTrain_Parfor( input_args )
%ALLTRAIN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

 load('D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\data\AElatdata\T_sunshi''5-40-20-10-5''.mat');
 train_x_six = train_x_six;
%  er(1,1) = threelays(train_x_six,250,283);
% 
   tic;
%    parfor  i = 1 : 2
     spmd
         switch  labindex
             case  1
             threelays(train_x_six,250,283);
             case  2
             fivelays(train_x_six,250,283);
%              case(i == 3)
%              sevenlays(train_x_six,250,283);
%              case(i == 4)
%              ninelays(train_x_six,250,283);
%              case(i == 5)
%              elevenlays(train_x_six,250,283);
         end
   end
   t = toc;
   disp(['allTrain_Parfor : ' ' Took ' num2str(t) ' seconds']);
%  figure;plot(er);
%  saveas(gcf,strcat('E://DataResulterGraph/��������ѵ��ͼ/���粻ͬ�������仯ͼ'),'fig');
end

