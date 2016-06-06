//
//  BWDetailRepositoryViewController.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubRepositoryModel.h"

/**
 * @class BWRepositoryDetailViewController
 * @brief This view controller shows the full project description for a repository, as well as all of the top contributors
 */
@interface BWRepositoryDetailViewController : UIViewController

/**
 * The designated initializer for our view controller
 * @param repositoryModel The model to fetch pertinent information from to display to the user, for a given repository
 */
- (instancetype)initWithModel:(BWGithubRepositoryModel *)repositoryModel;

@end
