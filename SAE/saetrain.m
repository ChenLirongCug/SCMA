function [sae, Llay] = saetrain(sae, x, opts)
   

    n = numel(sae.ae);        %sae�ĸ���
    for i = 1 : numel(sae.ae);
        disp(['Training AE ' num2str(i) '/' num2str(numel(sae.ae))]);
        [sae.ae{i}, l] = nntrain(sae.ae{i}, x, x, opts);
% (1)        Llay{i,1} = l;        %  ��ÿ��batch�������,һ��7075��batch
        t = nnff(sae.ae{i}, x, x);
% (1)       Llayer(i,11) = t.L;    %  ���ڼ�¼ÿ����һ�㣬ƽ�����ı仯���
                      
        %��ÿ�����������ֵ��Ϊ��һ�������ֵ
        x = t.a{2};
        
        %remove bias term
        x = x(:,2:end);                
        %         subplot(2,2,i);
% (1)       figure;  plot(l);              %   ���ӻ�7075��batch�����ֵ�仯
% (1)         title(strcat('��',num2str(i), '��7075��batch�����仯'));
%  (1)        saveas(gcf,strcat('E://DataResulterGraph/5-40-20-10-5-10-20-40-5+200iter/��',num2str(i), '��7075��batch�����仯'),'fig') ;    
    end
% (1)        Llay{1,2} = Llayer;
% (1)        figure;plot(Llayer);
% (1)        title(strcat('ÿ����һ�㣬ƽ�����ı仯���'));
% (1)        saveas(gcf,strcat('E://DataResulterGraph/5-40-20-10-5-10-20-40-5+200iter/ÿ����һ�㣬ƽ�����ı仯���'),'fig') ;
end
