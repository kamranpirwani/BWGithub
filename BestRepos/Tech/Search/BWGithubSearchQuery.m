//
//  BWGithubSearchQuery.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubSearchQuery.h"

static NSString *const kBWGithubSearchQueryPrettySortFieldBestMatch = @"Best Match";
static NSString *const kBWGithubSearchQueryPrettySortFieldStars = @"Stars";
static NSString *const kBWGithubSearchQueryPrettySortFieldForks = @"Forks";
static NSString *const kBWGithubSearchQueryPrettySortFieldUpdated = @"Updated";

@implementation BWGithubSearchQuery

- (instancetype)initWithSearchKeywords:(NSString *)keywords
                             sortField:(BWGithubSearchQuerySortField)sortField
                             sortOrder:(BWGithubSortOrder)sortOrder {
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
                                                                                 sortOrder:kBWGithubSortOrderDescending];
    return searchQuery;
}

+ (NSArray <NSString *> *)allPrettySortFieldStrings {
    return @[kBWGithubSearchQueryPrettySortFieldStars,
             kBWGithubSearchQueryPrettySortFieldBestMatch,
             kBWGithubSearchQueryPrettySortFieldForks,
             kBWGithubSearchQueryPrettySortFieldUpdated
             ];
}

+ (NSString *)prettyStringFromSortField:(BWGithubSearchQuerySortField)sortField {
    switch (sortField) {
        case kBWGithubSearchQuerySortForks:
            return kBWGithubSearchQueryPrettySortFieldForks;
        case kBWGithubSearchQuerySortStars:
            return kBWGithubSearchQueryPrettySortFieldStars;
        case kBWGithubSearchQuerySortUpdated:
            return kBWGithubSearchQueryPrettySortFieldUpdated;
        case kBWGithubSearchQuerySortBestMatch:
        default:
            return kBWGithubSearchQueryPrettySortFieldBestMatch;
    }
}

+ (BWGithubSearchQuerySortField)sortFieldFromPrettyString:(NSString *)prettyString {
    if ([prettyString isEqualToString:kBWGithubSearchQueryPrettySortFieldForks]) {
        return kBWGithubSearchQuerySortForks;
    } else if ([prettyString isEqualToString:kBWGithubSearchQueryPrettySortFieldStars]) {
        return kBWGithubSearchQuerySortStars;
    } else if ([prettyString isEqualToString:kBWGithubSearchQueryPrettySortFieldUpdated]) {
        return kBWGithubSearchQuerySortUpdated;
    } else {
        return kBWGithubSearchQuerySortBestMatch;
    }
}

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

- (void)setupSortOrderStringWithSortOrderEnum:(BWGithubSortOrder)sortOrder {
    switch (sortOrder) {
        case kBWGithubSortOrderAscending:
            _sortOrderString = @"asc";
            break;
        case kBWGithubSortOrderDescending:
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
