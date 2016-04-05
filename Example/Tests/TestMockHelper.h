//
//  TestMockHelper.h
//  QuramiJsonApi
//
//  Created by Marco Musella on 12/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QJADocument;

@interface TestMockHelper : NSObject

+ (NSDictionary *) mockResourceDictionary;
+ (NSDictionary *) mockErrorDictionary;
+ (NSString *) mockDocumentJsonString;
+ (QJADocument *) mockDocument;

@end
