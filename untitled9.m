FV = starship(0); 
%%
load graph_values_s1.mat q1
FV = switchFaceOrientation(q1);
%


FV.vertices = rotateVertices(FV.vertices, 0, 180, 0); 
FV.vertices(:, 1) = FV.vertices(:, 1) - mean(FV.vertices(:, 1)); 
FV.vertices(:, 3) = FV.vertices(:, 3) - mean(FV.vertices(:, 3)); 
FV.vertices = FV.vertices * 0.0008;  % use 0.8 for starship 0.003 for s1
FV.vertices(:, 2) = FV.vertices(:, 2) + 0.1; 
% FV.vertices(:, 3) = FV.vertices(:, 3) + 0.5 ; 
% 
% figure; 
% axis equal
% patch(FV, 'facecolor', 'b', 'edgecolor', 'none'); 

%%
% ip= '192.xxx.x.xx';   
% FV.vertices(:, 1) = FV.vertices(:, 1) + 0.3; 

tcpSendMesh(FV, ipPhone); 
%%
tcpSendMesh(FV2, ipPhone); 
    
