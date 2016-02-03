#import "QJAError.h"

@implementation QJAError


- (id) initWithDictionary: (NSDictionary *) errorData{
    
    if(self = [super init]){
        
        self.ID = errorData[@"ID"];
        self.status = errorData[@"status"];
        self.code = errorData[@"code"];
        self.title = errorData[@"title"];
        self.detail = errorData[@"detail"];
        self.links = errorData[@"links"];
        self.source = errorData[@"source"];
        self.meta = errorData[@"meta"];
    
    }
    return self;

}



@end
