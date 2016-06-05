//
//  BWFastImageCacheService.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/4/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWImageCacheService.h"
#import <HNKCache.h>

@interface BWImageCacheService()

@end

@implementation BWImageCacheService

static BWImageCacheService *_singleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[BWImageCacheService alloc] init];
    });
    return _singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSArray *)getSupportedImageFormats {
    //owner small - 60
    //owner big - 100
    //contributor small - 32x32
    NSString *githubOwnerSmallThumbnail = @"githubOwnerSmallThumbnail";
    HNKCacheFormat *format = [HNKCache sharedCache].formats[githubOwnerSmallThumbnail];
    if (!format) {
        format = [[HNKCacheFormat alloc] initWithName:githubOwnerSmallThumbnail];
        format.size = CGSizeMake(60, 60);
        format.scaleMode = HNKScaleModeAspectFill;
        format.compressionQuality = 0.8;
        format.diskCapacity = 1 * 1024 * 1024; // 1MB
        format.preloadPolicy = HNKPreloadPolicyLastSession;
    }
    
}

@end
