//
//  QJAErrorTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 11/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAError.h"
#import "TestMockHelper.h"

@interface QJAErrorTests : XCTestCase{

    QJAError *_sut;
}

@end

@implementation QJAErrorTests


- (void)setUp {
    [super setUp];
    _sut = [[QJAError alloc] initWithDictionary:[TestMockHelper mockErrorDictionary]];
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
    NSDictionary *passedLinks = [[TestMockHelper mockErrorDictionary] valueForKey:@"links"];
    XCTAssertTrue([_sut.links isEqualToDictionary:passedLinks]);
}

- (void) testThatQJAErrorHasSourceObject{
    NSDictionary *passedSource = [[TestMockHelper mockErrorDictionary] valueForKey:@"source"];
    XCTAssertTrue([_sut.source isEqualToDictionary:passedSource]);
}

- (void) testThatQJAErrorHasMetaObject{
    NSDictionary *passedMeta = [[TestMockHelper mockErrorDictionary] valueForKey:@"meta"];
    XCTAssertTrue([_sut.meta isEqualToDictionary:passedMeta]);
}


@end
