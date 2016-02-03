#import "QJADocument.h"
#import "QJAResource.h"
#import "QJAError.h"

@interface QJADocument(){

}

@end

@implementation QJADocument

#pragma mark - Class

+ (instancetype)jsonAPIDocumentWithDictionary:(NSDictionary *)dictionary {
    return [[QJADocument alloc] initWithDictionary:dictionary];
}

+ (instancetype)jsonAPIDocumentWithString:(NSString *)string {
    return [[QJADocument alloc] initWithJSONString:string];
}

#pragma mark - Instance

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        [self initializeDocumentWithDictionary:dictionary];
    }
    return self;
}

- (instancetype)initWithJSONString:(NSString*)string {
    self = [super init];
    if (self) {
        [self initializeDocumentWithJSONString:string];
    }
    return self;
}

- (void)initializeDocumentWithJSONString:(NSString*)string {
    id json = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    if ([json isKindOfClass:[NSDictionary class]] == YES) {
        [self initializeDocumentWithDictionary:json];
    }
}

#pragma mark - Resources

- (BOOL)hasErrors {
    return _errors.count > 0;
}

#pragma mark - Private

- (void)initializeDocumentWithDictionary:(NSDictionary*)dictionary {
    
    _meta = dictionary[@"meta"];
    _jsonApi = dictionary[@"jsonApi"];
    _links = dictionary[@"links"];
    
    id rawData = dictionary[@"data"];
    _data = [self initializeResourceWithData: rawData];
    
    NSArray *rawIncludedArray = dictionary[@"included"];
    _included = [self initializeResourceWithData: rawIncludedArray];
    
    NSMutableArray *returnedErrors = [NSMutableArray new];
    for (NSDictionary *rawError in dictionary[@"errors"]) {
        
        QJAError *resource = [[QJAError alloc] initWithDictionary:rawError];
        if (resource) [returnedErrors addObject:resource];
    }
    _errors = returnedErrors;
}

- (id)initializeResourceWithData:(id) data {
    
    if([data isKindOfClass:[NSDictionary class]])
        return [QJAResource jsonAPIResource: data];
    else if([data isKindOfClass:[NSArray class]])
        return [QJAResource jsonAPIResources: data];
    else
        return nil;
}


@end
