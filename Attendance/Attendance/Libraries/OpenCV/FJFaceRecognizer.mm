//
//  FaceRecognizer.mm
//  opencvtest
//
//  Created by Engin Kurutepe on 21/01/15.
//  Copyright (c) 2015 Fifteen Jugglers Software. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/ml/ml.hpp>
#endif

#import "FJFaceRecognizer.h"
#import "UIImage+OpenCV.h"

using namespace cv;
using namespace std;

@interface FJFaceRecognizer () {
    Ptr<FaceRecognizer> _faceClassifier;
    
    vector<Mat> imagess;
    vector<int> labelss;
}

@property (nonatomic, strong) NSMutableDictionary *labelsDictionary;

@end
@implementation FJFaceRecognizer

+ (FJFaceRecognizer *)faceRecognizerWithFile:(NSString *)path {
    FJFaceRecognizer *fr = [FJFaceRecognizer new];
    
    fr->_faceClassifier = createLBPHFaceRecognizer(); //CascadeClassifier
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (path && [fm fileExistsAtPath:path isDirectory:nil]) {
        fr->_faceClassifier->load(path.UTF8String);
        
        NSDictionary *unarchivedNames = [NSKeyedUnarchiver
                                    unarchiveObjectWithFile:[path stringByAppendingString:@".names"]];
        
        fr.labelsDictionary = [NSMutableDictionary dictionaryWithDictionary:unarchivedNames];

    }
    else {
        fr.labelsDictionary = [NSMutableDictionary dictionary];
        NSLog(@"could not load paramaters file: %@", path);
        
    }

    return fr;
}

- (BOOL)serializeFaceRecognizerParamatersToFile:(NSString *)path {
    
    self->_faceClassifier->save(path.UTF8String);
     
    [NSKeyedArchiver archiveRootObject:_labelsDictionary toFile:[path stringByAppendingString:@".names"]];
    
    return YES;
}

- (NSString *)predict:(UIImage*)img confidence:(double *)confidence {
    
    cv::Mat src = [img cvMatRepresentationGray];
    int label;
    
    self->_faceClassifier->predict(src, label, *confidence);
    
    return _labelsDictionary[@(label)];
}

- (void)updateWithFace:(UIImage *)img name:(NSString *)name {
    cv::Mat src = [img cvMatRepresentationGray];
    
    
    NSSet *keys = [_labelsDictionary keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return ([name isEqual:obj]);
    }];
    
    NSInteger label;
    
    if (keys.count) {
        label = [[keys anyObject] integerValue];
    }
    else {
        label = _labelsDictionary.allKeys.count;
        _labelsDictionary[@(label)] = name;
    }

    std::vector<cv::Mat> images = std::vector<cv::Mat>();
    images.push_back(src);
    std::vector<int> labels = std::vector<int>();
    labels.push_back((int)label);
    
    self->_faceClassifier->update(images, labels);
    [self labels];
}

- (NSArray *)labels {
    cv::Mat labels = _faceClassifier->getMat("labels");
    
    if (labels.total() == 0) {
        return @[];
    }
    else {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (MatConstIterator_<int> itr = labels.begin<int>(); itr != labels.end<int>(); ++itr ) {
            int lbl = *itr;
            [mutableArray addObject:@(lbl)];
           
        }
        NSLog(@"number elements of mutableArray:%lu", (unsigned long)mutableArray.count);
        return [NSArray arrayWithArray:mutableArray];
    }
}

