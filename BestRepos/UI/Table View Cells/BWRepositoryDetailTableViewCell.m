//
//  BWRepositoryDetailTableViewCell.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BWRepositoryDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfCommits;

@end

@implementation BWRepositoryDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _ivAvatar.layer.cornerRadius = _ivAvatar.frame.size.width / 2;
}

- (void)configureWithModel:(BWGithubContributorModel *)model {
    [_ivAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"Owner Placeholder Image"]];
    [_lblUsername setText:model.login];
    [_lblNumberOfCommits setText:[@(model.contributions) stringValue]];
}

- (void)prepareForReuse {
    [_ivAvatar sd_cancelCurrentImageLoad];
    _ivAvatar.image = [UIImage imageNamed:@"Github Contributon Placeholder Icon"];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
