//
//  BWBaseProvider.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWBaseProvider : NSObject

- (instancetype)initWithQueue:(NSOperationQueue *)queue;

- (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                 callback:(void(^)(id response, NSError *error))callback;


@end
