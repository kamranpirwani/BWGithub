//
//  BWSearchHeaderView.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubSearchQuery.h"

@interface BWSearchHeaderView : UIView

@property(nonatomic, assign, readonly) BWGithubSearchQuerySortField currentSortField;
@property(nonatomic, assign, readonly) BWGithubSearchQuerySortOrder currentSortOrder;

@end
