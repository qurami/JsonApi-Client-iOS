#import "QJAModelHelper.h"
#import "QJAResource.h"

@implementation QJAModelHelper

+ (instancetype)sharedModeler {
    static QJAModelHelper *_sharedModeler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModeler = [[QJAModelHelper alloc] init];
    });
    
    return _sharedModeler;
}

- (id)init {
    self = [super init];
    if (self) {
        _bindingMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)bindQJAResourceSubclass:(Class)resourceSubclass toResourceOfType:(NSString *)resourceType {
    [_bindingMap setValue:resourceSubclass forKey:resourceType];
}

- (Class)boundSubclassForResourceOfType:(NSString *)linkedType {
    
    Class linkedTypeClass = [_bindingMap valueForKey:linkedType];
    
    if(!linkedTypeClass)
        linkedTypeClass = [QJAResource class];
    
    return linkedTypeClass;
}

- (void)resetModelBinding {
    [_bindingMap removeAllObjects];
}

@end
