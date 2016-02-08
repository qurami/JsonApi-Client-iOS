#import "QJAResourceFormatter.h"


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

- (void)registerFormatWithName:(NSString*)formatName formattingBlock:(id(^)(id jsonValue))block {
    [self.formatBlocks setObject:[block copy] forKey: formatName ];
}

- (id)performFormatBlockWithName: (NSString *) formatName onJsonValue: (NSString *) value {
    
    id(^block)(NSString *);
    block = [self.formatBlocks objectForKey:formatName];
    if (block != nil) {
        return block(value);
    } else {
        return nil;
    }
}

@end
