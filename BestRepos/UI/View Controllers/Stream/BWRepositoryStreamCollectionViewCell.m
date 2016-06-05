//
//  BWRepositoryStreamCollectionViewCell.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryStreamCollectionViewCell.h"
#import <Haneke.h>
#import "BWUtils.h"

@interface BWRepositoryStreamCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivOrganizationImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRepositoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblStarredCount;
@property (weak, nonatomic) IBOutlet UILabel *lblForkedCount;
@property (weak, nonatomic) IBOutlet UIImageView *ivFirstContributor;

@property(nonatomic, assign) CGRect lastKnownRect;
@property (weak, nonatomic) IBOutlet UIImageView *ivSecondContributor;
@property (weak, nonatomic) IBOutlet UIImageView *ivThirdContributor;
@property (weak, nonatomic) IBOutlet UILabel *lblTopContributors;

@end

@implementation BWRepositoryStreamCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContibutorsImageViews];
}

- (NSArray *)getContributorImageViews {
    NSArray *imageViews = @[ _ivFirstContributor, _ivSecondContributor, _ivThirdContributor];
    return imageViews;
}

- (NSArray *)getAllImageView {
    NSMutableArray *imageViews = [[self getContributorImageViews] mutableCopy];
    [imageViews addObject:_ivOrganizationImage];
    return imageViews;
}

- (void)setupContibutorsImageViews {
    NSArray *imageViews = [self getContributorImageViews];
    [imageViews enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    }];
}

- (void)configureWithModel:(BWGithubRepositoryModel *)repositoryModel {
    [_ivOrganizationImage hnk_setImageFromURL:[NSURL URLWithString:repositoryModel.owner.avatarUrl] placeholder:[UIImage imageNamed:@"Owner Placeholder Image"]];
    _lblRepositoryName.text = repositoryModel.name;
    _lblProjectDescription.text = repositoryModel.projectDescription;
    _lblStarredCount.text = [BWUtils abbreviateNumber:repositoryModel.starredCount];
    _lblForkedCount.text = [BWUtils abbreviateNumber:repositoryModel.forkCount];
    
    if (repositoryModel.topContributors.count > 0) {
        NSArray *imageViews = [self getContributorImageViews];
        [imageViews enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (repositoryModel.topContributors.count > idx) {
                BWGithubContributorModel *contributor = [repositoryModel.topContributors objectAtIndex:idx];
                [imageView hnk_setImageFromURL:[NSURL URLWithString:contributor.avatarUrl] placeholder:[UIImage imageNamed:@"Github Contributon Placeholder Icon"]];
            }
        }];
    } else {
        _ivFirstContributor.hidden = YES;
        _ivSecondContributor.hidden = YES;
        _ivThirdContributor.hidden = YES;
        _lblTopContributors.text = @"NO CONTRIBUTORS";
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [[self getContributorImageViews] enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageView hnk_cancelSetImage];
        imageView.image = [UIImage imageNamed:@"Github Contributon Placeholder Icon"];
    }];
    [_ivOrganizationImage hnk_cancelSetImage];
    _ivOrganizationImage.image = [UIImage imageNamed:@"Owner Placeholder Image"];
    _lblTopContributors.text = @"TOP CONTRIBUTORS";
    _ivFirstContributor.hidden = NO;
    _ivSecondContributor.hidden = NO;
    _ivThirdContributor.hidden = NO;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
