//
//  BWServiceLocator.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @classBWServiceLocator
 * @brief The responsibilities of this class is to provide the facility to swap out
 *        services at run time. This allows us to use our services with mock and real providers,
 *        depending on the context
 * @note  We use the service locator design pattern and apply it to Objective-C
 */
@interface BWServiceLocator : NSObject

+ (instancetype)sharedInstance;

/**
 * Add the relevant service, confirming to the given protocol to our locator
 * @param service The instance of the service we want to add
 * @param protocol The procotol we are strong the service for
 */
- (void)addService:(id)service withProtocol:(Protocol *)protocol;

/**
 * Retrive the relevant service which conforms to the protocol
 * @param protocol The protocol the service we want conforms to
 * @return a service we stored in the locator via the addService:withProtocol: method
 */
- (id)getServiceWithProtocol:(Protocol *)protocol;

@end
