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
#import "BWGithubUserModel_Internal.h"

/**
 * @class BWGithubParserSpec
 * @brief The purpose of this class is to test whether our parser logic is working correctly
 *        by checking the well formed model objects from our mock providers against models we have
 *        created by matching what is in the mock json
 */
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
        XCTAssertEqualObjects(repositoryModel.language, responseModel.language, @"unexpected repository language in mock json");

        BWGithubBarebonesUserModel *expectedOwnerModel = [self getExpectedOwnerModel];
        BWGithubBarebonesUserModel *ownerReponseModel = responseModel.owner;
        XCTAssertEqual(expectedOwnerModel.identifier, ownerReponseModel.identifier, @"unexpected owner id in mock json");
        XCTAssertEqualObjects(expectedOwnerModel.login, ownerReponseModel.login, @"unexpected owner login in mock json");
        XCTAssertEqualObjects(expectedOwnerModel.avatarUrl, ownerReponseModel.avatarUrl, @"unexpected owner avatar url in mock json");
        XCTAssertEqualObjects(expectedOwnerModel.profileUrl, ownerReponseModel.profileUrl, @"unexpected owner profile url in mock json");

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

- (void)testHandleUserProfileFetch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Successfully parsed user profile"];

    BWGithubUserModel *expectedUserModel = [self getExpectedUserModel];
    
    [_mockProvider getUserProfileFromBarebonesUserModel:nil callback:^(NSError *error, BWGithubUserModel *user) {
        XCTAssertEqual(expectedUserModel.identifier, user.identifier, @"unexpected user id in mock json");
        XCTAssertEqualObjects(expectedUserModel.login, user.login, @"unexpected user login in mock json");
        XCTAssertEqualObjects(expectedUserModel.avatarUrl, user.avatarUrl, @"unexpected user avatar url in mock json");
        XCTAssertEqualObjects(expectedUserModel.profileUrl, user.profileUrl, @"unexpected user profile url in mock json");
        XCTAssertEqualObjects(expectedUserModel.type, user.type, @"unexpected user type in mock json");
        XCTAssertEqualObjects(expectedUserModel.name, user.name, @"unexpected user name in mock json");
        XCTAssertEqual(expectedUserModel.numberOfPublicRepositories, user.numberOfPublicRepositories, @"unexpected user number of public repos in mock json");
        XCTAssertEqual(expectedUserModel.followers, user.followers, @"unexpected user followers in mock json");
        XCTAssertEqual(expectedUserModel.following, user.following, @"unexpected user following in mock json");
        XCTAssertEqualObjects(expectedUserModel.location, user.location, @"unexpected user location in mock json");
        XCTAssertEqualObjects(expectedUserModel.bio, user.bio, @"unexpected user bio in mock json");

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
    repositoryModel.language = @"JavaScript";
    return repositoryModel;
}

- (BWGithubBarebonesUserModel *)getExpectedOwnerModel {
    BWGithubBarebonesUserModel *ownerModel = [[BWGithubBarebonesUserModel alloc] init];
    ownerModel.login = @"FreeCodeCamp";
    ownerModel.identifier = 9892522;
    ownerModel.avatarUrl = @"https://avatars.githubusercontent.com/u/9892522?v=3";
    ownerModel.profileUrl = @"https://api.github.com/users/FreeCodeCamp";
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

- (BWGithubUserModel *)getExpectedUserModel {
    BWGithubUserModel *userModel = [[BWGithubUserModel alloc] init];
    userModel.identifier = 985197;
    userModel.login = @"QuincyLarson";
    userModel.avatarUrl = @"https://avatars.githubusercontent.com/u/985197?v=3";
    userModel.profileUrl = @"https://api.github.com/users/QuincyLarson";
    userModel.type = @"User";
    userModel.name = @"Quincy Larson";
    userModel.numberOfPublicRepositories = 22;
    userModel.followers = 932;
    userModel.following = 13;
    userModel.location = @"San Francisco, California, US";
    userModel.bio = @"I'm a teacher at Free Code Camp. I write articles about technology at medium.com/@quincylarson and quora.com/profile/Quincy-Larson";

    return userModel;
}

@end
