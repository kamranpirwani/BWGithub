//
//  BWRepositoryDetailViewController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryDetailViewController.h"
#import "BWRepositoryDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BWRepositoryHeaderView.h"
#import "BWGithubService.h"
#import "BWProfileViewController.h"
#import "BWLoadingOverlayView.h"

@interface BWRepositoryDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) BWGithubRepositoryModel *repositoryModel;
@property(nonatomic, strong) BWLoadingOverlayView *loadingOverlayView;

@end

@implementation BWRepositoryDetailViewController

- (instancetype)initWithModel:(BWGithubRepositoryModel *)repositoryModel {
    self = [super init];
    if (self) {
        _repositoryModel = repositoryModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeaderView];
    [self registerCellWithTableView];
}

- (void)createHeaderView {
    BWRepositoryHeaderView *headerView = [[BWRepositoryHeaderView alloc] initWithModel:_repositoryModel];
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:headerView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.tableView
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.f
                                                                        constant:0.f];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:headerView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                         constant:headerView.bounds.size.height];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:headerView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.tableView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.f
                                                                         constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:headerView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.tableView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.f
                                                                         constant:0];
        
    self.tableView.tableHeaderView = headerView;
    [self.tableView addConstraint:widthConstraint];
    [self.tableView addConstraint:heightConstraint];
    [self.tableView addConstraint:topConstraint];
    [self.tableView addConstraint:leftConstraint];
}

- (void)registerCellWithTableView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([BWRepositoryDetailTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[BWRepositoryDetailTableViewCell reuseIdentifier]];
}

- (void)loadUserProfileForBarebonesUser:(BWGithubContributorModel *)userModel {
    _loadingOverlayView = [[BWLoadingOverlayView alloc] initWithParentView:self.view backgroundColor:[UIColor blackColor] alpha:1.f];
    [_loadingOverlayView showWithCallback:^{
        [[BWGithubService sharedInstance] getUserProfileFromBarebonesUserModel:userModel callback:^(NSError *error, BWGithubUserModel *completeUser) {
            if (!error) {
                BWProfileViewController *profileViewController = [[BWProfileViewController alloc] initWithModel:completeUser];
                [_loadingOverlayView dismissWithCallback:^{
                    [self.navigationController pushViewController:profileViewController animated:YES];
                }];
            }
        }];
    }];
}

#pragma mark - UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BWGithubContributorModel *contributorModel = [_repositoryModel.topContributors objectAtIndex:indexPath.row];
    [self loadUserProfileForBarebonesUser:contributorModel];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Background color
    UIColor *accent = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0];
    view.tintColor = accent;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    UIColor *primaryText = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0];
    [header.textLabel setTextColor:primaryText];
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _repositoryModel.topContributors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [BWRepositoryDetailTableViewCell reuseIdentifier];
    BWRepositoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                                                 forIndexPath:indexPath];
    BWGithubContributorModel *contributorModel = [_repositoryModel.topContributors objectAtIndex:indexPath.row];
    [cell configureWithModel:contributorModel];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Top Contributors";
}


@end
