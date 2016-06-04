//
//  BWRepositoryHeaderView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BWRepositoryHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *ivRepositoryImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRepositoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblProgrammingLanguage;

@end

@implementation BWRepositoryHeaderView

- (instancetype)initWithModel:(BWGithubRepositoryModel *)model {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    [self setupWithModel:model];
    return self;
}

- (void)setupWithModel:(BWGithubRepositoryModel *)model {
    [self.lblRepositoryName setText:model.name];
    [self.lblProgrammingLanguage setText:model.language];
    NSURL *imageUrl = [NSURL URLWithString:model.owner.avatarUrl];
    [self.ivRepositoryImage sd_setImageWithURL:imageUrl
                              placeholderImage:[UIImage imageNamed:@"Owner Placeholder Image"]];
    _ivRepositoryImage.layer.cornerRadius = 9.f;
}

@end
