//
//  BWRepositoryStreamCollectionViewCell.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryStreamCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BWUtils.h"

@interface BWRepositoryStreamCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivOrganizationImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRepositoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblStarredCount;
@property (weak, nonatomic) IBOutlet UILabel *lblForkedCount;
@property (weak, nonatomic) IBOutlet UILabel *lblWatchedCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOwner;
@property (weak, nonatomic) IBOutlet UIImageView *ivFirstContributor;

@property(nonatomic, assign) CGRect lastKnownRect;
@property (weak, nonatomic) IBOutlet UIImageView *ivSecondContributor;
@property (weak, nonatomic) IBOutlet UIImageView *ivThirdContributor;

@end

@implementation BWRepositoryStreamCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addDropShadow];
    [self setupContibutorsImageViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self shouldAddDropShadow]) {
        [self addDropShadow];
    }
}

- (NSArray *)getContributorImageViews {
    NSArray *imageViews = @[ _ivFirstContributor, _ivSecondContributor, _ivThirdContributor];
    return imageViews;
}

- (void)setupContibutorsImageViews {
    NSArray *imageViews = [self getContributorImageViews];
    [imageViews enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    }];
}

- (BOOL)shouldAddDropShadow {
    BOOL containsShadow = self.layer.shadowPath != nil;
    BOOL hasBoundsChanged = !CGRectEqualToRect(_lastKnownRect, self.bounds);
    return !containsShadow || hasBoundsChanged;
}

- (void)addDropShadow {
    _lastKnownRect = self.bounds;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)configureWithModel:(BWGithubRepositoryModel *)repositoryModel {
    [_ivOrganizationImage sd_setImageWithURL:[NSURL URLWithString:repositoryModel.owner.avatarUrl] placeholderImage:[UIImage imageNamed:@"Owner Placeholder Image"]];
    _lblRepositoryName.text = repositoryModel.name;
    _lblProjectDescription.text = repositoryModel.projectDescription;
    _lblStarredCount.text = [BWUtils abbreviateNumber:repositoryModel.starredCount];
    _lblForkedCount.text = [BWUtils abbreviateNumber:repositoryModel.forkCount];
    _lblWatchedCount.text = [BWUtils abbreviateNumber:repositoryModel.watchersCount];
    
    if (repositoryModel.topContributors.count > 0) {
        NSArray *imageViews = [self getContributorImageViews];
        [imageViews enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (repositoryModel.topContributors.count > idx) {
                BWGithubContributorModel *contributor = [repositoryModel.topContributors objectAtIndex:idx];
                [imageView sd_setImageWithURL:[NSURL URLWithString:contributor.avatarUrl] placeholderImage:[UIImage imageNamed:@"Github Contributon Placeholder Icon"]];
            }
        }];
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_ivOrganizationImage sd_cancelCurrentImageLoad];
    [_ivFirstContributor sd_cancelCurrentImageLoad];
    [_ivSecondContributor sd_cancelCurrentImageLoad];
    [_ivThirdContributor sd_cancelCurrentImageLoad];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
