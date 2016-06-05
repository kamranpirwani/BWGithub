//
//  BWGithubContributorModel_Internal.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubContributorModel.h"
#import "BWGithubBarebonesUserModel_Internal.h"

/**
 * The purpose of this class is to serve as an extension, providing readwrite access only to
 * classes that create instances of this model. For example, the parser and unit tests classes
 * need these headers to set these attributes. The consumers of this model will only have read only
 * access to all of the attributes
 */
@interface BWGithubContributorModel ()

@property(nonatomic, readwrite) NSUInteger contributions;

@end
