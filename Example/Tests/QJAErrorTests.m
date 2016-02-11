//
//  QJAErrorTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 11/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAError.h"

@interface QJAErrorTests : XCTestCase{

    QJAError *_sut;
}

@end

@implementation QJAErrorTests

- (NSDictionary *) mockErrorData{
    
    return @{
             @"id" : @"error-1234",
             @"status" : @"status-1234",
             @"code" : @"code-1234",
             @"title" : @"mock error title",
             @"detail" : @"mock error detail",
             @"links" : @{@"mock-links":@"mock-value"},
             @"source" : @{@"mock-source":@"mock-value"},
             @"meta" : @{@"mock-meta":@"mock-value"}
             };
    
}

- (void)setUp {
    [super setUp];
    _sut = [[QJAError alloc] initWithDictionary:[self mockErrorData]];
}

- (void)tearDown {
    _sut = nil;
    [super tearDown];
}

- (void) testThatQJAErrorInitializesWithDictionary{
    XCTAssertNotNil(_sut);
}

- (void) testThatQJAErrorHasId{
    XCTAssertTrue([_sut.ID isEqualToString:@"error-1234"]);
}

- (void) testThatQJAErrorHasStatus{
    XCTAssertTrue([_sut.status isEqualToString:@"status-1234"]);
}

- (void) testThatQJAErrorHasCode{
    XCTAssertTrue([_sut.code isEqualToString:@"code-1234"]);
}

- (void) testThatQJAErrorHasTitle{
    XCTAssertTrue([_sut.title isEqualToString:@"mock error title"]);
}

- (void) testThatQJAErrorHasDetail{
    XCTAssertTrue([_sut.detail isEqualToString:@"mock error detail"]);
}

- (void) testThatQJAErrorHasLinksObject{
    NSDictionary *passedLinks = [[self mockErrorData] valueForKey:@"links"];
    XCTAssertTrue([_sut.links isEqualToDictionary:passedLinks]);
}

- (void) testThatQJAErrorHasSourceObject{
    NSDictionary *passedSource = [[self mockErrorData] valueForKey:@"source"];
    XCTAssertTrue([_sut.source isEqualToDictionary:passedSource]);
}

- (void) testThatQJAErrorHasMetaObject{
    NSDictionary *passedMeta = [[self mockErrorData] valueForKey:@"meta"];
    XCTAssertTrue([_sut.meta isEqualToDictionary:passedMeta]);
}


@end
