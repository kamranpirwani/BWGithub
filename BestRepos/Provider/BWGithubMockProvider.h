//
//  BWGithubMockProvider.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWGithubProviderProtocol.h"

/**
 * @class BWGithubMockProvider
 * @brief The responsibility of this class is to mimic the behavior the real github provider would give us
 *        and provide us with mock responses, generated from json files of the actual api responses
 * @note This is particularly beneficial in the scenario where we don't want to perform the network requests,
 *       and want to quickly test the UI. Additionally, it can help in the event we get rate limited with their API
 */
@interface BWGithubMockProvider : NSObject <BWGithubProviderProtocol>

@end
