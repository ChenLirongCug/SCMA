function [ output_args ] = fusion( input_args )
%FUSION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%%%. ����ֿ� ��������ֵ
 part = medfilter1Copy(40:60,1:30)
part( part<2)=3
medfilter1Copy(40:60,1:30)=part
figure;contourf(medfilter1Copy);
%% ����ʾ������ axis off
                set(gcf,'box','off');
%% ȥ���ױ�
                set (gcf,'Position',[0,0,500,500]);
                axis normal;
                saveas(gca,'meanshape.bmp','bmp');

%%%%��aeout���������к�
one_mahal_d_25max = [one_mahal_d_25max'; map_1(6,:)];  one_mahal_d_6min = [one_mahal_d_6min'; map_1(6,:)];...
one_rawoutEr_25max = [one_rawoutEr_25max'; map_1(6,:)];one_rawoutEr_6min = [one_rawoutEr_6min'; map_1(6,:)];...
third_mahal_d_32max = [third_mahal_d_32max'; map_3(6,:)]; third_mahal_d_8min= [third_mahal_d_8min'; map_3(6,:)];...
 third_rawoutEr_32max= [third_rawoutEr_32max'; map_3(6,:)]; third_rawoutEr_8min = [third_rawoutEr_8min'; map_3(6,:)];...
two_mahal_d_40max = [two_mahal_d_40max'; map_2(6,:)]; two_mahal_d_6min = [two_mahal_d_6min'; map_2(6,:)];...
 two_rawoutEr_40max= [two_rawoutEr_40max'; map_2(6,:)]; two_rawoutEr_6min= [two_rawoutEr_6min'; map_2(6,:)];

%%%%%%%%%%���ռ��Ϸֿ��ĵڶ��࣬��Ϊ�������������
row = ones(100)
row = row *4
row =  kmeans_filter(1:100,1:100)+row
kmeans_filter(1:100,1:100)=row

end

