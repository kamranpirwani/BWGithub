//
//  BWBaseProvider.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class BWBaseProvider
 * @brief The base providers responsibilities is serving as the base class for performing all of our network
 *        requests
 */
@interface BWBaseProvider : NSObject

- (instancetype)initWithQueue:(NSOperationQueue *)queue;

/**
 * A method used to perform a network request
 * @param method     The type of request we are making, i.e. GET, POST, PUT
 * @param path       The url we are trying to navigate to
 * @param parameters The parameters we want to send up as a part of the request
 * @param callback   The response will be contained inside of the callback, providing
 *                   a response object and error
 */
- (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                 callback:(void(^)(id response, NSError *error))callback;


@end
