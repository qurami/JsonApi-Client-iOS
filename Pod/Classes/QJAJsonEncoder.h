#import <Foundation/Foundation.h>

@class QJADocument, QJAResource, QJAError;

@interface QJAJsonEncoder : NSObject

+ (NSString *) jsonEncodedStringForJSONAPIDocument: (QJADocument *) document;
+ (NSString *) jsonEncodedStringForJSONAPIResource: (QJAResource *) resource;
+ (NSString *) jsonEncodedStringForJSONAPIError: (QJAError *) jsonapiError;

@end
