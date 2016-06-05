//
//  BWRepositoryHeaderView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWRepositoryHeaderView.h"
#import <Haneke.h>

@interface BWRepositoryHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *ivRepositoryImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRepositoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblProgrammingLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation BWRepositoryHeaderView

- (instancetype)initWithModel:(BWGithubRepositoryModel *)model {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    [self setupWithModel:model];
    return self;
}

- (void)setupWithModel:(BWGithubRepositoryModel *)model {
    [self.lblRepositoryName setText:model.name];
    [self.lblProgrammingLanguage setText:model.language];
    NSURL *imageUrl = [NSURL URLWithString:model.owner.avatarUrl];
    [_ivRepositoryImage hnk_setImageFromURL:imageUrl
                       placeholder:[UIImage imageNamed:@"Owner Placeholder Image"]];
    _ivRepositoryImage.layer.cornerRadius = 9.f;
    _lblDescription.text = model.projectDescription;
    CGRect textRect = [_lblDescription.text boundingRectWithSize:CGSizeMake(self.bounds.size.height, 1000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:_lblDescription.font}
                                                         context:nil];
    textRect = CGRectIntegral(textRect);
    _lblDescription.frame = CGRectMake(CGRectGetMinX(_lblDescription.frame), CGRectGetMinY(_lblDescription.frame), textRect.size.width, textRect.size.height);
    
}

- (CGSize)intrinsicContentSize {

    CGFloat maxYPointOfLastElement = CGRectGetMaxY(_lblDescription.frame);
    CGFloat padding = 10;
    return CGSizeMake(self.bounds.size.width, maxYPointOfLastElement + padding);
}

@end
