//
//  MHIndexModel.m
//  MHWeather
//
//  Created by wmh—future on 16/6/11.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHIndexModel.h"

@implementation MHIndexModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
