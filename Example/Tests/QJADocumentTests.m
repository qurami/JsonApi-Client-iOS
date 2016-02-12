//
//  QJADocumentTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 11/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJADocument.h"
#import "QJAResource.h"
#import "QJAError.h"


@interface QJADocumentTests : XCTestCase{

    NSString *_mockJsonDocumentString;
    NSDictionary *_mockDocumentDictionary;
    
    QJADocument *_sut;
}

@end

@implementation QJADocumentTests

- (void)setUp {
    [super setUp];
    
    if(!_mockJsonDocumentString){
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [bundle pathForResource:@"mockDocument" ofType:@"json"];
        _mockJsonDocumentString = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];
        
        _mockDocumentDictionary =  [NSJSONSerialization JSONObjectWithData:[_mockJsonDocumentString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    }
    
    _sut = [[QJADocument alloc] initWithJSONString: _mockJsonDocumentString];
    
    
}

- (void)tearDown {
    _sut = nil;
    [super tearDown];
}

- (void) testThatQJADocumentInitializesWithJsonStringUsingConvenienceConstructor{
    QJADocument *sut = [QJADocument jsonAPIDocumentWithString:_mockJsonDocumentString];
                        
    XCTAssertNotNil(sut);
}

- (void) testThatQJADocumentInitializesWithJsonStringUsingDefaultConstructor{

    QJADocument *sut = [[QJADocument alloc] initWithJSONString:_mockJsonDocumentString];
    
    XCTAssertNotNil(sut);
}

- (void) testThatQJADocumentInitializesWithDictionaryUsingConvenienceConstructor{
    QJADocument *sut = [QJADocument jsonAPIDocumentWithDictionary:_mockDocumentDictionary];
    
    XCTAssertNotNil(sut);
}

- (void) testThatQJADocumentInitializesWithDictionaryUsingDefaultConstructor{
    
    QJADocument *sut = [[QJADocument alloc] initWithDictionary:_mockDocumentDictionary];
    
    XCTAssertNotNil(sut);
}

- (void) testThatQJADocumentHasMetaObject{
    NSDictionary *expectedMeta = _mockDocumentDictionary[@"meta"];
    XCTAssertTrue([_sut.meta isEqualToDictionary:expectedMeta]);
}

- (void) testThatQJADocumentHasArrayData{
    XCTAssertTrue([_sut.data isKindOfClass:[NSArray class]]);
}

- (void) testThatQJADocumentHasTheExactNumberOfResources{
    NSArray *resources = (NSArray *) _sut.data;
    XCTAssertEqual([resources count], 2);
}

- (void) testThatQJADocumentResourcesAreQJAResources{

    BOOL allResources = YES;
    
    for(id item in _sut.data){
        if (![item isKindOfClass:[QJAResource class]]) {
            allResources = NO;
            break;
        }
    }
    
    XCTAssertTrue(allResources);
}

- (void) testThatQJADocumentHasQJAResourceData{
    
    NSMutableDictionary *mockDocumentDictionaryData = [_mockDocumentDictionary mutableCopy];
    NSDictionary *rawResource = [mockDocumentDictionaryData[@"data"] objectAtIndex:0];
    [mockDocumentDictionaryData setObject:rawResource forKey:@"data"];
    
    QJADocument *sut = [[QJADocument alloc] initWithDictionary: mockDocumentDictionaryData];
    
    XCTAssertTrue([sut.data isKindOfClass:[QJAResource class]]);
    XCTAssertTrue([((QJAResource *)sut.data).ID isEqualToString:@"1"]);
}

- (void) testThatQJADocumentHasInitalizedResourcesProperly{
    QJAResource *firstResource = [_sut.data objectAtIndex:0];
    QJAResource *secondResource = [_sut.data objectAtIndex:1];
    XCTAssertTrue([firstResource.ID isEqualToString:@"1"]);
    XCTAssertTrue([secondResource.ID isEqualToString:@"2"]);
}

- (void) testThatQJADocumentErrorsArrayIsEmptyWhenNoErrors{
    XCTAssertEqual([_sut.errors count],0);
}

- (void) testThatQJADocumentReturnsNoErrorsFlagWhenNoErrors{
    XCTAssertFalse(_sut.hasErrors);
}

- (void) testThatDocumentInitializesErrorsWhenPresent{
    
    NSMutableDictionary *erroredMockDocument = [_mockDocumentDictionary mutableCopy];

    NSDictionary *rawError = @{@"id":@"error-1234"};
    
    [erroredMockDocument setObject:@[rawError] forKey:@"errors"];
    
    QJADocument *sut = [[QJADocument alloc] initWithDictionary: erroredMockDocument];
    
    XCTAssertTrue(sut.hasErrors);
    XCTAssertTrue([sut.errors count] == 1);
    XCTAssertTrue([[sut.errors objectAtIndex:0] isKindOfClass:[QJAError class]]);
    
    QJAError *initializedError = sut.errors[0];
    XCTAssertTrue([initializedError.ID isEqualToString:@"error-1234"]);

}

- (void) testThatQJADocumentHasCorrectJsonapiVersionObject{
    NSDictionary *passedJsonApiDocument = _mockDocumentDictionary[@"jsonapi"];
    XCTAssertTrue([_sut.jsonApi isEqualToDictionary:passedJsonApiDocument]);
}

- (void) testThatQJADocumentHasCorrectLinks{
    NSDictionary *passedLinks = _mockDocumentDictionary[@"links"];
    XCTAssertTrue([_sut.links isEqualToDictionary: passedLinks]);
}

- (void) testThatQJADocumentInitializesResourcesInIncludedArray{
    XCTAssertEqual([_sut.included count], 3);
}

- (void) testThatQJADocumentIncludedResourcesAreQJAResources{
    
    BOOL allResources = YES;
    
    for(id item in _sut.included){
        if (![item isKindOfClass:[QJAResource class]]) {
            allResources = NO;
            break;
        }
    }
    
    XCTAssertTrue(allResources);
}

- (void) testThatQJADocumentHasInitalizedIncludedResourcesProperly{
    QJAResource *firstResource = [_sut.included objectAtIndex:0];
    QJAResource *secondResource = [_sut.included objectAtIndex:1];
    QJAResource *thirdResource = [_sut.included objectAtIndex:2];
    
    XCTAssertTrue([firstResource.ID isEqualToString:@"9"]);
    XCTAssertTrue([secondResource.ID isEqualToString:@"5"]);
    XCTAssertTrue([thirdResource.ID isEqualToString:@"12"]);
}

@end
