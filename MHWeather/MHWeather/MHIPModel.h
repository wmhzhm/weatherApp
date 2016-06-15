//
//  MHIPModel.h
//  MHWeather
//
//  Created by wmh—future on 16/6/13.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "errNum": 0,
 "errMsg": "success",
 "retData": {
 "ip": "117.89.35.58", //IP地址
 "country": "中国", //国家
 "province": "江苏", //省份 国外的默认值为none
 "city": "南京", //城市  国外的默认值为none
 "district": "鼓楼",// 地区 国外的默认值为none
 "carrier": "中国电信" //运营商  特殊IP显示为未知
 }
 */
@interface MHIPModel : NSObject
@property (copy ,nonatomic) NSString *ip;
@property (copy ,nonatomic) NSString *country;
@property (copy ,nonatomic) NSString *province;
@property (copy ,nonatomic) NSString *city;
@property (copy ,nonatomic) NSString *district;
@property (copy ,nonatomic) NSString *carrier;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
