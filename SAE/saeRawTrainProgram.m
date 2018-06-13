function [ sae ] = saeRawTrainProgram( sae, x, opts )
%SAERAWPROGRAM ԭʼsaeѵ������ȥ���� ���ӻ�7075��batch�����ֵ�仯 �Լ� ÿ����һ�㣬ƽ�����ı仯���

    n = numel(sae.ae);        %sae�ĸ���
    inputSize = size(x,1);
    for i = 1 : numel(sae.ae);
        disp(['Training AE ' num2str(i) '/' num2str(numel(sae.ae))]);
        [sae.ae{i}, l] = nntrain(sae.ae{i}, x, x, opts);
        %         Llay{i,1} = l;        %  ��ÿ��batch�������,һ��7075��batch
        
        t = nnff(sae.ae{i}, x, x);
        %         Llayer(i,1) = t.L;    %  ���ڼ�¼ÿ����һ�㣬ƽ�����ı仯���
        x = t.a{2};
        %remove bias term
        x = x(:,2:end);
     
    end

end

