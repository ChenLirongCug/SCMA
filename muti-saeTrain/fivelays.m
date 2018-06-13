function rawoutEr = fivelays(train_x_six,NeuralNum,m,batNum)
%%  [5 200 i]
%%  �˴���ʾ��ϸ˵��



iterNum = 2000 ;              %��������
batchSizeNum =  batNum;       %batch�Ĵ�С������Ҫ�ܱ���������������70750�����ݣ�1415
saeLearningRate = 1;        %Ԥѵ�����ֵ�ѧϰ��
NNLearnRate = 0.8;            %��������
startNeuralNum = NeuralNum;          %����������Ԫ����Ŀ,��ʼ��
endNeuralNum = 100;           %����������Ԫ����Ŀ,��ֹ�� ��400��
AddNerualNum = 10 ;           %ÿ�����Ӷ��ٸ���Ԫ
tm = 200;
filename = ['E:\0nanhuashan\���ѵ��\fivelays\',num2str(batNum),'\'];
if ~exist(filename)
    new_folder = filename;
    mkdir(new_folder);
end
rand('state',0)   

j = 1;
threelayEr = 0;

disp('***********************************�������ѵ��*********************************************');
     for i = startNeuralNum : AddNerualNum : endNeuralNum
            
            Saestruct = [4 tm i];        %SAE�����ʼ������
            sae = saesetup(Saestruct);
            sae.ae{1}.activation_function       = 'PreLu';
            sae.ae{1}.learningRate              = saeLearningRate;
% %             sae.ae{1}.dropoutFraction = 0.8;         %dropout�������50%��������
%             sae.ae{2}.activation_function       = 'PreLu';
%             sae.ae{2}.learningRate              = saeLearningRate;
% %             sae.ae{2}.dropoutFraction = 0.7;         %dropout�������50%��������
            
            opts.numepochs =  iterNum;
            opts.batchsize = batchSizeNum;
            [sae] = saeRawTrainProgram(sae, train_x_six, opts);
            
            % encoder��w��ת��+decoder��b��
            wae1 = [sae.ae{2}.W{2}(:,1)';sae.ae{2}.W{1}(:,2:end)]; 
            wae2 = [sae.ae{1}.W{2}(:,1)';sae.ae{1}.W{1}(:,2:end)]; 
        

            % Use the SDAE to initialize a FFNN  fine_tuning����
            nn = nnsetup([4 tm i tm 4]);
            nn.activation_function              = 'PreLu';
            nn.learningRate                     = NNLearnRate;

            nn.W{1} = sae.ae{1}.W{1};                        %  encoder�����w1��Ȩֵ��discoder��w1+w2��ƫִ
            nn.W{2} = sae.ae{2}.W{1}; 
            nn.W{3} = wae1';
            nn.W{4} = wae2';
                  
            nn.output              = 'sigm';                  %  use softmax output

            %%%%%%%%%%% Train the FFNN
            opts.numepochs =   iterNum;
            opts.batchsize =  batchSizeNum;
            [nn,lfull] = nntrain(nn, train_x_six, train_x_six, opts);
            layLfull(j) = lfull(end);                                      %����������ֵ
            NNoutdata = nnfse(nn, train_x_six,batNum);                      %���ÿ�������
            
%             %%%5-40-20-10-5%  ����ʮ����ʱ�������������ֵ
%             if(i == 20)
%                 n = size(lfull,1);
%                 threelayEr = lfull(n,1);
%             end
            
            figure;plot(lfull);   %���������µ����
            saveas(gcf,strcat(filename , num2str(i),'����Ԫ��������������ֵ'),'fig');
            close(figure(gcf));     %�ر��������ɵ�ͼ
% %                         
   %%%%%%%%%%% �����ع���ԭʼ���ݲ��죬���ӻ��쳣���
            nnOutdata1 =  gather(NNoutdata); 
            rawoutEr =   elcomputer( train_x_six, nnOutdata1);   %�ع����
%             rawoutEr_log = log(rawoutEr);     %ȡ�����������ϵ                        
%             rawoutEr_log =  reshape(rawoutEr_log,247,279);          %250,283
%             figure;contourf(flipud(rawoutEr_log)); 
%             axis off;              %���᲻�ɼ���
%             title(strcat(num2str(i) ,'����Ԫ�쳣�ֲ�'));
%             saveas(gcf,strcat(filename, num2str(i),'���������쳣�ֲ�1ǧ'),'fig')  %���ֻ��һ��ͼ��handle��Ϊgcf           
%             close(figure(gcf));          
            
            %���Ͼ���
            mahal_d =   mahal( nnOutdata1, train_x_six);
%             mahal_d =   reshape(mahal_d,247,279); 
            mahal_d_log = log(mahal_d);     %ȡ�����������ϵ
% %             figure;contourf(flipud(mahal_d_log));
% %             axis off;              %���᲻�ɼ���
% %             title(strcat(num2str(i) ,'����Ԫ���Ͼ����쳣�ֲ�'));
% %             saveas(gcf,strcat(filename, num2str(i),'�����������Ͼ����쳣�ֲ�'),'fig')  %���ֻ��һ��ͼ��handle��Ϊgcf           
% %             close(figure(gcf));            
            save(strcat(filename,'prelu-',num2str(i),'����Ԫ.mat'));       
                        
%             %%%%%%%%%%   ��¼ÿ������Ԫ��������Ч���ı仯
%             disp(['������磬',num2str(i), '�����������������']); 
%             opts = statset('Display','final','MaxIter',1000);   %���ݴ��ˣ�100�β���������Ϊ1000��
%             nnoutdata2   =   gather(NNoutdata{2,1});
%             idx = kmeans(nnoutdata2, 5,'Options',opts);             
%             idx = reshape(idx,r,c);
%             idx = flipud(idx);
%             figure;contourf(idx); 
%             axis off;               %���᲻�ɼ���
% %           title(strcat('��',num2str(i), '�����Ч��'));
%             saveas(gcf,strcat(filename ,num2str(i),'�������ľ���Ч��'),'fig') 
%             close(figure(gcf));     %�ر��������ɵ�ͼ
            
            j = j+1 ;           %���ڼ�¼���ֵ��λ��
                       
    end
    
        figure;plot(layLfull);
%         
%        %�ҳ����Ļ���С��
%          max1 = max(layLfull);
%          mm   = max(max1);
%         [~,column] = find(layLfull==mm);
%         t(1,1) = tm;
%         t(1,2) =  startNeuralNum + (column-1) * AddNerualNum;
%        
        title(strcat('��',num2str(m),'�㣬ÿ����10����Ԫ�������ı仯���'));
        saveas(gcf,strcat(filename ,'5��-��Ԫ�����������ı仯���'),'fig') 
        close(figure(gcf));   
        disp('*****');

end
