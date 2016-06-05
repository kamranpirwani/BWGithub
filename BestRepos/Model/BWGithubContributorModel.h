//
//  BWGithubContributorModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWGithubBarebonesUserModel.h"

/**
 * @class BWGithubContributorModel
 * @brief The purpose of this class is to serve add an additional contribution field
 *        to the slim user model
 */
@interface BWGithubContributorModel : BWGithubBarebonesUserModel

/**
 * The number of contributions the user has made
 */
@property(nonatomic, readonly) NSUInteger contributions;

@end
