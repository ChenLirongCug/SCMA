function [ rawoutEr ] = computerRawAndRestroeL( x, y )
%COMPUTERRAWANDRESTROEL ����ԭʼ�������ع����ݵ�֮��
%   ��ԭʼ�����е�����ƽ���ͣ���������������Ҫ����Ϊ����������Ϊ����������
%   ���ع������е�����ƽ���ͣ���������
%   �����߽�����ֵ

    outdot = dot(x',x');                    %������ĵ�� 
    outdot = sqrt(outdot');                             %ÿ����������,�õ�������*1�ľ���
    rawdatadot = dot(y',y');        %����ԭʼ���ݵ��ڻ�
    rawdatadot = sqrt(rawdatadot');  
    rawoutEr =  imsubtract(outdot,rawdatadot);          %��ԭʼ�������������֮��

end

