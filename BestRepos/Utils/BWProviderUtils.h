//
//  BWProviderUtils.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 * @class BWProviderUtils
 * @brief The purpose of this class is to provide easy access to objects needed by our
 *        providers
 */
@interface BWProviderUtils : NSObject

/**
 * Returns an instance of our networking serial queue
 * @note This is created once per session
 */
+ (NSOperationQueue *)networkingSerialQueue;

/**
 * Returns an instance of our networking session manager
 * @note This is created once per session. Additionally, we modify our
 * request serialize in order to specify our requests to the GitHub v3 API, as well as
 * pass in our authorization information here
 *
 */
+ (AFHTTPSessionManager *)defaultHttpSessionManager;

@end
