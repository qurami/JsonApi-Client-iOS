//
//  QJAJsonEncoderTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 11/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAJsonEncoder.h"
#import "QJADocument.h"
#import "QJAResource.h"
#import "QJAError.h"
#import "TestMockHelper.h"

@interface QJAJsonEncoderTests : XCTestCase{

    NSString *_mockJsonDocumentString;
}

@end

@implementation QJAJsonEncoderTests



- (void)setUp {
    [super setUp];
    if(!_mockJsonDocumentString){
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [bundle pathForResource:@"mockDocument" ofType:@"json"];
        _mockJsonDocumentString = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)tearDown {
    [super tearDown];
}

- (NSDictionary *) jsonStringToDictionary: (NSString *) jsonString{

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}


- (void) testThatEncoderEncodesDocument{

    NSDictionary *rawDocument = [self jsonStringToDictionary:_mockJsonDocumentString];
    
    QJADocument *mockDocument = [[QJADocument alloc] initWithDictionary: rawDocument];
    
    NSString *encodedString = [QJAJsonEncoder jsonEncodedStringForJSONAPIDocument: mockDocument];
    
    NSDictionary *returnedDict = [self jsonStringToDictionary: encodedString];
    
    XCTAssertTrue([returnedDict isEqualToDictionary:rawDocument]);

}

- (void) testThatEncoderEncodesResource{

    NSDictionary *rawResource = [TestMockHelper mockResourceDictionary];
    
    QJAResource *mockResource = [[QJAResource alloc] initWithDictionary:rawResource];
    
    NSString *jsonResource = [QJAJsonEncoder jsonEncodedStringForJSONAPIResource:mockResource];
    
    NSDictionary *returnedDictionary = [self jsonStringToDictionary: jsonResource];
    
    XCTAssertTrue([rawResource isEqualToDictionary: returnedDictionary]);
}

- (void) testThatEncoderEncodesError{
    
    NSDictionary *rawDictionary = [TestMockHelper mockErrorDictionary];
    
    QJAError *error = [[QJAError alloc] initWithDictionary: rawDictionary];
    
    NSString *jsonError = [QJAJsonEncoder jsonEncodedStringForJSONAPIError: error];
    
    NSDictionary *returnedDictionary = [self jsonStringToDictionary: jsonError];
    
    XCTAssertTrue([rawDictionary isEqualToDictionary:returnedDictionary]);
}


@end
