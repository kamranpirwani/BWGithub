//
//  BWGithubSearchQuery.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BWGithubSearchQuerySortField) {
    kBWGithubSearchQuerySortBestMatch,
    kBWGithubSearchQuerySortStars,
    kBWGithubSearchQuerySortForks,
    kBWGithubSearchQuerySortUpdated
};

typedef NS_ENUM(NSInteger, BWGithubSortOrder) {
    kBWGithubSortOrderDescending,
    kBWGithubSortOrderAscending
};

@interface BWGithubSearchQuery : NSObject

+ (instancetype)mostPopularRepositoriesSearchQuery;

- (instancetype)initWithSearchKeywords:(NSString *)keywords
                             sortField:(BWGithubSearchQuerySortField)sortField
                             sortOrder:(BWGithubSortOrder)sortOrder;

@property(nonatomic, readonly) NSString *keywords;
@property(nonatomic, readonly) NSString *sortFieldString;
@property(nonatomic, readonly) NSString *sortOrderString;

@end
