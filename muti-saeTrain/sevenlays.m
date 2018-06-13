function  t = sevenlays(train_x_six,NeuralNum,m,batNum)
%%  �˴���ʾ��ϸ˵��



iterNum = 1000 ;               %��������
batchSizeNum = batNum ;            %batch�Ĵ�С������Ҫ�ܱ�������������
saeLearningRate = 0.2;         %Ԥѵ�����ֵ�ѧϰ��
NNLearnRate = 0.8;       %��������
startNeuralNum = NeuralNum;       %����������Ԫ����Ŀ,��ʼ��
endNeuralNum = 50;            %����������Ԫ����Ŀ,��ֹ����50��
AddNerualNum = 5 ;            %ÿ�����Ӷ��ٸ���Ԫ

filename = ['E:\0nanhuashan\���ѵ��\sevenlays\',num2str(batNum),'\'];
if ~exist(filename)
    new_folder = filename;
    mkdir(new_folder);
end
rand('state',0)   
j = 1;
% t1 = tm(1,1); % tmΪǰ�����ѵ�������С�Ĳ���
% t2 = tm(1,2);
t=0;

disp('*************************************************�߲�����ѵ��********************************************');
    for i = startNeuralNum : AddNerualNum : endNeuralNum
            
            Saestruct = [4 200 100 i];        %SAE�����ʼ������
            sae = saesetup(Saestruct);
            sae.ae{1}.activation_function       = 'PreLu';
            sae.ae{1}.learningRate              = saeLearningRate;
            opts.numepochs =  iterNum;
            opts.batchsize = batchSizeNum;
            [sae] = saeRawTrainProgram(sae, train_x_six, opts);
            
            % encoder��w��ת��+decoder��b��
            wae1 = [sae.ae{3}.W{2}(:,1)';sae.ae{3}.W{1}(:,2:end)]; 
            wae2 = [sae.ae{2}.W{2}(:,1)';sae.ae{2}.W{1}(:,2:end)]; 
            wae3 = [sae.ae{1}.W{2}(:,1)';sae.ae{1}.W{1}(:,2:end)];          

            % Use the SDAE to initialize a FFNN  fine_tuning����
            nn = nnsetup([4 200 100 i 100 200 4]);
            nn.activation_function              = 'PreLu';
            nn.learningRate                     = NNLearnRate;

            nn.W{1} = sae.ae{1}.W{1};                        %  encoder�����w1��Ȩֵ��discoder��w1+w2��ƫִ
            nn.W{2} = sae.ae{2}.W{1}; 
            nn.W{3} = sae.ae{3}.W{1}; 
            nn.W{4} = wae1';
            nn.W{5} = wae2';
            nn.W{6} = wae3';
            
            nn.output              = 'sigm';                  %  use softmax output

            %%%%%%%%%%% Train the FFNN
            opts.numepochs =   iterNum;
            opts.batchsize =  batchSizeNum;
            [nn,lfull] = nntrain(nn, train_x_six, train_x_six, opts);
            layLfull(j) = lfull(end);
            NNoutdata = nnfse(nn, train_x_six, batchSizeNum);                      %���ÿ�������
            
            %%%5-40-20-10-5%  ����ʮ����ʱ�������������ֵ
%             if(i == 10)
%                threelayEr = lfull(size(lfull,1),1);
%             end
                    
            figure;plot(lfull);   %���������µ����
            saveas(gcf,strcat(filename, num2str(i),'����Ԫ��������������ֵ'),'fig');
            close(figure(gcf));     %�ر��������ɵ�ͼ
                        
            %%%%%%%%%%% �����ع���ԭʼ���ݲ��죬���ӻ��쳣���
            nnoutdata1   =   gather(NNoutdata);
            rawoutEr =   elcomputer( train_x_six, nnoutdata1)   %�ع����
%             rawoutEr =  reshape(rawoutEr,r,c);
%             figure;visualize(rawoutEr); 
%             axis off;              %���᲻�ɼ���
%           title(strcat(num2str(i) ,'����Ԫ�쳣�ֲ�'));
% %             saveas(gcf,strcat(filename, num2str(i),'���������쳣�ֲ�'),'fig')  %���ֻ��һ��ͼ��handle��Ϊgcf           
% %             close(figure(gcf));            
% %      

            %���Ͼ���
            mahal_d =   mahal( nnoutdata1, train_x_six);
%             mahal_d =   reshape(mahal_d,250,283); 
            mahal_d_log = log(mahal_d);     %ȡ�����������ϵ
% %             figure;contourf(flipud(mahal_d_log));
% %             axis off;              %���᲻�ɼ���
% %             title(strcat(num2str(i) ,'����Ԫ���Ͼ����쳣�ֲ�'));
% %             saveas(gcf,strcat(filename, num2str(i),'�����������Ͼ����쳣�ֲ�'),'fig')  %���ֻ��һ��ͼ��handle��Ϊgcf           
% %             close(figure(gcf));            


%             %%%%%%%%%%   ��¼ÿ������Ԫ��������Ч���ı仯
%             disp(['�߲����磬',num2str(i), '�����������������']); 
%             opts = statset('Display','final','MaxIter',1000);   %���ݴ��ˣ�100�β���������Ϊ1000��
%             nnoutdata2   =   gather(NNoutdata{3,1});
%             idx = kmeans(nnoutdata2 ,5,'Options',opts);             
%             idx = reshape(idx,r,c);
%             idx = flipud(idx);
% %             figure;contourf(idx); 
% %             axis off;               %���᲻�ɼ���
% % %           title(strcat('��',num2str(i), '�����Ч��'));
% %             saveas(gcf,strcat(filename,num2str(i),'�������ľ���Ч��'),'fig') 
% %             close(figure(gcf));     %�ر��������ɵ�ͼ
            
            j = j+1 ;           %���ڼ�¼���ֵ��λ��
% %             

            clear  wae2 wae1 nn.W  nn.vW nn.dW;
            save(strcat(filename,'��Ԫ���ݿ�',num2str(i),'����Ԫ.mat'));
    end
    
           figure;plot(layLfull);
        
%     %   �ҳ����Ļ���С��
%          max1 = max(layLfull);
%          mm   = max(max1);
%         [~,column] = find(layLfull==mm);
%         t(1,1) = t1;
%         t(1,2) = t2;
%         t(1,3) =   startNeuralNum + (column-1) * AddNerualNum;
    
        title(strcat('��',num2str(m),'�㣬ÿ����5����Ԫ�������ı仯���'));
        saveas(gcf,strcat(filename,'7��-��Ԫ�����������ı仯���'),'fig') 
        close(figure(gcf));   
        disp('*****');

end



