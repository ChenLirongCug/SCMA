function [loss] = nneval_sub(nn, loss, train_x, train_y, val_x, val_y)
%NNEVAL evaluates performance of neural network
% Returns a updated loss struct
assert(nargin == 4 || nargin == 6, 'Wrong number of arguments');

% ����������ݹ��󣬽������з֡�dataNumΪ�зֵĴ�С
    j = 1;
    dataNum = 70000; 
    
if (size(train_x,1)>dataNum)
    
    m = size(train_x, 1);
    inputNum =  size(train_x, 1)/dataNum;
    surplusNum = mod( size(train_x, 1),dataNum);
    
    for i = 1 : 1 :  inputNum
        eval(['map_x_' num2str(i) '=' 'train_x(' num2str((i-1) * dataNum +1) ':'  num2str((i) * dataNum) ',:)' ]) ; % ��ñ仯�ı�����
        eval(['map_y_' num2str(i) '=' 'train_y(' num2str((i-1) * dataNum +1) ':'  num2str((i) * dataNum) ',:)' ]) ; % ��ñ仯�ı�����
        j = j + 1;
    end
        eval(['map_x_' num2str(j) '=' 'train_x(' num2str( m-surplusNum + 1) ':'  num2str(m) ',:)' ]) ; 
        eval(['map_y_' num2str(j) '=' 'train_y(' num2str( m-surplusNum + 1) ':'  num2str(m) ',:)' ]) ; 
        
end

er_trainall = 0; % ��������ʼֵ
er_trainall_softmax = 0;

for z = 1 : 1 : j
   
    eval(['train_x_sub =' 'map_x_' num2str(z) ]) ; 
    eval(['train_x_sub =' 'map_y_' num2str(z) ]) ; 
    
    nn.testing = 1;
    % training performance
    nn                    = nnff(nn, train_x_sub, train_y_sub);
    er_trainall           = er_trainall +  gather(nn.L);                     %     nnl = gather(nn.L);
                                                                             %     loss.train.e(end + 1) = nnl;  
    
    % validation performance   �ò���nargin��ʱ�򣬲���Ҫ������δ������µ� nnl
    if nargin == 6
        nn                    = nnff(nn, val_x, val_y);
        nnl                   = gather(nn.L);
        loss.val.e(end + 1)   = nnl;
    end

   
    
    nn.testing = 0;
    %calc misclassification rate if softmax   er_train�ǲ�������ֵռ�����Ķ��ٱ�����bad��λ��
    if strcmp(nn.output,'softmax')
        [er_train, dummy]                = nntest(nn,  train_x_sub, train_y_sub);
        er_trainall_softmax              = er_trainall_softmax + er_train * size( train_x_sub,1)       
%         loss.train.e_frac(end+1)         = er_trainall_softmax;
        
        if nargin == 6
            [er_val, dummy]             = nntest(nn, val_x, val_y);
            loss.val.e_frac(end+1)  = er_val;
        end
    end

end

   loss.train.e(end + 1) = er_trainall/j;                                %     loss.train.e(end + 1) = nnl; 
   if strcmp(nn.output,'softmax')
       loss.train.e_frac(end+1)    =  er_trainall_softmax /size( train_x,1);
   end
   
end
