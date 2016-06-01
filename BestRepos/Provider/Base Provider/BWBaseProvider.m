//
//  BWBaseProvider.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWBaseProvider.h"
#import "BWUtils.h"
#import "BWProviderUtils.h"
#import <AFNetworking.h>

@implementation BWBaseProvider {
    NSOperationQueue *_serialQueue;
}

- (instancetype)initWithQueue:(NSOperationQueue *)queue {
    self = [super init];
    if (self) {
        [BWUtils assertCondition:queue
                         message:@"Queue for provider must be non-nil"
                           class:[self class]
                          method:_cmd];
        _serialQueue = queue;
    }
    return self;
}

- (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                 callback:(void(^)(id response, NSError *error))callback {
    /**
     * Define completion block to invoke our callback after parsing the response into JSON
     */
    [_serialQueue addOperationWithBlock:^{
        NSError *error = nil;
        AFHTTPRequestSerializer *requestSerializer = [BWProviderUtils defaultHttpSessionManager].requestSerializer;
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:method
                                                                  URLString:path
                                                                 parameters:parameters
                                                                      error:&error];
        if (!error) {
            NSURLSessionDataTask *task = [[BWProviderUtils defaultHttpSessionManager] dataTaskWithRequest:request
                                                           completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                               if (callback) {
                                                                   callback(responseObject, error);
                                                               }
            }];
            [task resume];
        }
    }];
}


@end
