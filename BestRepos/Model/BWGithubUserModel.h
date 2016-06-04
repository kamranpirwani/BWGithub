//
//  BWGithubUserModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubBarebonesUserModel.h"

@interface BWGithubUserModel : BWGithubBarebonesUserModel

@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSUInteger numberOfPublicRepositories;
@property(nonatomic, readonly) NSUInteger followers;
@property(nonatomic, readonly) NSUInteger following;
@property(nonatomic, readonly) NSString *location;
@property(nonatomic, readonly) NSString *bio;

@end
