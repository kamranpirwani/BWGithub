//
//  BWLoadingOverlayView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWLoadingOverlayView.h"
#import "XHAmazingLoadingView.h"

@interface BWOverlayView ()
@property (nonatomic, readwrite, assign) CGFloat finalAlpha;
@end

@implementation BWLoadingOverlayView {
    XHAmazingLoadingView *_loadingView;
}

- (instancetype)initWithParentView:(UIView *)parentView backgroundColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha {
    self = [super initWithParentView:parentView backgroundColor:backgroundColor alpha:alpha];
    if (self) {
        [self setupLoadingView];
    }
    return self;
}

- (void)setupLoadingView {
    UIColor *primay = [UIColor colorWithRed:0/255.0 green:121/255.0 blue:107/255.0 alpha:1.0];
    _loadingView = [[XHAmazingLoadingView alloc] initWithType:XHAmazingLoadingAnimationTypeMusic loadingTintColor:primay size:200 parentFrame:self.bounds];
    _loadingView.alpha = self.finalAlpha;
    _loadingView.backgroundTintColor = [UIColor clearColor];
    _loadingView.frame = self.bounds;
}

- (void)showWithCallback:(void (^)())callback {
    [super showWithCallback:callback];
    [self addSubview:_loadingView];
    [_loadingView startAnimating];
}

- (void)dismissWithCallback:(void (^)())callback {
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
    [super dismissWithCallback:callback];
}

@end
