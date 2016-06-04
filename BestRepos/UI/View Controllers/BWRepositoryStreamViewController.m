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
#import "BWUtils.h"
#import "BWRepositoryDetailViewController.h"
#import "BWSearchHeaderView.h"

@interface BWRepositoryStreamViewController () <SDWebImageManagerDelegate, UISearchControllerDelegate, UISearchBarDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<BWGithubRepositoryModel *> *repositories;

@property(nonatomic, assign) CGSize calculatedNormalCellSize;

@property(nonatomic, strong) UISearchController *searchController;

@property(nonatomic, strong) BWGithubSearchQuery *currentSearchQuery;
@property(nonatomic, assign) BWGithubSearchQuerySortField currentSearchScope;

@property(nonatomic, strong) NSString *lastSearchString;

@end

@implementation BWRepositoryStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"BestRepos";
    [self setupImageDownloader];
    [self setupSearchController];
    [self calculateCellSizes];
    [self registerElementsWithCollectionView];
    [self fetchRepositories];
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
    _searchController.searchBar.scopeButtonTitles = [BWGithubSearchQuery allPrettySortFieldStrings];
    _searchController.searchBar.placeholder = @"Search for a repository by title";
}

- (void)calculateCellSizes {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat padding = 20.f;

    CGFloat calculatedWidth = screenSize.size.width - padding * 2;
    _calculatedNormalCellSize = CGSizeMake(calculatedWidth, 238);
}

- (void)registerElementsWithCollectionView {
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([BWRepositoryStreamCollectionViewCell class])
                                    bundle:nil];
    [_collectionView registerNib:cellNib
      forCellWithReuseIdentifier:[BWRepositoryStreamCollectionViewCell reuseIdentifier]];
    [_collectionView registerClass:[BWSearchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BWSearchHeaderView reuseIdentifier]];
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
    _currentSearchQuery = searchQuery;
    __weak typeof(self) weakSelf = self;
    [[BWGithubService sharedInstance] searchForRepositoryWithQuery:searchQuery callback:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
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
    cell.frame = ({
        CGRect newFrame = cell.frame;
        newFrame.size = _calculatedNormalCellSize;
        newFrame;
    });
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

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BWSearchHeaderView reuseIdentifier] forIndexPath:indexPath];
    [reusableView addSubview:_searchController.searchBar];
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return _searchController.searchBar.bounds.size;
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _calculatedNormalCellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MAX;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark - SDWebImageManagerDelegate Methods

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
    UIImage *resizedImage = [BWUtils imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
    return resizedImage;
}

#pragma mark - UISearchControllerDelegate Methods    

- (void)willPresentSearchController:(UISearchController *)searchController {
    if (_lastSearchString) {
        searchController.searchBar.text = _lastSearchString;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSString *scope = [searchBar.scopeButtonTitles objectAtIndex:searchBar.selectedScopeButtonIndex];
    BWGithubSearchQuerySortField sortField = [BWGithubSearchQuery sortFieldFromPrettyString:scope];
    BWGithubSearchQuery *searchQuery = [[BWGithubSearchQuery alloc] initWithSearchKeywords:searchText sortField:sortField sortOrder:kBWGithubSortOrderDescending];
    [self fetchRepositoriesWithSearchQuery:searchQuery];
    _searchController.active = NO;
    _lastSearchString = searchText;
}

@end
