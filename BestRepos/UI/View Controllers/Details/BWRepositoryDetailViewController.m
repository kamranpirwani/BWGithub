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

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) BWGithubRepositoryModel *repositoryModel;
@property(nonatomic, strong) BWLoadingOverlayView *loadingOverlayView;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *repositoryHeaderViewContainerHeightConstraint;
@property(nonatomic, weak) IBOutlet UIView *headerViewContainer;

@property(nonatomic, strong) BWRepositoryHeaderView *headerView;
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

- (void)styleView {
    self.navigationItem.title = kBWRepositoryDetailViewControllerTitle;
}

- (void)registerCellWithTableView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([BWRepositoryDetailTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[BWRepositoryDetailTableViewCell reuseIdentifier]];
}

/**
 * Displaying this view from a size class was a bit tricky, as it gets unarchived at 600x600, but it's actual height is unknown
 * until it is fully laid out, as we are dispaying data in a multiline label. We need to readjust our height once we know it using viewWillLayoutSubviews
 */
- (void)createHeaderView {
    _headerView = [[BWRepositoryHeaderView alloc] initWithModel:_repositoryModel];
    /**
     * When using inferred sized with size classes, the view will be unarchived with (600x600) dimensions
     * We need to set the actual frame here
     */
    _headerView.frame = ({
        CGRect actualWidthFrame = _headerView.frame;
        actualWidthFrame.size.width = CGRectGetWidth(self.view.bounds);
        actualWidthFrame;
    });
    //flexible top and bottom margins so we can grow to our parent view
    UIViewAutoresizing resizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_headerView setAutoresizingMask:resizingMask];
    [self.headerViewContainer addSubview:_headerView];
}


#pragma mark - View Controller Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleView];
    [self registerCellWithTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_headerView) {
        [self createHeaderView];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_repositoryHeaderViewContainerHeightConstraint.constant != _headerView.bounds.size.height) {
        _repositoryHeaderViewContainerHeightConstraint.constant = _headerView.bounds.size.height;
        [UIView animateWithDuration:0.35 delay:0.f usingSpringWithDamping:0.9 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

#pragma mark - Profile Fetch and Displaying

- (void)loadUserProfileForBarebonesUser:(BWGithubContributorModel *)userModel {
    _loadingOverlayView = [[BWLoadingOverlayView alloc] initWithParentView:self.view
                                                           backgroundColor:[BWUIUtils primaryTextColor]
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
