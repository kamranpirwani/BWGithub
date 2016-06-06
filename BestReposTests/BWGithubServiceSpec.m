//
//  BWGithubServiceSpec.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/1/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BWGithubService.h"
#import "BWGithubRepositoryModel.h"
#import "BWGithubContributorModel.h"

/**
 * @class BWGithubServiceSpec
 * @brief The purpose of this class is to test our service by hitting the real provider endpoints
 * @note  Although the calls to retrieve the top repositories AND the top contributors are two seperate calls,
 *        we abstract this away from our users - so we want to make sure this modicifation doesn't break anything
 *        In this spec, we are grouping the calls together and testing this functionality
 */
@interface BWGithubServiceSpec : XCTestCase

@end

static const NSTimeInterval kBWGithubServiceSpecTimeout = 60.f;

@implementation BWGithubServiceSpec

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetMostPopularRepositoriesAndContributorsGrouped {
    XCTestExpectation *jointExpectation = [self expectationWithDescription:@"Successfully hit real endpoint and retrieved repositories and top contributors"];
    __weak typeof(self) weakSelf = self;
    [[BWGithubService sharedInstance] searchForRepositoryWithQuery:[BWGithubSearchQuery mostPopularRepositoriesSearchQuery] callback:^(NSString *errorString, NSArray<BWGithubRepositoryModel *> *repositories) {
        XCTAssert(repositories.count > 0, @"unexpected results from repository endpoint");
        BWGithubRepositoryModel *firstRepository = [repositories firstObject];
        [weakSelf validateRepository:firstRepository];
        BWGithubContributorModel *firstContributor = [firstRepository.topContributors firstObject];
        [weakSelf validateContributor:firstContributor];
        [jointExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:kBWGithubServiceSpecTimeout handler:nil];
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
