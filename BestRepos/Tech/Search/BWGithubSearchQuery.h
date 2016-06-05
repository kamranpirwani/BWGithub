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

typedef NS_ENUM(NSInteger, BWGithubSearchQuerySortOrder) {
    kBWGithubSearchQuerySortOrderDescending,
    kBWGithubSearchQuerySortOrderAscending
};

/**
 * @class BWGithubSearchQuery
 * @brief The purpose of this class is to provide the facilities for consumers
 *        to search GitHub in a variety of different ways, and abstract all of the 
 *        API specific behavior away
 */
@interface BWGithubSearchQuery : NSObject

/**
 * A convenience initializer to form a search query searching for the most popular repositories
 * by states, in descending order
 */
+ (instancetype)mostPopularRepositoriesSearchQuery;

/**
 * The designated initializer for the search query
 * @param keywords The title of the repository
 * @param sortField The attribute we want to sort by - stars, forks, best match, or last upated
 * @param sortOrder The attribute we want to order the results by - ascending or descending
 */
- (instancetype)initWithSearchKeywords:(NSString *)keywords
                             sortField:(BWGithubSearchQuerySortField)sortField
                             sortOrder:(BWGithubSearchQuerySortOrder)sortOrder;

@property(nonatomic, readonly) NSString *keywords;
@property(nonatomic, readonly) NSString *sortFieldString;
@property(nonatomic, readonly) NSString *sortOrderString;

@end
