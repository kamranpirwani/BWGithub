//
//  BWRepositoryDetailTableViewCell.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryDetailTableViewCell.h"
#import <Haneke.h>

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
    [_ivAvatar hnk_setImageFromURL:[NSURL URLWithString:model.avatarUrl] placeholder:[UIImage imageNamed:@"Owner Placeholder Image"]];
    [_lblUsername setText:model.login];
    [_lblNumberOfCommits setText:[@(model.contributions) stringValue]];
}

- (void)prepareForReuse {
    [_ivAvatar hnk_cancelSetImage];
    _ivAvatar.image = [UIImage imageNamed:@"Github Contributon Placeholder Icon"];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
