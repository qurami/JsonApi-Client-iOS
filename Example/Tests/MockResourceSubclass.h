//
//  MockResourceSubclass.h
//  QuramiJsonApi
//
//  Created by Marco Musella on 08/02/16.
//  Copyright © 2016 Marco Musella. All rights reserved.
//

#import "QJAResource.h"

@interface MockResourceSubclass : QJAResource

@property (nonatomic, strong) NSString *mockAttrOne;
@property (nonatomic, strong) NSString *mockAttrTwo;
@property (nonatomic, strong) NSString *formattedAttribute;

@end
