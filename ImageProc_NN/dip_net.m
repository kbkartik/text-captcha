% Initialization
clear ; close all; clc

% Parameters setup
input_layer_size  = 784;  % 28x28 Input Images of Digits
hidden_layer_size1 = 150; % 150 hidden units
hidden_layer_size2 = 150; % 150 hidden units
num_labels = 26;          % 26 labels, from 1 to 26

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

load('letterstrain.mat');
m = size(X, 1);
X = double(X);

% Randomly select 100 data points to display
sel = randperm(size(X, 1));
sel = sel(1:100);

displayData(X(sel, :));

fprintf('Program paused. Press enter to continue.\n');
pause;

fprintf('\nInitializing Neural Network Parameters ...\n')

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size1);
initial_Theta2 = randInitializeWeights(hidden_layer_size1, hidden_layer_size2);
initial_Theta3 = randInitializeWeights(hidden_layer_size2, num_labels);

initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:) ; initial_Theta3(:)];

fprintf('\nChecking Backpropagation... \n');

checkNNGradients;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

fprintf('\nChecking Backpropagation (w/ Regularization) ... \n')

%  Check gradients by running checkNNGradients
lambda = 3;
checkNNGradients(lambda);

debug_J  = nnCostFunction(initial_nn_params, input_layer_size, ...
                          hidden_layer_size1, hidden_layer_size2, num_labels, X, y, lambda);

fprintf(['\n\nCost at (fixed) debugging parameters (w/ lambda = %f): %f ' ...
         ], lambda, debug_J);

fprintf('Program paused. Press enter to continue.\n');
pause;

fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 800);

lambda = 1;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size1, ...
                                   hidden_layer_size2, ...
                                   num_labels, X, y, lambda);

[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

Theta1 = reshape(nn_params(1:hidden_layer_size1 * (input_layer_size + 1)), hidden_layer_size1, (input_layer_size + 1));
temp1 = 1+ (hidden_layer_size1 * (input_layer_size + 1));
temp2 = (hidden_layer_size1) * (hidden_layer_size2 + 1);
Theta2 = reshape(nn_params(temp1:(temp1 + temp2 - 1)),...
                hidden_layer_size1, (hidden_layer_size2 + 1));
Theta3 = reshape(nn_params((temp1 + temp2):end), num_labels, (hidden_layer_size2 + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;

load('letterstest.mat');
pred = predict(Theta1, Theta2, Theta3, double(Xtest));

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == ytest)) * 100);