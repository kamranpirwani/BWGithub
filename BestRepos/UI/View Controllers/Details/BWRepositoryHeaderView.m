//
//  BWRepositoryHeaderView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryHeaderView.h"
#import <Haneke.h>

@interface BWRepositoryHeaderView()

@property(nonatomic, weak) IBOutlet UIImageView *ivRepositoryImage;
@property(nonatomic, weak) IBOutlet UILabel *lblRepositoryName;
@property(nonatomic, weak) IBOutlet UILabel *lblProgrammingLanguage;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;

@end

@implementation BWRepositoryHeaderView

- (instancetype)initWithModel:(BWGithubRepositoryModel *)model {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    [self setupWithModel:model];
    [self styleView];
    return self;
}

- (void)setupWithModel:(BWGithubRepositoryModel *)model {
    [self.lblRepositoryName setText:model.name];
    [self.lblProgrammingLanguage setText:model.language];
    NSURL *imageUrl = [NSURL URLWithString:model.owner.avatarUrl];
    [_ivRepositoryImage hnk_setImageFromURL:imageUrl
                       placeholder:[UIImage imageNamed:@"Owner Placeholder Image"]];
    _lblDescription.text = model.projectDescription;
}

- (void)styleView {
    _ivRepositoryImage.layer.cornerRadius = 9.f;
}

@end
