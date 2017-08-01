//
//  OpencvWrapper.m
//  OpencvProj
//
//  Created by arianne on 2016-11-11.
//  Copyright © 2016 della. All rights reserved.
//

#import "OpencvWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpencvWrapper

+(NSString*) OpencvVersionString {
    return [NSString stringWithFormat:@"opencv versions %s", CV_VERSION];
}

// https://www.youtube.com/watch?v=PD5d7EKYLcA
+(UIImage* ) equalizeHist: (UIImage *) image{
    
    cv:: Mat imageMat;
    cv:: Mat eqzImg;
    //transform uiimage to mat
    //cv:: Mat imageUi2Mat;
    UIImageToMat(image, imageMat);
    //cv:: cvtColor(imageUi2Mat, imageMat, CV_BGR2GRAY);

    if (imageMat.channels() == 1) {
       
        // Calculate the size of image
        //int size = imageMat.rows * imageMat.cols;
        int histogram[256];
    
        //zero histogram array
        for (int i =0; i< 256; i++)
            histogram[i] = 0;
        
        // step 1
        // accumulate histogram
        //accumulate histgram
        for (int i = 0; i<imageMat.rows; i++)
            for (int j = 0; j<imageMat.cols; j++)
              histogram[(int)imageMat.at<uchar>(i,j)]++;
        
        
        //count pxx
        int p_count = 0;
        for (int i = 0; i< 256; i++) {
            p_count += histogram[i];
            //std::cout<< p_count << "\n";
         }
        
        //cpd // step 2,3 and 4
        //probability/cumulative  probability distrib and scale histogram
        double cpd = 0;
        int cpd_hist [256];
        for (int i = 0; i <256; i++){
            cpd += (double)histogram[i]/(double)p_count;
            cpd_hist [i] = (int)((cpd*255) + 0.5);
            //std::cout<< cpd_hist[i] << "\n";
        }
    
        // step 5
        //equalized image
        //cv:: cvtColor(imageUi2Mat, eqzImg, CV_BGR2GRAY);
        for(int i = 0; i<imageMat.rows; i++){
            for (int j = 0; j<imageMat.cols; j++){
                imageMat.at<uchar>(i,j) = cpd_hist[(int)imageMat.at<uchar>(i,j)];
                }
         }
    
        eqzImg = imageMat.clone();
    
    
      
    } //end if statement
    else {
        // Calculate the size of image
        //int size = imageMat.rows * imageMat.cols;
        int histogram[256];
        std::vector<cv::Mat> channels;
        
        //convert to ycrcb format
        cv:: Mat ycrcbMat;
        cv:: cvtColor(imageMat, ycrcbMat, CV_BGR2YCrCb);
        
        // split channels
        cv::split(ycrcbMat,channels);
        
        //zero histogram array
        for (int i =0; i< 256; i++)
            histogram[i] = 0;
        
        // step 1
        // accumulate histogram
        //accumulate histgram
        for (int i = 0; i<imageMat.rows; i++)
            for (int j = 0; j<imageMat.cols; j++)
                histogram[(int)channels[0].at<uchar>(i,j)]++;
        
        
        //
        int p_count = 0;
        for (int i = 0; i< 256; i++) {
            p_count += histogram[i];
            //std::cout<< p_count << "\n";
        }
        
        //cpd
        //cpd // step 2,3 and 4
        //probability/cumulative  probability distrib and scale histogram
        double cpd = 0;
        int cpd_hist [256];
        for (int i = 0; i <256; i++){
            cpd += (double)histogram[i]/(double)p_count;
            cpd_hist [i] = (int)((cpd*255) + 0.5);
            //std::cout<< cpd_hist[i] << "\n";
        }
        
        // step 5
        //equalized image
        //cv:: cvtColor(imageUi2Mat, eqzImg, CV_BGR2GRAY);
        for(int i = 0; i<imageMat.rows; i++){
            for (int j = 0; j<imageMat.cols; j++){
                channels[0].at<uchar>(i,j) = cpd_hist[(int)channels[0].at<uchar>(i,j)];
            }
        }
        cv:: Mat channels_out;
        cv::merge(channels,channels_out);
        
        // convert channels
        cvtColor(channels_out,eqzImg,CV_YCrCb2BGR);
        std::cout<< "convert channels to bgr\n ";
        
        
    }
    //return MatToUIImage(imageMat); 
   return MatToUIImage(eqzImg);
}
@end
