% set up the code for communicating with Unity
% update ip address to send to before running
ip= "192.xxx.x.xx";
tcpipClient = tcpip('',55001,'NetworkRole','Client');
set(tcpipClient,'Timeout',	30);

A = rand(20, 3);
A = A';
l = size (A, 2); 

fclose(tcpipClient);

outBufferSize = 2048;
    
bytesPerLine = 3*8+4; 
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

    fprintf(tcpipClient, '%f,%f,%f\n', a);
end

fclose(tcpipClient);

toc(t)