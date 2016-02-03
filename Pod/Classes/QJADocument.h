#import <Foundation/Foundation.h>

@class QJAResource;

@interface QJADocument : NSObject


//mandatory members
@property (nonatomic, strong) NSDictionary *meta;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSArray *errors;

//optional members
@property (nonatomic, strong) NSDictionary *jsonApi;
@property (nonatomic, strong) NSArray *links;
@property (nonatomic, strong) NSArray *included;



// Initializers
+ (instancetype)jsonAPIDocumentWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)jsonAPIDocumentWithString:(NSString *)string;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithJSONString:(NSString*)string;

- (BOOL)hasErrors;


@end
