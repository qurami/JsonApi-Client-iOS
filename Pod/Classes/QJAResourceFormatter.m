#import "QJAResourceFormatter.h"

@interface QJAResourceFormatter()

@property (nonatomic, strong) NSMutableDictionary *formatBlocks;

@end

@implementation QJAResourceFormatter

+ (instancetype)sharedFormatter {
    static QJAResourceFormatter *_sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [[QJAResourceFormatter alloc] init];
    });
    
    return _sharedFormatter;
}

- (id)init {
    self = [super init];
    if (self) {
        self.formatBlocks = @{}.mutableCopy;
    }
    return self;
}

+ (void)registerFormat:(NSString*)name withBlock:(id(^)(id jsonValue))block {
    [[QJAResourceFormatter sharedFormatter].formatBlocks setObject:[block copy] forKey:name];
}

+ (id)performFormatBlock:(NSString*)value withName:(NSString*)name {
    id(^block)(NSString *);
    block = [[QJAResourceFormatter sharedFormatter].formatBlocks objectForKey:name];
    if (block != nil) {
        return block(value);
    } else {
        return nil;
    }
}

@end
