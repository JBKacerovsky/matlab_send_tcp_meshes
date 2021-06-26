bytesPerLine = 3*8+4;  
test = 6:18; 
test = [54, 2.^test]; 

A = rand(2^15, 4);
A = A';
l = size (A, 2); 

%%
fclose(tcpipClient);

times4 = []; 

for i = 1:5
temp = []; 

for outBufferSize = test
    
chunkSize = floor(outBufferSize/bytesPerLine);

tcpipClient.OutputBufferSize = outBufferSize;
    
    t = tic; 
    
    fopen(tcpipClient);
    fprintf(tcpipClient, '%s\n', 'test matrix');
    for k = 1:ceil(l/chunkSize)

        if k*chunkSize <= l
            a = A(:, (k-1)*chunkSize+1:k*chunkSize); 
        else
            a = A(:, (k-1)*chunkSize+1:end);
        end
            
        fprintf(tcpipClient, '%f,%f,%f,%f\n', a);
    end
    
    fclose(tcpipClient);    
    
    temp(end+1) = toc(t);
end
times4(i, :) = temp; 
end
%
tt = mean(times4, 1); 
figure;
scatter(test, tt); 

%%

[~, idx] = min(tt);
fastest = test(idx)