function nn = nnff(nn, x, y)
%  NNFF  ������GPU ����
%  performs a feedforward pass ǰ������
%  nn = nnff(nn, x, y) returns an neural network structure with updated
%  layer activations, error and loss (nn.a, nn.e and nn.L)

    
  m = size(x, 1);       %���ٸ�����,70750
  x = [ones(m,1) x];    %������������1
  nn.a{1} = gpuArray( x);
  n = nn.n;
  
  %feedforward pass
  for i = 2 : n-1
      GnnW = gpuArray( nn.W{i - 1}' );
      %       GnnOut = gpuArray( nn.a{i - 1} );
      
      switch nn.activation_function
          case 'sigm'
              % Calculate the unit's outputs (including the bias term)
              nn.a{i} = sigm( nn.a{i - 1} * GnnW );
              
              %               nn.a{i} = gather(GnnOutNext);
              
          case 'tanh_opt'
              nn.a{i} = tanh_opt(nn.a{i - 1} * GnnW);
              %               nn.a{i} = gather(GnnOutNext);
          case 'PreLu'
              if (gather(nn.a{i - 1})<0)
                   nn.a{i}  =  nn.alfa{i} * (nn.a{i-1} * GnnW);
              else
                   nn.a{i}  =  nn.a{i-1} * GnnW;
              end;
      end
      
      %dropout
      if(nn.dropoutFraction > 0)
          if(nn.testing)
              dF = nn.dropoutFraction ;
              nn.a{i} = nn.a{i}.*(1 - dF);
          else
              dF =  nn.dropoutFraction ;
              nn.dropOutMask{i} = (rand(size(nn.a{i}))> dF);
              nn.a{i} = nn.a{i}.*nn.dropOutMask{i};
          end
      end
      
      %calculate running exponential activations for use with sparsity
      if(nn.nonSparsityPenalty>0)
          p = gpuArray( nn.p{i} );
          nn.p{i} = 0.99 * p + 0.01 * mean(nn.a{i}, 1);
      end
      
      %Add the bias term
      nn.a{i} = [ones(m,1) nn.a{i}];
      
      %  �� a{i}�ϲ�
      if  ~eval([ 'exist(''sub_a_',  num2str(i),''', ''var'')'])
          eval([ 'sub_a_',  num2str(i), ' = nn.a{i}; ']);
      else
          eval([ 'sub_a_',  num2str(i), ' = [sub_a_', num2str(i), '; nn.a{i}]; ']);
      end;
  end
        
 
  GnnWn = gpuArray( nn.W{n - 1}' );
  switch nn.output
      case 'sigm'
          nn.a{n} = sigm(nn.a{n - 1} * GnnWn);
      case 'linear'
          nn.a{n} = nn.a{n - 1} * GnnWn;
      case 'softmax'
          nn.a{n} = nn.a{n - 1} * GnnWn;
          nn.a{n} = exp(bsxfun(@minus, nn.a{n}, max(nn.a{n},[],2)));
          nn.a{n} = bsxfun(@rdivide, nn.a{n}, sum(nn.a{n}, 2));
  end
 
    
%error and loss�� lossΪ��������ƽ��loss
    nn.e = y( 1 : size(y, 1) ,:) - nn.a{n}(1 : size(y, 1) ,:) ;
      
    switch nn.output
        case {'sigm', 'linear'}
            nn.L = 1/2 * sum(sum(nn.e .^ 2)) / m;   %������ƽ�����
        case 'softmax'
            nn.L = -sum(sum(y .* log(nn.a{n}))) / m;
    end
end
