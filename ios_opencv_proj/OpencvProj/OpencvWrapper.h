//
//  OpencvWrapper.h
//  OpencvProj
//
//  Created by arianne on 2016-11-11.
//  Copyright © 2016 della. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpencvWrapper : NSObject
+(NSString *) OpencvVersionString;
+(UIImage *) equalizeHist: (UIImage *) image;
+(UIImage *) cartonize: (UIImage *) image;

@end

