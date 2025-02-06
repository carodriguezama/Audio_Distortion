% Example - Fall 2024
close all ; clear all ; clc ;


FlagLoadMatFile = 1 ;

if FlagLoadMatFile == 0
    %% load file
    disp('load mp4 file')
    obj = VideoReader("./LaneDetection_Video_Example.mp4");
    objMatrix = read(obj);

    %% save images
    save('LaneDetection_Video_Example.mat','objMatrix');

elseif FlagLoadMatFile == 1

    disp('load mat file')
    load('LaneDetection_Video_Example.mat')

end

%% convert image from rgb to gray
disp('convert image from rgb to gray')

nFrames = size(objMatrix,4);
nx = size(objMatrix,1);
ny = size(objMatrix,2);

objGray = zeros(nx,ny,nFrames);
objGray = logical(objGray);

for i=1:nFrames
    img_aux = objMatrix(:,:,:,i) ;
    img_aux = rgb2gray(img_aux) ;
    img_aux =  edge(img_aux, 'canny', 0.3*graythresh(img_aux));
    objGray(:,:,i) = (img_aux);
end

%% process the images
disp('process the images')

disp(' edge detector')

figure()
imshow( objGray(:,:,300) )


disp(' mean of the frames')
figure()
nFrames_AVG = 100 ;
for i=1:(nFrames-nFrames_AVG)

    img_aux = mean( double(objGray(:,:,i:nFrames_AVG+i-1)) , 3 ) ;
    objGray_avg(:,:,i) = logical( img_aux>0.05 & img_aux<0.2 );

    if(1==1)
        imshow(objGray_avg(:,:,i))
        str_aux = fprintf('frame=%d\n',i);
        pause(0.01)
    end

end


%% mask on the image
disp(' mask')

mask = zeros(nx,ny);
mask( 250:400 , 200:700 ) = 1;
figure()
imshow(mask)

for i=200:nFrames

    img_aux = objGray_avg(:,:,i) ;

    objGray_avg(:,:,i) = img_aux.*mask ;

    if(1==1)
        imshow(objGray_avg(:,:,i))
        str_aux = fprintf('frame=%d\n',i);
        pause(0.01)
    end

end






