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
#import "BWUIUtils.h"
#import "BWRepositoryDetailViewController.h"
#import "BWSearchFilterView.h"
#import "BWLoadingOverlayView.h"
#import "BWOverlayView.h"

/**
 * @enum
 * @brief An enum for the different kinds of state our ui filters can be in
 */
typedef NS_ENUM(NSInteger, BWFilterState) {
    kBWFilterStateHideFilters = 1, //The filters are hidden
    kBWFilterStateShowFilters = 2, //The filters are shown
};

static NSString *kBWRepositoryStreamViewControllerTitle = @"Best Repos";
static NSString *kBWRepositoryStreamViewControllerSearchBarPlaceholderText = @"Search for a repository by title";

@interface BWRepositoryStreamViewController () <UISearchControllerDelegate, UISearchBarDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;

/**
 * The datasource for our collection view
 */
@property(nonatomic, strong) NSArray<BWGithubRepositoryModel *> *repositories;

@property(nonatomic, strong) UISearchController *searchController;

/**
 * The last search query we performed
 * We can use this to avoid making network calls for the same queries
 */
@property(nonatomic, strong) BWGithubSearchQuery *currentSearchQuery;

/**
 * The loading overlay when we are performing a search
 */
@property(nonatomic, strong) BWLoadingOverlayView *loadingOverlayView;

/**
 * A black overlay shown when the user taps to see filters
 */
@property(nonatomic, strong) BWOverlayView *overlayView;

/**
 * The filter view used to retrieve the current search filters when querying for new data
 */
@property (weak, nonatomic) IBOutlet BWSearchFilterView *searchFilterView;

/**
 * The height constraint for our filter view
 * Used to hide and show the filters view based on user interaction
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchFilterViewHeightContraint;

/**
 * The container view we add our search bar to
 */
@property (weak, nonatomic) IBOutlet UIView *searchBarContainerView;

/**
 * The current display state for our filters
 * Used to determine if we showing or hiding them
 */
@property(nonatomic, assign) BWFilterState currentFilterState;

/**
 * The view which gives more information to the user when no searh results are found
 */
@property (weak, nonatomic) IBOutlet UIView *nullStateView;

/**
 * The label which gives more information to the user when no searh results are found
 */
@property (weak, nonatomic) IBOutlet UILabel *nullStateLabel;

@end

@implementation BWRepositoryStreamViewController {
    //Indicating whether we have already performed our initial top 100 repository fetch
    BOOL _hasFetchedInitialRepositories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarAndFilterState];
    [self registerElementsWithCollectionView];
    [self setupSearchController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /**
     * Since we are unloading from a size class, our view width and height are not
     * correct until this method call. If we place this in viewDidLoad, our loading overlay gets initialized with the
     * incorrect frame
     */
    if (!_hasFetchedInitialRepositories) {
        [self fetchRepositories];
        _hasFetchedInitialRepositories = YES;
    }
}

#pragma mark - Setup

- (void)setupNavigationBarAndFilterState {
    self.navigationItem.title = kBWRepositoryStreamViewControllerTitle;

    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(filterTapped:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    _currentFilterState = kBWFilterStateHideFilters;
}

- (void)registerElementsWithCollectionView {
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([BWRepositoryStreamCollectionViewCell class])
                                    bundle:nil];
    [_collectionView registerNib:cellNib
      forCellWithReuseIdentifier:[BWRepositoryStreamCollectionViewCell reuseIdentifier]];
}

- (void)setupSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.definesPresentationContext = YES;
    _searchController.searchBar.delegate = self;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.placeholder = kBWRepositoryStreamViewControllerSearchBarPlaceholderText;
    [_searchBarContainerView addSubview:_searchController.searchBar];
}

#pragma mark - Fetch

- (void)fetchRepositories {
    BWGithubSearchQuery *topRepositorySearchQuery = [BWGithubSearchQuery mostPopularRepositoriesSearchQuery];
    [self fetchRepositoriesWithSearchQuery:topRepositorySearchQuery];
}

