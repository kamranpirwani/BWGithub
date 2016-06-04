//
//  BWGithubBarebonesUserModel_Internal.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubBarebonesUserModel.h"

@interface BWGithubBarebonesUserModel ()

@property(nonatomic, readwrite) NSUInteger identifier;
@property(nonatomic, readwrite) NSString *login;
@property(nonatomic, readwrite) NSString *avatarUrl;
@property(nonatomic, readwrite) NSString *profileUrl;

@end
