//
//  BWAppController.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class BWAppController
 * @brief The app controller is responsible for initialzing the app and managing any
 *        relevant lifecycle state. Additionally, we can toggle between providers/mock providers
 *        here
 */
@interface BWAppController : NSObject

/**
 * Initialize any core dependencies in the app and ui for our app
 */
+ (void)initializeApplication;

@end
