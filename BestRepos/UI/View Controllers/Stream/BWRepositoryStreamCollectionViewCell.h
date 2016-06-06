//
//  BWRepositoryStreamCollectionViewCell.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubRepositoryModel.h"

static CGFloat kBWRepositoryStreamCollectionViewCellHeight = 215.f;

/**
 * @class BWRepositoryStreamCollectionViewCell
 * @brief a collection view cell designed to show the user information about a repository
 */
@interface BWRepositoryStreamCollectionViewCell : UICollectionViewCell

/**
 * Setup the cell with our repository model
 * @param model The model to fetch pertinent information from to display to the user, for a given repository
 * @note This method translates our model data into the ui
 */
- (void)configureWithModel:(BWGithubRepositoryModel *)repositoryModel;

/**
 * The reuse identifier for our cell
 */
+ (NSString *)reuseIdentifier;

@end
