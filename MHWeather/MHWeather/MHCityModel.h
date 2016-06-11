//
//  MHCityModel.h
//  MHWeather
//
//  Created by wmh—future on 16/6/11.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHCityModel : NSObject

@property (copy ,nonatomic) NSString * province_cn;//省
@property (copy ,nonatomic) NSString *name_cn;//区、县
@property (copy ,nonatomic) NSString *district_cn;//市
@property (assign ,nonatomic) NSInteger area_id;//城市代码
@property (copy ,nonatomic) NSString *name_en;//城市拼音
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
