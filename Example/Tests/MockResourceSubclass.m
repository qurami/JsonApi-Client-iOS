//
//  MockResourceSubclass.m
//  QuramiJsonApi
//
//  Created by Marco Musella on 08/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import "MockResourceSubclass.h"

@implementation MockResourceSubclass

- (NSDictionary *) mapAttributesToProperties{
    
    return @{
             @"mock-attr-one" : @"mockAttrOne",
             @"mock-attr-two" : @"mockAttrTwo",
             @"mock-attr-formatted" : @"MockFormat:formattedAttribute"
             };
}


@end
