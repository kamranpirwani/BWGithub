//
//  BWServiceLocator.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWServiceLocator : NSObject

+ (instancetype)sharedInstance;

- (void)addService:(id)service withProtocol:(Protocol *)protocol;
- (id)getServiceWithProtocol:(Protocol *)protocol;

@end
