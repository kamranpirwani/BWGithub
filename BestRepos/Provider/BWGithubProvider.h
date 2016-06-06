//
//  BWGithubProvider.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWBaseProvider.h"
#import "BWGithubProviderProtocol.h"
#import "BWGithubSearchQuery.h"

/**
 * @class BWGithubProvider
 * @brief The responsibility of this class is to perform all of our network related tasks
 *        with GitHub, and provide a response to the consumer
 */
@interface BWGithubProvider : BWBaseProvider <BWGithubProviderProtocol>

@end
