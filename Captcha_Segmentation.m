% Author: Kartik Bharadwaj

origImg = imread('Final_test_processed.png');
[rows, columns, ColorChannels] = size(origImg);

%User prompt for changing color image to grayscale

if ColorChannels > 1
	Message = sprintf('Your image file has %d color channels.\nDo you want to convert it to grayscale?', ColorChannels);
	button = questdlg(Message, 'Convert and Continue', 'Cancel');
	if strcmp(button, 'Cancel')
		fprintf(1, 'Exited Captcha_Segmentation.m.\n');
		return;
	end
	origImg = rgb2gray(origImg);
end

%Thresholding
thresholdVal = 100;
bnyImg = origImg < thresholdVal;

%Getting connected component labels of the image
labelImg = bwlabel(bnyImg, 8);

%Getting region properties of the labels
blobMeasurementsval = regionprops(labelImg, origImg, 'all');
totalBlobs = size(blobMeasurementsval, 1);

imshow(origImg);
axis image;
hold on;
boundaries = bwboundaries(bnyImg);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;

Blobareas = [blobMeasurementsval.Area];
selectedareaindex = (Blobareas > 6000) & (Blobareas < 12000);

finalIndex = find(selectedareaindex);
finalBlobsImg = ismember(labelImg, finalIndex);
CharacterImg = bwlabel(finalBlobsImg, 8);

%Image Cropping and Segmentation
message = sprintf('Would you like to crop out each character to individual images?');
reply = questdlg(message, 'Extract Individual Images?', 'Yes', 'No');
if strcmpi(reply, 'Yes')
	figure;		
    % Maximize window.
	set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]);
	for k = 1 : length(finalIndex)           % Loop through all blobs.
		% Find the bounding box of each blob.
		finalblobsBoundingBox = blobMeasurementsval(finalIndex(k)).BoundingBox;
		singlecharacter = imcrop(origImg, finalblobsBoundingBox);
		%imwrite(singlechar,'truth.png');
		subplot(3, 4, k);
		imshow(singlecharacter);
    end
end