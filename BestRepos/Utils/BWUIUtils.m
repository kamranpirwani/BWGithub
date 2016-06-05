//
//  BWUIUtils.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWUIUtils.h"

@implementation BWUIUtils

+ (void)setupAppearance {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.f
                                           alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIColor *whiteColor = [UIColor colorWithRed:245.0/255.0
                                          green:245.0/255.0
                                           blue:245.0/255.0
                                          alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:21.0];
    NSArray *keys = @[NSForegroundColorAttributeName, NSShadowAttributeName, NSFontAttributeName];
    NSArray *objects = @[whiteColor, shadow, font];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    //Tint the back button and buttons on the navigation bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Tint the navigation bar color
    [[UINavigationBar appearance] setBarTintColor:[self primaryColor]];
    
    //Tint the search bar buttons
    [[UISearchBar appearance] setTintColor:[self accentColor]];
}

+ (UIColor *)darkPrimaryColor {
    return [UIColor colorWithRed:0/255.0
                           green:150/255.0
                            blue:136/255.0
                           alpha:1.0];
}

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:0/255.0
                           green:121/255.0
                            blue:107/255.0
                           alpha:1.0];
}

+ (UIColor *)accentColor {
    return [UIColor colorWithRed:255/255.0
                           green:82/255.0
                            blue:82/255.0
                           alpha:1.0];
}

+ (UIColor *)primaryTextColor {
    return [UIColor colorWithRed:33/255.0
                           green:33/255.0
                            blue:33/255.0
                           alpha:1.0];
}

+ (UIColor *)secondaryTextColor {
    return [UIColor colorWithRed:114/255.0
                           green:114/255.0
                            blue:114/255.0
                           alpha:1.0];
}

@end
