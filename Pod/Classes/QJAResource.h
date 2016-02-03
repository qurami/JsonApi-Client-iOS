#import <Foundation/Foundation.h>

@class QJADocument;

@interface QJAResource : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSDictionary *links;
@property (nonatomic, strong) NSDictionary *relationships;

+ (id)jsonAPIResource:(NSDictionary*)dictionary;
+ (NSArray*)jsonAPIResources:(NSArray*)array;
- (id)initWithDictionary:(NSDictionary*)dict;

- (NSDictionary *)mapAttributesToProperties;

- (NSArray *) getRelatedResourcesFromJSONAPIResourcesArray: (NSArray *) array;

@end
