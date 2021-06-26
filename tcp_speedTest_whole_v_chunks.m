% set up the code for communicating with Unity
% update ip address to send to before running
ip= '192.xxx.x.xx';
tcpipClient = tcpip('',55001,'NetworkRole','Client');
set(tcpipClient,'Timeout',	30);


%%
fclose(tcpipClient);
test = 4:15; 
test = 2.^test; 

times = []; 

for i = test
    A = rand(i, 4);
    A = A';
    tcpipClient.OutputBufferSize = whos('A').bytes*size(A, 1)*6;


    t = tic; 
    fopen(tcpipClient); 
    fprintf(tcpipClient, '%s\n', 'test matrix');
    fprintf(tcpipClient, '%f,%f,%f,%f\n', A);
    fclose(tcpipClient);
    
    times(end+1) = toc(t); 

end


%%
chunkSize = 14; 

tcpipClient.OutputBufferSize = 1024;

times2 = [];    
 
for i = test
    
    A = rand(i, 4);
    A = A';
    l = size (A, 2); 
        
    t = tic; 
    
    fopen(tcpipClient);
    fprintf(tcpipClient, '%s\n', 'test matrix');
    
    for k = 1:ceil(i/chunkSize)
        
        if k*chunkSize < l
            a = A(:, (k-1)*chunkSize+1:k*chunkSize); 
        else
            a = A(:, (k-1)*chunkSize+1:end);
        end
            
        fprintf(tcpipClient, '%f,%f,%f,%f\n', a);
    end
    
    fclose(tcpipClient);
    
    times2(end+1) = toc(t);
end

%%  


times3 = []; 
 
for i = test
        
    A = rand(i, 4);
    A = A';
    l = size (A, 2); 
    
    t = tic; 
    
    for k = 1:ceil(i/chunkSize)
        
        if k*chunkSize < l
            a = A(:, (k-1)*chunkSize+1:k*chunkSize); 
        else
            a = A(:, (k-1)*chunkSize+1:end);
        end
        
        fopen(tcpipClient);
        fprintf(tcpipClient, '%s\n', 'test matrix');
        fprintf(tcpipClient, '%f,%f,%f,%f\n', a);
        fclose(tcpipClient);
    end
    
    times3(end+1) = toc(t);
end

%%
figure
hold on
scatter(test, times, 70, 'filled', 'b'); 
scatter(test, times2, 70, 'filled', 'r'); 
scatter(test, times3, 70, 'filled', 'g');  