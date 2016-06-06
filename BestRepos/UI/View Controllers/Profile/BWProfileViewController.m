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

@property(nonatomic, weak) IBOutlet UIImageView *ivProfilePicture;
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblFollowingCount;
@property(nonatomic, weak) IBOutlet UILabel *lblPublicRepositoryCount;
@property(nonatomic, weak) IBOutlet UILabel *lblFollowersCount;
@property(nonatomic, weak) IBOutlet UILabel *lblType;
@property(nonatomic, weak) IBOutlet UILabel *lblLocation;

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
    [self styleView];
    [self configureWithModel:_userModel];
}

- (void)styleView {
    self.navigationItem.title = _userModel.login;
    _ivProfilePicture.layer.cornerRadius = CGRectGetWidth(_ivProfilePicture.bounds) / 2;
}

@end
