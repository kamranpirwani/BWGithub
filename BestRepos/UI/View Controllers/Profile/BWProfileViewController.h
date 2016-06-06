//
//  BWProfileViewController.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubUserModel.h"

/**
 * @class BWProfileViewController
 * @brief The profile view controller displays light information about the given user
 *        such as their name, followers, number of users following them, public repositories count
 *        type of account and location
 */
@interface BWProfileViewController : UIViewController

/**
 * The designated initializer for our view controller
 * @param model The model to fetch pertinent information from to display to the user, for a given user
 * @note This method translates our model data into the ui
 */
- (instancetype)initWithModel:(BWGithubUserModel *)userModel;

@end
