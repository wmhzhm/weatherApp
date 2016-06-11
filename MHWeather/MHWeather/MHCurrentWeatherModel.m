//
//  MHCurrentWeatherModel.m
//  MHWeather
//
//  Created by wmh—future on 16/6/11.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHCurrentWeatherModel.h"

@implementation MHCurrentWeatherModel
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    if ([key isEqualToString:@"aqi"]) {
//        self.aqi = 0;
//    }
//}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
