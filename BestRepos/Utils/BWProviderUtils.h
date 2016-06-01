//
//  BWProviderUtils.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BWProviderUtils : NSObject

+ (NSOperationQueue *)networkingSerialQueue;

+ (AFHTTPSessionManager *)defaultHttpSessionManager;

@end
