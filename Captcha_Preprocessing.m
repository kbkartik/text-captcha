% Author: Kartik Bharadwaj

I = imread('download9.png');
J = rgb2gray(I); % RGB to Gray conversion

%Image preprocessing

K = bwareaopen(J,100,8); % Elimination of small pixel coagulation using
                        % connected components
K1 = ~K;
K1 = im2uint8(K1);
K1 = K1 > 135;
K1 = imclearborder(K1); %Eliminates pixels which are attached to image boundary
K2 = bwmorph(K1,'spur',8);
K3 = bwmorph(K2,'clean');
K4 = bwmorph(K3,'bridge',Inf);

%Applying filters

h1 = fspecial('gaussian', 2, 1);
h2 = fspecial('average', 2);
g = imfilter(K4,h1, 'replicate');
g1 = imfilter(g,h2, 'replicate');

%Marking characters in Captcha
[B, L, N, A] = bwboundaries(g1, 'holes');
s = regionprops(L,'all');
imshow(~g1)
hold on
for k = 1:length(B)
    boundary = B{k};
    if k <= N
        plot(boundary(:,2), boundary(:,1))
    end
end