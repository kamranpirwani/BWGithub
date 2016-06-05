//
//  BWRepositoryHeaderView.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubRepositoryModel.h"

/**
 * @class BWRepositoryHeaderView
 * @brief The header view which shows the image of the owner of the repository,
 *        the programming language used, name and description
 */
@interface BWRepositoryHeaderView : UIView

/**
 * The designated initializer for our view
 * @param repositoryModel The model to fetch pertinent information from to display to the user, for a given repository
 */
- (instancetype)initWithModel:(BWGithubRepositoryModel *)model;

@end
