//
//  BWGithubAuthCredentials.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubAuthCredentials.h"
#import "BWUtils.h"

@interface BWGithubAuthCredentials ()

@property(nonatomic, copy, readwrite) NSString *username;
@property(nonatomic, copy, readwrite) NSString *password;

@end

static NSString *const kBWGithubAuthCredentialsFileName = @"Credentials";
static NSString *const kBWGithubAuthUsernameKey = @"username";
static NSString *const kBWGithubAuthPasswordKey = @"password";

@implementation BWGithubAuthCredentials

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initFromAuthDictionary];
    }
    return self;
}

- (void)initFromAuthDictionary {
    NSDictionary *authDictionary = [BWUtils dictionaryFromPlistFileNamed:kBWGithubAuthCredentialsFileName];
    [BWUtils assertCondition:(authDictionary != nil)
                     message:@"You must provide a Credentials.plist with your GitHub Username and password"
                       class:[self class]
                      method:_cmd];
    NSString *username = authDictionary[kBWGithubAuthUsernameKey];
    NSString *password = authDictionary[kBWGithubAuthPasswordKey];
    
    //Even if this chek passes, the credentials could be wrong
    BOOL areCredentialsPotentiallyValid = (username.length > 0 && password.length > 0);
    [BWUtils assertCondition:areCredentialsPotentiallyValid
                     message:@"You must provide a valid username and password"
                       class:[self class]
                      method:_cmd];
    _username = username;
    _password = password;
}

@end
