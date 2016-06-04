//
//  BWRepositoryStreamCollectionViewCell.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWGithubRepositoryModel.h"

@interface BWRepositoryStreamCollectionViewCell : UICollectionViewCell

- (void)configureWithModel:(BWGithubRepositoryModel *)repositoryModel;

+ (NSString *)reuseIdentifier;

@end
