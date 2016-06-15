//
//  MHIPModel.m
//  MHWeather
//
//  Created by wmh—future on 16/6/13.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHIPModel.h"

@implementation MHIPModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
