//
//  BWSearchHeaderView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWSearchHeaderView.h"

@interface BWSearchHeaderView()

@property(nonatomic, assign, readwrite) BWGithubSearchQuerySortField currentSortField;
@property(nonatomic, assign, readwrite) BWGithubSearchQuerySortOrder currentSortOrder;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *searchFilterButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *searchOrderButtons;

@property (weak, nonatomic) IBOutlet UIView *searchBarContainerView;

@end

typedef NS_ENUM(NSInteger, BWSearchFilterButtonTag) {
    kBWSearchFilterButtonTagStars = 1,
    kBWSearchFilterButtonTagForks,
    kBWSearchFilterButtonTagLastUpdated,
    kBWSearchFilterButtonTagBestMatch
};

typedef NS_ENUM(NSInteger, BWSearchOrderButtonTag) {
    kBWSearchOrderButtonTagDescending = 1,
    kBWSearchOrderButtonTagAscending
};


@implementation BWSearchHeaderView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    [self setupInitialState];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *nib = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        [self addSubview:nib];
        [self setupInitialState];
    }
    return self;
}

- (void)setupInitialState {
    BWSearchFilterButtonTag searchFilterTag = kBWSearchFilterButtonTagStars;
    [self updateCurrentSortFieldWithTag:searchFilterTag];
    [self updateSortFilterButtonStatesWithTag:searchFilterTag];
    
    BWSearchOrderButtonTag searchOrderTag = kBWSearchOrderButtonTagDescending;
    [self updateCurrentSortOrderWithTag:searchOrderTag];
    [self updateSortOrderButtonStatesWithTag:searchOrderTag];
}

- (IBAction)searchFilterButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    BWSearchFilterButtonTag tag = button.tag;
    [self updateCurrentSortFieldWithTag:tag];
    [self updateSortFilterButtonStatesWithTag:tag];
}

- (void)updateCurrentSortFieldWithTag:(BWSearchFilterButtonTag)tag {
    BWGithubSearchQuerySortField sortField;
    switch (tag) {
        case kBWSearchFilterButtonTagStars:
            sortField = kBWGithubSearchQuerySortStars;
            break;
        case kBWSearchFilterButtonTagForks:
            sortField = kBWGithubSearchQuerySortForks;
            break;
        case kBWSearchFilterButtonTagLastUpdated:
            sortField = kBWGithubSearchQuerySortUpdated;
            break;
        case kBWSearchFilterButtonTagBestMatch:
        default:
            sortField = kBWGithubSearchQuerySortBestMatch;
            break;
    }
    _currentSortField = sortField;
}

- (void)updateSortFilterButtonStatesWithTag:(BWSearchFilterButtonTag)tag {
    [_searchFilterButtons enumerateObjectsUsingBlock:^(UIButton  *_Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button.tag == tag) {
            button.alpha = 1.f;
        } else {
            button.alpha = 0.45f;
        }
    }];
}

- (IBAction)searchOrderButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    BWSearchOrderButtonTag tag = button.tag;
    [self updateCurrentSortOrderWithTag:tag];
    [self updateSortOrderButtonStatesWithTag:tag];
}

- (void)updateCurrentSortOrderWithTag:(BWSearchOrderButtonTag)tag {
    BWGithubSearchQuerySortOrder sortOrder;
    switch (tag) {
        case kBWSearchOrderButtonTagAscending:
            sortOrder = kBWGithubSearchQuerySortOrderAscending;
            break;
        case kBWSearchOrderButtonTagDescending:
        default:
            sortOrder = kBWGithubSearchQuerySortOrderDescending;
            break;
    }
    _currentSortOrder = sortOrder;
}

- (void)updateSortOrderButtonStatesWithTag:(BWSearchOrderButtonTag)tag {
    [_searchOrderButtons enumerateObjectsUsingBlock:^(UIButton  *_Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button.tag == tag) {
            button.alpha = 1.f;
        } else {
            button.alpha = 0.45f;
        }
    }];
}

@end
