//
//  BWRootViewController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRootViewController.h"
#import "BWRepositoryStreamCollectionViewCell.h"
#import "BWGithubService.h"
#import "SDWebImageManager.h"
#import "BWUtils.h"

@interface BWRootViewController () <SDWebImageManagerDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<BWGithubRepositoryModel *> *repositories;

@property(nonatomic, assign) CGSize calculatedNormalCellSize;

@property(nonatomic, strong) NSIndexPath *indexPathOfFocusedCell;

@end

@implementation BWRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageDownloader];
    [self calculateCellSizes];
    [self registerCellWithCollectionView];
    [self fetchRepositories];
}

- (void)setupImageDownloader {
    [[SDWebImageManager sharedManager] setDelegate:self];
    [[[SDWebImageManager sharedManager] imageCache] setShouldDecompressImages:NO];
    [[[SDWebImageManager sharedManager] imageCache] setShouldCacheImagesInMemory:NO];
}

- (void)calculateCellSizes {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat padding = 20.f;

    CGFloat calculatedWidth = screenSize.size.width - padding * 2;
    _calculatedNormalCellSize = CGSizeMake(calculatedWidth, 238);
}

- (void)registerCellWithCollectionView {
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([BWRepositoryStreamCollectionViewCell class])
                                    bundle:nil];
    [_collectionView registerNib:cellNib
      forCellWithReuseIdentifier:[BWRepositoryStreamCollectionViewCell reuseIdentifier]];
}

- (void)fetchRepositories {
    __weak typeof(self) weakSelf = self;
    [[BWGithubService sharedInstance] getMostPopularRepositoriesAndTheirTopContributors:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
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

#pragma mark SDWebImageManagerDelegate Methods

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
    UIImage *resizedImage = [BWUtils imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
    return resizedImage;
}

@end
