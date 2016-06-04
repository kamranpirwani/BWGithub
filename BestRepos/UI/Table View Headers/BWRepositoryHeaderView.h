//
//  BWRepositoryHeaderView.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubRepositoryModel.h"

@interface BWRepositoryHeaderView : UIView

- (instancetype)initWithModel:(BWGithubRepositoryModel *)model;

@end
