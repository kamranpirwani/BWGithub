//
//  BWGithubBarebonesUserModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class BWGithubBarebonesUserModel
 * @brief The purpose of this class is to serve as a slim model for a Github User
 *        We have extracted out the common fields for users into this base class
 * @note  We currently form the slim user model when fetching repositories
 */
@interface BWGithubBarebonesUserModel : NSObject

/**
 * The unique identifier for the user
 */
@property(nonatomic, readonly) NSUInteger identifier;

/**
 * The handle for the user
 */
@property(nonatomic, readonly) NSString *login;

/**
 * The users avatar picture url
 */
@property(nonatomic, readonly) NSString *avatarUrl;

/**
 * The users profile url
 */
@property(nonatomic, readonly) NSString *profileUrl;

@end
