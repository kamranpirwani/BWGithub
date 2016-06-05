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

@property(nonatomic, weak) IBOutlet UIImageView *ivOrganizationImage;
@property(nonatomic, weak) IBOutlet UILabel *lblRepositoryName;
@property(nonatomic, weak) IBOutlet UILabel *lblProjectDescription;
@property(nonatomic, weak) IBOutlet UILabel *lblStarredCount;
@property(nonatomic, weak) IBOutlet UILabel *lblForkedCount;
@property(nonatomic, weak) IBOutlet UIImageView *ivFirstContributor;

@property(nonatomic, weak) IBOutlet UIImageView *ivSecondContributor;
@property(nonatomic, weak) IBOutlet UIImageView *ivThirdContributor;
@property(nonatomic, weak) IBOutlet UILabel *lblTopContributors;

@end

static NSString *BWRepositoryStreamCollectionViewCellValidContributorText = @"TOP CONTRIBUTORS";
static NSString *BWRepositoryStreamCollectionViewCellInvalidContributorText =  @"NO CONTRIBUTORS";;

@implementation BWRepositoryStreamCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContibutorsImageViews];
}

#pragma mark - Setup

- (void)setupContibutorsImageViews {
    NSArray *imageViews = [self getContributorImageViews];
    [imageViews enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    }];
}

- (void)configureWithModel:(BWGithubRepositoryModel *)repositoryModel {
    [_ivOrganizationImage hnk_setImageFromURL:[NSURL URLWithString:repositoryModel.owner.avatarUrl]
                                  placeholder:[UIImage imageNamed:@"Owner Placeholder Image"]];
    _lblRepositoryName.text = repositoryModel.name;
    _lblProjectDescription.text = repositoryModel.projectDescription;
    _lblStarredCount.text = [BWUtils abbreviateNumber:repositoryModel.starredCount];
    _lblForkedCount.text = [BWUtils abbreviateNumber:repositoryModel.forkCount];
    
    if (repositoryModel.topContributors.count > 0) {
        NSArray *imageViews = [self getContributorImageViews];
        [imageViews enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (repositoryModel.topContributors.count > idx) {
                BWGithubContributorModel *contributor = [repositoryModel.topContributors objectAtIndex:idx];
                [imageView hnk_setImageFromURL:[NSURL URLWithString:contributor.avatarUrl]
                                   placeholder:[UIImage imageNamed:@"Github Contributon Placeholder Icon"]];
            }
        }];
    } else {
        [self setupViewWithValidContributors:NO];
    }
    
}

- (void)setupViewWithValidContributors:(BOOL)hasMoreThanOneContributor {
    _ivFirstContributor.hidden = !hasMoreThanOneContributor;
    _ivSecondContributor.hidden = !hasMoreThanOneContributor;
    _ivThirdContributor.hidden = !hasMoreThanOneContributor;
    NSString *topContributorText = hasMoreThanOneContributor ? BWRepositoryStreamCollectionViewCellValidContributorText : BWRepositoryStreamCollectionViewCellInvalidContributorText;
    _lblTopContributors.text = topContributorText;
}

#pragma mark Helpers

- (NSArray *)getContributorImageViews {
    NSArray *imageViews = @[ _ivFirstContributor, _ivSecondContributor, _ivThirdContributor];
    return imageViews;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [[self getContributorImageViews] enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageView hnk_cancelSetImage];
        imageView.image = [UIImage imageNamed:@"Github Contributon Placeholder Icon"];
    }];
    [_ivOrganizationImage hnk_cancelSetImage];
    _ivOrganizationImage.image = [UIImage imageNamed:@"Owner Placeholder Image"];
    [self setupViewWithValidContributors:YES];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
