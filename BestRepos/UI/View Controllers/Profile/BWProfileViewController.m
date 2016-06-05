//
//  BWProfileViewController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWProfileViewController.h"
#import "BWUtils.h"
#import <Haneke.h>

@interface BWProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPublicRepositoryCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowersCount;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

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
    NSString *displayName = (userModel.name != nil) ? userModel.name : userModel.login;
    _lblName.text = displayName;
    NSString *biography = (userModel.bio != nil) ? userModel.bio : [NSString stringWithFormat:@"%@ has no biography included", displayName];
    _lblBiography.text = biography;
    _lblType.text = (userModel.type != nil) ? userModel.type : @"No type provided";
    _lblLocation.text = (userModel.location != nil) ? userModel.location : @"No location provided";

    _lblPublicRepositoryCount.text = [BWUtils abbreviateNumber:userModel.numberOfPublicRepositories];
    _lblFollowersCount.text = [BWUtils abbreviateNumber:userModel.followers];
    _lblFollowingCount.text = [BWUtils abbreviateNumber:userModel.following];
    [_ivProfilePicture hnk_setImageFromURL:[NSURL URLWithString:userModel.avatarUrl] placeholder:[UIImage imageNamed:@"Owner Placeholder Image"]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _userModel.login;
    _ivProfilePicture.layer.cornerRadius = CGRectGetWidth(_ivProfilePicture.bounds) / 2;
    [self configureWithModel:_userModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
