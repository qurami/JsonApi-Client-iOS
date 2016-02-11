#import <Foundation/Foundation.h>

@class QJADocument, QJAResource, QJAError;

/**
 @brief Utility class for encoding a QJADocument, QJAResource or QJAError to a Json String
 */
@interface QJAJsonEncoder : NSObject

/**
 @brief encodes QJADocument to string
 @parameter document the document to encode
 @return NSString the json encoded string document
 */
+ (NSString *) jsonEncodedStringForJSONAPIDocument: (QJADocument *) document;
/**
 @brief encodes QJAResource to string
 @parameter resource the resource to encode
 @return NSString the json encoded string resource
 */
+ (NSString *) jsonEncodedStringForJSONAPIResource: (QJAResource *) resource;
/**
 @brief encodes QJAError to string
 @parameter jsonapiError the error to encode
 @return NSString the json encoded string error
 */
+ (NSString *) jsonEncodedStringForJSONAPIError: (QJAError *) jsonapiError;

@end
