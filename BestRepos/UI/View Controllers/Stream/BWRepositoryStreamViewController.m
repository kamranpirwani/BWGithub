//
//  BWRootViewController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryStreamViewController.h"
#import "BWRepositoryStreamCollectionViewCell.h"
#import "BWGithubService.h"
#import "SDWebImageManager.h"
#import "BWUIUtils.h"
#import "BWRepositoryDetailViewController.h"
#import "BWSearchHeaderView.h"
#import "BWLoadingOverlayView.h"
#import "BWOverlayView.h"

typedef NS_ENUM(NSInteger, BWFilterState) {
    kBWFilterStateHideFilters = 1,
    kBWFilterStateShowFilters = 2,
};

@interface BWRepositoryStreamViewController () <SDWebImageManagerDelegate, UISearchControllerDelegate, UISearchBarDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<BWGithubRepositoryModel *> *repositories;

@property(nonatomic, assign) CGSize calculatedNormalCellSize;

@property(nonatomic, strong) UISearchController *searchController;

@property(nonatomic, strong) BWGithubSearchQuery *currentSearchQuery;
@property(nonatomic, assign) BWGithubSearchQuerySortField currentSearchScope;

@property(nonatomic, strong) NSString *lastSearchString;

@property(nonatomic, strong) BWLoadingOverlayView *loadingOverlayView;
@property(nonatomic, strong) BWOverlayView *overlayView;

@property (weak, nonatomic) IBOutlet BWSearchHeaderView *searchHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchHeaderViewHeightContraint;
@property (weak, nonatomic) IBOutlet UIView *searchBarContainerView;

@property(nonatomic, assign) BWFilterState currentFilterState;

@end

@implementation BWRepositoryStreamViewController {
    BOOL _hasFetchedInitialRepositories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"BestRepos";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setupNavigationBar];
    [self setupImageDownloader];
    [self registerElementsWithCollectionView];
    [self setupSearchController];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_hasFetchedInitialRepositories) {
        [self fetchRepositories];
        _hasFetchedInitialRepositories = YES;
    }
}

- (void)setupNavigationBar {
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(filterTapped:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    _currentFilterState = kBWFilterStateHideFilters;
}

- (void)filterTapped:(UIBarButtonItem *)sender {
    [self toggleFilters];
}

- (void)toggleFilters {
    if (_currentFilterState == kBWFilterStateHideFilters) {
        _currentFilterState = kBWFilterStateShowFilters;
        [self showFilters];
    } else if (_currentFilterState == kBWFilterStateShowFilters) {
        _currentFilterState = kBWFilterStateHideFilters;
        [self hideFilters];
    }
}

- (void)setupImageDownloader {
    [[SDWebImageManager sharedManager] setDelegate:self];
    [[[SDWebImageManager sharedManager] imageCache] setShouldDecompressImages:NO];
    [[[SDWebImageManager sharedManager] imageCache] setShouldCacheImagesInMemory:NO];
}

- (void)setupSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.definesPresentationContext = YES;
    _searchController.searchBar.delegate = self;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.placeholder = @"Search for a repository by title";
    [_searchBarContainerView addSubview:_searchController.searchBar];
}

