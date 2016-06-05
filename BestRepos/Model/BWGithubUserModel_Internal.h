//
//  BWGithubUserModel_Internal.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubUserModel.h"

/**
 * The purpose of this class is to serve as an extension, providing readwrite access only to 
 * classes that create instances of this model. For example, the parser and unit tests classes
 * need these headers to set these attributes. The consumers of this model will only have read only
 * access to all of the attributes
 */
@interface BWGithubUserModel ()

@property(nonatomic, readwrite) NSString *type;
@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) NSUInteger numberOfPublicRepositories;
@property(nonatomic, readwrite) NSUInteger followers;
@property(nonatomic, readwrite) NSUInteger following;
@property(nonatomic, readwrite) NSString *location;
@property(nonatomic, readwrite) NSString *bio;


@end
