#import "QJAResource.h"

#import "QJAResourceFormatter.h"
#import "QJAModelHelper.h"

#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - JSONAPIResource

@interface QJAResource(){
    
    NSDictionary *_rawData;
}


@end

@implementation QJAResource

#pragma mark -
#pragma mark - Class Methods

+ (NSArray*)resourcesWithDictionaryArray:(NSArray*)array {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity: [array count]];
    for (NSDictionary *dict in array) {
        NSString *type = dict[@"type"] ?: @"";
        Class resourceObjectClass = [[QJAModelHelper sharedModeler] boundSubclassForResourceOfType:type];
        [mutableArray addObject:[[resourceObjectClass alloc] initWithDictionary:dict]];
    }
    
    return mutableArray;
}

+ (instancetype)resourceWithDictionary:(NSDictionary*)dictionary {
    NSString *type = dictionary[@"type"] ?: @"";
    Class resourceObjectClass = [[QJAModelHelper sharedModeler] boundSubclassForResourceOfType:type];
    
    return [[resourceObjectClass alloc] initWithDictionary:dictionary];
}

#pragma mark -
#pragma mark - Instance Methods


- (instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        [self initializeResourceWithDictionary:dict];
    }
    return self;
}

- (NSDictionary *)mapAttributesToProperties {
    return [[NSDictionary alloc] init];
}


- (BOOL)setWithResource:(id)otherResource {
    if ([otherResource isKindOfClass:[self class]] == YES) {
        
        return YES;
    }
    
    return NO;
}

- (void)initializeResourceWithDictionary: (NSDictionary *) rawResourceObjectDictionary {
    
    _rawData = [NSDictionary dictionaryWithDictionary: rawResourceObjectDictionary];
    

    if(!_rawData[@"id"] || _rawData[@"id"] == [NSNull null] || [_rawData[@"id"] length] == 0){
        NSLog(@"%@ warning: object is missing id, every jsonapiresource MUST have an id. For further reading please refer to: http://jsonapi.org/format/#document-resource-objects ", NSStringFromClass([self class]));
    }
    else{
        self.ID = _rawData[@"id"];
    }
    
    if(!_rawData[@"type"] ||  _rawData[@"type"] == [NSNull null] || [_rawData[@"type"] length] == 0){
        NSLog(@"%@ warning: object is missing type, every jsonapiresource MUST have a type. For further reading please refer to: http://jsonapi.org/format/#document-resource-objects ", NSStringFromClass([self class]));
    }
    else{
        self.type = _rawData[@"type"];
    }
    
    
    
    NSDictionary *rawResourceObjectAttributesDictionary = (_rawData[@"attributes"] && (_rawData[@"attributes"] != [NSNull null])) ? _rawData[@"attributes"] : nil;
    
    if(rawResourceObjectAttributesDictionary){
        self.attributes = rawResourceObjectAttributesDictionary;
    }
    else{
        self.attributes = @{};
    }
    
    if(!_rawData[@"links"] || _rawData[@"links"] == [NSNull null]){
        self.links = @{};
    }
    else{
        self.links = _rawData[@"links"];
    }
    
    NSDictionary *rawResourceObjectRelationshipsDictionary = (_rawData[@"relationships"] && (_rawData[@"relationships"] != [NSNull null])) ? _rawData[@"relationships"] : nil;
    
    if(rawResourceObjectRelationshipsDictionary){
        self.relationships = rawResourceObjectRelationshipsDictionary;
    }
    else{
        rawResourceObjectRelationshipsDictionary = @{};
    }
    
    NSDictionary *userMap = [self mapAttributesToProperties];
    
    if([userMap count]>0){
        
        for (NSString *key in [userMap allKeys]) {
            
                if ([rawResourceObjectAttributesDictionary objectForKey:key] != nil && [rawResourceObjectAttributesDictionary objectForKey:key] != [NSNull null]) {
                    
                    NSString *propertyName = [userMap objectForKey:key];
                    
                    NSRange formatRange = [propertyName rangeOfString:@":"];
                    
                    @try {
                        if (formatRange.location != NSNotFound) {
                            NSString *formatFunction = [propertyName substringToIndex:formatRange.location];
                            propertyName = [propertyName substringFromIndex:(formatRange.location+1)];
                            
                            NSString *formattedValue = [[QJAResourceFormatter sharedFormatter] performFormatBlockWithName: formatFunction onJsonValue:[rawResourceObjectAttributesDictionary objectForKey:key]];
                            
                            [self setValue: formattedValue forKey: propertyName ];
                        } else {
                            [self setValue:[rawResourceObjectAttributesDictionary objectForKey:key] forKey:propertyName ];
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@ warning: %@", NSStringFromClass([self class]),[exception description]);
                    }
                }
            }
        }
}


- (NSArray *) getRelatedResourcesFromJSONAPIResourcesArray: (NSArray *) array{
    
    NSMutableArray *relationships = [NSMutableArray new];

    
    for(NSDictionary *relationship in [self.relationships allValues]){
        
        NSDictionary *relationshipData = (relationship[@"data"] && (relationship[@"data"] != [NSNull null])) ? relationship[@"data"] : nil;
        
        if(relationshipData){
            
            if([relationshipData isKindOfClass:[NSArray class]]){
                for (NSDictionary *thisResourceIdentifier in relationshipData) {
                    NSString *relationshipType = thisResourceIdentifier[@"type"];
                    NSString *relationshipId = thisResourceIdentifier[@"id"];
                    
                    for(QJAResource *thisResource in array){
                        if([thisResource.ID isEqualToString: relationshipId] && [thisResource.type isEqualToString: relationshipType])
                            [relationships addObject: thisResource];
                    }
                    
                }
            }
            else{
                NSString *relationshipType = relationshipData[@"type"];
                NSString *relationshipId = relationshipData[@"id"];
                
                for(QJAResource *thisResource in array){
                    if([thisResource.ID isEqualToString: relationshipId] && [thisResource.type isEqualToString: relationshipType])
                        [relationships addObject: thisResource];
                }
            }
        }
    }
    
    return [relationships count] > 0 ? relationships : nil;

}


@end
