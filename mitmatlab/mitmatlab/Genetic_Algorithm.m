function D = Genetic_Algorithm(train_features, train_targets, params, region);

% Classify using a basic genetic algorithm
% Inputs:
% 	features	- Train features
%	targets	- Train targets
%	Params  - [Type, TargetErr, Nchrome, Pco, Pmut], where:
%               Type:       Type of weak learner (Can be any that doesn't use a parameter: LS, ML, MLdiag, Pocket, Perceptron
%               TargetErr:  Target error on the train set for the GA
%               Nchrome:    Number of chromosomes to use
%               Pco:        Probability of recombination
%               Pmut:       Probability of mutation
%	region	- Decision region vector: [-x x -y y number_of_points]
%
% Outputs
%	D			- Decision sufrace

[type, TargetErr, Nchrome, Pco, Pmut] = process_params(params);
[D,L]     = size(train_features);
iter      = 0;

%Build the chromosomes
%The mapping in this realization is wheather or not to use a given example for building the classifier
chromosomes = rand(Nchrome, L)>0.5;
ranking     = ones(1,Nchrome);

while 1,    
    %Determine the fit of each chromosome
    for i = 1:Nchrome,
        if (ranking(i) == 1),
            %Build a classifier and test it
            index   = find(chromosomes(i,:) == 1);
            D       = feval(type, train_features(:,index), train_targets(index), [], region);
            scores  = calculate_error (D, train_features, train_targets, [], [], region, length(unique(train_targets)));
            ranking(i) = scores(3);
        end
    end
    
    if ((min(ranking) < TargetErr)),
        break
    end

    iter = iter + 1;
    if (iter/10 == floor(iter/10)),
        disp(['Iteration number ' num2stR(iter) ': Best classifier so far has an error of ' num2str(min(ranking)*100) '%'])
    end

    %Rank the chromosomes
    [m, rating] = sort(ranking);
    
    for i = 1:floor(Nchrome/2),
        %Select the two chromosomes with the highest score
        c1  = rating(i*2-1);
        c2  = rating(i*2);
        
        %If rand[0,1]<Pco then 
        if (rand(1) < Pco),
            %Crossover each pair at a random bit
            crossover = randperm(L-2);  %This is to avoid edges
            temp1     = chromosomes(c1,:);
            temp2     = chromosomes(c2,:);
            chromosomes(c1,1:crossover(1)+1)    = temp2(1:crossover(1)+1);
            chromosomes(c2,crossover(1)+2:end)  = temp1(crossover(1)+2:end);
            ranking(c1) = 1;
            ranking(c2) = 1;
        else
            %Change each bit with probability Pmut
            chromosomes(c1,:) = xor(chromosomes(c1,:),(rand(1,L)>(1-Pmut)));
            chromosomes(c2,:) = xor(chromosomes(c2,:),(rand(1,L)>(1-Pmut)));
            ranking(c1) = 1;
            ranking(c2) = 1;
        end
    end
    
end

best     = find(ranking == min(ranking));
best     = best(1);
index    = find(chromosomes(best,:) == 1);
D        = feval(type, train_features(:,index), train_targets(index), [], region);

