//
//  MHFutuerWeatherModel.h
//  MHWeather
//
//  Created by wmh—future on 16/6/12.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 date: "2015-08-04",
 week: "星期二",
 fengxiang: "无持续风向",
 fengli: "微风级",
 hightemp: "32℃",
 lowtemp: "23℃",
 type: "多云"
 */
@interface MHFutuerWeatherModel : NSObject
@property (copy ,nonatomic) NSString *date;
@property (copy ,nonatomic) NSString *week;
@property (copy ,nonatomic) NSString *fengxiang;
@property (copy ,nonatomic) NSString *fengli;
@property (copy ,nonatomic) NSString *hightemp;
@property (copy ,nonatomic) NSString *lowtemp;
@property (copy ,nonatomic) NSString *type;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
