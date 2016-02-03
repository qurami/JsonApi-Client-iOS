#import "QJAClient.h"

@class QJAJsonPatchDocument;

@interface QJAClient (JSONPatchExtension)

- (void) patchWithJsonPatchDocumentArray: (NSArray<QJAJsonPatchDocument *> *) array forResourceAtPath: (NSString *) resourcePath completionHandler: (void(^)(NSArray<QJADocument *> *documents,NSInteger statusCode, NSError *error)) completionHandler;

@end
