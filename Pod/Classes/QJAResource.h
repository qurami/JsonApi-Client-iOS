#import <Foundation/Foundation.h>

@class QJADocument;

/**
 Objective-C representation of a JsonApi Resource object. Conforms to the JsonApi 1.0 specification. For any further information please visit http://jsonapi.org
 */
@interface QJAResource : NSObject

/**
 the id of the JA Resource.
 */
@property (nonatomic, strong) NSString *ID;
/**
 the type of the JA Resource.
 */
@property (nonatomic, strong) NSString *type;
/**
 the attributes of the JA Resource, represented as an NSDictionary.
 */
@property (nonatomic, strong) NSDictionary *attributes;
/**
 the links of the JA Resource, represented as an NSDictionary.
 */
@property (nonatomic, strong) NSDictionary *links;
/**
 the relationships of the JA Resource, represented as an NSDictionary.
 */
@property (nonatomic, strong) NSDictionary *relationships;

/**
 @brief convenience constructor, initializes a QJAResource with an NSDictionary.
 @return QJAResource instance.
 */
+ (instancetype)resourceWithDictionary:(NSDictionary*)dictionary;
/**
 @brief convenience constructor, initializes an Array QJAResource instances with an array of NSDictionary.
 @return NSArray of QJAResource instances.
 */
+ (NSArray*)resourcesWithDictionaryArray:(NSArray*)array;
/**
 @brief default constructor, initializes an instance of QJAResource with the given NSDictionary.
 @discussion in this framework, usually a JsonApi Resource is initialized from a JsonApi Document, therefore a json string initializer is not provided since this is handled in the QJADocument object. The dictionary is a Json deserialization in a NSDictionary.
 @return QJAResource instance.
 */
- (instancetype)initWithDictionary:(NSDictionary*)dict;

/**
 @brief returns the user specified properties map.
 @discussion override this method in your subclasses of QJAResource to map a specific attribute name to your Subclass' property.
 @return NSDictionary properties map
 */
- (NSDictionary *)mapAttributesToProperties;

/**
 fetches the the related QJAResources from a given array.
 @param array an Array of QJAResource instances
 @return NSArray subset of the input array containing only the related QJAResource instances. Nil if no related resource is present
 */
- (NSArray *) getRelatedResourcesFromJSONAPIResourcesArray: (NSArray *) array;

@end
