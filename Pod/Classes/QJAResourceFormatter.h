#import <Foundation/Foundation.h>


/**
 Applies formatting solutions on properties of QJAResource subclasses where the property data format may differ from the one received from the remote JsonApi Document. e.g.: Format a timestamp into an NSDate.
 */
@interface QJAResourceFormatter : NSObject


/**
 @brief the dictionary used to map format names with blocks.
 @discussion don't address directly to this dictionary, use the designated methods instead.
 */
@property (nonatomic, strong) NSMutableDictionary *formatBlocks;

/**
 returns the shared singleton instance.
 */
+ (instancetype) sharedFormatter;

/**
 @brief Registers a new formatting block.
 @param formatName the name with whome the format is being registered.
 @param block the formatting block that will be executed, returns the formatted value.
 */
- (void)registerFormatWithName:(NSString*)formatName formattingBlock:(id(^)(id jsonValue))block;

/**
 @brief performs a formatting bock on the passed value.
 @param formatName the name of the registered format.
 @param value the value passed to the formatting block.
 */
- (id)performFormatBlockWithName: (NSString *) formatName onJsonValue: (NSString *) value;

@end
