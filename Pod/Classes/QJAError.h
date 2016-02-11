#import <Foundation/Foundation.h>


/**
 Objective-C representation of a JsonApi Error object. Conforms to the JsonApi 1.0 specification. For any further information please visit http://jsonapi.org

 */
@interface QJAError : NSObject

/**
 the id of the JA Error.
 */
@property (nonatomic, strong) NSString *ID;
/**
 the status of the JA Error.
 */
@property (nonatomic, strong) NSString *status;
/**
 the code of the JA Error.
 */
@property (nonatomic, strong) NSString *code;
/**
 the title of the JA Error.
 */
@property (nonatomic, strong) NSString *title;
/**
 the details of the JA Error.
 */
@property (nonatomic, strong) NSString *detail;
/**
 the links object of the JA Error.
 */
@property (nonatomic, strong) NSDictionary *links;
/**
 the source object of the JA Error.
 */
@property (nonatomic, strong) NSDictionary *source;
/**
 the meta object the JA Error.
 */
@property (nonatomic, strong) NSDictionary *meta;

/**
 @brief default constructor, initializes an instance of QJAError with the given NSDictionary.
 @return QJAError instance.
 */
- (id) initWithDictionary: (NSDictionary *) errorData;

@end
