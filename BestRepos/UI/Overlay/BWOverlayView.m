//
//  BWOverlayView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWOverlayView.h"

@interface BWOverlayView()

@property(nonatomic, assign) CGFloat finalAlpha;
@property(nonatomic, weak) UIView *parentView;

@property(nonatomic, copy) void (^tapBlock)(void);

@end

@implementation BWOverlayView

- (instancetype)initWithParentView:(UIView *)parentView backgroundColor:(UIColor *)backgroundColor alpha:(CGFloat)alpha {
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        self.backgroundColor = backgroundColor;
        _finalAlpha = alpha;
        _parentView = parentView;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

+ (instancetype)fullScreenBlackOverlay {
    UIView *parentView = [[UIApplication sharedApplication] keyWindow];
    return [self blackOverlayWithParentView:parentView];
}

+ (instancetype)blackOverlayWithParentView:(UIView *)parentView {
    BWOverlayView *overlayView = [[BWOverlayView alloc] initWithParentView:parentView
                                                           backgroundColor:[UIColor blackColor]
                                                                     alpha:0.8f];
    return overlayView;
}

- (void)setTapCallback:(void(^)())callback {
    _tapBlock = callback;
}

- (void)handleTap {
    if (_tapBlock) {
        _tapBlock();
    }
}

- (void)showWithCallback:(void(^)())callback {
    self.alpha = 0.f;
    [_parentView addSubview:self];
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = _finalAlpha;
    } completion:^(BOOL finished) {
        if (finished) {
            if (callback) {
                callback();
            }
        }
    }];
}

- (void)dismissWithCallback:(void(^)())callback {
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (callback) {
                callback();
            }
        }
    }];
}

@end
