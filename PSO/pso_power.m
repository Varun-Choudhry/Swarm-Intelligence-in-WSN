clear all;

for sce=1:4
    
scene = strcat('space',int2str(sce));
load(scene)
Archivename  = strcat(scene,'.t2');

fid = fopen(Archivename ,'wt');
fprintf(fid,'##################Training Start##################\n\n');
fprintf(fid,'scene = %s\n\n',scene);


for t=1:4
tic
fprintf(fid,'##########################################################################\n');
fprintf(fid,'                           TEST = %d                                    \n',t);
fprintf(fid,'##########################################################################\n');

n = 30;          % swarm size
num_steps = 300; % maximum number of steps
dim = size(X,2);   % dimensions of particles

wmax=0.9;  %initial inertia coefficient 
wmin=0.4;  %final inertia coefficient
c1=2;      %acceleration coefficient
c2=2;      %acceleration coefficient


%Set search space limit
pMin = -30;
pMax = 0;

%Set velocity limit
vMax = 5; 
vMin = -vMax;

fprintf(fid,'PSO Settings\n');
fprintf(fid,'Number of Particles = %f\n',n);
fprintf(fid,'Maximum number of steps = %f\n',num_steps);
fprintf(fid,'Problem Dimensions= %f\n',dim);
fprintf(fid,'Coeficient C1 = %f\n',c1);
fprintf(fid,'Coeficient C2 = %f\n',c2);
fprintf(fid,'Inertia (wmax) = %f / (wmin) = %f \n\n',wmax,wmin);
fprintf(fid,'pMax = %f / pMin = %f\n',pMax,pMin);
fprintf(fid,'vMax = %f / vMin = %f\n',vMax,vMin);

fitness=0*ones(n,num_steps);                           
current_fitness =0*ones(n,1);



%Initialization of particle positions
power_vector  = pMin + (pMax - pMin)*rand(dim,n);                   

%Inicialização of particle velocite 
velocity = rand(dim,n); 
%velocity = vMin + (vMax - vMin)*rand(dim,n);


%Calculate initial particle fitness                                 
for i=1:n
        current_fitness(i) = connect_report(X,power_vector (:,i)) ;    
end


%Initialize PBEST
pbest_fitness  = current_fitness ;
pbest_position  = power_vector  ;

%Initialize GBEST
[gbest_fitness,g] = min(pbest_fitness) ;
for i=1:n
    gbest_position(:,i) = pbest_position(:,g) ;
end

for iter=1:num_steps   

%Linearly decreases the inertia factor
w = wmax - ((wmax-wmin)/num_steps)*iter; 

%Calculate new particle velocity
for i=1:n
    velocity(:,i) = w*velocity(:,i) + c1*(rand*(pbest_position(:,i)-power_vector (:,i))) + c2*(rand*(gbest_position(:,i)-power_vector (:,i)));
end
%Limits Particle velocity

for k=1:n
    index = velocity(:,k)>vMax;
    velocity(index,k)=vMax;

    index = velocity(:,k)<vMin;
    velocity(index,k)=vMin;
end	

%Calculates new particle position
power_vector  = power_vector  + velocity;

%Limits the particle's search space
for k=1:n         
    index = power_vector (:,k)>pMax;
    power_vector (index,k)=pMax;

    index = power_vector (:,k)<pMin;
    power_vector (index,k)=pMin;
end



%the new particle fitness
for i=1:n,
        current_fitness(i) = connect_report(X,power_vector (:,i)) ;    
end

%Calculate pbest
for i=1:n
    if current_fitness(i) < pbest_fitness(i)
        pbest_fitness(i)  = current_fitness(i);  
        pbest_position(:,i) = power_vector (:,i);
    end
end

[current_gbest_fitness,g] = min(pbest_fitness);

%Calculate gbest
if current_gbest_fitness < gbest_fitness
    gbest_fitness = current_gbest_fitness;
    for i=1:n
        gbest_position(:,i) = pbest_position(:,g);       
    end

end 

 if(iter==1 || rem(iter,50)==0)  
   sprintf('Iteration  - %4d | sum = %f\n',iter,gbest_fitness)
   fprintf(fid,'Iteration  - %4d | sum = %f\n',iter,gbest_fitness);
 end
 
end %end of algorithm

 
gbest_fitness;
d=gbest_position(:,1);

fprintf(fid,'\n\n');
fprintf(fid,'Power of each node\n\n');
for i=1:dim    
 	fprintf(fid,'Node %i= %f ',i, d(i));	   
    fprintf(fid,'\n');
end
fprintf(fid,'\n\n');
 

timeSpent = toc;
fprintf(fid,'Time spent: %d\n\n',timeSpent);

end 
fclose(fid);

end
