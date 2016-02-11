#import <Foundation/Foundation.h>

@class QJAResource;

/**
 Objective-C representation of a JsonApi Document object. Conforms to the JsonApi 1.0 specification. For any further information please visit http://jsonapi.org
 */
@interface QJADocument : NSObject


/**
 the meta object of the JA Document. This member is mandatory by jsonapi specification.
 */
@property (nonatomic, strong) NSDictionary *meta;
/**
 @brief the data object of the JA Document. This member is mandatory by jsonapi specification.
 @discussion this object, by jsonapi design, can be either an Array or a Resource, therefore the type is intentionally generic. It will always be initialized as a QJAResource or as a NSArray of QJAResource instances.
 */
@property (nonatomic, strong) id data;
/**
 the errors array of the JA Document, empty if no errors have been received. This member is mandatory by jsonapi specification.
 */
@property (nonatomic, strong) NSArray *errors;
/**
 the jsonapi object of the JA Document. This member is optional by jsonapi specification.
 */
@property (nonatomic, strong) NSDictionary *jsonApi;
/**
 the links object of the JA Document. This member is optional by jsonapi specification.
 */
@property (nonatomic, strong) NSDictionary *links;
/**
 @brief the included resources array of the JA Document.
 @discussion if resources have been included, they're stored in this array following jsonapi specification, otherwise empty.
 */
@property (nonatomic, strong) NSArray *included;



/**
 @brief convenience constructor, initializes a QJADocument with an NSDictionary.
 @param dictionary the NSDictionary containing the raw data.
 @return QJADocument instance.
 */
+ (instancetype)jsonAPIDocumentWithDictionary:(NSDictionary *)dictionary;
/**
 @brief convenience constructor, initializes a QJADocument with a Json string.
 @param string the NSString containing the json data.
 @return QJADocument instance.
 */
+ (instancetype)jsonAPIDocumentWithString:(NSString *)string;
/**
 @brief default constructor, initializes a QJADocument with an NSDictionary.
 @param dictionary the NSDictionary containing the raw data.
 @return QJADocument instance.
 */
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
/**
 @brief default constructor, initializes a QJADocument with a Json string.
 @param string the NSString containing the json data.
 @return QJADocument instance.
 */
- (instancetype)initWithJSONString:(NSString*)string;
/**
 boolean value indicating if the document contains errors.
 */
- (BOOL)hasErrors;


@end
