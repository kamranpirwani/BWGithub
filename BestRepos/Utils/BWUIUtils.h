//
//  BWUIUtils.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 * @class BWUIUtils
 * @brief The purpose of this class is to provide basic utilities to customize the
 * user interface of the app.
 */
@interface BWUIUtils : NSObject

/**
 * A convenience method to invoke the relevant appearance methods and style our user interface
 */
+ (void)setupAppearance;

/**
 * All of the relevant colors we are using in the app
 * http://www.materialpalette.com/teal/red
 */
+ (UIColor *)darkPrimaryColor;
+ (UIColor *)primaryColor;
+ (UIColor *)accentColor;
+ (UIColor *)primaryTextColor;
+ (UIColor *)secondaryTextColor;
+ (UIColor *)dividerColor;

@end
