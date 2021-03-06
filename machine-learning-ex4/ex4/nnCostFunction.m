function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
X = [ones(m, 1) X];

m1 = hidden_layer_size;
n1 = input_layer_size + 1;

m2 = num_labels;
n2 = hidden_layer_size + 1;

K=num_labels;

% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
sm = 0;

for i=1:m
	c=y(i);
	y_i_Vec = zeros(K,1);
	y_i_Vec(c) = 1;
	
	x = X(i,:)';
	a2 = [1;sigmoid(Theta1*x)]; % Add ones to the a2 data matrix	
	a3 = sigmoid(Theta2*a2);
	h_Xi = a3;

	%sm = sm + sum( y_i_Vec.*( -log(h_Xi) ) + (ones(K,1)-y_i_Vec).*( -log(1-h_Xi)) );	
	for k=1:K
		sm = sm + ( y_i_Vec(k)*( -log(h_Xi(k)) ) + (1-y_i_Vec(k))*( -log(1-h_Xi(k))) );
	endfor
endfor

J = (1/m)*sm;

if lambda~=0
	J= J + (1/(2*m)) * lambda * (sum(sum(Theta1(:,2:n1).^2))+sum(sum(Theta2(:,2:n2).^2)));			
endif


% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

deltaMatrix2 = zeros(m2,n2);
deltaMatrix1 = zeros(m1,n1);

for i=1:m
	c=y(i);
	y_i_Vec = zeros(K,1);
	y_i_Vec(c) = 1;
	
	%forward propogation
	x_i = X(i,:)';
	a1=x_i;
	
	a2 = sigmoid(Theta1*a1); % Add ones to the a2 data matrix	- size [m1+1,1]
	a2 = [1;a2];
	
	a3 = sigmoid(Theta2*a2);
	
	%backpropogation
	delta3 = a3-y_i_Vec;
	ones_vec = ones(m1+1,1);
	delta2 = (Theta2')*delta3.*a2.*(ones_vec-a2);
	delta2=delta2(2:m1+1);
	
	deltaMatrix2 = deltaMatrix2+delta3*(a2');
	deltaMatrix1 = deltaMatrix1+delta2*(a1');

endfor

%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

D1=(1/m)*deltaMatrix1;
D1(:,2:n1) = D1(:,2:n1)+(lambda/m)*Theta1(:,2:n1);

D2=(1/m)*deltaMatrix2;
D2(:,2:n2) = D2(:,2:n2)+(lambda/m)*Theta2(:,2:n2);


Theta1_grad=D1;
Theta2_grad=D2;






% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