- (void)trainingFace{
    
    Ptr<FaceRecognizer> model = createFisherFaceRecognizer();
    std::string name = model->name();
    
    // images for first person
    imagess.push_back(imread("Person/person1.jpg", CV_LOAD_IMAGE_GRAYSCALE));
    labelss.push_back(0);
    imagess.push_back(imread("Person/person2.jpg", CV_LOAD_IMAGE_GRAYSCALE));
    labelss.push_back(0);
    imagess.push_back(imread("Person/person3.jpg", CV_LOAD_IMAGE_GRAYSCALE));
    labelss.push_back(0);
    imagess.push_back(imread("Person/person4.jpg", CV_LOAD_IMAGE_GRAYSCALE));
    labelss.push_back(0);
    
    // images for second person
//    images.push_back(imread("person1/0.jpg", CV_LOAD_IMAGE_GRAYSCALE)); labels.push_back(1);
//    images.push_back(imread("person1/1.jpg", CV_LOAD_IMAGE_GRAYSCALE)); labels.push_back(1);
//    images.push_back(imread("person1/2.jpg", CV_LOAD_IMAGE_GRAYSCALE)); labels.push_back(1);
    
//     model =  createFisherFaceRecognizer();
//
//    // This is the common interface to train all of the available cv::FaceRecognizer
//    // implementations:
//    //
    model->train(imagess, labelss);
//
//    //predict person
//    // Read in a sample image:
    Mat img = imread("Person/person1.jpg", CV_LOAD_IMAGE_GRAYSCALE);
//    // And get a prediction from the cv::FaceRecognizer:
    int predicted_label = -1;
    double predicted_confidence = 0.0;
//    // Get the prediction and associated confidence from the model
    model->predict(img, predicted_label, predicted_confidence);

}

- (void) readImage:(UIImage *)imagesss {
    Ptr<FaceRecognizer> model = createFisherFaceRecognizer();
    model =  createFisherFaceRecognizer();
    
    // This is the common interface to train all of the available cv::FaceRecognizer
    // implementations:
    //
    model->train(imagess, labelss);
    //predict person
    // Read in a sample image:
    Mat img = imread("Person/person1.jpg", CV_LOAD_IMAGE_GRAYSCALE);
    // And get a prediction from the cv::FaceRecognizer:
    int predicted_label = -1;
    double predicted_confidence = 0.0;
    // Get the prediction and associated confidence from the model
    model->predict(img, predicted_label, predicted_confidence);

    
}

- (void)trainingImage{
    int num_files = 2;
    int width = 128;
    int height = 128;
    
    Mat image[2];
    image[0] = imread("person6.jpg", 0);
    image[1] = imread("person7.jpg", 0);
    cv::Size minSize(128,128); //width = 128; int height = 128;
    
//    resize(image[0], image[0], minSize);
//    resize(image[1], image[1], minSize);
    
    Mat new_image(2, height*width, CV_32FC1); //Training sample from input images
    
    int ii = 0;
    for (int i = 0; i < num_files; i++){
        Mat temp = image[i];
        ii = 0;
        for (int j = 0; j < temp.rows; j++){
            for (int k = 0; k < temp.cols; k++){
                new_image.at<float>(i, ii++) = temp.at<uchar>(j, k);
            }
        }
    }
    //new_image.push_back(image[0].reshape(0, 1));
    //new_image.push_back(image[1].reshape(0, 1));
    Mat labels(num_files, 1, CV_32FC1);
    labels.at<float>(0, 0) = 1.0;//tomato
    labels.at<float>(1, 0) = -1.0;//melon
    
   // cv::imshow("New image", new_image);
    printf("%f %f", labels.at<float>(0, 0), labels.at<float>(1, 0));
    
    CvSVMParams params;
    params.svm_type = CvSVM::C_SVC;
    params.kernel_type = CvSVM::LINEAR;
    params.gamma = 3;
    params.degree = 3;
    params.term_crit = cvTermCriteria(CV_TERMCRIT_ITER, 100, 1e-6);
    CvSVM svm;
    svm.train(new_image, labels, Mat(), Mat(), params);
    
    svm.save("svm.xml"); // saving
   // svm.load("svm.xml"); // loading
    
    Mat test_img = imread("person6.jpg", 0);
    resize(test_img, test_img, minSize);
    test_img = test_img.reshape(0, 1);
    cv:imshow("shit_image", test_img);
    test_img.convertTo(test_img, CV_32FC1);
    float res = svm.predict(test_img);
    if (res > 0)
        cout << endl << "Tomato";
    else
        cout << endl << "Melon";
    waitKey(0);
}


@end
