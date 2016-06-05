//
//  BWOverlayView.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @class BWOverlayView
 * @brief The purpose of this class is to provide an easy mechanism to create and display overlays in our app
 */
@interface BWOverlayView : UIView

/**
 * A convenience method to display an overlay on the apps window
 * @note This will cover the entire bounds of the screen
 */
+ (instancetype)fullScreenBlackOverlay;

/**
 * A convenience method to display an overlay on the parentView
 * @note This will cover the entire parent views bounds
 */
+ (instancetype)blackOverlayWithParentView:(UIView *)parentView;

/**
 * The designated initializer for our overlay
 * @param parentView The parent view we are going to add ourself on to, as well as act as the frame for ourself
 * @param backgroundColor the background color for the overlay
 * @param alpha The final opacity of the overlay, after it is animated in
 */
- (instancetype)initWithParentView:(UIView *)parentView
                   backgroundColor:(UIColor *)backgroundColor
                             alpha:(CGFloat)alpha;

/**
 * A method used to set a callback when the overlay receieves touches
 */
- (void)setTapCallback:(void(^)())callback;

/**
 * A method used to add the overlay to the parent view, and animate it in
 */
- (void)showWithCallback:(void(^)())callback;

/**
 * A method used to dismiss the overlay and remove it from the parent view
 */
- (void)dismissWithCallback:(void(^)())callback;

@end
