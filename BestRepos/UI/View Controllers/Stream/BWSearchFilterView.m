//
//  BWSearchHeaderView.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWSearchFilterView.h"

@interface BWSearchFilterView()

@property(nonatomic, assign, readwrite) BWGithubSearchQuerySortField currentSortField;
@property(nonatomic, assign, readwrite) BWGithubSearchQuerySortOrder currentSortOrder;

/**
 * Maintain a collection of search filter and buttons, so adding/removing ui elements will be as simple
 * as modifying their tags
 */
@property(nonatomic, strong) IBOutletCollection(UIButton) NSArray *searchFilterButtons;
@property(nonatomic, strong) IBOutletCollection(UIButton) NSArray *searchOrderButtons;

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

static CGFloat kBWSearchFilterViewOpacityOfSelectedButton = 1.f;
static CGFloat kBWSearchFilterViewOpacityOfUnselectedButton = 0.45f;

@implementation BWSearchFilterView

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
            button.alpha = kBWSearchFilterViewOpacityOfSelectedButton;
        } else {
            button.alpha = kBWSearchFilterViewOpacityOfUnselectedButton;
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
            button.alpha = kBWSearchFilterViewOpacityOfSelectedButton;
        } else {
            button.alpha = kBWSearchFilterViewOpacityOfUnselectedButton;
        }
    }];
}

@end
