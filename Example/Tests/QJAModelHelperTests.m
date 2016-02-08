//
//  QJAModelHelperTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 08/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAModelHelper.h"
#import "QJAResource.h"

@interface QJAModelHelperTests : XCTestCase

@end

@implementation QJAModelHelperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testThatSingletonMethodCreatesInstance{
    
    id object = [QJAModelHelper sharedModeler];
    XCTAssertTrue([object isKindOfClass:[QJAModelHelper class]]);
}

- (void) testThatSingletonIsUnique{
    
    id object_one = [QJAModelHelper sharedModeler];
    id object_two = [QJAModelHelper sharedModeler];
    
    XCTAssertEqualObjects(object_one, object_two);
    
}

- (void) testThatModelerBindsClassWithType{
    
    QJAModelHelper *sut = [QJAModelHelper new];
    
    [sut bindQJAResourceSubclass:[NSString class] toResourceOfType:@"test"];
    
    XCTAssertNotNil(sut.bindingMap[@"test"]);

}

- (void) testThatModelerReturnsBoundClass{

    QJAModelHelper *sut = [QJAModelHelper new];
    
    [sut bindQJAResourceSubclass:[NSString class] toResourceOfType:@"test"];
    
    Class bound = [sut boundSubclassForResourceOfType:@"test"];
    
    XCTAssertEqual([NSString class], bound);
}

- (void) testThatModelerReturnsQJAResourceByDefault{
    
    QJAModelHelper *sut = [QJAModelHelper new];
    
    Class boundOfNil = [sut boundSubclassForResourceOfType:@"not-set"];
    
    XCTAssertEqual([QJAResource class], boundOfNil);

}

@end
