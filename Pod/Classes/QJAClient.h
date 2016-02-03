#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QJADocument;

extern NSString *const JSONAPIClientErrorDomain;

typedef enum JSONAPIErrorCodes{

    kMimetypeError = 415,
    kMalformedContentError = 400
    
}JSONAPIErrorCodes;

@interface QJAClient : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

//the endpoint of the json api call
@property (strong, nonatomic) NSString *endpoint;


//for customization of default session configuration and for basic http auth
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (strong, nonatomic) NSURLCredential *sessionCredential;


- (void) appendAdditionalHTTPHeaders: (NSDictionary *) additionalHeaders;

- (void) getJSONAPIDocumentWithPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

- (void) getJSONAPIDocumentWithPath: (NSString *) path includedResourceTypes: (NSArray *) includedResourceTypes completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

- (void) postJSONAPIDocument: (QJADocument *) documentToPost withPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

- (void) postJSONAPIDocument: (QJADocument *) documentToPost withPath: (NSString *) path includedResources: (NSArray *) includedResourceTypes completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

- (void) deleteJSONAPIResourceWithPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;


- (void) appendQueryParameters: (NSDictionary <NSString *, NSString *> *) queryParameters;
- (void) appendRequestBody: (NSString *) body;
- (void) setContentTypeExtension: (NSArray <NSString *> *) contentTypeExtensions acceptExtensions: (NSArray <NSString *> *) acceptExtensions;
- (void) genericRequestWithHTTPMethod: (NSString *) httpMethod resourcePath: (NSString *) path completionHandler: (void(^)(NSData *retrievedData, NSInteger statusCode, NSError *error)) completionHandler;


@end

