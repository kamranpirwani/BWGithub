//
//  BWGithubBarebonesUserModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWGithubBarebonesUserModel : NSObject

@property(nonatomic, readonly) NSUInteger identifier;
@property(nonatomic, readonly) NSString *login;
@property(nonatomic, readonly) NSString *avatarUrl;

@end
