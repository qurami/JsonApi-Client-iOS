#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QJADocument;

extern NSString *const JSONAPIClientErrorDomain;

typedef enum JSONAPIErrorCodes{

    kMimetypeError = 415,
    kMalformedContentError = 400
    
}JSONAPIErrorCodes;

/**
 Objective-C client for basic http requests using the jsonapi specification. For any further information please visit http://jsonapi.org
 */
@interface QJAClient : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

/**
 @brief the endpoint url string
 @discussion use this property to set the url of your endpoint as a string.
 */
@property (strong, nonatomic) NSString *endpoint;


/**
 @brief the NSURLSessionConfiguration used by the client, [NSURLSessionConfiguration defaultSessionConfiguration] is used by default.
 @discussion inject your custom session configuration if you prefer to use a different one.
 */
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;

/**
  the NSURLCredential for auth challenges
 */
@property (strong, nonatomic) NSURLCredential *sessionCredential;

/**
 @brief use this method to append any additional HTTP headers in addition to the standard jsonapi HTTP headers.
 @param additionalHeaders a dictionary containing your additional headers.
 */
- (void) appendAdditionalHTTPHeaders: (NSDictionary *) additionalHeaders;

/**
 @brief use this method to download a JsonApi Document wrapped in a QJADocument
 @param path the path of the resource on the server
 @param completionHandler the completion handler to be invoked upon completion, "jsonApiDocument" is the returned document, "statusCode" is the returned status code, "error" is the returned error (if any).
 */
- (void) getJSONAPIDocumentWithPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

/**
 @brief use this method to GET a JsonApi Document wrapped in a QJADocument, by including its linked resources
 @param path the path of the resource on the server
 @param includedResourceTypes an array containing the type of the resources to include in the Jsonapi Document
 @param completionHandler the completion handler to be invoked upon completion, "jsonApiDocument" is the returned document, "statusCode" is the returned status code, "error" is the returned error (if any).
 */
- (void) getJSONAPIDocumentWithPath: (NSString *) path includedResourceTypes: (NSArray *) includedResourceTypes completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;


/**
 @brief use this method to POST a JsonApi Document wrapped in a QJADocument
 @param documentToPost the Jsonapi Document to be POSTed
 @param path the path of the document on the server
 @param completionHandler the completion handler to be invoked upon completion, "jsonApiDocument" is the returned document, "statusCode" is the returned status code, "error" is the returned error (if any).
 */
- (void) postJSONAPIDocument: (QJADocument *) documentToPost withPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

/**
 @brief use this method to POST a JsonApi Document wrapped in a QJADocument
 @param documentToPost the Jsonapi Document to be POSTed
 @param path the path of the document on the server
 @param includedResourceTypes an array specifying the type of the resources included in the Jsonapi Document
 @param completionHandler the completion handler to be invoked upon completion, "jsonApiDocument" is the returned document, "statusCode" is the returned status code, "error" is the returned error (if any).
 */
- (void) postJSONAPIDocument: (QJADocument *) documentToPost withPath: (NSString *) path includedResources: (NSArray *) includedResourceTypes completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

/**
 @brief use this method to DELETE a JsonApi Document wrapped in a QJADocument
 @param documentToPost the Jsonapi Document to be POSTed
 @param path the path of the document on the server
 @param completionHandler the completion handler to be invoked upon completion, "jsonApiDocument" is the returned document, "statusCode" is the returned status code, "error" is the returned error (if any).
 */
- (void) deleteJSONAPIResourceWithPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler;

/**
 @brief use this method to append a query parameters to your HTTP call
 @param queryParameters a dictionary containing your query parameters
 */
- (void) appendQueryParameters: (NSDictionary <NSString *, NSString *> *) queryParameters;

/**
 @brief use this method to append a BODY to your HTTP call
 @param BODY an NSString containing your HTTP body
 */
- (void) appendRequestBody: (NSString *) body;

/**
 @brief use this method to extend (sperimental) the JsonApi allowed content types and accepts
 @param contentTypeExtensions the content type extensions as NSStrings Array
 @param acceptExtensions the accept extensions as NSStrings Array
 @discussion this feature is sperimental, it's not offically accepted by the JsonApi specification
 */
- (void) setContentTypeExtension: (NSArray <NSString *> *) contentTypeExtensions acceptExtensions: (NSArray <NSString *> *) acceptExtensions;

/**
 @brief use this method to perform a generic HTTP operation
 @param httpMethod the HTTP method to use
 @param path the path of the document on the server
 @param completionHandler the completion handler to be invoked upon completion, "retrievedData" is the returned raw data, "statusCode" is the returned status code, "error" is the returned error (if any).
 */
- (void) genericRequestWithHTTPMethod: (NSString *) httpMethod resourcePath: (NSString *) path completionHandler: (void(^)(NSData *retrievedData, NSInteger statusCode, NSError *error)) completionHandler;


@end

