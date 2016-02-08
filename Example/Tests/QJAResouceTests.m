//
//  QJAResouceTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 08/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAResource.h"
#import "MockResourceSubclass.h"
#import "QJAResourceFormatter.h"

@interface QJAResouceTests : XCTestCase{

    NSDictionary *_mockDictionary;
    QJAResource *_sut;
}

@end

@implementation QJAResouceTests

- (NSDictionary *) buildMockDictionary{
    
    return  @{
              @"id" : @"mockId",
              @"type" : @"mockType",
              @"attributes" : @{
                      @"mock-attr-one" : @"1234",
                      @"mock-attr-two" : @"5678",
                      @"mock-attr-formatted" : @"format"
              },
              @"links" : @{
                      @"self" : @"http://www.google.it"
              },
              @"relationships" : @{
                      @"relation-single-data" : @{
                              @"links" : @{
                                      @"self" : @"http://mock.com",
                                      @"related" : @"http://mock2.com"
                              },
                              @"data" : @{
                                      @"type" : @"relation1",
                                      @"id" : @"1234-relation"
                              }
                       },
                      @"relation-array-data" : @{
                              @"links" : @{
                                      @"self" : @"http://mock.com",
                                      @"related" : @"http://mock2.com"
                              },
                              @"data" : @[
                                      @{
                                          @"type" : @"relation2",
                                          @"id" : @"5678-relation"
                                      },
                                      @{
                                          @"type" : @"relation3",
                                          @"id" : @"91011-relation"
                                      }
                              ]
                              
                      }
              }
    };
    
}

- (void)setUp {
    [super setUp];
    
    if(!_mockDictionary)
        _mockDictionary = [self buildMockDictionary];
    
    _sut = [QJAResource resourceWithDictionary:_mockDictionary];
}



- (void)tearDown {
    _sut = nil;
    [super tearDown];
}


- (void) testThatQJAResourceInitializesWithDictionary{

    QJAResource *sut = [[QJAResource alloc] initWithDictionary: _mockDictionary];
    
    XCTAssertNotNil(sut);

}

- (void) testThatQJAResourceInitializesWithConvenienceConstructor{
    
    QJAResource *sut = [QJAResource resourceWithDictionary:_mockDictionary];
    
    XCTAssertNotNil(sut);

}

- (void) testThatMultipleResourcesAreInitialized{
    
    NSDictionary *rawResourceOne = [self buildMockDictionary];
    NSDictionary *rawResourceTwo = [self buildMockDictionary];
    
    NSArray *suts = [QJAResource resourcesWithDictionaryArray:@[rawResourceOne, rawResourceTwo]];
    
    NSInteger count = [suts count];
    
    BOOL allResources = YES;
    
    for (id item in suts) {
        if (![item isKindOfClass:[QJAResource class]]) {
            allResources = NO;
            break;
        }
    }
    
    XCTAssertTrue(count == 2 && allResources);

}

- (void) testThatIdPropertyIsSet{
    XCTAssertTrue([_sut.ID isEqualToString:@"mockId"]);
}

- (void) testThatTypePropertyIsSet{
    XCTAssertTrue([_sut.type isEqualToString:@"mockType"]);
}

- (void) testThatAttributesDictionaryIsSet{
    NSDictionary *attrs = _mockDictionary[@"attributes"];
    XCTAssertTrue([attrs isEqualToDictionary:_sut.attributes]);
}

- (void) testThatLinksDictionaryIsSet{
    NSDictionary *links = _mockDictionary[@"links"];
    XCTAssertTrue([links isEqualToDictionary:_sut.links]);
}

- (void) testThatRelationshipsDictionaryIsSet{
    NSDictionary *relationships = _mockDictionary[@"relationships"];
    XCTAssertTrue([relationships isEqualToDictionary:_sut.relationships]);
}

- (void) testThatResourceFetchesRelatedResourcesFromAnArray{
    
    QJAResource *relatedOne = [QJAResource resourceWithDictionary:[self buildMockDictionary]];
    QJAResource *unrelatedOne = [QJAResource resourceWithDictionary:[self buildMockDictionary]];
    
    relatedOne.type = @"relation1";
    relatedOne.ID = @"1234-relation";
    
    unrelatedOne.type = @"unrelated";
    unrelatedOne.ID = @"1234-unrelated";
    
    NSArray *relatedResources = [_sut getRelatedResourcesFromJSONAPIResourcesArray:@[relatedOne, unrelatedOne]];
    
    XCTAssertEqualObjects(relatedResources[0], relatedOne);
    XCTAssertTrue([relatedResources count] == 1);

}

- (void) testThatResourceFetchesRelatedResourcesFromAnArrayWhenRelationIsMultiple{
    
    QJAResource *relatedOne = [QJAResource resourceWithDictionary:[self buildMockDictionary]];
    QJAResource *unrelatedOne = [QJAResource resourceWithDictionary:[self buildMockDictionary]];
    
    relatedOne.type = @"relation2";
    relatedOne.ID = @"5678-relation";
    
    unrelatedOne.type = @"unrelated";
    unrelatedOne.ID = @"1234-unrelated";
    
    NSArray *relatedResources = [_sut getRelatedResourcesFromJSONAPIResourcesArray:@[relatedOne, unrelatedOne]];
    
    XCTAssertEqualObjects(relatedResources[0], relatedOne);
    XCTAssertTrue([relatedResources count] == 1);
    
}

- (void) testThatResourceReturnsNilIfNoRelatedResourceIsPresent{

    QJAResource *unrelatedOne = [QJAResource resourceWithDictionary:[self buildMockDictionary]];
    QJAResource *unrelatedTwo = [QJAResource resourceWithDictionary:[self buildMockDictionary]];
    
    unrelatedOne.type = @"unrelated1";
    unrelatedOne.ID = @"5678-unrelated";
    
    unrelatedTwo.type = @"unrelated";
    unrelatedTwo.ID = @"1234-unrelated";
    
    NSArray *relatedResources = [_sut getRelatedResourcesFromJSONAPIResourcesArray:@[unrelatedOne, unrelatedTwo]];
    
    XCTAssertNil(relatedResources);

}

- (void) testThatResourceAttributesMappingIsExecuted{
    
    MockResourceSubclass *sut = [[MockResourceSubclass alloc] initWithDictionary:[self buildMockDictionary]];
    
    XCTAssertTrue([sut.mockAttrOne isEqualToString:@"1234"] && [sut.mockAttrTwo isEqualToString:@"5678"]);

}

- (void) testThatFormatIsAppliedOnInitializationOfSubclass{
    
    [[QJAResourceFormatter sharedFormatter] registerFormatWithName:@"MockFormat" formattingBlock:^id(id jsonValue) {
        NSString *original = (NSString *)jsonValue;
        return [NSString stringWithFormat:@"%@-applied", original];
    }];
    
    MockResourceSubclass *sut = [[MockResourceSubclass alloc] initWithDictionary:[self buildMockDictionary]];
    
    XCTAssertTrue([sut.formattedAttribute isEqualToString:@"format-applied"]);

}

@end
