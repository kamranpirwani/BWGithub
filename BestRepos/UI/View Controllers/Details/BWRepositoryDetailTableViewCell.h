//
//  BWRepositoryDetailTableViewCell.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubContributorModel.h"

/**
 * @class BWRepositoryDetailTableViewCell
 * @brief This cell shows additional such as an image, primay text and subtext
 * @note Currently it is being used for displaying top contributors, their names and commits,
 *       but if we had functionality such as showing users, such as users that are following you, we would slighlty
 *       tweak this class to be more generic
 */
@interface BWRepositoryDetailTableViewCell : UITableViewCell

/**
 * Setup the cell with our user model
 * @param model The model to fetch pertinent information from to display to the user, for a given user
 * @note This method translates our model data into the ui
 */
- (void)configureWithModel:(BWGithubContributorModel *)model;

/**
 * The reuse identifier of cell
 */
+ (NSString *)reuseIdentifier;

@end
