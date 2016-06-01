//
//  BWGithubContributorModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWGithubBarebonesUserModel.h"

@interface BWGithubContributorModel : BWGithubBarebonesUserModel

@property(nonatomic, readonly) NSUInteger contributions;

@end
