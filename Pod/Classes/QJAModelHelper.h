#import <Foundation/Foundation.h>

@interface QJAModelHelper : NSObject

+ (void) bindQJAResourceSubclass:(Class)jsonApiResource toResourceOfType:(NSString*)resourceType;
+ (Class) boundSubclassForResourceOfType:(NSString*)resourceType;

+ (void) resetModelBinding;

@end
