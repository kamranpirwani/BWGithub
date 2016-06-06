//
//  BWGithubSearchQuery.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubSearchQuery.h"

@implementation BWGithubSearchQuery

#pragma mark - Initializers

- (instancetype)initWithSearchKeywords:(NSString *)keywords
                             sortField:(BWGithubSearchQuerySortField)sortField
                             sortOrder:(BWGithubSearchQuerySortOrder)sortOrder {
    self = [super init];
    if (self) {
        _keywords = keywords;
        [self setupSortFieldStringWithSortFieldEnum:sortField];
        [self setupSortOrderStringWithSortOrderEnum:sortOrder];
        
    }
    return self;
}

+ (instancetype)mostPopularRepositoriesSearchQuery {
    BWGithubSearchQuery *searchQuery = [[BWGithubSearchQuery alloc] initWithSearchKeywords:@""
                                                                                 sortField:kBWGithubSearchQuerySortStars
                                                                                 sortOrder:kBWGithubSearchQuerySortOrderDescending];
    return searchQuery;
}

#pragma mark - Helpers

- (void)setupSortFieldStringWithSortFieldEnum:(BWGithubSearchQuerySortField)sortField {
    switch (sortField) {
        case kBWGithubSearchQuerySortForks:
            _sortFieldString = @"forks";
            break;
        case kBWGithubSearchQuerySortStars:
            _sortFieldString = @"stars";
            break;
        case kBWGithubSearchQuerySortUpdated:
            _sortFieldString = @"updated";
            break;
            
        case kBWGithubSearchQuerySortBestMatch:
        default:
            //default behavior for GitHub
            _sortFieldString = @"";
            break;
    }
}

- (void)setupSortOrderStringWithSortOrderEnum:(BWGithubSearchQuerySortOrder)sortOrder {
    switch (sortOrder) {
        case kBWGithubSearchQuerySortOrderAscending:
            _sortOrderString = @"asc";
            break;
        case kBWGithubSearchQuerySortOrderDescending:
        //default behavior for GitHub
        default:
            _sortOrderString = @"desc";
            break;
    }
}

- (BOOL)isEqual:(id)object {
    BWGithubSearchQuery *otherQuery = (BWGithubSearchQuery *)object;
    BOOL areKeywordsEqual = [_keywords isEqualToString:otherQuery.keywords];
    if (!areKeywordsEqual) {
        return NO;
    }
    
    BOOL areSortFieldsEqual = [_sortFieldString isEqualToString:otherQuery.sortFieldString];
    if (!areSortFieldsEqual) {
        return NO;
    }
    
    BOOL areSortOrdersEqual = [_sortOrderString isEqualToString:otherQuery.sortOrderString];
    if (!areSortOrdersEqual) {
        return NO;
    }
    return YES;
}



@end
