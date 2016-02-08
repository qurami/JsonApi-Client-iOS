//
//  QJAResourceFormatterTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 05/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAResourceFormatter.h"

@interface QJAResourceFormatterTests : XCTestCase{
    
}

@end

@implementation QJAResourceFormatterTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testThatSingletonMethodCreatesInstance{
    
    id object = [QJAResourceFormatter sharedFormatter];
    XCTAssertTrue([object isKindOfClass:[QJAResourceFormatter class]]);
}

- (void) testThatSingletonIsUnique{
    
    id object_one = [QJAResourceFormatter sharedFormatter];
    id object_two = [QJAResourceFormatter sharedFormatter];
    
    XCTAssertEqualObjects(object_one, object_two);

}

- (void) testThatResourceFormatterRegistersBlockForFormat{
    
    QJAResourceFormatter *sut = [QJAResourceFormatter new];
    
    id (^blockToPass)(id jsonValue) = ^id(id jsonValue){return @"hello";};
    
    [sut registerFormatWithName:@"HelloTest" formattingBlock:blockToPass];
    
    id retrievedBlock = [sut.formatBlocks valueForKey: @"HelloTest"];
    
    XCTAssertEqualObjects(blockToPass, retrievedBlock);
    
    
}

- (void) testThatResourceFormatterExecutesRegisteredBlockWithFormat{

    
    QJAResourceFormatter *sut = [QJAResourceFormatter new];
    
    __block NSNumber *executed = [NSNumber numberWithBool:NO];
    id (^blockToPass)(id jsonValue) = ^id(id jsonValue){
        executed = [NSNumber numberWithBool: YES];
        return executed;
    };

    
    [sut registerFormatWithName:@"Test Format" formattingBlock: blockToPass];
    [sut performFormatBlockWithName:@"Test Format" onJsonValue:@"irrelevant"];
    
    XCTAssertTrue([executed boolValue]);
    
}


@end
