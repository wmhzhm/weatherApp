//
//  MHFutuerWeatherModel.m
//  MHWeather
//
//  Created by wmh—future on 16/6/12.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHFutuerWeatherModel.h"

@implementation MHFutuerWeatherModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
