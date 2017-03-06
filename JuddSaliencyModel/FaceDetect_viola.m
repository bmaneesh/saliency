function [bboxes] =  FaceDetect_viola(a);
detector = vision.CascadeObjectDetector;
bboxes=step(detector,a);
IFaces = insertObjectAnnotation(a, 'rectangle', bboxes, 'Face');
figure, imshow(IFaces), title('Detected faces');
end