- (void)hideFilters {
    [_overlayView dismissWithCallback:^{
        _searchHeaderViewHeightContraint.constant = 0.f;
        [_collectionView setScrollEnabled:YES];
        [UIView animateWithDuration:0.15f animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
    _overlayView = nil;
}

- (void)showFilters {
    _overlayView = [[BWOverlayView alloc] initWithParentView:self.collectionView backgroundColor:[UIColor blackColor] alpha:0.8];
    __weak typeof(self) weakSelf = self;
    [_overlayView setTapCallback:^{
        [weakSelf toggleFilters];
    }];
    [_overlayView showWithCallback:^{
        [_collectionView setScrollEnabled:NO];
        _searchHeaderViewHeightContraint.constant = 125;
        [UIView animateWithDuration:0.15f animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}

- (void)registerElementsWithCollectionView {
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([BWRepositoryStreamCollectionViewCell class])
                                    bundle:nil];
    [_collectionView registerNib:cellNib
      forCellWithReuseIdentifier:[BWRepositoryStreamCollectionViewCell reuseIdentifier]];
}

- (void)showLoadingSpinner:(BOOL)showSpinner {
    if (showSpinner) {
        _loadingOverlayView = [[BWLoadingOverlayView alloc] initWithParentView:self.collectionView backgroundColor:[UIColor blackColor] alpha:1.f];
        [_loadingOverlayView showWithCallback:nil];
    } else {
        [_loadingOverlayView dismissWithCallback:nil];
        _loadingOverlayView = nil;
    }
}

- (void)fetchRepositories {
    BWGithubSearchQuery *topRepositorySearchQuery = [BWGithubSearchQuery mostPopularRepositoriesSearchQuery];
    [self fetchRepositoriesWithSearchQuery:topRepositorySearchQuery];
}

- (void)fetchRepositoriesWithSearchQuery:(BWGithubSearchQuery *)searchQuery {
    BOOL hasSearchQueryChanged = ![_currentSearchQuery isEqual:searchQuery];
    if (!hasSearchQueryChanged) {
        return;
    }
    [self showLoadingSpinner:YES];
    _currentSearchQuery = searchQuery;
    __weak typeof(self) weakSelf = self;
    [[BWGithubService sharedInstance] searchForRepositoryWithQuery:searchQuery callback:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
        [weakSelf showLoadingSpinner:NO];
        if (!error) {
            [weakSelf handleRepositoriesFromFetch:repositories];
        } else {
            [weakSelf handleErrorFromFetch:error];
        }
    }];
}

- (void)handleRepositoriesFromFetch:(NSArray<BWGithubRepositoryModel *> *)repositories {
    _repositories = repositories;
    [self.collectionView reloadData];
}

- (void)handleErrorFromFetch:(NSError *)error {
    
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _repositories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BWRepositoryStreamCollectionViewCell *cell = [self dequeueStreamCollectionViewCellFromCollectionView:collectionView andIndexPath:indexPath];
    BWGithubRepositoryModel *model = [_repositories objectAtIndex:indexPath.row];
    [cell configureWithModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BWGithubRepositoryModel *model = [_repositories objectAtIndex:indexPath.row];
    BWRepositoryDetailViewController *detailViewController = [[BWRepositoryDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UICollectionViewDelegate Methods

- (BWRepositoryStreamCollectionViewCell *)dequeueStreamCollectionViewCellFromCollectionView:(UICollectionView *)collectionView
                                                                               andIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [BWRepositoryStreamCollectionViewCell reuseIdentifier];
    BWRepositoryStreamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                           forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    return CGSizeMake(CGRectGetWidth(screenRect), 215);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MAX;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - SDWebImageManagerDelegate Methods

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
    UIImage *resizedImage = [BWUIUtils imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
    return resizedImage;
}

#pragma mark - UISearchControllerDelegate Methods    

- (void)willPresentSearchController:(UISearchController *)searchController {
    if (_currentFilterState == kBWFilterStateShowFilters) {
        [self toggleFilters];
    }
    if (_lastSearchString) {
        searchController.searchBar.text = _lastSearchString;
    }
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    BWGithubSearchQuerySortField sortField = [_searchHeaderView currentSortField];
    BWGithubSearchQuerySortOrder sortOrder = [_searchHeaderView currentSortOrder];

    BWGithubSearchQuery *searchQuery = [[BWGithubSearchQuery alloc] initWithSearchKeywords:searchText sortField:sortField sortOrder:sortOrder];
    [self fetchRepositoriesWithSearchQuery:searchQuery];
    _searchController.active = NO;
    _lastSearchString = searchText;
}

@end
