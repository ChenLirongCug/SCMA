function finalOut = nnfse(nn, x , batNum)   %%% ����ǰ���������
%
%  x ̫���ʱ��Ҫ���з�
%  ������ �����м������ a{i}
%  
%

    j           =  1;                              %��Ϊ������
    dataNum     =  batNum;                           %��70000��Ϊ���Σ�����ǰ�����
    n           =  nn.n;                           %�������    
    surplusNum  =  mod( size(x, 1),  dataNum);     %����
    inputNum    =  fix( size(x, 1)/dataNum);       %��
    nn.testing  =  1;                                %����testing
      
% %  �����������x����,�ҳ���dataNum���������������з֡�����������0���룬�γ�����ΪdataNum�ľ�����������
%     if ( size(x,1)  >=  dataNum  )
%         
%         m           =  size(x, 1);
%         inputNum    =  fix( size(x, 1)/dataNum);
%                 
%         for  i = 1 : 1 :  inputNum 
%             eval(['sub_x_' num2str(i) '=' 'x(' num2str((i-1) * dataNum +1) ':'  num2str((i) * dataNum) ',:);' ]) ; % ��ñ仯�ı�����
% %             eval(['' num2str(i) '=' 'y(' num2str((i-1) * dataNum +1) ':'  num2str((i) * dataNum) ',:);' ]) ; % ��ñ仯�ı�����
%             j = j + 1;
%         end
%         
%         if ( surplusNum ~= 0 )
%             eval(['sub_x_' num2str(j) '=' 'x(' num2str( m - surplusNum + 1) ':'  num2str(m) ',:);' ]) ;
%             eval(['temp = '  'zeros( '  num2str( dataNum - surplusNum )  ', '  'size(x,2));']) ;                   % �����油����0 
%             eval(['sub_x_', num2str(j) ,'= [ sub_x_' , num2str(j) , '; temp ];' ]) ;
%             %��y�������־���
%             eval(['y = [ x ; temp ];']) ;
%         else
%             j = j -1;
%         end
% 
%     else
%          sub_x_1 = x ;
%     end
 
    
% zΪx ���зְ���� ����
for z = 1 : 1 : inputNum + 1
    
%   eval([ 'm = size(sub_x_',  num2str(z), ', 1);']);     %���ٸ�����,70750
    
    if(z ~= inputNum +1)
        eval(['sub_x_', num2str(z), ' = x((z - 1) * dataNum + 1 : z * dataNum, :);']);   %
    else
        eval(['sub_x_', num2str(z), ' = x((inputNum) * dataNum + 1 : size(x, 1), :);']); 
        eval(['temp = '  'zeros( '  num2str( dataNum - surplusNum )  ', '  'size(x,2));']) ;                   % �����油����0 
        eval(['sub_x_', num2str(z) ,'= [ sub_x_' , num2str(z) , '; temp ];' ]) ;
    end
       
    eval(['sub_x_', num2str(z), ' = [ones(dataNum,1)',  '  sub_x_', num2str(z), '];' ]);
    eval(['nn.a{1} = sub_x_', num2str(z),';']);

    %remove bias term
    nn = nnff(nn, nn.a{1}(:,2:end), nn.a{1}(:,2:end));
    
    
    %   �ϲ�������
    if   ~eval(['exist(''sub_a_',  num2str(n),''', ''var'')'])
        eval([ 'sub_a_',  num2str(n), ' = nn.a{n}; ']);
    else
        eval([ 'sub_a_',  num2str(n), ' = [sub_a_', num2str(n),'; nn.a{n}] ;']);
    end;
end

    eval([ 'finalOut = [sub_a_', num2str(n),'(1:size(x,1),:)];']);
    
    nn.testing = 0;              %�˳�testing
    
%     sub_a_n = sub_a_n(size(x),:);
%  
% %   ��ÿһ���a�������һ��
% for p = 2 : 1 : nn.n
%      eval([ 'nn.a{',  num2str(p), '} = [sub_a_', num2str(p), '];']);    
% end


 end