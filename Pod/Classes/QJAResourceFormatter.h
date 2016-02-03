#import <Foundation/Foundation.h>

@interface QJAResourceFormatter : NSObject

+ (void)registerFormat:(NSString*)name withBlock:(id(^)(id jsonValue))block;
+ (id)performFormatBlock:(NSString*)value withName:(NSString*)name;

@end
