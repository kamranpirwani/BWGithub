//
//  BWSearchHeaderView.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubSearchQuery.h"

/**
 * @class BWSearchFilterView
 * @brief This view is used to handle changes in search priorities and filtering
 * @note It will update the UI state to reflect the current sort order and fields, while providing
 *       easy access to the controller
 */
@interface BWSearchFilterView : UIView

/**
 * The current sort field the user has selected
 * @note This defaults to kBWGithubSearchQuerySortStars
 */

@property(nonatomic, assign, readonly) BWGithubSearchQuerySortField currentSortField;

/**
 * The current sort order the user has selected
 * @note This defaults to kBWGithubSearchQuerySortOrderDescending
 */
@property(nonatomic, assign, readonly) BWGithubSearchQuerySortOrder currentSortOrder;

@end
