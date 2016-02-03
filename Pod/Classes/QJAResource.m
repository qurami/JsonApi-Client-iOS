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

+ (NSArray*)jsonAPIResources:(NSArray*)array {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity: [array count]];
    for (NSDictionary *dict in array) {
        NSString *type = dict[@"type"] ?: @"";
        Class resourceObjectClass = [QJAModelHelper boundSubclassForResourceOfType:type];
        [mutableArray addObject:[[resourceObjectClass alloc] initWithDictionary:dict]];
    }
    
    return mutableArray;
}

+ (id)jsonAPIResource:(NSDictionary*)dictionary {
    NSString *type = dictionary[@"type"] ?: @"";
    Class resourceObjectClass = [QJAModelHelper boundSubclassForResourceOfType:type];
    
    return [[resourceObjectClass alloc] initWithDictionary:dictionary];
}

#pragma mark -
#pragma mark - Instance Methods


- (id)initWithDictionary:(NSDictionary*)dict {
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
    
    _rawData = rawResourceObjectDictionary;
    

    if(!rawResourceObjectDictionary[@"id"] || rawResourceObjectDictionary[@"id"] == [NSNull null] || [rawResourceObjectDictionary[@"id"] length] == 0){
        NSLog(@"%@ warning: object is missing id, every jsonapiresource MUST have an id. For further reading please refer to: http://jsonapi.org/format/#document-resource-objects ", NSStringFromClass([self class]));
    }
    else
        self.ID = rawResourceObjectDictionary[@"id"];
    
    if(!rawResourceObjectDictionary[@"type"] ||  rawResourceObjectDictionary[@"type"] == [NSNull null] || [rawResourceObjectDictionary[@"type"] length] == 0){
        NSLog(@"%@ warning: object is missing type, every jsonapiresource MUST have a type. For further reading please refer to: http://jsonapi.org/format/#document-resource-objects ", NSStringFromClass([self class]));
    }
    else
        self.type = rawResourceObjectDictionary[@"type"];
    
    
    
    NSDictionary *rawResourceObjectAttributesDictionary = (rawResourceObjectDictionary[@"attributes"] && (rawResourceObjectDictionary[@"attributes"] != [NSNull null])) ? rawResourceObjectDictionary[@"attributes"] : nil;
    
    if(rawResourceObjectAttributesDictionary){
        self.attributes = rawResourceObjectAttributesDictionary;
    }
    else
        self.attributes = @{};
    
    
    
    NSDictionary *rawResourceObjectRelationshipsDictionary = (rawResourceObjectDictionary[@"relationships"] && (rawResourceObjectDictionary[@"relationships"] != [NSNull null])) ? rawResourceObjectDictionary[@"relationships"] : nil;
    if(rawResourceObjectRelationshipsDictionary){
        self.relationships = rawResourceObjectRelationshipsDictionary;
    }
    else
        rawResourceObjectRelationshipsDictionary = @{};
    
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
                            
                            [self setValue:[QJAResourceFormatter performFormatBlock:[rawResourceObjectAttributesDictionary objectForKey:key] withName:formatFunction] forKey:propertyName ];
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
    
    return relationships;

}


@end
