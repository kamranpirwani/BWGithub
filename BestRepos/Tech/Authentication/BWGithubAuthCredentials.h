//
//  BWGithubAuthCredentials.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWGithubAuthCredentials : NSObject

@property(nonatomic, copy, readonly) NSString *username;
@property(nonatomic, copy, readonly) NSString *password;

@end