- (void)fetchRepositoriesWithSearchQuery:(BWGithubSearchQuery *)searchQuery {
    //only fetch if query is different
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
    
    if (_repositories.count > 0) {
        _nullStateView.alpha = 0.f;
    } else {
        _nullStateView.alpha = 1.f;
        _nullStateLabel.text = [NSString stringWithFormat:@"No search results found for:\n%@", _currentSearchQuery.keywords];
    }
}

- (void)handleErrorFromFetch:(NSError *)error {
    //TODO handle error
}

#pragma mark - Filters

- (void)filterTapped:(UIBarButtonItem *)sender {
    [self toggleFilters];
}

/**
 * If we are hiding filters, show them
 * If we are showing filters, hide them
 */
- (void)toggleFilters {
    if (_currentFilterState == kBWFilterStateHideFilters) {
        _currentFilterState = kBWFilterStateShowFilters;
        [self showFilters];
    } else if (_currentFilterState == kBWFilterStateShowFilters) {
        _currentFilterState = kBWFilterStateHideFilters;
        [self hideFilters];
    }
}

- (void)hideFilters {
    [_overlayView dismissWithCallback:^{
        _searchFilterViewHeightContraint.constant = 0.f;
        [_collectionView setScrollEnabled:YES];
        [UIView animateWithDuration:0.15f animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
    _overlayView = nil;
}

- (void)showFilters {
    [self createOverlayForFilters];
    //In the event that the user is scrolling when tapping filter, immediately stop scrolling
    //to the current content offset so we don't experience any ui weirdness
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    [_overlayView showWithCallback:^{
        [_collectionView setScrollEnabled:NO];
        _searchFilterViewHeightContraint.constant = 125;
        [UIView animateWithDuration:0.15f animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}

- (void)createOverlayForFilters {
    _overlayView = [[BWOverlayView alloc] initWithParentView:self.collectionView
                                             backgroundColor:[UIColor blackColor]
                                                       alpha:0.8];
    __weak typeof(self) weakSelf = self;
    [_overlayView setTapCallback:^{
        [weakSelf toggleFilters];
    }];
}

#pragma mark - Loading

- (void)showLoadingSpinner:(BOOL)showSpinner {
    if (showSpinner) {
        _nullStateView.alpha = 0.f;
        //If we are performing a fetch while one is already in progress, lets dismiss that loading view first
        if (_loadingOverlayView) {
            [_loadingOverlayView dismissWithCallback:nil];
        }
        _loadingOverlayView = [[BWLoadingOverlayView alloc] initWithParentView:self.collectionView backgroundColor:[UIColor blackColor] alpha:1.f];
        [_loadingOverlayView showWithCallback:nil];
    } else {
        [_loadingOverlayView dismissWithCallback:nil];
        _loadingOverlayView = nil;
    }
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
    return CGSizeMake(CGRectGetWidth(screenRect), kBWRepositoryStreamCollectionViewCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MAX;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UISearchControllerDelegate Methods    

- (void)willPresentSearchController:(UISearchController *)searchController {
    if (_currentFilterState == kBWFilterStateShowFilters) {
        [self toggleFilters];
    }
    if (_currentSearchQuery) {
        searchController.searchBar.text = _currentSearchQuery.keywords;
    }
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    BWGithubSearchQuerySortField sortField = [_searchFilterView currentSortField];
    BWGithubSearchQuerySortOrder sortOrder = [_searchFilterView currentSortOrder];

    BWGithubSearchQuery *searchQuery = [[BWGithubSearchQuery alloc] initWithSearchKeywords:searchText
                                                                                 sortField:sortField
                                                                                 sortOrder:sortOrder];
    [self fetchRepositoriesWithSearchQuery:searchQuery];
    //dismiss our search bar animation
    _searchController.active = NO;
}

@end
