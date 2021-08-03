function [sum_a] = connect_report(X,power_vector)

% X - matrix with the positions of each node
% power_vector - vector with the power that each node is transmitting
%
% power_vector = [ P1 P2 P3 ... PN ]
N = size(X,2);          % Number of nodes

% N = 20;
freq = 915;             % Frequency fixed at 915MHz

    %--------------------%
    %  cost calculation % 
    %--------------------%
    
cost = zeros(N);        % NxN position matrix

for l=1:N
    for c=1:N
        
        if l == c
            cost(l,c) = -Inf;
        else
            cost(l,c) = FRISS(1,1,freq, X(:,l), X(:,c));
        end
        
    end
end


% for i = 1:N
% % power_vector(i) = (randi(50,1,1)/10)-10.5;
% power_vector(i) = -20.371;
% %
% end
    %------------------------------------------------ %
    % Converting power_vector from dBm to Watt %
    %------------------------------------------------ %
for i = 1:N
    power_vector_watt (i) = 10.^((power_vector(i)./10)-3);
end


%------------------------------------------------ %
    % Counting the power received by each node %
    %------------------------------------------------ %
% This routine calculates the power received by each node (column) when the
% transmitter is node l (row)
PR = zeros(N);         % PR - received power matrix.

for l = 1: N
    for c = 1 : N
        PR(l,c) = power_vector(l) + cost(l,c);
    end
end
 
%-----------------------------------------%
    % Analyzing if there is a connection %
    %-----------------------------------------%
A = zeros(N);      % adjacency matrix
for l = 1:N
    for c = 1: N
        
        if PR(l,c) >= -60 
            A (l,c) = 1;
        else
            A (l,c) = 0;
        end
    end
end

for i=1:N
    D(i) = sum(A(i,:));
end
% The status2 matrix has the number of nodes on its main diagonal
% connected to the node indicated by status2(i,i). If status2(i,i) is equal to
% ZERO, so there are no neighbors for node i.

% If there is at least one disconnected node, that is, D(i,i) = 0, it is already
% enough to state that the graph is disconnected.
connect = 1;
for i = 1:N
    connect = D(i).*connect;
end

if connect == 0
    sum_a = Inf;

else

   % Determining the Laplacean matrix of A
   for i = 1:N
        for j = 1:N

            if i == j
                L(i,j) = D(i);
            else
                if  A(i,j) == 1
                    L(i,j) = -1;
                else

                L(i,j) = 0;
                end
            end
        end
    end

    eigenvector = eig(L);
    
    if eigenvector(2) > 0
        sum_a = 10.*log10((sum(power_vector_watt))/(1e-3));
    else
        sum_a = Inf;
    end
end

end 