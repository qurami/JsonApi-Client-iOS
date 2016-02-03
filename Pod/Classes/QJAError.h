#import <Foundation/Foundation.h>

@interface QJAError : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSDictionary *links;
@property (nonatomic, strong) NSDictionary *source;
@property (nonatomic, strong) NSDictionary *meta;

- (id) initWithDictionary: (NSDictionary *) errorData;

@end
