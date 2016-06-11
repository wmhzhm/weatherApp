//
//  MHCurrentWeatherModel.h
//  MHWeather
//
//  Created by wmh—future on 16/6/11.
//  Copyright © 2016年 wmh—future. All rights reserved.
//


/*JASON数据样式
 date: "2015-08-03", //今天日期
 week: "星期一",    //今日星期
 curTemp: "28℃",    //当前温度
 aqi: "92",        //pm值
 fengxiang: "无持续风向", //风向
 fengli: "微风级",     //风力
 hightemp: "30℃",   //最高温度
 lowtemp: "23℃",    //最低温度
 type: "阵雨",      //天气状态
 index: [//指标列表
 */
#import <Foundation/Foundation.h>

@interface MHCurrentWeatherModel : NSObject
@property (copy ,nonatomic) NSString *date;
@property (copy ,nonatomic) NSString *week;
@property (copy ,nonatomic) NSString *curTemp;
@property (copy ,nonatomic) NSString *aqi;
@property (copy ,nonatomic) NSString *fengxiang;
@property (copy ,nonatomic) NSString *fengli;
@property (copy ,nonatomic) NSString *hightemp;
@property (copy ,nonatomic) NSString *lowtemp;
@property (copy ,nonatomic) NSString *type;
@property (strong ,nonatomic) NSArray *index;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
