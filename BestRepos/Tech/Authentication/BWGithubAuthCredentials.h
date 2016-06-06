//
//  BWGithubAuthCredentials.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class BWGithubAuthCredentials
 * @brief The purpose of this class is to provide a wrapper around our
 *        GitHub credentials and retrive them from a file on disk. This allows us to
 *        get around hardcoding our details into the client, and gives us the ability to 
 *        modify our credentials without having to recompile the app
 */
@interface BWGithubAuthCredentials : NSObject

/**
 * The username we have stored in our file
 */
@property(nonatomic, copy, readonly) NSString *username;

/**
 * The access token we have stored in our file
 */
@property(nonatomic, copy, readonly) NSString *password;

@end
