//
//  BWProfileViewController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BWProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPublicRepositoryCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowersCount;

@property (weak, nonatomic) IBOutlet UILabel *lblBiography;
@property(nonatomic, strong) BWGithubUserModel *userModel;
@end

@implementation BWProfileViewController

- (instancetype)initWithModel:(BWGithubUserModel *)userModel {
    self = [super init];
    if (self) {
        _userModel = userModel;
    }
    return self;
}

- (void)configureWithModel:(BWGithubUserModel *)userModel {
    _lblName.text = userModel.name;
    _lblBiography.text = userModel.bio;
    _lblPublicRepositoryCount.text = [@(userModel.numberOfPublicRepositories) stringValue];
    _lblFollowersCount.text = [@(userModel.followers) stringValue];
    _lblFollowingCount.text = [@(userModel.following) stringValue];
    [_ivProfilePicture sd_setImageWithURL:[NSURL URLWithString:userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"Owner Placeholder Image"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _ivProfilePicture.layer.cornerRadius = CGRectGetWidth(_ivProfilePicture.bounds) / 2;
    [self configureWithModel:_userModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
