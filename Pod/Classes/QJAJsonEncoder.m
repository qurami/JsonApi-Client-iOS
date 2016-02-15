#import "QJAJsonEncoder.h"
#import "QJADocument.h"
#import "QJAResource.h"
#import "QJAError.h"


@implementation QJAJsonEncoder


+ (NSString *) jsonEncodedStringForJSONAPIDocument: (QJADocument *) document{
    
    NSMutableDictionary *rawDocument = [NSMutableDictionary new];
    [rawDocument setObject: [self jsonEncodableValueForObject: document.jsonApi] forKey:@"jsonapi"];
    [rawDocument setObject: [self jsonEncodableValueForObject: document.meta] forKey:@"meta"];
    [rawDocument setObject: [self jsonEncodableValueForObject: document.links] forKey:@"links"];
    
    if(document.data){
        
        id rawData = nil;
        
        if([document.data isKindOfClass: [QJAResource class]])
            rawData = [self dictionaryForJSONAPIResource: document.data];
        else if([document.data isKindOfClass:[NSArray class]] && [document.data count] > 0){
            
            rawData = [[NSMutableArray alloc] initWithCapacity: [document.data count]];
            
            for (QJAResource *thisResource in document.data) {
                NSDictionary *dictionaryResource = [self dictionaryForJSONAPIResource: thisResource];
                if(dictionaryResource)
                    [rawData addObject: dictionaryResource];
            }
        }
        
        [rawDocument setObject:[self jsonEncodableValueForObject: rawData] forKey:@"data"];

    }
    
    
    
    
    if(document.included && [document.included count] > 0){
        
        NSMutableArray *rawIncluded = nil;
        
        rawIncluded = [[NSMutableArray alloc] initWithCapacity: [document.included count]];
        
        for (QJAResource *thisIncludedResource in document.included) {
            NSDictionary *resourceDictionary = [self dictionaryForJSONAPIResource: thisIncludedResource];
            if(resourceDictionary)
                [rawIncluded addObject: resourceDictionary];
        }
        
        [rawDocument setObject: [self jsonEncodableValueForObject: rawIncluded] forKey:@"included"];

    }
    
    
    if(document.errors && [document.errors count] > 0){
        NSMutableArray *rawErrors = nil;

        rawErrors = [[NSMutableArray alloc] initWithCapacity: [document.errors count]];
        for (QJAError *thisError in document.errors) {
            NSDictionary *jsonapiErrorDictionary = [self dictionaryForJSONAPIError: thisError];
            if(jsonapiErrorDictionary)
                [rawErrors addObject: jsonapiErrorDictionary];
        }
        
        [rawDocument setObject: [self jsonEncodableValueForObject: rawErrors] forKey:@"errors"];
    }
    
    
    return [self jsonParseDictionary: rawDocument];
}

+ (NSDictionary *) dictionaryForJSONAPIResource: (QJAResource *) resource{
    
    NSMutableDictionary *rawResource = [NSMutableDictionary new];
    
    if(resource.ID){
        [rawResource setObject:[self jsonEncodableValueForObject:resource.ID] forKey:@"id"];
    }
    if(resource.type){
        [rawResource setObject:[self jsonEncodableValueForObject:resource.type] forKey:@"type"];
    }
    if(resource.links){
        [rawResource setObject:[self jsonEncodableValueForObject:resource.links] forKey:@"links"];
    }
    if(resource.attributes){
        [rawResource setObject:[self jsonEncodableValueForObject:resource.attributes] forKey:@"attributes"];
    }
    if(resource.relationships){
        [rawResource setObject:[self jsonEncodableValueForObject:resource.relationships] forKey:@"relationships"];
    }
    
    
    return rawResource;
    
}

+ (NSString *) jsonEncodedStringForJSONAPIResource: (QJAResource *) resource{
    
    return [self jsonParseDictionary: [self dictionaryForJSONAPIResource: resource]];
}

+ (NSDictionary *) dictionaryForJSONAPIError: (QJAError *) jsonapiError{
    
    NSDictionary *rawError = @{
                               @"id" : [self jsonEncodableValueForObject: jsonapiError.ID],
                               @"status" : [self jsonEncodableValueForObject: jsonapiError.status],
                               @"code" : [self jsonEncodableValueForObject: jsonapiError.code],
                               @"title" : [self jsonEncodableValueForObject: jsonapiError.title],
                               @"detail" : [self jsonEncodableValueForObject: jsonapiError.detail],
                               @"links" : [self jsonEncodableValueForObject: jsonapiError.links],
                               @"source" : [self jsonEncodableValueForObject: jsonapiError.source],
                               @"meta" : [self jsonEncodableValueForObject: jsonapiError.meta]
                               };
    
    return  rawError;
}

+ (NSString *) jsonEncodedStringForJSONAPIError: (QJAError *) jsonapiError{
    
    return [self jsonParseDictionary: [self dictionaryForJSONAPIError: jsonapiError]];
}


+ (NSString *) jsonParseDictionary: (NSDictionary *) dictionary{
    
    NSString *jsonString = nil;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"JSONAPIJSONEncoder error, unable to parse dictionary: %@ to json: %@", dictionary, error.localizedDescription);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    
    return jsonString;
    
    
    
}

+ (id) jsonEncodableValueForObject: (id) object{
    
    if(object)
        return object;
    else
        return [NSNull null];
}

@end
