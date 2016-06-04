//
//  BWGithubUserModel_Internal.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubUserModel.h"

@interface BWGithubUserModel ()

@property(nonatomic, readwrite) NSString *type;
@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) NSUInteger numberOfPublicRepositories;
@property(nonatomic, readwrite) NSUInteger followers;
@property(nonatomic, readwrite) NSUInteger following;
@property(nonatomic, readwrite) NSString *location;
@property(nonatomic, readwrite) NSString *bio;


@end
