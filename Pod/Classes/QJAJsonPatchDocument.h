#import <Foundation/Foundation.h>

typedef enum JSONPatchOperation{
    
    JSONPatchOperationAdd = 0,
    JSONPatchOperationRemove,
    JSONPatchOperationReplace,
    JSONPatchOperationMove,
    JSONPatchOperationCopy,
    JSONPatchOperationTest

}JSONPatchOperation;

@interface QJAJsonPatchDocument : NSObject

@property (nonatomic, assign) JSONPatchOperation op;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) id value;

- (NSString *) convertToJsonStringWithError: (NSError **) error;
- (NSData *) convertToJsonDataWithError: (NSError **) error;
- (NSDictionary *) toDictionary;

@end
