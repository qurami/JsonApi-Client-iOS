//
//  TestMockHelper.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 12/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import "TestMockHelper.h"
#import "QJADocument.h"

@implementation TestMockHelper

+ (NSDictionary *) mockResourceDictionary{

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

+ (NSDictionary *) mockErrorDictionary{
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

+ (NSString *) mockDocumentJsonString{
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"mockDocument" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];
    
    return jsonString;
}

+ (QJADocument *) mockDocument{
    
    QJADocument *mockDocument = [[QJADocument alloc] initWithJSONString: [TestMockHelper mockDocumentJsonString]];
    
    return mockDocument;

}

@end
