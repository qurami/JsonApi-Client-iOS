#import <Foundation/Foundation.h>

/**
 Helper class that tells a document how to initialize a specific JsonApi Resource type with a QJAResource subclass. 
     E.G.: "type" : "Comment" becomes "CommentClass : QJAresource" rather than a QJAResource instance.
 */
@interface QJAModelHelper : NSObject

/**
 @brief the dictionary used to store the bindings.
 @discussion don't address directly to this dictionary, use the designated methods instead.
 */
@property (strong, nonatomic) NSMutableDictionary *bindingMap;


/**
 @brief returns the shared singleton instance.
 @return QJAModelHelper instance.
 */
+ (instancetype)sharedModeler;


/**
 @brief binds a QJAResource subclass Class object with a resource type
 @param resourceSubclass the QJAResource subclass
 @param resourceType the JsonApi Resource type
 */
- (void) bindQJAResourceSubclass:(Class)resourceSubclass toResourceOfType:(NSString*)resourceType;

/**
 @brief returns the bound Class for the resource type
 @param resourceType the JsonApi resource type, or QJAResource if no linked resource type is present.
 @return Class the bound class type.
 */
- (Class) boundSubclassForResourceOfType:(NSString*)resourceType;

/**
 @brief resets the model binding
 */
- (void) resetModelBinding;

@end
