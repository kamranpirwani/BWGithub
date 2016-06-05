//
//  BWUIUtils.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWUIUtils.h"

@implementation BWUIUtils

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
