#import "QJAModelHelper.h"
#import "QJAResource.h"

@interface QJAModelHelper ()

@property (strong, nonatomic) NSMutableDictionary *bindingMap;

@end

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

+ (void)bindQJAResourceSubclass:(Class)jsonApiResource toResourceOfType:(NSString *)linkedType {
    [[[QJAModelHelper sharedModeler] bindingMap] setValue:jsonApiResource forKey:linkedType];
}

+ (Class)boundSubclassForResourceOfType:(NSString *)linkedType {
    
    Class linkedTypeClass = [[[QJAModelHelper sharedModeler] bindingMap] valueForKey:linkedType];
    
    if(!linkedTypeClass)
        linkedTypeClass = [QJAResource class];
    
    return linkedTypeClass;
}

+ (void)resetModelBinding {
    [[[QJAModelHelper sharedModeler] bindingMap] removeAllObjects];
}

@end
