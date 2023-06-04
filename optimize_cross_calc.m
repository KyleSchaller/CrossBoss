% Cleaned up version of Kyle's Optimized Cross Calc Code
%
% by Silv

clear; clc; close all;

% Set up optimization options
warning('off', 'all')
%hybridopts = optimoptions('patternsearch','OptimalityTolerance',1e-10);
X_loc = [0,0,0,0,0,0,0,0,0,0,0];
Y_loc = [0,1,2,3,4,5,6,7,8,9,10];
options = optimoptions('particleswarm', 'Display', 'iter', 'SwarmSize', 10,'UseParallel',true,'ObjectiveLimit',-190);
optim_func = @(x)cross_calc2(x,X_loc,Y_loc);
num_vars = 10;
lower_bound = zeros(10, 1);
upper_bound = 10 * ones(10, 1);

% Run PSO
final_score = particleswarm(optim_func, num_vars, lower_bound, upper_bound, options);

X_points = final_score(1:5);
Y_points = final_score(6:10);

figure
scatter(X_points,Y_points,'SizeData',100,'MarkerEdgeColor','k','MarkerFaceColor','k')
xlim([0,10])
ylim([0,10])