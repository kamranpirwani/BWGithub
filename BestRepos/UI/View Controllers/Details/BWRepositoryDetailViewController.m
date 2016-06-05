//
//  BWRepositoryDetailViewController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryDetailViewController.h"
#import "BWRepositoryDetailTableViewCell.h"
#import "BWRepositoryHeaderView.h"
#import "BWGithubService.h"
#import "BWProfileViewController.h"
#import "BWUIUtils.h"
#import "BWLoadingOverlayView.h"
#import "SCLAlertView.h"

@interface BWRepositoryDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) BWGithubRepositoryModel *repositoryModel;
@property(nonatomic, strong) BWLoadingOverlayView *loadingOverlayView;

@end

static NSString *const kBWRepositoryDetailViewControllerTitle = @"Repository";
static NSString *const kBWRepositoryDetailViewControllerValidHeaderTitle = @"Top Contributors";
static NSString *const kBWRepositoryDetailViewControllerInvalidHeaderTitle = @"No Contributors";

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
    [self styleView];
    [self createHeaderView];
    [self registerCellWithTableView];
}

- (void)styleView {
    self.navigationItem.title = kBWRepositoryDetailViewControllerTitle;
}

- (void)createHeaderView {
    BWRepositoryHeaderView *headerView = [[BWRepositoryHeaderView alloc] initWithModel:_repositoryModel];

    /**
     * TODO: Fix hardcoded height here
     * Some funkiness going on with inferred simulator metrics and size classes
     * I have to set the height programmatically and in constraints
     * Getting the view's height showing up entirely accurately wasn't the highest priority so I will leave this here for now
     *
     */
    CGFloat height = 200;
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
                                                                         constant:height];
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
    
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), height);
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
    _loadingOverlayView = [[BWLoadingOverlayView alloc] initWithParentView:self.view
                                                           backgroundColor:[UIColor blackColor]
                                                                     alpha:1.f];
    __weak typeof(self) weakSelf = self;
    [_loadingOverlayView showWithCallback:^{
        [[BWGithubService sharedInstance] getUserProfileFromBarebonesUserModel:userModel callback:^(NSString *errorString, BWGithubUserModel *completeUser) {
            [weakSelf handleUserProfileFetch:errorString withCompleteUser:completeUser];
        }];
    }];
}

- (void)handleUserProfileFetch:(NSString *)errorString withCompleteUser:(BWGithubUserModel *)completeUser {
    void (^actionBlock)() = ^{
        if (!errorString) {
            BWProfileViewController *profileViewController = [[BWProfileViewController alloc] initWithModel:completeUser];
            [self.navigationController pushViewController:profileViewController animated:YES];
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"Error"
                    subTitle:errorString
            closeButtonTitle:@"Okay"
                    duration:0.0f];
        }
    };
    
    [_loadingOverlayView dismissWithCallback:actionBlock];
}

#pragma mark - UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BWGithubContributorModel *contributorModel = [_repositoryModel.topContributors objectAtIndex:indexPath.row];
    [self loadUserProfileForBarebonesUser:contributorModel];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [BWUIUtils dividerColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[BWUIUtils primaryTextColor]];
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
    if (_repositoryModel.topContributors.count > 0) {
        return kBWRepositoryDetailViewControllerValidHeaderTitle;
    } else {
        return kBWRepositoryDetailViewControllerInvalidHeaderTitle;
    }
}


@end
