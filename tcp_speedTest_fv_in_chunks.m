function tcpSendMesh(FV, ip, port)

% set up the code for communicating with Unity
tcpipClient = tcpip(ip,,'NetworkRole','Client');
set(tcpipClient,'Timeout',	30);

%
fclose(tcpipClient);

outBufferSize = 2000; 
    
bytesPerLine = 3*8+8;  
tcpipClient.OutputBufferSize = outBufferSize;
chunkSize = floor(outBufferSize/bytesPerLine); 
 
vert = FV.vertices';
l = size(vert, 2); 
    
fopen(tcpipClient);
fprintf(tcpipClient, '%s\n', 'vertices');

for k = 1:ceil(l/chunkSize)

    if k*chunkSize < l
        a = vert(:, (k-1)*chunkSize+1:k*chunkSize); 
    else
        a = vert(:, (k-1)*chunkSize+1:end);
    end

    fprintf(tcpipClient, '%f,%f,%f\n', a);
end

fclose(tcpipClient);
    

%

fac = FV.faces; 
fac = fac -1;
fac = fac';

l = size(fac, 2); 

bytesPerLine = 3*(floor(log10(max(fac(:))))+1)+3; 

chunkSize = floor(outBufferSize/bytesPerLine); 
    
fopen(tcpipClient);
fprintf(tcpipClient, '%s\n', 'faces');

for k = 1:ceil(l/chunkSize)

    if k*chunkSize < l
        a = fac(:, (k-1)*chunkSize+1:k*chunkSize); 
    else
        a = fac(:, (k-1)*chunkSize+1:end);
    end

    fprintf(tcpipClient, '%d,%d,%d\n', a);
end

fclose(tcpipClient);

%
fopen(tcpipClient);     
fprintf(tcpipClient, '%s\n', 'drawMesh');   
fclose(tcpipClient);
    