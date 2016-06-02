//
//  BWGithubParserTest.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BWGithubParser.h"
#import "BWGithubMockProvider.h"
#import "BWGithubRepositoryModel_Internal.h"
#import "BWGithubContributorModel_Internal.h"
#import "BWGithubBarebonesUserModel_Internal.h"

@interface BWGithubParserSpec : XCTestCase

@end

static const NSTimeInterval kBWGithubParserSpecTimeout = 30.f;

@implementation BWGithubParserSpec {
    BWGithubMockProvider *_mockProvider;
}

- (void)setUp {
    [super setUp];
    _mockProvider = [[BWGithubMockProvider alloc] init];
}

- (void)tearDown {
    _mockProvider = nil;
    [super tearDown];
}

#pragma mark - Test Methods

- (void)testHandleTopMostPopularRepositoriesFetch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Successfully parsed repositories"];
    
    BWGithubRepositoryModel *repositoryModel = [self getExpectedRepositoryModel];

    [_mockProvider searchForRepositoryWithQuery:nil callback:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
        XCTAssert(repositories.count == 1, @"unexpected repository count in mock json");
        BWGithubRepositoryModel *responseModel = [repositories firstObject];
        XCTAssertEqual(repositoryModel.identifier, responseModel.identifier, @"unexpected repository id in mock json");
        XCTAssertEqualObjects(repositoryModel.name, responseModel.name, @"unexpected repository name in mock json");
        XCTAssertEqualObjects(repositoryModel.fullName, responseModel.fullName, @"unexpected repository full name in mock json");
        XCTAssertEqualObjects(repositoryModel.htmlUrl, responseModel.htmlUrl, @"unexpected repository html name in mock json");
        XCTAssertEqualObjects(repositoryModel.projectDescription, responseModel.projectDescription, @"unexpected repository project description in mock json");
        XCTAssertEqualObjects(repositoryModel.contributorsUrl, responseModel.contributorsUrl, @"unexpected repository contributors url in mock json");
        XCTAssertEqual(repositoryModel.forkCount, responseModel.forkCount, @"unexpected repository fork count in mock json");
        XCTAssertEqual(repositoryModel.starredCount, responseModel.starredCount, @"unexpected repository starred count in mock json");
        XCTAssertEqual(repositoryModel.watchersCount, responseModel.watchersCount, @"unexpected repository watchers count in mock json");

        BWGithubBarebonesUserModel *expectedOwnerModel = [self getExpectedOwnerModel];
        BWGithubBarebonesUserModel *ownerReponseModel = responseModel.owner;
        XCTAssertEqual(expectedOwnerModel.identifier, ownerReponseModel.identifier, @"unexpected owner id in mock json");
        XCTAssertEqualObjects(expectedOwnerModel.login, ownerReponseModel.login, @"unexpected owner login in mock json");
        XCTAssertEqualObjects(expectedOwnerModel.avatarUrl, ownerReponseModel.avatarUrl, @"unexpected owner avatar url in mock json");

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kBWGithubParserSpecTimeout handler:nil];
}

- (void)testHandleTopContributorsFromRepositoryFetch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Successfully parsed top contributors"];
    
    BWGithubContributorModel *contributorModel = [self getExpectedContributorModel];
    
    [_mockProvider getTopContributorsFromRepository:nil callback:^(NSError *error, NSArray<BWGithubContributorModel *> *contributors) {
        XCTAssert(contributors.count == 1, @"unexpected contributor count in mock json");
        BWGithubContributorModel *responseModel = [contributors firstObject];
        XCTAssertEqual(contributorModel.identifier, responseModel.identifier, @"unexpected contributor id in mock json");
        XCTAssertEqualObjects(contributorModel.login, contributorModel.login, @"unexpected contributor login in mock json");
        XCTAssertEqualObjects(contributorModel.avatarUrl, contributorModel.avatarUrl, @"unexpected contributor avatar url in mock json");
        XCTAssertEqual(contributorModel.contributions, contributorModel.contributions, @"unexpected contributor contributions in mock json");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kBWGithubParserSpecTimeout handler:nil];
}

#pragma mark - Expected Model Helpers

- (BWGithubRepositoryModel *)getExpectedRepositoryModel {
    BWGithubRepositoryModel *repositoryModel = [[BWGithubRepositoryModel alloc] init];
    repositoryModel.identifier = 28457823;
    repositoryModel.name = @"FreeCodeCamp";
    repositoryModel.fullName = @"FreeCodeCamp/FreeCodeCamp";
    repositoryModel.htmlUrl = @"https://github.com/FreeCodeCamp/FreeCodeCamp";
    repositoryModel.projectDescription = @"The https://FreeCodeCamp.com open source codebase and curriculum. Learn to code and help nonprofits.";
    repositoryModel.contributorsUrl= @"https://api.github.com/repos/FreeCodeCamp/FreeCodeCamp/contributors";
    repositoryModel.forkCount = 4655;
    repositoryModel.starredCount = 131833;
    repositoryModel.watchersCount = 131833;
    return repositoryModel;
}

- (BWGithubBarebonesUserModel *)getExpectedOwnerModel {
    BWGithubBarebonesUserModel *ownerModel = [[BWGithubBarebonesUserModel alloc] init];
    ownerModel.login = @"FreeCodeCamp";
    ownerModel.identifier = 9892522;
    ownerModel.avatarUrl = @"https://avatars.githubusercontent.com/u/9892522?v=3";
    return ownerModel;
}

- (BWGithubContributorModel *)getExpectedContributorModel {
    BWGithubContributorModel *contributorModel = [[BWGithubContributorModel alloc] init];
    contributorModel.identifier = 985197;
    contributorModel.login = @"QuincyLarson";
    contributorModel.avatarUrl = @"https://avatars.githubusercontent.com/u/985197?v=3";
    contributorModel.contributions = 2263;
    return contributorModel;
}

@end
