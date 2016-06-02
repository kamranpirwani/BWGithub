//
//  BWGithubSearchQuery.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubSearchQuery.h"

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
    BWGithubSearchQuery *searchQuery = [[BWGithubSearchQuery alloc] initWithSearchKeywords:nil
                                                                                 sortField:kBWGithubSearchQuerySortStars
                                                                                 sortOrder:kBWGithubSortOrderDescending];
    return searchQuery;
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



@end
