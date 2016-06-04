//
//  BWRepositoryDetailTableViewCell.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubContributorModel.h"

@interface BWRepositoryDetailTableViewCell : UITableViewCell

- (void)configureWithModel:(BWGithubContributorModel *)model;

+ (NSString *)reuseIdentifier;

@end
