//
//  QJAClientTests.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 05/04/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QJAClient.h"
#import "OHHTTPStubs.h"
#import "OHPathHelpers.h"
#import "TestMockHelper.h"


@interface QJAClientTests : XCTestCase{

    QJAClient *_sut;
    NSString *_documentJson;
}

@end

@implementation QJAClientTests

- (void)setUp {
    [super setUp];
    _sut = [QJAClient new];
    
    if(!_documentJson){
        _documentJson = [TestMockHelper mockDocumentJsonString];
    }

}

- (void)tearDown {

    _sut = nil;
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void) stubForHttpGetWithExpectedUrl: (NSString *) expectedUrlString {
    
    [self stubForHttpGetWithExpectedUrl: expectedUrlString customHeaders: nil];
}

- (void) stubForHttpGetWithExpectedUrl: (NSString *) expectedUrlString customHeaders: (NSDictionary *) customHeaders {
    
    if(!customHeaders){
        customHeaders = @{@"Content-Type":@"application/vnd.api+json"};
    }
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString: expectedUrlString];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSData *data = [_documentJson dataUsingEncoding:NSUTF8StringEncoding];
        return [OHHTTPStubsResponse responseWithData: data statusCode: 200 headers: customHeaders];
    }];
}



- (void) testThatClientCallsEndpoint{
    
    
    __block XCTestExpectation *endpointCalled = [self expectationWithDescription:@"Endpoint Called Epectation"];
    
    
    [self stubForHttpGetWithExpectedUrl: @"http:/mydummyendpoint.com"];
    
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        [endpointCalled fulfill];
        endpointCalled = nil;
    }];
    
    _sut.endpoint = @"http://mydummyendpoint.com";
    [_sut getJSONAPIDocumentWithPath: nil completionHandler: nil];

    
    [self waitForExpectationsWithTimeout:.1 handler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"endpoint called expectation fail");
        }
    }];

}

- (void) testThatClientAppendsPath{

    __block XCTestExpectation *endpointCalled = [self expectationWithDescription:@"Endpoint Called Epectation With Path"];
    
    
    [self stubForHttpGetWithExpectedUrl: @"http:/mydummyendpoint.com/dummy"];
    
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        [endpointCalled fulfill];
        endpointCalled = nil;
    }];
    
    _sut.endpoint = @"http://mydummyendpoint.com";
    [_sut getJSONAPIDocumentWithPath: @"dummy" completionHandler: nil];
    
    
    [self waitForExpectationsWithTimeout:.1 handler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"endpoint called expectation fail");
        }
    }];

}

- (void) testThatClientCallsCompletionBlockAfterGetHTTPRequest{

    
    __block XCTestExpectation *callbackCalled = [self expectationWithDescription:@"Callback Called Expectation"];
    
    
    [self stubForHttpGetWithExpectedUrl: @"http:/mydummyendpoint.com/dummy"];
    
    
    _sut.endpoint = @"http://mydummyendpoint.com";
    [_sut getJSONAPIDocumentWithPath: @"dummy" completionHandler:^(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error) {
        [callbackCalled fulfill];
        callbackCalled = nil;
    }];
    
    
    [self waitForExpectationsWithTimeout:.1 handler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"endpoint called expectation fail");
        }
    }];

}

- (void) testThatClientReturnsMimetypeErrorWhenMimetypeIsNotCorrect{
    
    __block XCTestExpectation *errorExpectation = [self expectationWithDescription:@"Mimetype Error Expectation"];
    
    
    [self stubForHttpGetWithExpectedUrl: @"http:/mydummyendpoint.com/dummy" customHeaders:@{@"Content-Type":@"txt"}];
    
    
    _sut.endpoint = @"http://mydummyendpoint.com";
    [_sut getJSONAPIDocumentWithPath: @"dummy" completionHandler:^(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error) {
        if(error && error.code == kMimetypeError){
            [errorExpectation fulfill];
        }
    }];
    
    
    [self waitForExpectationsWithTimeout:.1 handler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"endpoint called expectation fail");
        }
    }];

}


@end
