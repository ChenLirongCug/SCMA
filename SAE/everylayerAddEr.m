function everylayerAddEr
%EVERYLAYERADDER ���ڼ���ÿ���У�ÿ��������Ԫ�������Լ�����仯���
%%  ��������Ϊ9��ѵ����CG���ݣ�5-40-20-10-5-10-20-40-5
%%  ���������븳ֵ
interNum = 200 ;               %��������
batchSizeNum = 10 ;            %batch�Ĵ�С������Ҫ�ܱ�������������
saeLearningRate = 0.3;         %Ԥѵ�����ֵ�ѧϰ��
AllNNLearningRate = 0.8;       %��������
NeuralNumsinglelay = 10;       %����������Ԫ����Ŀ,��ʼ��
endNeuralNum = 200;            %����������Ԫ����Ŀ,��ֹ��
AddNerualNum = 10 ;            %ÿ�����Ӷ��ٸ���Ԫ

% startendNum = 5 ;              %ͷβ��Ԫ��һ��
loadAddress = 'D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\data\AElatdata\T_sunshi''5-40-20-10-5''.mat';  %��Ҫ���ص������ļ�λ��
% saveAddress = 'D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\data\everylayerAddEr\everylayerAddEr.mat';  %��Ҫ�洢�������ļ�λ��
% everLayNeurNumAddAddr = strcat('D:\Program Files\MATLAB\R2014a\toolbox\final-DeepLearnToolbox-master\data\everylay',num2str(startendNum) ,'.mat');  %��Ҫ�洢�������ļ�λ��
%%%%%%%%%%%%%%%%%%%%%%%
load(loadAddress);
rand('state',0)   

   
    for i = NeuralNumsinglelay : AddNerualNum : endNeuralNum
            
            Saestruct = [5  i];        %SAE�����ʼ������
            sae = saesetup(Saestruct);
            sae.ae{1}.activation_function       = 'sigm';
            sae.ae{1}.learningRate              = saeLearningRate;
            opts.numepochs =  interNum;
            opts.batchsize = batchSizeNum;
            [sae] = saeRawTrainProgram(sae, x, opts);
          
            % encoder��w��ת��+decoder��b��
            wae1 = [sae.ae{1}.W{2}(:,1)';sae.ae{1}.W{1}(:,2:end)]; 

            % Use the SDAE to initialize a FFNN  fine_tuning����
            nn = nnsetup([startendNum  i  startendNum]);
            nn.activation_function              = 'sigm';
            nn.learningRate                     = AllNNLearningRate;

            nn.W{1} = sae.ae{1}.W{1};                        %  encoder�����w1��Ȩֵ��discoder��w1+w2��ƫִ
            nn.W{2} = wae1';
            nn.output              = 'sigm';                  %  use softmax output

            %%%%%%%%%%% Train the FFNN
            opts.numepochs =   interNum;
            opts.batchsize =  batchSizeNum;
            [nn,lfull] = nntrain(nn, x, x, opts);
            
            figure;plot( lfull);   %���������µ����
            saveas(gcf,strcat('E://DataResulterGraph/��������ѵ��ͼ/', numel(sae.ae), '����������������ֵ'),'fig');
            
            subCG = nnfse(nn, x);                      %���ÿ�������
            
            %%%%%%%%%%% �����ع���ԭʼ���ݲ��죬���ӻ��쳣���
            rawoutEr =  computerRawAndRestroeL( subCG{1,1}, train_x_six);     %ÿ����һ����Ԫ�������ɵ����ݶ���ԭʼ���ݽ��бȽ�
            Aller(j,1) = mean(rawoutEr(:));                       %����������������
            rawoutEr =  reshape(rawoutEr,250,283);
            figure;contourf(flipud(rawoutEr)); 
            axis off;               %���᲻�ɼ���
%           title(strcat(num2str(i) ,'����Ԫ�쳣�ֲ�'));
            saveas(gcf,strcat('E://DataResulterGraph/����ѵ�����ͼ/',num2str(z),'��',num2str(i),'���������쳣�ֲ�'),'fig')  %���ֻ��һ��ͼ��handle��Ϊgcf           
            close(figure(gcf));            
            
            %%%%%%%%%%   ��¼ÿ������Ԫ��������Ч���ı仯
            disp([num2str(i) '�����������������']); 
            opts = statset('Display','final','MaxIter',1000);   %���ݴ��ˣ�100�β���������Ϊ1000��
            idx = kmeans(subCG{1,1},5,'Options',opts);             
            idx = reshape(idx,250,283);
            idx = flipud(idx);
            figure;contourf(idx); 
            axis off;               %���᲻�ɼ���
%           title(strcat('��',num2str(i), '�����Ч��'));
            saveas(gcf,strcat('E://DataResulterGraph/����ѵ�����ͼ/��',num2str(z),'��',num2str(i),'�������ľ���Ч��'),'fig') 
            close(figure(gcf));     %�ر��������ɵ�ͼ
            
            j = j+1 ;           %���ڼ�¼���ֵ��λ��
    end
    
        figure;plot(Aller );
        if (size(Aller(:,1)) == 20)
            set(gca,'xtick',[10:10:200]);
%             set(gca,'xticklabel',{'2005��','2006��','2007��','2008��','2009��','2010��'});
        else
            set(gca,'xtick',[5:5:40]);
        end
    %     title(strcat('��',num2str(z),'�㣬ÿ����10����Ԫ�������ı仯���'));
        saveas(gcf,strcat('E://DataResulterGraph/����ѵ�����ͼ/��',num2str(z),'�������ı仯���'),'fig') 
        close(figure(gcf));   
        disp('*****');
        
end

