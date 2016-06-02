//
//  BWGithubProviderSpec.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BWGithubProvider.h"
#import "BWGithubRepositoryModel_Internal.h"
#import "BWGithubContributorModel_Internal.h"
#import "BWProviderUtils.h"
#import "BWGithubSearchQuery.h"

@interface BWGithubProviderSpec : XCTestCase

@end

static const NSTimeInterval kBWGithubProviderSpecTimeout = 60.f;


@implementation BWGithubProviderSpec {
    BWGithubProvider *_provider;
}

- (void)setUp {
    [super setUp];
    _provider = [[BWGithubProvider alloc] initWithQueue:[BWProviderUtils networkingSerialQueue]];
}

- (void)tearDown {
    _provider = nil;
    [super tearDown];
}

- (void)testGetMostPopularRepositoriesAndContributors {
    XCTestExpectation *repositoryExpectation = [self expectationWithDescription:@"Successfully hit real endpoint and retrieved repositories"];
    XCTestExpectation *contributorExpectation = [self expectationWithDescription:@"Successfully hit real endpoint and retrieved contributors"];

    __weak typeof(self) weakSelf = self;
    
    BWGithubSearchQuery *searchQuery = [BWGithubSearchQuery mostPopularRepositoriesSearchQuery];
    
    [_provider searchForRepositoryWithQuery:searchQuery callback:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
        XCTAssert(repositories.count > 0, @"unexpected results from repository endpoint");
        BWGithubRepositoryModel *firstRepository = [repositories firstObject];
        [weakSelf validateRepository:firstRepository];
        [repositoryExpectation fulfill];
        
        [_provider getTopContributorsFromRepository:firstRepository callback:^(NSError *error, NSArray<BWGithubContributorModel *> *contributors) {
            XCTAssert(contributors.count > 0, @"unexpected results from contributor endpoint");
            BWGithubContributorModel *firstContributor = [contributors firstObject];
            [weakSelf validateContributor:firstContributor];
            [contributorExpectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:kBWGithubProviderSpecTimeout handler:nil];
}

- (void)validateRepository:(BWGithubRepositoryModel *)repository {
    XCTAssert(repository.identifier > 0, @"unexpected repository id in response");
    XCTAssertNotNil(repository.name, @"unexpected repository name in response");
    XCTAssertNotNil(repository.fullName, @"unexpected repository full name in response");
    XCTAssertNotNil(repository.htmlUrl, @"unexpected repository html url in response");
    XCTAssertNotNil(repository.projectDescription, @"unexpected repository project description in response");
    XCTAssertNotNil(repository.contributorsUrl, @"unexpected repository contributors url in response");
    //We can make this assumption because we filtered our network query for stars > 0, and these should be VERY high numbers in the response anyways
    XCTAssert(repository.starredCount > 0, @"unexpected repository star count in response");
}

- (void)validateContributor:(BWGithubContributorModel *)contributor {
    XCTAssert(contributor.identifier > 0, @"unexpected contributor id in response");
    XCTAssertNotNil(contributor.login, @"unexpected contributor login in response");
    XCTAssertNotNil(contributor.avatarUrl, @"unexpected contributor avatarUrl in response");
}

@end
