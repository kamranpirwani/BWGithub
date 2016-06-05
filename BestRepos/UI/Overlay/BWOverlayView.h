//
//  BWOverlayView.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWOverlayView : UIView

+ (instancetype)fullScreenBlackOverlay;
+ (instancetype)blackOverlayWithParentView:(UIView *)parentView;

- (instancetype)initWithParentView:(UIView *)parentView backgroundColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha;

- (void)setTapCallback:(void(^)())callback;

- (void)showWithCallback:(void(^)())callback;
- (void)dismissWithCallback:(void(^)())callback;

@end
