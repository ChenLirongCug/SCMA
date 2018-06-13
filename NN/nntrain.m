function [nn,  Lfull]  = nntrain(nn, train_x, train_y, opts, val_x, val_y)
%NNTRAIN trains a neural net 
%  Lfull��¼ÿ�ε��������ֵ  
%��������train x train y ��̫�󣬳������з�ѵ��
%  ѵ����ʱ����batch��1000��Ϊ����ѵ����������������
% [nn, L] = nnff(nn, x, y, opts) trains the neural network nn with input x and
% output y for opts.numepochs epochs, with minibatches of size
% opts.batchsize. Returns a neural network nn with updated activations,
% errors, weights and biases, (nn.a, nn.e, nn.W, nn.b) and L, the sum
% squared error for each training minibatch.

assert(isfloat(train_x), 'train_x must be a float');
assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')

loss.train.e               = [];
loss.train.e_frac          = [];
loss.val.e                 = [];
loss.val.e_frac            = [];
opts.validation = 0;
if nargin == 6
    opts.validation = 1;
end

fhandle = [];
if isfield(opts,'plot') && opts.plot == 1
    fhandle = figure();
end

m = size(train_x, 1);

batchsize  =  opts.batchsize;
numepochs  =  opts.numepochs;

numbatches =  fix( m / batchsize) ; %ȡ����
numyushu   =  mod(m, batchsize);  %����

% assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

L = zeros(numepochs*(numbatches+1),1); 

Lfull = zeros(numepochs,1);
n = 1;                                 % nΪbatch�ĸ��� ��ʼֵ

for i = 1 : numepochs
    tic;
        kk = randperm(m);             %���������

%     kk1 = kk(1:(m-numyushu));
%     kk2 = kk((m-numyushu):m);
    
    for l = 1 : numbatches
        batch_x = train_x(kk((l - 1) * batchsize + 1 : l * batchsize), :);   %
        
        %Add noise to input (for use in denoising autoencoder)
        if(nn.inputZeroMaskedFraction ~= 0)
            batch_x = batch_x.*(rand(size(Gbatch_x))>nn.inputZeroMaskedFraction);
        end
        
        batch_y = train_y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        
        nn = nnff(nn, batch_x, batch_y);  % ǰ�������磬���������������ֻΪ��ȡ������Լ����ֵ
        nn = nnbp(nn);                    % ���������磬Ϊ�˸���Ȩֵ������dW
        nn = nnapplygrads(nn);            % ����dW,���ȨֵW�ı仯���͸��½��
        
                
        L = gather(nn.L); 
        L(n) = L;    %ÿһ��batch�����ƽ��ֵ����n=����/batchsize,��
        
        n = n + 1;
    end
     
    
%     if(numyushu ~= 0)    %%    �������������0
%         
%         for q = 1 : 1 :  numyushu
%              
%         end    
%     end
    
    t = toc;
    %%  full-batch ѵ��
    if opts.validation == 1
        loss = nneval(nn, loss, train_x, train_y, val_x, val_y);  %nneval�������������
        str_perf = sprintf('; Full-batch train mse = %f, val mse = %f', loss.train.e(end), loss.val.e(end));
    else
        loss = nneval(nn, loss, train_x, train_y);        
        Lfull(i) = loss.train.e(end);                             % ÿһ��epoch������������ƽ�����       
        str_perf = sprintf('; Full-batch train err = %f',  Lfull(i));   %full batch �� ��������������ƽ�����ֵ
    end
    if ishandle(fhandle)
        nnupdatefigures(nn, fhandle, loss, opts, i);
    end
        
%     disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mini-batch mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1)))) str_perf]);
      disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mini-batch mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1))))]);
    
     %���ڶ�̬����ѧϰ��
      nn.learningRate = nn.learningRate * nn.scaling_learningRate;
    

end
end

